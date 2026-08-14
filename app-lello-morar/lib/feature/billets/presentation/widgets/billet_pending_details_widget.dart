import 'dart:convert';
import 'dart:io';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';
import 'package:morar/feature/billets/domain/entity/billet_status_enum.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class BilletPendingDetailsWidget extends StatelessWidget {
  final Billet billet;
  final Function(String text) copyBarcodeFunction;
  final String? pdf;
  final String? fileName;
  const BilletPendingDetailsWidget({
    Key? key,
    required this.billet,
    required this.copyBarcodeFunction,
    required this.pdf,
    required this.fileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SessionBloc sessionBloc = BlocProvider.of(context);
    ThemeData theme = Theme.of(context);
    return pdf != null
        ? Column(
            children: [
              Center(
                child: Text(
                  getString(context, "billet_info_payment"),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              CircuitBreakerWidget(
                reference:
                    sessionBloc.state.session?.condominium?.reference ?? "",
                appContainer: ApplicationContainer.instance(),
                applicationRbac: ApplicationRbac.morarBoletosVisualizar,
                rbacEnabled: sessionBloc
                    .checkRback(ApplicationRbac.morarBoletosVisualizar),
                child: PrimaryButton(
                  text: getString(context, "income_billet_detail_open"),
                  onPressed: () async {
                    _registerAnalyticsEventShare(sessionBloc);
                    await viewFile(fileBase64: pdf!, fileName: fileName).then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(
                              pdfFile: value,
                              title: 'PDF Boleto',
                              canDownload: true,
                              fileName: fileName),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              if (billet.code != null &&
                  billet.situation == BilletStatusEnum.pendente)
                CircuitBreakerWidget(
                  reference:
                      sessionBloc.state.session?.condominium?.reference ?? "",
                  appContainer: ApplicationContainer.instance(),
                  applicationRbac: ApplicationRbac.morarBoletosCodigoDeBarras,
                  rbacEnabled: sessionBloc
                      .checkRback(ApplicationRbac.morarBoletosCodigoDeBarras),
                  child: SecondaryButton(
                    buttonBorderColor: LelloTheme.palleteOf(theme).textOpaque(),
                    child: Text(
                      getString(context, "billet_copy_barcode"),
                      style: LelloTextStyles.button(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
                    onPressed: () {
                      copyBarcodeFunction(billet.code!);
                    },
                  ),
                ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  getString(context, "billet_contact_us"),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              SecondaryButton(
                buttonBorderColor: LelloTheme.palleteOf(theme).textOpaque(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/ic_whats.svg"),
                    SizedBox(width: Dimens.spacingSmall),
                    Text(
                      getString(context, "whats_app_button_title"),
                      style: LelloTextStyles.button(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  _openWhatsapp(context);
                },
              ),
            ],
          );
  }

  Future<void> _openWhatsapp(BuildContext context) async {
    String message = getString(context, "whats_app_default_message");
    Launch.whatsApp(context, FlavorConfig.config.supportMoradorWhatsAppNumber,
        message: message);
  }

  Future<File> viewFile({required String fileBase64, String? fileName}) async {
    Uint8List bytes = base64.decode(fileBase64);
    String name = fileName ?? "billet_file.pdf";
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + name);
    await file.writeAsBytes(bytes);
    return file;
  }

  void _registerAnalyticsEventShare(SessionBloc sessionBloc) {
    String reference = sessionBloc.state.session?.condominium?.reference ?? "";
    String unit = sessionBloc.state.session?.unity?.title ?? "";
    OwnerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsOwner.boletosCompartilhar(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: unit,
      referenceValue: reference,
    );
  }
}
