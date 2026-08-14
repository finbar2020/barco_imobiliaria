import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';

class ReservationSuccessDialog extends StatefulWidget {
  final ReservationBloc bloc;
  final ReservationScheduled reserva;
  final Space? space;
  final Condominium? condominium;
  final Unity? unity;

  const ReservationSuccessDialog({
    Key? key,
    required this.bloc,
    required this.reserva,
    required this.space,
    required this.condominium,
    required this.unity,
  }) : super(key: key);

  @override
  State<ReservationSuccessDialog> createState() =>
      _ReservationSuccessDialogState();
}

class _ReservationSuccessDialogState extends State<ReservationSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    DateTime reserveDate = DateFormat("dd/MM/yyyy HH:mm")
        .parse(widget.reserva.startReservationDate!);

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_reserve_ticket.svg"),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              "${widget.space?.name} \n ${DateFormat.yMd().format(reserveDate)}",
              textAlign: TextAlign.center,
              style: LelloTextStyles.body(theme)!
                  .copyWith(color: theme.primaryColor),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              '${widget.condominium?.name ?? ''} - ${widget.unity?.title ?? ''}',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: LelloTextStyles.body(theme),
            ),
            SizedBox(height: Dimens.spacing),
            Divider(),
            SizedBox(height: Dimens.spacing),
            Text(
              getString(context, "space_reservation_reservation_success"),
              style: LelloTextStyles.bodyBold(theme)!
                  .copyWith(color: LelloTheme.palleteOf(theme).success()),
            ),
            widget.space?.reservationRule.chargeable == true &&
                    widget.space?.reservationRule.isGuarantor == false
                ? buildPaidReservation(context, theme)
                : buildFreeReservation(context, theme)
          ],
        ),
      ),
    );
  }

  Widget buildFreeReservation(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingMedium),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    getString(context, "ok"),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  bool isLoading = false;

  Widget buildPaidReservation(BuildContext context, ThemeData theme) {
    if (widget.reserva.receipt != null && widget.reserva.billetCode != null) {
      return Column(
        children: [
          Text(
            "${getString(context, "income_billet_detail_expiration")} ${widget.reserva.vencimento}",
            style: LelloTextStyles.body(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).textLightest()),
          ),
          SizedBox(height: Dimens.spacingLarge),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: OutlinedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final document = await widget.bloc
                    .downloadBillet(billetNumber: widget.reserva.receipt!);
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
              child: Container(
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : Text(getString(context, "income_billet_detail_open"),
                        style: LelloTextStyles.button(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).text())),
              ),
            ),
          ),
          SizedBox(height: Dimens.spacingSmall),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: OutlinedButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text: widget.reserva.billetCode ?? "",
                  ),
                ).then(
                  (value) => Flushbar(
                    duration: Duration(seconds: 1),
                    message: getString(context, "billet_copied_barcode"),
                  )..show(context),
                );
              },
              child: Container(
                child: Text(getString(context, "billet_copy_barcode"),
                    style: LelloTextStyles.button(theme)!
                        .copyWith(color: LelloTheme.palleteOf(theme).text())),
              ),
            ),
          ),
          SizedBox(height: Dimens.spacingSmall),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.transparent,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Text(getString(context, "pay_later"),
                    style: LelloTextStyles.button(theme)!
                        .copyWith(color: theme.colorScheme.error)),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(height: Dimens.spacingLarge),
        Text(
          "${getString(context, "chat_error_title")}!",
          textAlign: TextAlign.center,
          style: LelloTextStyles.subtitle(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).textLight()),
        ),
        SizedBox(height: Dimens.spacingSmall),
        Text(
          getString(context, widget.space?.reservationRule.paymentInfo ?? ''),
          textAlign: TextAlign.center,
          style: LelloTextStyles.subtitle(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).textLight()),
        ),
        SizedBox(height: Dimens.spacingLarge),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    getString(context, "ok"),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
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
}
