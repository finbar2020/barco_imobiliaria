// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';
import 'package:lello/feature/accountability/presentation/detail/bloc/accountability_detail_state.dart';
import 'package:lello/feature/accountability/presentation/detail/page/accountability_details_grouped_entries_page.dart';
import 'package:lello/feature/accountability/presentation/question_create/page/question_create_page.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';

import '../../../../session/presentation/bloc/session_bloc.dart';
import '../../../domain/entity/accountability_recommendations.dart';
import '../controller/accountability_detail_controller.dart';

class AccountabilityDetailPage extends StatefulWidget {
  const AccountabilityDetailPage({Key? key}) : super(key: key);

  @override
  AccountabilityDetailPageState createState() =>
      AccountabilityDetailPageState();
}

class AccountabilityDetailPageState extends State<AccountabilityDetailPage> {
  final AccountabilityDetailController controller =
      ApplicationContainer.instance().resolve<AccountabilityDetailController>();
  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();
  final formatCurrency = NumberFormat.currency(symbol: "R\$");
  var loaded = false;
  AccountabilityPeriods period = AccountabilityPeriods(
      period: DateTime.now(), situation: "APROVADA", approvalDate: null);

  Environment env = ApplicationContainer.instance().resolve<Environment>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final condominium = sessionBloc.state.session!.selectedCondominium!;
    final currencyFormat = NumberFormat.currency(symbol: "R\$");
    final dateFormat = DateFormat("MMMM yyyy");
    final theme = Theme.of(context);
    period =
        ModalRoute.of(context)!.settings.arguments as AccountabilityPeriods;
    if (!loaded) {
      loaded = true;
    }
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).background(),
        appBar: PrimaryAppBar(
            title: getString(context, "accountability_title"), theme: theme),
        body: FutureBuilder(
          future: controller.getAccountabilityList(
              condominiumId: sessionBloc.state.session!.selectedCondominium!.id,
              periods: period),
          builder: (context, snapshot) {
            return BlocConsumer(
              listener: (context, state) {
                if (state is AccountabilitySendRecommendationFailureState) {
                  Navigator.pushNamed(context,
                      ApplicationRoute.accountabilitySendRecommendationFailure);
                }
                if (state is AccountabilitySendRecommendationSuccessState) {
                  Navigator.pushNamed(context,
                      ApplicationRoute.accountabilitySendRecommendationSuccess);
                }
              },
              bloc: controller.bloc,
              builder: (context, state) {
                if (state is AccountabilityDetailFailedState) {
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: ErrorHandlingWidget(
                        reTryFunction: () {
                          controller.getAccountabilityList(
                              condominiumId: sessionBloc
                                  .state.session!.selectedCondominium!.id,
                              periods: period);
                        },
                        backFunction: () => Navigator.pop(context, true),
                        isProduction: env.isProduction,
                        error: state.error.error.toString(),
                        errorCode: state.error.code.toString(),
                        subTitle: "accountability_error",
                        textReturnButton: "back_to_the_previous_page"),
                  );
                }
                if (state is AccountabilityDetailLoadingState ||
                    state is AccountabilitySendRecommendationLoadingState) {
                  return const Center(
                    child: LoadingWidget(),
                  );
                }
                if (state is AccountabilityDetailLoadedState) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: Dimens.spacingMedium,
                                  top: Dimens.spacing,
                                ),
                                child: Text(
                                    state.period != null
                                        ? toBeginningOfSentenceCase(dateFormat
                                            .format(state.period!.period))!
                                        : "",
                                    style: LelloTextStyles.title(theme)),
                              ),
                              SizedBox(height: Dimens.spacingXSmall),
                              Builder(builder: (context) {
                                if (state.period?.initialPeriod == null ||
                                    state.period?.endingPeriod == null) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: Dimens.spacingMedium + 4),
                                  child: Text(
                                      "${getString(context, 'accounttability_period')} ${getString(context, 'accounttability_period_from')} ${state.period!.initialPeriod!.toDayMonthString()} ${getString(context, 'accounttability_period_to')} ${state.period!.endingPeriod!.toDayMonthString()}",
                                      style: LelloTextStyles.subBody(theme)),
                                );
                              }),
                              SizedBox(height: Dimens.spacingMedium),
                              ListView.separated(
                                itemBuilder: (context, index) {
                                  final entity = state
                                      .accountability.groupedEntries[index];
                                  return Padding(
                                    padding:
                                        EdgeInsets.all(Dimens.spacingMedium)
                                            .copyWith(top: 0.0, bottom: 0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        SizedBox(
                                          height: Dimens.spacingSmall,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    getString(context,
                                                        "condominium_balance_detail_name"),
                                                    style: LelloTextStyles
                                                        .bodyBold(theme),
                                                  ),
                                                  Text(
                                                    entity.description,
                                                    style: LelloTextStyles.body(
                                                        theme),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          Dimens.spacingMedium)
                                                ],
                                              ),
                                            ),
                                            CircuitBreakerWidget(
                                              appContainer: ApplicationContainer
                                                  .instance(),
                                              reference: sessionBloc
                                                      .state
                                                      .session
                                                      ?.selectedCondominium
                                                      ?.reference ??
                                                  "",
                                              applicationRbac: ApplicationRbac
                                                  .sindicoPpcDetalhes,
                                              rbacEnabled: sessionBloc
                                                  .checkRback(ApplicationRbac
                                                      .sindicoPpcDetalhes),
                                              child: Flexible(
                                                child: SizedBox(
                                                  height: 40,
                                                  child: PrimaryButton(
                                                      text: getString(context,
                                                          "condominium_balance_details"),
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          ApplicationRoute
                                                              .accountabilityDetailGrouped,
                                                          arguments:
                                                              AccountabilityDetailGroupedArguments(
                                                                  entity),
                                                        );
                                                      }),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    getString(context,
                                                        "condominium_balance_detail_debit_word"),
                                                    style: LelloTextStyles
                                                        .bodyBold(theme),
                                                  ),
                                                  Text(
                                                    currencyFormat
                                                        .format(entity.debits),
                                                    style: LelloTextStyles.body(
                                                        theme),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          Dimens.spacingMedium)
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    getString(context,
                                                        "condominium_balance_detail_credit_word"),
                                                    style: LelloTextStyles
                                                        .bodyBold(theme),
                                                  ),
                                                  Text(
                                                    currencyFormat
                                                        .format(entity.credits),
                                                    style: LelloTextStyles.body(
                                                        theme),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          Dimens.spacingMedium)
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                                itemCount:
                                    state.accountability.groupedEntries.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(
                                  color:
                                      LelloTheme.palleteOf(theme).separator(),
                                ),
                              ),
                              if (state
                                  .accountability.recommendations.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimens.spacingMedium),
                                  child: CircuitBreakerWidget(
                                    appContainer:
                                        ApplicationContainer.instance(),
                                    reference: sessionBloc.state.session
                                            ?.selectedCondominium?.reference ??
                                        "",
                                    applicationRbac: ApplicationRbac
                                        .sindicoPpcListaRecomendacoes,
                                    rbacEnabled: sessionBloc.checkRback(
                                        ApplicationRbac
                                            .sindicoPpcListaRecomendacoes),
                                    child: _buildRecommendationColumn(
                                        theme, state),
                                  ),
                                ),
                              SizedBox(height: Dimens.spacingMedium),
                              if (!((state.period?.isAproved) ?? false))
                                CircuitBreakerWidget(
                                  appContainer: ApplicationContainer.instance(),
                                  reference: sessionBloc.state.session
                                          ?.selectedCondominium?.reference ??
                                      "",
                                  applicationRbac: ApplicationRbac
                                      .sindicoPpcRecomendarAprovacao,
                                  rbacEnabled: sessionBloc.checkRback(
                                      ApplicationRbac
                                          .sindicoPpcRecomendarAprovacao),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimens.spacingMedium),
                                    child: ApproveRecommendationButton(
                                      condominiumId: condominium.id,
                                      period: period,
                                      recommendations:
                                          state.accountability.recommendations,
                                    ),
                                  ),
                                ),
                              Container(
                                color: LelloTheme.palleteOf(theme).background(),
                                padding: EdgeInsets.all(Dimens.spacingMedium),
                                child: state.period?.isAproved == true
                                    ? PrimaryButton(
                                        onPressed: null,
                                        child: Text(
                                          "${getString(context, "accountability_approved")}\n${state.period?.getFormattedDate}",
                                          textAlign: TextAlign.center,
                                        ))
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          CircuitBreakerWidget(
                                            appContainer:
                                                ApplicationContainer.instance(),
                                            reference: sessionBloc
                                                    .state
                                                    .session
                                                    ?.selectedCondominium
                                                    ?.reference ??
                                                "",
                                            applicationRbac: ApplicationRbac
                                                .sindicoPpcAprovarWrite,
                                            rbacEnabled: sessionBloc.checkRback(
                                                ApplicationRbac
                                                    .sindicoPpcAprovarWrite),
                                            child: PrimaryButton(
                                                text: getString(context,
                                                    "accountability_approve"),
                                                onPressed: () {
                                                  Navigator.of(context).pushNamed(
                                                      ApplicationRoute
                                                          .accountabilityConfirmation,
                                                      arguments:
                                                          state.accountability);
                                                }),
                                          ),
                                          SizedBox(height: Dimens.spacingSmall),
                                          if (state.period != null &&
                                              !state.period!.isAproved)
                                            CircuitBreakerWidget(
                                              appContainer: ApplicationContainer
                                                  .instance(),
                                              reference: sessionBloc
                                                      .state
                                                      .session
                                                      ?.selectedCondominium
                                                      ?.reference ??
                                                  "",
                                              applicationRbac: ApplicationRbac
                                                  .sindicoPpcDuvidasWrite,
                                              rbacEnabled: sessionBloc
                                                  .checkRback(ApplicationRbac
                                                      .sindicoPpcDuvidasWrite),
                                              child: SecondaryButton(
                                                buttonBorderColor:
                                                    theme.primaryColor,
                                                text: getString(context,
                                                    "question_main_submit_question"),
                                                onPressed: () {
                                                  var period = state
                                                      .accountability.period;
                                                  if (period != null) {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      ApplicationRoute
                                                          .accountabilityNewQuestion,
                                                      arguments:
                                                          QuestionCreatePageArg(
                                                        accountability: state
                                                            .accountability,
                                                        period: state
                                                            .accountability
                                                            .period!,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            )
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: LelloTheme.palleteOf(theme).background(),
                        child: Container(
                          decoration: ShapeDecoration(
                              color: LelloTheme.palleteOf(theme).separator(),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      topLeft: Radius.circular(8)))),
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                            getString(context,
                                                "accountability_initial_balance"),
                                            style: LelloTextStyles.bodyBold(
                                                theme)),
                                        Text(formatCurrency.format(state
                                                .accountability
                                                .initialBalance ??
                                            0)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: Dimens.spacing),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            getString(context,
                                                "accountability_total_expenses"),
                                            style: LelloTextStyles.bodyBold(
                                                theme)),
                                        Text(formatCurrency.format(state
                                                .accountability.totalExpenses ??
                                            0)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: Dimens.spacing),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            getString(context,
                                                "accountability_total_income"),
                                            style: LelloTextStyles.bodyBold(
                                                theme)),
                                        Text(formatCurrency.format(
                                            state.accountability.totalIncome ??
                                                0)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: Dimens.spacing),
                              Row(
                                children: [
                                  Text(
                                      getString(
                                          context, "accountability_balance"),
                                      style:
                                          LelloTextStyles.subtitleBold(theme)),
                                  SizedBox(width: Dimens.spacing),
                                  const Expanded(
                                    child: Divider(),
                                  ),
                                  SizedBox(width: Dimens.spacing),
                                  Text(
                                    formatCurrency.format(
                                        state.accountability.balance ?? 0),
                                    style: LelloTextStyles.subtitle(theme),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  Padding _buildRecommendationColumn(
      ThemeData theme, AccountabilityDetailLoadedState state) {
    return Padding(
      padding:
          EdgeInsets.all(Dimens.spacingMedium).copyWith(top: 0.0, bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimens.spacing),
          Container(
            height: 2.0,
            color: LelloTheme.palleteOf(theme).separator(),
          ),
          SizedBox(height: Dimens.spacing),
          Text(
            getString(context, "accountability_recommentadtion"),
            style: LelloTextStyles.bodyBold(theme),
          ),
          SizedBox(height: Dimens.spacingMedium),
          ...List.generate(
              state.accountability.recommendations.length,
              (index) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                                state.accountability.recommendations[index]
                                        .name ??
                                    "",
                                style: LelloTextStyles.body(theme)),
                          ),
                          SizedBox(width: Dimens.spacingMedium),
                          Text(
                              state.accountability.recommendations[index]
                                      .dateFormatted ??
                                  "",
                              style: LelloTextStyles.body(theme)),
                        ],
                      ),
                      SizedBox(height: Dimens.spacing),
                    ],
                  ))
        ],
      ),
    );
  }
}

class ApproveRecommendationButton extends StatelessWidget {
  final AccountabilityPeriods period;
  final List<AccountabilityRecommendations> recommendations;
  final String condominiumId;
  const ApproveRecommendationButton({
    Key? key,
    required this.period,
    required this.recommendations,
    required this.condominiumId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ApplicationContainer.instance()
        .resolve<AccountabilityDetailController>();
    final theme = Theme.of(context);
    return Builder(builder: (context) {
      if (recommendations.any((element) => element.isUser == true)) {
        return PrimaryButton(
          buttonColor: LelloTheme.palleteOf(theme).grey(),
          onPressed: () {},
          text: getString(context, "accountability_recommended_approve"),
        );
      }
      return PrimaryButton(
        onPressed: () async {
          controller.period = period;

          controller.condominiumId = condominiumId;

          await controller.approveRecommendation(
            period: period.period,
            condominiumId: condominiumId,
          );

          controller.getAccountabilityList(
            condominiumId: condominiumId,
            periods: period,
          );
        },
        text: getString(context, "accountability_recommend_approve"),
      );
    });
  }
}
