// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_filter_sort.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_card.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_filter_drawer.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_month_year.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../controllers/agreements_controller.dart';

class AgreementsInProgressPageArgs {
  String? agreementsNotificationContext;
  AgreementsInProgressPageArgs({
    this.agreementsNotificationContext,
  });
}

class AgreementsInProgressPage extends StatefulWidget {
  const AgreementsInProgressPage({Key? key}) : super(key: key);

  @override
  State<AgreementsInProgressPage> createState() =>
      _AgreementsInProgressPageState();
}

class _AgreementsInProgressPageState extends State<AgreementsInProgressPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();

  final controller =
      ApplicationContainer.instance().resolve<AgreementsController>();
  AgreementsInProgressPageArgs? arguments;
  bool redirect = false;

  @override
  void dispose() {
    controller.searchText = "";
    controller.disposeFilter();
    super.dispose();
  }

  @override
  void initState() {
    controller.sortDueDateKey = AgreementsFilterSortKeys.dueDateCrescent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    arguments = ModalRoute.of(context)!.settings.arguments
        as AgreementsInProgressPageArgs?;
    return Theme(
      data: theme,
      child: Scaffold(
        key: scaffoldState,
        appBar: PrimaryAppBar(
          title: getString(context, "agreements_in_progress"),
          theme: theme,
          actions: [
            IconButton(
              onPressed: () {
                scaffoldState.currentState!.openEndDrawer();
              },
              icon: SvgPicture.asset(
                "assets/ic_filter.svg",
                color: theme.primaryColor,
              ),
            )
          ],
        ),
        endDrawer: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Drawer(
            child: AgreementsFilterDrawer(
              isProposal: false,
            ),
          ),
        ),
        body: BlocBuilder<AgreementsBloc, AgreementsState>(
          bloc: controller.agreementsBloc,
          builder: (context, state) {
            if (state is AgreementsLoadingState) {
              return Column(
                children: const [
                  Expanded(child: LoadingWidget()),
                ],
              );
            }

            if (state is AgreementsErrorState) {
              return ErrorMessageWidget(
                  message: getString(context, ""));
            }
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
              if (arguments?.agreementsNotificationContext?.isNotEmpty ==
                      true &&
                  redirect == false &&
                  mounted) {
                var item = controller.agreementsInProgressFiltered
                    .cast<Agreement?>()
                    .firstWhere(
                        (element) =>
                            element?.notificationParameter ==
                                arguments?.agreementsNotificationContext ||
                            element?.id ==
                                arguments?.agreementsNotificationContext,
                        orElse: () => null);
                if (item != null) {
                  controller.agreement = item;
                  arguments?.agreementsNotificationContext = null;
                  redirect = true;
                  await Navigator.pushNamed(
                    context,
                    ApplicationRoute.agreementsInProgressCardDetails,
                  );
                }
              }
            });

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              controller.searchText = val;
                            });
                          },
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              suffixIcon: SvgPicture.asset(
                                  "assets/ic_search.svg",
                                  color: theme.primaryColor,
                                  height: 16,
                                  fit: BoxFit.scaleDown),
                              hintText: getString(context,
                                  "agreements_search_by_unit_or_owner")),
                        ),
                      ),
                    ],
                  ),
                ),
                TextInProgress(
                    text: getString(
                        context, "agreements_in_progress_amounts_receivable"),
                    isTitle: true),
                TextInProgress(
                  text: controller.agreementsInProgress!.getAmountReceivable,
                  style: LelloTextStyles.subtitle(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).success()),
                  isTitle: false,
                ),
                TextInProgress(
                  text: getString(
                      context, "agreements_in_progress_quantity_in_progress"),
                  isTitle: true,
                ),
                TextInProgress(
                  text:
                      controller.agreementsInProgressFiltered.length.toString(),
                  style: LelloTextStyles.subtitle(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text()),
                  isTitle: false,
                ),
                TextInProgress(
                  text: getString(
                      context, "agreements_in_progress_last_installment"),
                  isTitle: true,
                ),
                TextInProgress(
                  text: controller.agreementsInProgress!.getLastInstallment,
                  style: LelloTextStyles.subtitle(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text()),
                  isTitle: false,
                ),
                const Divider(height: 2.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.agreementsInProgressFiltered.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AgreementsMonthYear(
                              index: index,
                              agreements:
                                  controller.agreementsInProgressFiltered),
                          AgreementsCard(
                            agreement:
                                controller.agreementsInProgressFiltered[index],
                            onPressed: () {
                              controller.agreement = controller
                                  .agreementsInProgressFiltered[index];
                              Navigator.pushNamed(
                                context,
                                ApplicationRoute
                                    .agreementsInProgressCardDetails,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TextInProgress extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool isTitle;
  const TextInProgress({
    Key? key,
    required this.text,
    this.style,
    required this.isTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimens.spacingMedium,
        isTitle ? Dimens.spacingSmall : Dimens.spacingXSmall,
        Dimens.spacingMedium,
        isTitle ? Dimens.spacingXSmall : Dimens.spacingSmall,
      ),
      child: Text(
        text,
        style: style ??
            LelloTextStyles.subtitleBold(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).grey(),
            ),
      ),
    );
  }
}
