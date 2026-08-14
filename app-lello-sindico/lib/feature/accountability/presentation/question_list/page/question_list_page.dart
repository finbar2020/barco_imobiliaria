import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/loading_widget.dart';

import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/presentation/question_list/bloc/question_list_bloc.dart';
import 'package:lello/feature/accountability/presentation/question_list/bloc/question_list_state.dart';
import 'package:lello/feature/accountability/presentation/question_list/page/question_list_detail_page.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

import '../controller/question_list_controller.dart';

class QuestionListPage extends StatefulWidget {
  const QuestionListPage({Key? key}) : super(key: key);

  @override
  QuestionListPageState createState() => QuestionListPageState();
}

class QuestionListPageState extends State<QuestionListPage> {
  final QuestionListBloc bloc = ApplicationContainer.instance().resolve();

  final dateFormat = DateFormat("MMMM yyyy");
  final formattedDate = DateFormat("dd MMMM yyyy");
  late SessionBloc sessionBloc;

  Environment env = ApplicationContainer.instance().resolve<Environment>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final QuestionListController controller =
        ApplicationContainer.instance().resolve<QuestionListController>();

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            theme: theme,
            title: getString(context, "accountability_list_question")),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return true;
          },
          child: FutureBuilder(
            future: controller.getQuestionList(),
            builder: (context, snapshot) => BlocBuilder(
              bloc: controller.bloc,
              builder: ((context, state) {
                if (state is QuestionListLoadingState) {
                  return Column(
                    children: [
                      Expanded(
                        child: LoadingWidget(
                          message: getString(context,
                              "accountability_list_question_loading_setup"),
                        ),
                      ),
                    ],
                  );
                }
                if (state is QuestionListLoadedState) {
                  return ListView.separated(
                    itemBuilder: (listContext, index) {
                      final entity = state.data[index];
                      return ListTile(
                        onTap: () {
                          clickItem(context, entity);
                        },
                        title: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.spacingSmall,
                              vertical: Dimens.spacing),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      entity.doubtType!.name,
                                      style:
                                          LelloTextStyles.subtitleBold(theme),
                                    ),
                                  ),
                                  SizedBox(width: Dimens.spacingSmall),
                                  IgnorePointer(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            entity.questionSituationColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      onPressed: () => {},
                                      onLongPress: null,
                                      child: SizedBox(
                                        height: 11,
                                        child: Center(
                                          child: Text(
                                              getString(context,
                                                  entity.questionSituationText),
                                              style:
                                                  LelloTextStyles.button(theme)
                                                      ?.copyWith(fontSize: 11)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimens.spacingSmall),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "${getString(context, "accountability_list_question_item_period")}: ${dateFormat.format(entity.period)}\n${getString(context, "accountability_list_question_item_date")}: ${formattedDate.format(entity.createdAt)}",
                                      style: LelloTextStyles.subBody(theme),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    "assets/ic_next.svg",
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: state.data.length,
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: LelloTheme.palleteOf(theme).separator(),
                      height: 0,
                    ),
                  );
                }
                if (state is QuestionListFailedState) {
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: ErrorHandlingWidget(
                        reTryFunction: () {
                          controller.getQuestionList();
                        },
                        backFunction: () => Navigator.pop(context, true),
                        isProduction: env.isProduction,
                        error: state.error.error.toString(),
                        errorCode: state.error.code.toString(),
                        subTitle: "accountability_list_question_fail",
                        textReturnButton: "back_to_the_previous_page"),
                  );
                }

                if (state is QuestionListEmptyState) {
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacing),
                    child: Center(
                      child: Text(
                        "Ainda não foram cadastradas dúvidas",
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.titleSmall(theme),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ),
          ),
        ),
      ),
    );
  }

  void clickItem(BuildContext context, AccountabilityDoubt entity) {
    Navigator.pushNamed(
      context,
      ApplicationRoute.accountabilityQuestionListDetailPage,
      arguments: QuestionListDetailPageArgs(
        accountabilityDoubt: entity,
      ),
    );
  }
}
