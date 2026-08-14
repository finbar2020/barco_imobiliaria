import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_registration.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_state.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_term_responsability_dialog.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class ReservationReserveDialog extends StatefulWidget {
  final LoadedDialogState state;
  final ReservationBloc bloc;

  const ReservationReserveDialog({
    Key? key,
    required this.state,
    required this.bloc,
  }) : super(key: key);

  @override
  State<ReservationReserveDialog> createState() =>
      _ReservationReserveDialogState();
}

class _ReservationReserveDialogState extends State<ReservationReserveDialog> {
  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();
  bool termCheck = false;
  int loadingPdf = 0;
  File? file;

  @override
  Widget build(BuildContext context) {
    Map<String, String>? customHeader = authenticationStore.getCustomHeader();
    ThemeData theme = Theme.of(context);
    return Dialog(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogContent(
                  theme: theme,
                  context: context,
                  state: widget.state,
                  bloc: widget.bloc,
                  customHeader: customHeader),
              _buildDialogBottomSheet(
                  theme: theme,
                  context: context,
                  state: widget.state,
                  bloc: widget.bloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogContent(
      {required ThemeData theme,
      required BuildContext context,
      required LoadedDialogState state,
      required ReservationBloc bloc,
      required customHeader}) {
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          state.space.reservationRule.chargeable!
              ? Center(
                  child: SvgPicture.asset("assets/ic_reserve_ticket.svg"),
                )
              : Center(
                  child: SvgPicture.asset("assets/ic_reservas_gratis.svg"),
                ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            "${state.space.name} \n ${DateFormat.yMd().format(state.reserveDate)}",
            textAlign: TextAlign.center,
            style: LelloTextStyles.body(theme)!
                .copyWith(color: theme.primaryColor),
          ),
          Column(
            children: [
              SizedBox(height: Dimens.spacingSmall),
              state.space.reservationRule.chargeable!
                  ? Text(
                      (state.space.reservationRule.price == null ||
                              state.space.reservationRule.price == 0)
                          ? "${state.space.reservationRule.percentageTax?.toPrecision(2)}% ${getString(context, "of_condominium_quota")}"
                          : "${NumberFormat.currency(symbol: "R\$").format(state.space.reservationRule.price)}",
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.bodyBold(theme)!
                          .copyWith(color: theme.primaryColor),
                    )
                  : Text(
                      getString(context, "free"),
                      style: LelloTextStyles.bodyBold(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
            ],
          ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            '${state.session?.condominium?.name ?? ''} - ${state.session?.unity?.title ?? ''}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: LelloTextStyles.caption(theme),
          ),
          SizedBox(height: Dimens.spacingXSmall),
          if (state.space.reservationRule.chargeable!) Divider(),
          SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimens.spacingXSmall),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    state.space.reservationRule.chargeable! ||
                            state.space.reservationRule.isGuarantor
                        ? RichText(
                            text: TextSpan(
                              text: getString(context, "billing_mode"),
                              style: LelloTextStyles.bodyBold(theme)!
                                  .copyWith(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: getString(
                                    context,
                                    state.space.reservationRule.paymentInfo,
                                  ),
                                  style: LelloTextStyles.body(theme),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(height: Dimens.spacingXSmall),
                    Divider(),
                    SizedBox(height: Dimens.spacingSmall),
                    Text(
                      getString(context, "space_registration_terms_use"),
                      style: LelloTextStyles.bodyBold(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    if (state.space.reservationRule.chargeable! || state.space.reservationRule.isGuarantor)
                      Column(
                        children: [
                          Text(
                            getString(context,
                                    "space_registration_usage_term_message")
                                .replaceAll(
                                    "###",
                                    state
                                        .space.reservationRule.cancellationLimit
                                        .toString()),
                            style: LelloTextStyles.body(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).text(),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    Wrap(
                      children: [
                        Text(getString(context, "space_registration_important"),
                            style: LelloTextStyles.bodyBold(theme)),
                        Text(
                          getString(context, "space_registration_read_terms"),
                          style: LelloTextStyles.body(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).text(),
                          ),
                        ),
                        InkWell(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) =>
                                  ReservationTermResponsabilityDialog(
                                term: state.space.term!,
                              ),
                            );
                          },
                          child: Text(
                            getString(context, "space_registration_usage_term"),
                            textAlign: TextAlign.left,
                            style: LelloTextStyles.body(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).textAccent(),
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  LelloTheme.palleteOf(theme).textAccent(),
                            ),
                          ),
                        ),
                        Text(" | ", style: LelloTextStyles.body(theme)),
                        InkWell(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () async {
                            _searchInternalRegimePdf(
                                customHeader, state.space.fileUrl);
                          },
                          child: Text(
                            getString(context,
                                "space_registration_internal_regime_term"),
                            textAlign: TextAlign.left,
                            style: LelloTextStyles.body(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).textAccent(),
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  LelloTheme.palleteOf(theme).textAccent(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogBottomSheet({
    required ThemeData theme,
    required BuildContext context,
    required LoadedDialogState state,
    required ReservationBloc bloc,
  }) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                termCheck = !termCheck;
              });
            },
            child: Container(
              color: LelloTheme.palleteOf(theme).greyCard(),
              child: Padding(
                padding: EdgeInsets.all(Dimens.spacingXSmall),
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        activeColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        side: BorderSide(
                          width: 1.0,
                          color: LelloTheme.palleteOf(theme).separator(),
                        ),
                        value: termCheck,
                        onChanged: (value) {
                          setState(() {
                            termCheck = value!;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: Text(
                          getString(
                              context, "space_registration_agree_with_terms"),
                          style: LelloTextStyles.captionBold(theme)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimens.spacing),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    getString(context, "cancel").toUpperCase(),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).grey(),
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: termCheck == false,
                  child: InkWell(
                    onTap: () {
                      DateTime start = DateTime(
                        state.reserveDate.year,
                        state.reserveDate.month,
                        state.reserveDate.day,
                        int.parse(widget.state.hour.from.substring(0, 2)),
                        int.parse(widget.state.hour.from.substring(3, 5)),
                      );
                      DateTime end = DateTime(
                        state.reserveDate.year,
                        state.reserveDate.month,
                        state.reserveDate.day,
                        int.parse(widget.state.hour.until.substring(0, 2)),
                        int.parse(widget.state.hour.until.substring(3, 5)),
                      );
                      bloc.postReservation(
                        ReservationRegistration(
                          spaceId: state.space.id,
                          space: state.space,
                          unitId: state.session!.unity!.id,
                          idStatus: 83,
                          reservationStartDate: start.toIso8601String(),
                          reservationEndDate: end.toIso8601String(),
                          flagUtilityTerm: true,
                          reservationType: state.space.type!.description,
                        ),
                        state.reserveDate,
                        state.hour,
                      );
                    },
                    child: Opacity(
                      opacity: termCheck == false ? 0.3 : 1.0,
                      child: Text(
                        getString(context, "confirm").toUpperCase(),
                        style: LelloTextStyles.subBody(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).success(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _searchInternalRegimePdf(Map<String, String>? customHeader, fileUrl) async {
    if (fileUrl != "") {
      file = await DefaultCacheManager()
          .getSingleFile(fileUrl, headers: customHeader);

      if (file != null) {
        var directory = await getApplicationDocumentsDirectory();
        var FilePath =
            "${directory.path}/regime_interno_${DateFormat("yyyy_MM_dd_HH_mm_ss").format(DateTime.now())}.pdf";
        var savedFile = file?.copySync(FilePath);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(
              pdfFile: savedFile,
              title: 'Regime Interno',
              canDownload: true,
            ),
          ),
        );
      } else {
        _showFlushBar();
      }
    } else {
      _showFlushBar();
    }
  }

  void _showFlushBar() {
    Flushbar(
        duration: Duration(seconds: 5),
        message:
            getString(context, "space_registration_internal_regime_term_error"))
      ..show(context);
  }
}
