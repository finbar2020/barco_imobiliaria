import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';

class AgreementCard extends StatefulWidget {
  final Agreement agreement;
  final AgreementCreated agreementCreated;
  final AgreementsBloc bloc;
  final BuildContext anotherContext;
  const AgreementCard({
    Key? key,
    required this.agreement,
    required this.agreementCreated,
    required this.bloc,
    required this.anotherContext,
  }) : super(key: key);

  @override
  _AgreementCardState createState() => _AgreementCardState();
}

class _AgreementCardState extends State<AgreementCard> {
  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();
  File? file;
  int loadingPdf = 0; // 0 = erro 1= loading 2= sucesso
  Map<String, String>? customHeader;
  String condoId = "";
  @override
  void initState() {
    super.initState();
    customHeader = authenticationStore.getCustomHeader();
    final SessionBloc sessionBloc = BlocProvider.of(context);
    condoId = sessionBloc.state.session!.condominium!.id!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final SessionBloc sessionBloc = BlocProvider.of(context);

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: widget.agreement.isPending
          ? () {}
          : () {
              widget.bloc.getDetails(agreementId: widget.agreement.id);
              Navigator.pushNamed(context, ApplicationRoute.agreementDetail,
                  arguments: [widget.bloc, widget.agreementCreated]);
            },
      child: Container(
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color:
              widget.agreement.highlight ? theme.highlightColor : Colors.white,
          elevation: 8,
          shadowColor: Colors.grey,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: widget.agreement.isPending
                  ? _buildPendingBody(theme, context, sessionBloc)
                  : _buildCanceledAndReleasedBody(theme, context, sessionBloc),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildCanceledAndReleasedBody(
      ThemeData theme, BuildContext context, SessionBloc sessionBloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.agreement.date,
              style: LelloTextStyles.subtitle(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).textLight(),
              ),
            ),
            SizedBox(width: Dimens.spacingSmall),
            Row(
              children: [
                Text(
                  widget.agreement.getStatusInfo(context),
                  style: LelloTextStyles.caption(theme)?.copyWith(
                    color: widget.agreement.getStatusColor(theme),
                  ),
                ),
                SizedBox(width: Dimens.spacingSmall),
                Container(
                  height: 10.0,
                  width: 10.0,
                  decoration: BoxDecoration(
                      color: widget.agreement.getStatusColor(theme),
                      borderRadius: BorderRadius.circular(25.0)),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            getString(context, "agreement_new_expiration").toUpperCase(),
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).textLight(),
            ),
          ),
        ),
        Text(
          widget.agreement.newExpiration,
          style: LelloTextStyles.subBody(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).text(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            getString(context, "agreement_new_value").toUpperCase(),
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).textLight(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.agreement.newValue,
              style: LelloTextStyles.subBody(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              ),
            ),
            if (widget.agreement.isReleased)
              Icon(Icons.keyboard_arrow_right,
                  color: LelloTheme.palleteOf(theme).textLight()),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            getString(context, "agreements_installments").toUpperCase(),
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).textLight(),
            ),
          ),
        ),
        Text(
          widget.agreement.getInstallments,
          style: LelloTextStyles.subBody(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).text(),
          ),
        ),
        if (widget.agreement.isReleased) SizedBox(height: Dimens.spacing),
        if (widget.agreement.isReleased)
          Row(
            children: [
              Expanded(
                  child: _buidSharedButton(theme, () async {
                await _searchBilletPdf();
              }, loadingPdf, sessionBloc)),
              _buildPaymentButton(theme, sessionBloc),
            ],
          ),
      ],
    );
  }

  Widget _buildPaymentButton(ThemeData theme, SessionBloc sessionBloc) {
    if (widget.agreement.getPaymentLink != null)
      return Expanded(
          child: _buildButton(
        context,
        theme,
        "agreement_go_to_pay",
        () {
          UrlLauncherNative.openUrl(widget.agreement.getPaymentLink.toString())
              .then((value) => _registerAnalyticsEvent(sessionBloc, false));
        },
        otherColor: true,
      ));
    else
      return Expanded(
          child: _buildButton(
        context,
        theme,
        "billet_copy_barcode",
        widget.agreement.getBarCode != ""
            ? () async {
                Clipboard.setData(
                        ClipboardData(text: widget.agreement.getBarCode))
                    .then((value) {
                  _registerAnalyticsEvent(sessionBloc, false);
                  return Flushbar(
                    duration: Duration(seconds: 1),
                    message: getString(context, "billet_copied_barcode"),
                  )..show(context);
                });
              }
            : () {},
      ));
  }

  Widget _buildPendingBody(
      ThemeData theme, BuildContext context, SessionBloc sessionBloc) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.agreement.date,
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).textLight(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    getString(context, 'original_value'),
                    style: LelloTextStyles.caption(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).textLight(),
                    ),
                  ),
                ),
                Text(
                  widget.agreement.base,
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    getString(context, 'taxes'),
                    style: LelloTextStyles.caption(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).textLight(),
                    ),
                  ),
                ),
                Text(
                  widget.agreement.fine,
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    getString(context, 'update_value'),
                    style: LelloTextStyles.caption(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).textLight(),
                    ),
                  ),
                ),
                Text(
                  widget.agreement.total,
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: Dimens.spacingSmall),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Expanded(
                      child: Text(
                        widget.agreement.getStatusInfo(context),
                        textAlign: TextAlign.end,
                        style: LelloTextStyles.caption(theme)?.copyWith(
                          color: widget.agreement.getStatusColor(theme),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimens.spacingSmall),
                  Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                        color: widget.agreement.getStatusColor(theme),
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, ThemeData theme, String title,
      VoidCallback onPressed,
      {bool otherColor = false}) {
    return Container(
      padding: const EdgeInsets.only(right: 5.0),
      height: 54.0,
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

  _searchBilletPdf() async {
    setState(() {
      loadingPdf = 1;
    });
    if (widget.agreement.installmentId != "") {
      file = await DefaultCacheManager()
          .getSingleFile(
              "${widget.agreement.baseUrl}/condominiums/$condoId/agreement/installment/${widget.agreement.installmentId}/download",
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
      event: billetView
          ? AnalyticsEventsOwner.acordosVisualizarBoleto()
          : AnalyticsEventsOwner.acordosCopiarCodigoDeBarras(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
      referenceValue:
          sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
    );
  }
}
