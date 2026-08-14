import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/presentation/question_create/bloc/question_create_state.dart';
import 'package:lello/feature/accountability/presentation/question_create/controller/question_create_controller.dart';
import 'package:lello/feature/accountability/presentation/question_create/widget/question_create_form_widget.dart';

class QuestionCreatePageArg {
  final Accountability accountability;
  final DateTime period;
  QuestionCreatePageArg({required this.accountability, required this.period});
}

class QuestionCreatePage extends StatefulWidget {
  @override
  _QuestionCreatePageState createState() => _QuestionCreatePageState();
}

class _QuestionCreatePageState extends State<QuestionCreatePage> {
  final dateFormat = DateFormat("MMMM yyyy");
  final formattedDate = DateFormat("dd MMMM yyyy");
  late Accountability accountability;
  late DateTime period;
  final QuestionCreateController controller =
      ApplicationContainer.instance().resolve<QuestionCreateController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    QuestionCreatePageArg arguments =
        ModalRoute.of(context)!.settings.arguments as QuestionCreatePageArg;
    accountability = arguments.accountability;
    period = arguments.period;
    controller.doubtSelected ??= AccountabilityDoubt(period: period);
    return Scaffold(
      appBar: PrimaryAppBar(
          theme: theme,
          title: getString(context, "accountability_send_question")),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.popUntil(context,
              ModalRoute.withName(ApplicationRoute.accountabilityDetail));
          return true;
        },
        child: FutureBuilder(
          future: controller.getQuestions(),
          builder: (context, snapshot) => BlocBuilder(
            bloc: controller.bloc,
            builder: ((context, state) {
              if (state is QuestionCreateEmptyState ||
                  state is QuestionCreateLoadingState) {
                return Column(
                  children: [
                    Expanded(
                      child: LoadingWidget(
                        message: getString(context,
                            "accountability_send_question_loading_setup"),
                      ),
                    ),
                  ],
                );
              }
              if (state is QuestionCreateLoadedState) {
                return Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(Dimens.spacingMedium),
                                  decoration: BoxDecoration(
                                      color: LelloTheme.palleteOf(theme)
                                          .separator(),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      )),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    formattedDate
                                                        .format(DateTime.now()),
                                                    style: LelloTextStyles
                                                        .bodyBold(theme)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Dimens.spacing),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getString(context,
                                                      "condominium_hub_title"),
                                                  style:
                                                      LelloTextStyles.bodyBold(
                                                          theme),
                                                ),
                                                Text(
                                                  controller
                                                      .sessionBloc
                                                      .state
                                                      .session!
                                                      .selectedCondominium!
                                                      .name!
                                                      .toString(),
                                                  style: LelloTextStyles.body(
                                                    theme,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: Dimens.spacing),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getString(context,
                                                      "accounttability_question_provison"),
                                                  style:
                                                      LelloTextStyles.bodyBold(
                                                          theme),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      dateFormat.format(
                                                          controller
                                                              .doubtSelected!
                                                              .period),
                                                      style:
                                                          LelloTextStyles.body(
                                                              theme),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(Dimens.spacingMedium),
                                  child: QuestionCreateFormWidget(
                                    types: state.data,
                                    accountability: accountability,
                                    onChanged: () {
                                      setState(() {});
                                    },
                                    accountabilityDoubt:
                                        controller.doubtSelected!,
                                  ),
                                ),
                              ]),
                        ),
                      ]),
                    ),
                  ],
                );
              }
              if (state is QuestionCreateFailedState) {
                return ErrorMessageWidget(
                  message: getString(
                      context,
                      state.errorMessageKey ??
                          "accountability_send_question_loading_setup_error"),
                );
              }
              return const SizedBox.shrink();
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var element in accountability.groupedEntries) {
      for (var element in element.accounts) {
        for (var element in element.entries) {
          element.checked = false;
        }
      }
    }
    controller.dispose();
    super.dispose();
  }
}
