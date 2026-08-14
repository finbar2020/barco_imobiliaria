import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/widgets/hex_color.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_rule.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class ReservationSchudeleCardWidget extends StatefulWidget {
  final ReservationScheduled model;
  final VoidCallback cancelReservation;
  final ReservationBloc bloc;
  const ReservationSchudeleCardWidget({
    Key? key,
    required this.model,
    required this.cancelReservation,
    required this.bloc,
  }) : super(key: key);

  @override
  State<ReservationSchudeleCardWidget> createState() =>
      _ReservationSchudeleCardWidgetState();
}

class _ReservationSchudeleCardWidgetState
    extends State<ReservationSchudeleCardWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SessionBloc sessionBloc = BlocProvider.of(context);
    return Column(
      children: [
        Card(
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            color: widget.model.highlight ? theme.highlightColor : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFDBDBDB),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.spacing),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.model.tituloReserva,
                                style: LelloTextStyles.body(theme),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (widget.model.subTituloReserva != "")
                                Text(
                                  widget.model.subTituloReserva,
                                  style:
                                      LelloTextStyles.caption(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme)
                                        .textOpaque(),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              SizedBox(height: Dimens.spacingSmall),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${widget.model.diaMes}, ${formatHourMinute(widget.model.startReservationDate!)} - ${formatHourMinute(widget.model.endReservationDate!)}",
                                    style: LelloTextStyles.bodyBold(theme),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: Dimens.spacingMedium),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: Dimens.spacingMedium,
                            right: Dimens.spacingMedium),
                        child: Container(
                          height: 10.0,
                          width: 10.0,
                          decoration: BoxDecoration(
                            color: HexColor(widget.model.color),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(Dimens.spacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          final space = widget.bloc.listSpaces.firstWhereOrNull(
                              (element) => element.id == widget.model.areaId);
                          if (widget.model.reservationValue == null ||
                              space == null) {
                            return SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PriceBuilder(
                                  rule: space.reservationRule,
                                  reservation: widget.model),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: Dimens.spacing),
                      Row(
                        children: [
                          Expanded(
                            child: widget.model.canCancel
                                ? CircuitBreakerWidget(
                                    child: Container(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      height: 36.0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: BorderSide(
                                              color: LelloTheme.palleteOf(theme)
                                                  .textLightest(),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          getString(context, "cancel"),
                                          style: LelloTextStyles.button(theme)!
                                              .copyWith(
                                            color: LelloTheme.palleteOf(theme)
                                                .text(),
                                          ),
                                        ),
                                        onPressed: widget.cancelReservation,
                                      ),
                                    ),
                                    applicationRbac: ApplicationRbac
                                        .morarReservasAreasAgendamentosCancelar,
                                    reference: sessionBloc.state.session
                                            ?.condominium?.reference
                                            .toString() ??
                                        "",
                                    appContainer:
                                        ApplicationContainer.instance(),
                                    rbacEnabled: sessionBloc.checkRback(
                                        ApplicationRbac
                                            .morarReservasAreasAgendamentosCancelar),
                                  )
                                : Container(),
                          ),
                          SizedBox(height: Dimens.spacingSmall),
                          Expanded(
                            child: widget.model.payment
                                ? CircuitBreakerWidget(
                                    child: Container(
                                      height: 36.0,
                                      child: PrimaryButton(
                                        text: getString(context, "pay"),
                                        child: isLoading
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      theme.colorScheme.surface,
                                                ),
                                              )
                                            : null,
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          final document = await widget.bloc
                                              .downloadBillet(
                                                  billetNumber:
                                                      widget.model.receipt!);
                                          setState(() {
                                            isLoading = false;
                                          });
                                          if (document == null) {
                                            return;
                                          }
                                          await viewFile(
                                            fileBase64: document.data!,
                                            fileName: document.name,
                                          ).then(
                                            (value) => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PDFScreen(
                                                    pdfFile: value,
                                                    title: 'PDF Boleto',
                                                    canDownload: true),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    applicationRbac: ApplicationRbac
                                        .morarReservasAreasAgendamentosPagar,
                                    reference: sessionBloc.state.session
                                            ?.condominium?.reference
                                            .toString() ??
                                        "",
                                    appContainer:
                                        ApplicationContainer.instance(),
                                    rbacEnabled: sessionBloc.checkRback(
                                        ApplicationRbac
                                            .morarReservasAreasAgendamentosPagar),
                                  )
                                : Container(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: Dimens.spacing),
      ],
    );
  }

  Future<File> viewFile({required String fileBase64, String? fileName}) async {
    Uint8List bytes = base64.decode(fileBase64);
    String name = fileName ?? "billet_file";
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + name);
    await file.writeAsBytes(bytes);
    return file;
  }

  String formatHourMinute(String date) {
    DateTime dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss").parse(date);
    String hour = dateFormat.hour.toString().length < 2
        ? "0${dateFormat.hour.toString()}"
        : dateFormat.hour.toString();
    String minute = dateFormat.minute.toString().length < 2
        ? "0${dateFormat.minute.toString()}"
        : dateFormat.minute.toString();
    return "$hour:$minute";
  }
}

class PriceBuilder extends StatelessWidget {
  final ReservationRule rule;
  final ReservationScheduled reservation;
  const PriceBuilder({
    Key? key,
    required this.rule,
    required this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Builder(builder: (context) {
      if (reservation.reservationValue != null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${getString(context, "refund_value")} ${NumberFormat.currency(symbol: "R\$").format(reservation.reservationValue ?? 0.0)}",
              style: LelloTextStyles.body(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              ),
            ),
            SizedBox(height: Dimens.spacingXSmall),
            Text(
              reservation.paymentMethodTile(context),
              style: LelloTextStyles.body(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              ),
            ),
          ],
        );
      }
      return Container();
    });
  }
}
