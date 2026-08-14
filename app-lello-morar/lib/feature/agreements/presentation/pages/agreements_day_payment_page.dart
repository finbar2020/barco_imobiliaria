import 'package:essentials/essentials.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_day_quotas_dialog.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_options_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_payday_bottom_sheet.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_resume_bottom_sheet.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';
import 'package:sprintf/sprintf.dart';

class AgreementsDayPaymentPage extends StatefulWidget {
  const AgreementsDayPaymentPage({Key? key}) : super(key: key);

  @override
  _AgreementsDayPaymentPageState createState() =>
      _AgreementsDayPaymentPageState();
}

class _AgreementsDayPaymentPageState extends State<AgreementsDayPaymentPage> {
  final theme = LelloTheme.light;
  late AgreementsBloc bloc;
  AgreementCreated agreement = AgreementCreated();
  final formatCurrency = NumberFormat.currency(symbol: "R\$");
  int indexList = 0;
  bool checked = false;
  bool indicate = false;
  bool creditCard = false;
  bool loading = false;
  bool privacyPolicyAgreed = false;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as List;
    bloc = arguments[0];
    agreement = arguments[1];
    if (arguments.length > 2) {
      indicate = arguments[2];
    }
    if (arguments.length > 3) {
      creditCard = arguments[3];
    }
    return WillPopScope(
      onWillPop: () async {
        if (creditCard) {
          bloc.getChoicePayment();
          Navigator.popUntil(
            context,
            ModalRoute.withName(ApplicationRoute.agreementsChoicePayment),
          );
          return true;
          // bloc.goToInstallments();
          // Navigator.popUntil(
          //   context,
          //   ModalRoute.withName(ApplicationRoute.agreementInstallment),
          // );
        } else {
          bloc.goToRecommendation();
          Navigator.popUntil(
            context,
            ModalRoute.withName(
                ApplicationRoute.agreementsRecommendationPayment),
          );
        }
        return true;
      },
      child: Theme(
          data: theme,
          child: BlocConsumer<AgreementsBloc, AgreementsState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is PostPendingProposalLoadedState) {
                Navigator.pushNamed(
                  context,
                  ApplicationRoute.agreementSuccessSend,
                  arguments: [bloc],
                );
              }
              if (state is PostAgreementLoadedState) {
                Navigator.pushNamed(
                  context,
                  ApplicationRoute.agreementBillet,
                  arguments: [bloc, creditCard, agreement, state.agreement],
                );
              }
              if (state is AgreementsLoadingState) {
                loading = true;
              } else {
                loading = false;
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: WhiteAppBar(
                  title: creditCard
                      ? "agreement_only_billet"
                      : "agreements_day_payment",
                  isGetString: true,
                  onPressed: creditCard
                      ? () {
                          bloc.getChoicePayment();
                          Navigator.popUntil(
                            context,
                            ModalRoute.withName(
                                ApplicationRoute.agreementsChoicePayment),
                          );
                          // bloc.goToInstallments();
                          // Navigator.popUntil(
                          //   context,
                          //   ModalRoute.withName(
                          //       ApplicationRoute.agreementInstallment),
                          // );
                        }
                      : () {
                          bloc.goToRecommendation();
                          Navigator.popUntil(
                            context,
                            ModalRoute.withName(ApplicationRoute
                                .agreementsRecommendationPayment),
                          );
                        },
                ),
                body: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: creditCard
                      ? _buildCreditCardInfo(state)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              sprintf(getString(context, "agreements_step"),
                                  [2, 2]),
                              style: LelloTextStyles.subtitle(theme)!.copyWith(
                                color: LelloTheme.palleteOf(theme).textOpaque(),
                              ),
                            ),
                            SizedBox(height: Dimens.spacing),
                            Text(
                              getString(
                                  context, "agreements_day_payment_title"),
                              style: LelloTextStyles.subtitleBold(theme),
                            ),
                            SizedBox(height: Dimens.spacingMedium),
                            if (state is AgreementsLoadingState)
                              Expanded(
                                child: Center(
                                  child: LoadingWidget(),
                                ),
                              ),
                            if (state is AgreementsErrorState)
                              Expanded(
                                child: Center(
                                    child: Text(
                                  getString(context, state.errorMessageKey),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                            if (state is AgreementsPaydayLoadedState)
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: state.days.length,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () =>
                                                _selectDay(state, index),
                                            child: AgreementOptionsCard(
                                                check: state.checkList[index],
                                                simpleText: true,
                                                onChanged: (value) {
                                                  _selectDay(state, index);
                                                },
                                                title:
                                                    "${getString(context, "access_control_days").replaceAll("s", "")} ${state.days[index]}"),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: Dimens.spacing),
                                    Center(
                                      child: InkWell(
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {
                                            state.checkList = List.generate(
                                                state.checkList.length,
                                                (index) => false);
                                            checked = false;
                                          });
                                          Modal.showBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) =>
                                                  AgreementPaydayBottomSheet(
                                                    bloc: bloc,
                                                    days: state.days,
                                                    agreement: agreement,
                                                  ));
                                        },
                                        child: Text(
                                          getString(context,
                                              "agreements_other_day_choice"),
                                          style: LelloTextStyles.subBody(theme)!
                                              .copyWith(
                                            color: LelloTheme.palleteOf(theme)
                                                .textOpaque(),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                              "assets/ic_information_orange.svg"),
                                          SizedBox(width: Dimens.spacingSmall),
                                          Expanded(
                                            child: RichText(
                                              text: new TextSpan(
                                                style: LelloTextStyles.subtitle(
                                                    theme),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          " ${getString(context, "agreement_attention")}",
                                                      style: LelloTextStyles
                                                              .subtitleBold(
                                                                  theme)!
                                                          .copyWith(
                                                              color: LelloTheme
                                                                      .palleteOf(
                                                                          theme)
                                                                  .warning())),
                                                  TextSpan(
                                                      text: getString(context,
                                                          "agreement_attention_description"),
                                                      style: LelloTextStyles
                                                          .subtitle(theme)),
                                                ],
                                              ),
                                            ),
                                            // child: Text(
                                            //   getString(context,
                                            //       'you_have_no_quotas')!,
                                            //   style: LelloTextStyles.subtitle(
                                            //           theme)!
                                            //       .copyWith(
                                            //     color:
                                            //         LelloTheme.palleteOf(theme)
                                            //             .textLight(),
                                            //   ),
                                            // ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
                  child: Container(
                    width: double.infinity,
                    height: 52.0,
                    child: creditCard
                        ? IgnorePointer(
                            ignoring: privacyPolicyAgreed == false || loading,
                            child: Opacity(
                              opacity:
                                  privacyPolicyAgreed && !loading ? 1.0 : 0.3,
                              child: PrimaryButton(
                                text: getString(context, "next"),
                                onPressed: () {
                                  Modal.showBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) =>
                                        AgreementResumeBottomSheet(
                                      bloc: bloc,
                                      agreement: agreement,
                                      pendingProposal: false,
                                      creditCard: true,
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : IgnorePointer(
                            ignoring: !checked && !loading,
                            child: Opacity(
                              opacity: checked && !loading ? 1.0 : 0.3,
                              child: PrimaryButton(
                                text: getString(context, "next"),
                                onPressed: () {
                                  agreement;
                                  Modal.showBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) =>
                                          AgreementResumeBottomSheet(
                                            bloc: bloc,
                                            agreement: agreement,
                                            pendingProposal: indicate,
                                          ));
                                },
                              ),
                            ),
                          ),
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget _buildCreditCardInfo(AgreementsState state) {
    if (state is AgreementsLoadingState)
      return Column(
        children: [
          Expanded(
            child: Center(
              child: LoadingWidget(),
            ),
          ),
        ],
      );
    if (state is AgreementsErrorState)
      return Column(
        children: [
          Expanded(
            child: Center(
                child: Text(
              getString(context, state.errorMessageKey),
              textAlign: TextAlign.center,
            )),
          ),
        ],
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          sprintf(getString(context, "agreements_step"), [2, 2]),
          style: LelloTextStyles.subtitle(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).textOpaque(),
          ),
        ),
        SizedBox(height: Dimens.spacing),
        Expanded(
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      getString(
                          context, "agreement_privacy_policy_description"),
                      style: LelloTextStyles.subtitle(theme)),
                  SizedBox(height: Dimens.spacing),
                  GestureDetector(
                    onTap: togglePrivacyPolicyAgreed,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            side: BorderSide(width: 0.5),
                            value: privacyPolicyAgreed,
                            onChanged: (value) {
                              togglePrivacyPolicyAgreed();
                            },
                          ),
                        ),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: getString(context,
                                  "agreement_privacy_policy_compliance_description"),
                              style: LelloTextStyles.subBody(theme),
                              children: [
                                TextSpan(
                                  text: getString(
                                      context, "agreement_privacy_policy"),
                                  style:
                                      LelloTextStyles.subBody(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme)
                                        .textAccent(),
                                    decoration: TextDecoration.underline,
                                    decorationColor: LelloTheme.palleteOf(theme)
                                        .textAccent(),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => UrlLauncherNative.openUrl(
                                        UrlsUri.privacyPolicy().toString()),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ],
    );
  }

  void togglePrivacyPolicyAgreed() {
    setState(() {
      privacyPolicyAgreed = !privacyPolicyAgreed;
    });
  }

  _selectDay(AgreementsPaydayLoadedState state, int index) {
    agreement.dueDate = int.parse(state.days[index]);
    setState(() {
      state.checkList = List.generate(state.checkList.length, (index) => false);
      state.checkList[index] = true;
      checked = true;
      if (state.days[index] == "29" ||
          state.days[index] == "30" ||
          state.days[index] == "31") {
        showDialog(
          context: context,
          builder: (context) => AgreementDayQuotasDialog(),
        );
      }
    });
  }
}
