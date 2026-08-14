import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_state.dart';
import 'package:morar/feature/insurance/presentation/controller/insurance_controller.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class InsuranceContractDialog extends StatefulWidget {
  const InsuranceContractDialog({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final InsuranceController controller;

  @override
  _InsuranceContractDialogState createState() =>
      _InsuranceContractDialogState();
}

class _InsuranceContractDialogState extends State<InsuranceContractDialog> {
  bool initialized = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(getString(context, "insurance_contract_terms"),
                style: LelloTextStyles.body(theme)!
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
              style: LelloTextStyles.caption(theme),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Container(
                color: LelloTheme.palleteOf(theme).backgroundDark(),
                height: 270.0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      getString(context, "insurance_contract_terms_details"),
                      style: LelloTextStyles.subBody(theme),
                    ),
                  ),
                )),
            Container(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
              width: double.infinity,
              child: PrimaryButton(
                text: getString(context, "confirm"),
                onPressed: () {
                  widget.controller.postInsurance(false);
                  Navigator.pop(context);
                },
              ),
            ),
            if ((widget.controller.bloc.state as LoadedInsuranceState)
                    .model
                    ?.insuranceInfo
                    ?.termoDeUso !=
                null)
              Container(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                width: double.infinity,
                child: SecondaryButton(
                  text: getString(context, "insurance_use_terms_download"),
                  onPressed: () async {
                    String? terms =
                        (widget.controller.bloc.state as LoadedInsuranceState)
                            .model
                            ?.insuranceInfo
                            ?.termoDeUso;
                    await _downloadTerms(terms, context);
                  },
                ),
              ),
            InkWell(
              onTap: () {
                _registerAnalyticsEvent(sessionBloc);
                Navigator.pop(context);
              },
              child: Text(
                getString(context, "cancel"),
                style: LelloTextStyles.subBody(theme)!.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _downloadTerms(String? url, BuildContext context) async {
    if (url == null) {
      Flushbar(
        message: getString(context, "warning_failed_message"),
        duration: Duration(seconds: 2),
      )..show(context);
      return;
    }
    if (await CheckPermissions.storage()) {
      FileMethods.getFileFromUrl(url, name: "termos_de_contratacao.pdf").then(
        (value) => {
          setState(() {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFScreen(
                    pdfFile: value,
                    title: 'Termos de Contratacao',
                    canDownload: true),
              ),
            );
          })
        },
      );
    }
  }

  void _registerAnalyticsEvent(SessionBloc sessionBloc) {
    OwnerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsOwner.comodidadesParceiroSegurosDesistir(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
      referenceValue:
          sessionBloc.state.session!.condominium!.reference.toString(),
    );
  }
}
