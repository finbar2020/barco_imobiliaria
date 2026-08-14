import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_installments_option.dart';
import 'package:sprintf/sprintf.dart';

class AgreementsInstallmentPage extends StatefulWidget {
  const AgreementsInstallmentPage({Key? key}) : super(key: key);

  @override
  _AgreementsInstallmentPageState createState() =>
      _AgreementsInstallmentPageState();
}

class _AgreementsInstallmentPageState extends State<AgreementsInstallmentPage> {
  final theme = LelloTheme.light;
  late AgreementsBloc bloc;
  AgreementCreated agreement = AgreementCreated();
  final formatCurrency = NumberFormat.currency(symbol: "R\$");
  int indexList = 0;
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as List;
    bloc = arguments[0];
    agreement = arguments[1];
    return WillPopScope(
      onWillPop: () async {
        bloc.getChoicePayment();
        Navigator.popUntil(
          context,
          ModalRoute.withName(ApplicationRoute.agreementsChoicePayment),
        );
        return true;
      },
      child: Theme(
          data: theme,
          child: BlocBuilder<AgreementsBloc, AgreementsState>(
            bloc: bloc,
            builder: (context, state) {
              return Scaffold(
                appBar: WhiteAppBar(
                  title: "agreements_installments",
                  isGetString: true,
                  onPressed: () {
                    bloc.getChoicePayment();
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(
                          ApplicationRoute.agreementsChoicePayment),
                    );
                  },
                ),
                body: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        sprintf(getString(context, "agreements_step"), [2, 3]),
                        style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textOpaque(),
                        ),
                      ),
                      SizedBox(height: Dimens.spacing),
                      Text(
                        getString(context, "agreements_installments_title"),
                        style: LelloTextStyles.subtitleBold(theme),
                      ),
                      SizedBox(height: Dimens.spacing),
                      if (state is AgreementsLoadingState)
                        Expanded(
                          child: Center(
                            child: LoadingWidget(),
                          ),
                        ),
                      if (state is AgreementsErrorState)
                        Expanded(
                          child: Center(
                            child: Container(
                              height: 60.0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    getString(context, state.errorMessageKey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (state is AgreementsInstallmentLoadedState)
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.installments.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return AgreementInstallmentsOption(
                                installment: state.installments[index],
                              );
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: Dimens.spacingMedium,
                              color: LelloTheme.palleteOf(theme).textOpaque(),
                            ),
                            SizedBox(width: Dimens.spacingSmall),
                            Expanded(
                              child: Text(
                                getString(
                                    context, "agreement_tax_credit_info"),
                                style: LelloTextStyles.caption(theme)!.copyWith(
                                  color:
                                      LelloTheme.palleteOf(theme).textOpaque(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
                  child: Container(
                    width: double.infinity,
                    height: 52.0,
                    child: PrimaryButton(
                      text: getString(context, "next"),
                      onPressed: () {
                        bloc.getPayday();
                        Navigator.pushNamed(
                            context, ApplicationRoute.agreementDayPayment,
                            arguments: [bloc, agreement, false, true]);
                      },
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
