import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/mailing/domain/entity/mailing.dart';
import 'package:morar/feature/mailing/presentation/bloc/mailing_bloc.dart';
import 'package:morar/feature/mailing/presentation/bloc/mailing_state.dart';
import 'package:morar/feature/mailing/presentation/controllers/mailing_controller.dart';
import 'package:morar/feature/mailing/presentation/widgets/mailing_card_widget.dart';

import '../widgets/mailing_bottom_sheet.dart';

class MailingPageArgs {
  String? mailingNotificationContext;
  MailingPageArgs({this.mailingNotificationContext});
}

class MailingPage extends StatefulWidget {
  const MailingPage({Key? key}) : super(key: key);

  @override
  _MailingPageState createState() => _MailingPageState();
}

class _MailingPageState extends State<MailingPage> {
  final controller =
      ApplicationContainer.instance().resolve<MailingController>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  MailingPageArgs? arguments;

  @override
  void initState() {
    controller.getMailings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    arguments = ModalRoute.of(context)?.settings.arguments as MailingPageArgs?;

    return Theme(
      data: theme,
      child: Scaffold(
        bottomNavigationBar: BlocBuilder<MailingBloc, MailingState>(
          bloc: controller.bloc,
          builder: (context, state) {
            if (state is MailingSuccessState) {
              if (state.mailings.length < controller.totalItems) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: theme.disabledColor,
                        width: 0.4,
                      ),
                    ),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        controller.getMailings(showAll: true);
                      },
                      child: Text(
                        "${getString(context, "mailing_all_records")} (${controller.totalItems})",
                        style: LelloTextStyles.subBody(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textAccent(),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
            return SizedBox.shrink();
          },
        ),
        appBar: CustomAppBar(title: "mailing_title"),
        body: BlocBuilder<MailingBloc, MailingState>(
          bloc: controller.bloc,
          builder: (context, state) {
            if (state is MailingLoadingState) {
              return Column(
                children: [
                  Expanded(
                    child: LoadingWidget(),
                  ),
                ],
              );
            }
            if (state is MailingInitialState) {
              return Center(
                child: Text(
                  getString(context, "resident_mail_empty"),
                  style: LelloTextStyles.subtitle(theme),
                ),
              );
            }
            if (state is MailingSuccessState) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                if (arguments?.mailingNotificationContext?.isNotEmpty == true &&
                    mounted) {
                  var item = state.mailings.cast<Mailing?>().firstWhere(
                      (element) =>
                          element?.notificationParameter ==
                              arguments?.mailingNotificationContext ||
                          element?.id == arguments?.mailingNotificationContext,
                      orElse: () => null);
                  if (item != null) {
                    setState(() {
                      item.highlight = true;
                    });
                  }
                  arguments?.mailingNotificationContext = null;
                }
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    color: LelloTheme.palleteOf(theme).backgroundDark(),
                    width: double.infinity,
                    height: Dimens.spacingLarge,
                    child: Center(
                      child: Text(
                        '${controller.session.condominium?.name ?? ''} - ${controller.session.unity?.title ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        style: LelloTextStyles.body(theme),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: state.mailings.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(height: 1),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30)),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: MediaQuery.of(context).size.width,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.8,
                                  minHeight:
                                      MediaQuery.of(context).size.height * 0.6,
                                ),
                                context: context,
                                builder: (context) {
                                  return MailingBottomSheet(
                                    mailing: state.mailings[index],
                                  );
                                },
                              );
                            },
                            child: MailingCardWidget(
                              model: state.mailings[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            if (state is MailingFailureState) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(Dimens.spacingMedium),
                      child: ErrorHandlingWidget(
                        reTryFunction: () {
                          controller.getMailings(showAll: true);
                        },
                        backFunction: () => Navigator.pop(context, true),
                        isProduction: env.isProduction,
                        error: "",
                        errorCode: "",
                      ),
                    ),
                  ),
                ],
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
