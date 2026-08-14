import 'dart:io';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/app_review/app_review.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';

class AgreementsBilletPage extends StatefulWidget {
  const AgreementsBilletPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AgreementsBilletPage> createState() => _AgreementsBilletPageState();
}

class _AgreementsBilletPageState extends State<AgreementsBilletPage> {
  final formatCurrency = NumberFormat.currency(symbol: "R\$");
  bool creditCard = false;
  AgreementCreated agreementCreated = AgreementCreated();
  late Agreement agreement;
  late AgreementsBloc bloc;
  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();
  File? file;
  String condoId = "";
  int loadingPdf = 0; // 0 = erro 1= loading 2= sucesso
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var arguments = ModalRoute.of(context)!.settings.arguments as List;
    bloc = arguments[0];
    creditCard = arguments[1];
    agreementCreated = arguments[2];
    agreement = arguments[3];

    final SessionBloc sessionBloc = BlocProvider.of(context);
    Map<String, String>? customHeader = authenticationStore.getCustomHeader();

    condoId = sessionBloc.state.session!.condominium!.id!;
    return WillPopScope(
      onWillPop: () async {
        bloc.goToAgreements(agreementCreated);
        Navigator.popUntil(
            context, ModalRoute.withName(ApplicationRoute.agreements));
        return true;
      },
      child: Scaffold(
        appBar: WhiteAppBar(
          title: getString(context, "income_billet_detail_billet"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Dimens.spacingMedium),
                Center(
                  child: Container(
                    height: 86.0,
                    width: 70.0,
                    child:
                        SvgPicture.asset("assets/ic_agreement_billet_big.svg"),
                  ),
                ),
                SizedBox(height: Dimens.homeMenuIconSize),
                Text(
                  sessionBloc.state.session!.condominium!.name!,
                  style: LelloTextStyles.titleSmallBold(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
                SizedBox(height: Dimens.spacingSmall),
                Text(
                  "${getString(context, "non_payments_item_title")} ${sessionBloc.state.session!.unity!.namedTitle}",
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.body(theme),
                ),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                  getString(context, "agreements_billet"),
                  style: LelloTextStyles.titleSmallBold(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
                SizedBox(height: Dimens.spacingSmall),
                Text(
                  formatCurrency.format(agreementCreated.totalValue),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.body(theme),
                ),
                if (creditCard) SizedBox(height: Dimens.spacingMedium),
                if (creditCard)
                  Text(getString(context, "agreement_billet_info_digital"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)),
                SizedBox(height: Dimens.spacingLarge),
                Row(
                  children: [
                    Expanded(
                      child: _buidSharedButton(theme, () async {
                        await _searchBilletPdf(customHeader);
                      }, loadingPdf, sessionBloc),
                    )
                  ],
                ),
                SizedBox(height: Dimens.spacing),
                _buildButton(
                  context,
                  theme,
                  "billet_copy_barcode",
                  () {
                    Clipboard.setData(ClipboardData(text: agreement.getBarCode))
                        .then((value) {
                      _registerAnalyticsEvent(sessionBloc, false);
                      return Flushbar(
                        duration: Duration(seconds: 1),
                        message: getString(context, "billet_copied_barcode"),
                      )..show(context);
                    });
                  },
                ),
                if (creditCard) SizedBox(height: Dimens.spacing),
                if (creditCard)
                  _buildButton(
                    context,
                    theme,
                    "agreement_go_to_pay",
                    () {
                      UrlLauncherNative.openUrl(agreement.getPaymentLink.
                      toString(),);
                      _registerAnalyticsEventPartner(sessionBloc);
                    },
                    otherColor: true,
                  ),
                SizedBox(height: Dimens.spacing),
                _buildButton(
                  context,
                  theme,
                  "conclude",
                  () {
                    bloc.goToAgreements(agreementCreated);
                    AppReview.call(context: context);
                    Navigator.popUntil(context,
                        ModalRoute.withName(ApplicationRoute.agreements));
                  },
                ),
                SizedBox(height: Dimens.spacing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, ThemeData theme, String title,
      VoidCallback onPressed,
      {bool otherColor = false}) {
    return Container(
      padding: const EdgeInsets.only(right: 5.0),
      height: 54.0,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: otherColor
              ? LelloTheme.palleteOf(theme).success()
              : LelloTheme.palleteOf(theme).customColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: otherColor
                  ? LelloTheme.palleteOf(theme).success()
                  : LelloTheme.palleteOf(theme).textLightest(),
            ),
          ),
        ),
        child: Text(
          getString(context, title),
          style: LelloTextStyles.button(theme)!.copyWith(
            color: otherColor
                ? LelloTheme.palleteOf(theme).customColor()
                : LelloTheme.palleteOf(theme).text(),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  _buidSharedButton(ThemeData theme, VoidCallback onPressed, int loading,
      SessionBloc sessionBloc) {
    return Container(
      padding: const EdgeInsets.only(right: 5.0),
      height: 54.0,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: LelloTheme.palleteOf(theme).customColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: LelloTheme.palleteOf(theme).textLightest(),
            ),
          ),
        ),
        child: loading == 1
            ? CircularProgressIndicator()
            : Text(
                getString(context, "agreement_billet_view"),
                style: LelloTextStyles.button(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
        onPressed: () {
          _registerAnalyticsEvent(sessionBloc, true);
          onPressed();
        },
      ),
    );
  }

  _searchBilletPdf(Map<String, String>? customHeader) async {
    setState(() {
      loadingPdf = 1;
    });
    if (agreement.installmentId != "") {
      file = await DefaultCacheManager()
          .getSingleFile(
              "${agreement.baseUrl}/condominiums/$condoId/agreement/installment/${agreement.installmentId}/download",
              headers: customHeader)
          .whenComplete(() => setState(() {
                loadingPdf = 2;
              }));
    } else {
      setState(() {
        loadingPdf = 0;
      });
    }
    if (loadingPdf == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PDFScreen(pdfFile: file, title: 'PDF Boleto', canDownload: true),
        ),
      );
    } else {
      Flushbar(
        duration: Duration(seconds: 1),
        message: getString(context, "request_fine_error_message"),
      )..show(context);
    }
  }

  void _registerAnalyticsEvent(SessionBloc sessionBloc, bool billetView) {
    OwnerAnalyticsLogEvents.logEvent(
      userId: sessionBloc.state.session?.me?.id ?? "",
      event: billetView
          ? AnalyticsEventsOwner.acordosVisualizarBoleto()
          : AnalyticsEventsOwner.acordosCopiarCodigoDeBarras(),
      unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
      referenceValue:
          sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
    );
  }

  void _registerAnalyticsEventPartner(SessionBloc sessionBloc) {
    OwnerAnalyticsLogEvents.logEvent(
      userId: sessionBloc.state.session?.me?.id ?? "",
      event: AnalyticsEventsOwner.acordosAcessarSiteParceiroVamosParcelar(),
      unitValue: sessionBloc.state.session!.unity?.namedTitle.toString() ?? "",
      referenceValue:
          sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
    );
  }
}
