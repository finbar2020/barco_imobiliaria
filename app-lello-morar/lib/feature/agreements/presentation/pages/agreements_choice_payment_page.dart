import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_payment_method.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_payment_method_enum.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_options_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_options_payment_bottom_sheet.dart';
import 'package:morar/feature/me/presentation/pages/me_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';

class AgreementsChoicePaymentPage extends StatefulWidget {
  const AgreementsChoicePaymentPage({Key? key}) : super(key: key);

  @override
  _AgreementsChoicePaymentPageState createState() =>
      _AgreementsChoicePaymentPageState();
}

class _AgreementsChoicePaymentPageState
    extends State<AgreementsChoicePaymentPage> {
  final theme = LelloTheme.light;
  late AgreementsBloc bloc;
  AgreementCreated agreement = AgreementCreated();
  AgreementPaymentMethod? paymentMethod; // 1 == Boleto || 0 == Cartão
  late SessionBloc sessionBloc;

  @override
  Widget build(BuildContext context) {
    sessionBloc = BlocProvider.of(context);
    var arguments = ModalRoute.of(context)!.settings.arguments as List;
    bloc = arguments[0];
    agreement = arguments[1];
    return WillPopScope(
      onWillPop: () async {
        bloc.goToAgreements(agreement);
        Navigator.popUntil(
            context, ModalRoute.withName(ApplicationRoute.agreements));
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocBuilder<AgreementsBloc, AgreementsState>(
          bloc: bloc,
          builder: (context, state) {
            if (!(state is AgreementsChoiceLoadedState)) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.white,
              );
            }
            return Scaffold(
              appBar: WhiteAppBar(
                title: "pendency_type_payment",
                isGetString: true,
                onPressed: () {
                  bloc.goToAgreements(agreement);
                  Navigator.popUntil(context,
                      ModalRoute.withName(ApplicationRoute.agreements));
                },
              ),
              body: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paymentMethod?.type == AgreementPaymentMethodEnum.billet
                            ? sprintf(
                                getString(context, "agreements_step"), [1, 3])
                            : sprintf(
                                getString(context, "agreements_step"), [1, 2]),
                        style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textOpaque(),
                        ),
                      ),
                      SizedBox(height: Dimens.spacing),
                      Text(
                        getString(context, "agreements_choice_payment"),
                        style: LelloTextStyles.subtitleBold(theme),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: state.agreementPaymentMethod.length,
                        itemBuilder: (context, index) {
                          final item = state.agreementPaymentMethod[index];
                          return GestureDetector(
                            onTap: () {
                              _onClickPaymentMethod(item, context);
                            },
                            child: AgreementOptionsCard(
                              check: paymentMethod == item,
                              icon: item.getIcon(),
                              title: item.getTitle(),
                              subtitle: item.description,
                              enabled: item.enabled,
                              onChanged: (value) {
                                _onClickPaymentMethod(item, context);
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: Dimens.spacing),
                      InkWell(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        onTap: () {
                          Modal.showBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) =>
                                  AgreementOptionsPaymentBottomSheet());
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: Dimens.spacingLarge,
                              color: LelloTheme.palleteOf(theme).textAccent(),
                            ),
                            SizedBox(
                              width: Dimens.spacingSmall,
                            ),
                            Text(
                              getString(context, "agreements_understand"),
                              overflow: TextOverflow.ellipsis,
                              style: LelloTextStyles.subBody(theme)!.copyWith(
                                color: LelloTheme.palleteOf(theme).textAccent(),
                                decoration: TextDecoration.underline,
                                decorationColor: LelloTheme.palleteOf(theme)
                                    .textAccent(),
                              ),
                            ),
                            Text(
                              getString(
                                  context, "agreements_understand_options"),
                              overflow: TextOverflow.ellipsis,
                              style: LelloTextStyles.subBody(theme)!.copyWith(
                                  color:
                                      LelloTheme.palleteOf(theme).textOpaque()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: IgnorePointer(
                ignoring: paymentMethod == null,
                child: Opacity(
                  opacity: paymentMethod == null ? 0.3 : 1.0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      25.0,
                      10.0,
                      25.0,
                      25.0,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 52.0,
                      child: PrimaryButton(
                        text: getString(context, "next"),
                        onPressed: () {
                          bloc.getPayday();
                          if (paymentMethod?.type ==
                              AgreementPaymentMethodEnum.billet) {
                            agreement.paymentMethod =
                                AgreementPaymentMethodEnum.billet.index;
                            bloc.getRecommendation();
                            Navigator.pushNamed(
                                context,
                                ApplicationRoute
                                    .agreementsRecommendationPayment,
                                arguments: [bloc, agreement, false]);
                          } else {
                            agreement.paymentMethod =
                                AgreementPaymentMethodEnum.credit.index;
                            bloc.getInstallments(agreement.totalValue);
                            Navigator.pushNamed(
                                context, ApplicationRoute.agreementDayPayment,
                                arguments: [bloc, agreement, false, true]);
                          }
                          _registerAnalyticsEvent(agreement, sessionBloc);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onClickPaymentMethod(
      AgreementPaymentMethod item, BuildContext context) {
    bool emailEmpty = checkEmailEmpty();
    bool phoneEmpty = checkPhoneEmpty();
    setState(() {
      if (item.enabled == false) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Markdown(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        data: item.disabledDescription),
                    SizedBox(height: Dimens.spacing),
                    Padding(
                      padding: EdgeInsets.all(Dimens.spacing),
                      child: PrimaryButton(
                        text: getString(context, "ok"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              );
            });
      } else if (item.type == AgreementPaymentMethodEnum.credit &&
          (phoneEmpty || emailEmpty)) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Padding(
                  padding: EdgeInsets.all(Dimens.spacingLarge),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Transform.scale(
                          scale: 1.2,
                          child: SvgPicture.asset(
                            "assets/ic_billet_alert.svg",
                          ),
                        ),
                      ),
                      SizedBox(height: Dimens.spacing),
                      Text(
                        getString(
                            context, "agreements_credit_incomplete_info_title"),
                        style: LelloTextStyles.subtitle(theme),
                      ),
                      SizedBox(height: Dimens.spacing),
                      Text(
                        getString(
                            context, "agreements_credit_incomplete_info_body"),
                        style:
                            LelloTextStyles.body(theme)!.copyWith(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      if (emailEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimens.spacingSmall),
                          child: Text(
                            getString(context, "me_email_title"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                        ),
                      if (phoneEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimens.spacingSmall),
                          child: Text(
                            getString(context, "me_phone_title"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                        ),
                      SizedBox(height: Dimens.spacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              getString(context, "cancel").toUpperCase(),
                              style: LelloTextStyles.subBody(theme)!.copyWith(
                                color: LelloTheme.palleteOf(theme).text(),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: goMeEdit,
                            child: Text(
                              "VAMOS LÁ",
                              style: LelloTextStyles.subBody(theme)!.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      } else {
        paymentMethod = item;
      }
    });
  }

  _registerAnalyticsEvent(agreement, SessionBloc sessionBloc) {
    if (agreement.paymentMethod == 0) {
      OwnerAnalyticsLogEvents.logEvent(
        userId: sessionBloc.state.session?.me?.id ?? "",
        event: AnalyticsEventsOwner.acordosEscolherPagarCartaoDeCredito(),
        unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
    } else if (agreement.paymentMethod == 1) {
      OwnerAnalyticsLogEvents.logEvent(
        userId: sessionBloc.state.session?.me?.id ?? "",
        event: AnalyticsEventsOwner.acordosEscolherPagarBoleto(),
        unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
    }
  }

  bool checkPhoneEmpty() {
    var sessState = sessionBloc.state;
    if (sessState is SessionLoadedState) {
      return sessState.session?.me?.phone?.isEmpty ?? true;
    }
    return false;
  }

  bool checkEmailEmpty() {
    var sessState = sessionBloc.state;
    if (sessState is SessionLoadedState) {
      return sessState.session?.me?.email?.isEmpty ?? true;
    }
    return false;
  }

  void goMeEdit() {
    Navigator.pop(context);
    Navigator.of(context).pushNamed(ApplicationRoute.me,
        arguments: MePageArgs(
          autoEditMode: true,
          emailRequired: true,
          phoneRequired: true,
          backAfterSave: true,
        ));
  }
}
