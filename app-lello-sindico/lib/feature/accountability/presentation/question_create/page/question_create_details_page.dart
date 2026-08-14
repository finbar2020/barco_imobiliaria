import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/presentation/question_create/bloc/question_create_state.dart';
import 'package:path/path.dart' as path;

import '../controller/question_create_controller.dart';

class QuestionCreateDetailsPageArg {
  final AccountabilityDoubt doubt;
  QuestionCreateDetailsPageArg({required this.doubt});
}

class QuestionCreateDetailsPage extends StatefulWidget {
  const QuestionCreateDetailsPage({super.key});

  @override
  _QuestionCreateDetailsPageState createState() =>
      _QuestionCreateDetailsPageState();
}

class _QuestionCreateDetailsPageState extends State<QuestionCreateDetailsPage> {
  final dateFormat = DateFormat("MMMM yyyy");
  final formattedDate = DateFormat("dd MMMM yyyy");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: "R\$");
    final QuestionCreateController controller =
        ApplicationContainer.instance().resolve<QuestionCreateController>();
    QuestionCreateDetailsPageArg arguments = ModalRoute.of(context)!
        .settings
        .arguments as QuestionCreateDetailsPageArg;
    controller.doubtSelected = arguments.doubt;

    return Scaffold(
      appBar: PrimaryAppBar(
          theme: theme,
          title: getString(context, "accountability_send_question")),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: FutureBuilder(
          future: controller.getQuestions(),
          builder: (context, snapshot) => BlocConsumer(
            bloc: controller.bloc,
            listener: (context, state) async {
              if (state is QuestionCreateSendFailedState) {
                await Navigator.pushNamed(
                  context,
                  ApplicationRoute.accountabilityNewQuestionError,
                );
                setState(() {});
              }
              if (state is QuestionCreateSendedState) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  ApplicationRoute.accountabilityNewQuestionSuccess,
                  ModalRoute.withName(
                    ApplicationRoute.accountabilityDetail,
                  ),
                );
              }
            },
            builder: ((context, state) {
              if (state is QuestionCreateSendingState) {
                return Column(
                  children: [
                    Expanded(
                      child: LoadingWidget(
                        message: getString(context,
                            "accountability_send_question_loading_send"),
                      ),
                    ),
                  ],
                );
              }
              if (state is QuestionCreateLoadingState) {
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
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    controller.doubtSelected!.doubtType!.name,
                                    style: LelloTextStyles.subtitleBold(theme),
                                  ),
                                  SizedBox(height: Dimens.spacingSmall),
                                  Text(
                                    "${getString(context, "accountability_send_question_sumary_period")}: ${dateFormat.format(controller.doubtSelected!.period)}",
                                  ),
                                  Text(
                                    "${getString(context, "accountability_send_question_sumary_date")}: ${formattedDate.format(DateTime.now())}",
                                  ),
                                  SizedBox(height: Dimens.spacingLarge),
                                  Text(
                                    getString(context,
                                        "accountability_send_question_sumary_enteries"),
                                    style: LelloTextStyles.titleSmall(theme),
                                  ),
                                  SizedBox(height: Dimens.spacingLarge),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: List.generate(
                                      controller.doubtSelected!.entiries.length,
                                      (index) {
                                        var item = controller
                                            .doubtSelected!.entiries[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${item.dateFormatted} - ${item.history} - ${currencyFormat.format(item.value)}",
                                            style: LelloTextStyles.body(theme),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Text(
                                    "-------------------------------------------",
                                    style: LelloTextStyles.titleSmall(theme),
                                  ),
                                  SizedBox(height: Dimens.spacingSmall),
                                  Text(
                                    controller.doubtSelected!.message,
                                    style: LelloTextStyles.body(theme),
                                  ),
                                  SizedBox(height: Dimens.spacingMedium),
                                  if (controller.doubtSelected!.attachmentsFiles
                                          .isNotEmpty ==
                                      true)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          getString(context,
                                              "accountability_send_question_sumary_files"),
                                          style:
                                              LelloTextStyles.titleSmall(theme)
                                                  ?.copyWith(
                                            color: LelloTheme.palleteOf(theme)
                                                .grey(),
                                          ),
                                        ),
                                        SizedBox(height: Dimens.spacingSmall),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: List.generate(
                                            controller.doubtSelected!
                                                .attachmentsFiles.length,
                                            (index) {
                                              final item = controller
                                                  .doubtSelected!
                                                  .attachmentsFiles[index];
                                              return Row(
                                                children: <Widget>[
                                                  SvgPicture.asset(
                                                      "assets/ic_clips.svg"),
                                                  SizedBox(
                                                      width:
                                                          Dimens.spacingXSmall),
                                                  Expanded(
                                                    child: Text(
                                                      "${index + 1} - ${path.basename(item.path)}",
                                                      style: LelloTextStyles
                                                          .bodyBold(theme),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: Dimens.spacingMedium),
                                  PrimaryButton(
                                    text: getString(context,
                                        "accountability_send_question_sumary_send"),
                                    onPressed: () async {
                                      await controller.sendDoubt();
                                    },
                                  ),
                                  SizedBox(height: Dimens.spacingSmall),
                                  SecondaryButton(
                                    text: getString(context, "back"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ),
        ),
      ),
    );
  }
}
