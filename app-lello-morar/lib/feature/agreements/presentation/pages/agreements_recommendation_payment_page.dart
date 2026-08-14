import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_payment_method_enum.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_recommendatio_payment.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_installments_bottom_sheet.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_resume_bottom_sheet.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_recommendation_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_recommendation_syndic_card.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AgreementsRecommendationPaymentPage extends StatefulWidget {
  const AgreementsRecommendationPaymentPage({Key? key}) : super(key: key);

  @override
  _AgreementsRecommendationPaymentPageState createState() =>
      _AgreementsRecommendationPaymentPageState();
}

class _AgreementsRecommendationPaymentPageState
    extends State<AgreementsRecommendationPaymentPage> {
  late AgreementRecommendationPayment agreementRecommendationPayment;
  final theme = LelloTheme.light;
  AgreementCreated agreement = AgreementCreated();
  final formatCurrency = NumberFormat.currency(symbol: "R\$");
  late AgreementsBloc bloc;
  int indexList = 0;

  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    var arguments = ModalRoute.of(context)!.settings.arguments as List;
    bloc = arguments[0];
    agreement = arguments[1];
    return WillPopScope(
      onWillPop: () async {
        bloc.getChoicePayment();
        Navigator.popUntil(context,
            ModalRoute.withName(ApplicationRoute.agreementsChoicePayment));
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocConsumer<AgreementsBloc, AgreementsState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is PostAgreementLoadedState) {
              // bloc.getAgreementBillet(state.agreement.installmentId);
              Navigator.pushNamed(
                context,
                ApplicationRoute.agreementBillet,
                arguments: [bloc, false, agreement, state.agreement],
              );
            }
            if (state is PostPendingProposalLoadedState) {
              Navigator.pushNamed(
                context,
                ApplicationRoute.agreementSuccessSend,
                arguments: [bloc],
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: WhiteAppBar(
                title: "agreements",
                isGetString: true,
                onPressed: () {
                  bloc.getChoicePayment();
                  Navigator.popUntil(
                      context,
                      ModalRoute.withName(
                          ApplicationRoute.agreementsChoicePayment));
                },
              ),
              body: _agreementsAvailableBody(theme, state, bloc, sessionBloc),
            );
          },
        ),
      ),
    );
  }

  Widget _agreementsAvailableBody(ThemeData theme, AgreementsState state,
      AgreementsBloc bloc, SessionBloc sessionBloc) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        children: [
          if (state is AgreementsLoadingState)
            Expanded(
              child: Center(
                child: LoadingWidget(),
              ),
            ),
          if (state is AgreementsErrorState)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                    height: 60.0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          getString(context, state.errorMessageKey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (state is AgreementsRecommendationLoadedState)
            Expanded(child: _buildLoaded(state, sessionBloc)),
        ],
      ),
    );
  }

  Widget _buildLoaded(
      AgreementsRecommendationLoadedState state, SessionBloc sessionBloc) {
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sprintf(getString(context, "agreements_step"), [2, 3]),
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).textOpaque(),
              ),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              getString(context, 'payment_options'),
              style: LelloTextStyles.titleSmallBold(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, 'payment_options_description'),
              style: LelloTextStyles.subtitle(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
            ),
            _agreementsRecommendationPaymentOptionCardView(state, sessionBloc),
            SizedBox(height: Dimens.spacingMedium),
            _agreementsRecommendationPaymentOptionsSyndicCardView(
                state, sessionBloc),
            SizedBox(height: Dimens.spacingMedium),
          ],
        )),
      ),
      Container(
        child: Center(
          child: _nextButton(state, sessionBloc),
        ),
      )
    ]);
  }

  Widget _agreementsRecommendationPaymentOptionCardView(
      AgreementsRecommendationLoadedState state, SessionBloc sessionBloc) {
    AgreementRecommendationPayment recomendation =
        state.optionsPayments.firstWhere((element) => element.recomendation);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.spacingMedium),
        Text(getString(context, 'indicated_payment_condo'),
            style: LelloTextStyles.subtitleBold(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            )),
        SizedBox(height: Dimens.spacingMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: AgreementsRecommendationCard(
            paymentTitle:
                "[${recomendation.installmentQtd}X] ${formatCurrency.format(agreement.totalValue / recomendation.installmentQtd)}",
            formPaymentTitle: getString(context, "income_billet_detail_billet"),
            dueDateTitle: recomendation.dueDay.toString(),
            totalValue: agreement.totalValue,
            onPressed: () {
              agreement.installmentQuantity = recomendation.installmentQtd;
              agreement.dueDate = recomendation.dueDay ?? 0;
              agreement.paymentMethod = AgreementPaymentMethodEnum.billet.index;
              OwnerAnalyticsLogEvents.logEvent(
                userId: sessionBloc.state.session?.me?.id ?? "",
                event: AnalyticsEventsOwner
                    .acordosEscolherOpcoesDePagamentoMaisIndicada(),
                unitValue:
                    sessionBloc.state.session!.unity?.title.toString() ?? "",
                referenceValue: sessionBloc
                        .state.session!.condominium?.reference
                        ?.toString() ??
                    "",
              );
              Modal.showBottomSheet(
                  context: context,
                  builder: (context) => AgreementResumeBottomSheet(
                        bloc: bloc,
                        agreement: agreement,
                        pendingProposal: false,
                      ));
            },
          ),
        )
      ],
    );
  }

  Widget _agreementsRecommendationPaymentOptionsSyndicCardView(
      AgreementsRecommendationLoadedState state, SessionBloc sessionBloc) {
    List<AgreementRecommendationPayment> options = state.optionsPayments
        .where((element) => !element.recomendation)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getString(context, 'agreements_other_options'),
            style: LelloTextStyles.subtitleBold(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            )),
        SizedBox(height: Dimens.spacingMedium),
        ...List.generate(
            options.length,
            (index) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: AgreementsRecommendationSyndicCard(
                        paymentTitle:
                            "[${options[index].installmentQtd}X] ${formatCurrency.format(agreement.totalValue / options[index].installmentQtd)}",
                        formPaymentTitle:
                            getString(context, "income_billet_detail_billet"),
                        onPressed: () {
                          agreement.installmentQuantity =
                              options[index].installmentQtd;

                          if (agreement.installmentQuantity == 1) {
                            agreement.dueDate =
                                DateTime.now().add(Duration(days: 3)).day;
                            Modal.showBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) =>
                                    AgreementResumeBottomSheet(
                                      bloc: bloc,
                                      agreement: agreement,
                                      pendingProposal: false,
                                    ));
                          } else {
                            bloc.getPayday();
                            Navigator.pushNamed(
                                context, ApplicationRoute.agreementDayPayment,
                                arguments: [bloc, agreement]);
                          }
                          OwnerAnalyticsLogEvents.logEvent(
                            userId: sessionBloc.state.session?.me?.id ?? "",
                            event: AnalyticsEventsOwner
                                .acordosEscolherOutrasOpcoesDePagamento(),
                            unitValue: sessionBloc.state.session!.unity?.title
                                    .toString() ??
                                "",
                            referenceValue: sessionBloc
                                    .state.session!.condominium?.reference
                                    ?.toString() ??
                                "",
                          );
                        },
                      ),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                  ],
                )),
      ],
    );
  }

  Widget _nextButton(
      AgreementsRecommendationLoadedState state, SessionBloc sessionBloc) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(width: 1, color: LelloTheme.palleteOf(theme).text()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 23.0),
          child: Text(
            getString(context, "button_want_customize_agreements"),
            style: LelloTextStyles.button(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
        ),
        onPressed: () {
          OwnerAnalyticsLogEvents.logEvent(
            userId: sessionBloc.state.session?.me?.id ?? "",
            event: AnalyticsEventsOwner.acordosEscolherPersonalizarAcordo(),
            unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
            referenceValue:
                sessionBloc.state.session!.condominium?.reference?.toString() ??
                    "",
          );
          Modal.showBottomSheet(
              context: context,
              builder: (context) => AgreementInstallmentsBottomSheet(
                    agreement: agreement,
                    //get max state.optionsPayments.installmentQtd
                    min: state.optionsPayments
                        .map((e) => e.installmentQtd)
                        .reduce((value, element) =>
                            value > element ? value : element),
                    onPressed: () {
                      Navigator.pop(context);
                      bloc.getPayday();
                      Navigator.pushNamed(
                          context, ApplicationRoute.agreementDayPayment,
                          arguments: [bloc, agreement, true]);
                    },
                  ));
        },
      ),
    );
  }

  String showValueInstallments(int value) {
    var calculate = (1200.0 / value).toDouble();
    String text = formatCurrency.format(calculate);
    return text;
  }
}
