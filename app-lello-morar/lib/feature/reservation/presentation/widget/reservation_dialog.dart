import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/widgets/hex_color.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_state.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_moves_dialog.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_reserve_dialog.dart';

class ReservationDialog extends StatefulWidget {
  final ReservationBloc bloc;
  const ReservationDialog({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  _ReservationDialogState createState() => _ReservationDialogState();
}

class _ReservationDialogState extends State<ReservationDialog> {
  late ReservationBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<ReservationBloc, ReservationState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is ReservationSendSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is LoadingDialogState) {
          return Dialog(
              child: Container(
            height: 250.0,
            child: Column(
              children: [
                Expanded(
                  child: LoadingWidget(),
                ),
              ],
            ),
          ));
        }
        if (state is FailureDialogState) {
          return _buildLimitedDates(theme: theme, keyMessage: state.message!);
        }
        if (state is LoadedDialogState) {
          if (state.isBillet &&
              state.billetData != null &&
              state.billetName != null) {
            viewFile(state.billetData!, state.billetName!)
                .then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFScreen(
                            pdfFile: value,
                            title: 'PDF Boleto',
                            canDownload: true),
                      ),
                    ));
          }
          if (state.space.type!.id != "M") {
            return ReservationReserveDialog(
              state: state,
              bloc: bloc,
            );
          } else {
            return ReservationMovesDialog(
              state: state,
              bloc: bloc,
            );
          }
        }
        return Container();
      },
    );
  }

  _buildLimitedDates({required ThemeData theme, String? keyMessage}) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_billet_alert.svg"),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              "${getString(context, "chat_error_title")}!",
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!
                  .copyWith(color: HexColor("#61000000")),
            ),
            Text(
              _getMessage(keyMessage),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!
                  .copyWith(color: HexColor("#61000000")),
            ),
            SizedBox(height: Dimens.spacingLarge),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
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
          ],
        ),
      ),
    );
  }

  Future<File> viewFile(String fileBese64, String fileName) async {
    Uint8List bytes = base64.decode(fileBese64);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + fileName);
    await file.writeAsBytes(bytes);
    return file;
  }

  Widget _buildFailureBilet(ThemeData theme) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_billet_alert.svg"),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              "${getString(context, "chat_error_title")}!",
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!
                  .copyWith(color: HexColor("#61000000")),
            ),
            Text(
              getString(context, "reserve_available_billet"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!
                  .copyWith(color: HexColor("#61000000")),
            ),
            SizedBox(height: Dimens.spacingLarge),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
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
          ],
        ),
      ),
    );
  }

  String _getMessage(String? keyMessage) {
    if (keyMessage == null) return getString(context, "reserve_limit_date");

    if (getString(context, keyMessage).isNotEmpty == true)
      return getString(context, keyMessage);

    if (keyMessage.isNotEmpty == true) return keyMessage;

    return getString(context, "reserve_limit_date");
  }
}
