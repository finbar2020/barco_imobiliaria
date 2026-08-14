// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_certificate/timesheet_certificate_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_certificate_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet_certificates/certificate_card.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class CertificateWidget extends StatefulWidget {
  final TimesheetCertificateController controller;
  final DateTime date;
  const CertificateWidget({
    super.key,
    required this.date,
    required this.controller,
  });

  @override
  State<CertificateWidget> createState() => _CertificateWidgetState();
}

class _CertificateWidgetState extends State<CertificateWidget> {
  bool selectAll = false;

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocConsumer(
      bloc: widget.controller.bloc,
      listener: (context, state) {
        if (state is TimesheetCertificateLoadedState && state.file != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text(
                    "${getString(context, "gdp_timesheet_certificate_title")}s",
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () async {
                        File file = File(state.file!.path);
                        if (await Permission.mediaLibrary.request().isGranted) {
                          _saveFile(file, context, state.filename!);
                        }
                      },
                    ),
                    Builder(
                      builder: (shareContext) => IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () async {
                          File? customFile;
                          if (state.filename != null) {
                            var newDirectory =
                                "${(await getApplicationDocumentsDirectory()).path}/${state.filename}";
                            customFile = state.file?.copySync(newDirectory);
                          }
                          final box =
                              shareContext.findRenderObject() as RenderBox;
                          final rect =
                              box.localToGlobal(Offset.zero) & box.size;
                          Share.shareXFiles(
                              [XFile('${customFile?.path ?? state.file?.path}')],
                              sharePositionOrigin: rect);
                        },
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: img.Image.file(
                        state.file!,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is TimesheetCertificateLoadedState &&
            state.getArchiveFailed) {
          Flushbar(
            message: getString(context, "gdp_timesheet_certificate_error"),
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      },
      builder: (context, state) {
        if (state is TimesheetCertificateLoadingState) {
          return const Expanded(child: Center(child: LoadingWidget()));
        } else if (state is TimesheetCertificateLoadedState &&
            state.list.isEmpty) {
          return Expanded(
            child: DismissKeyboard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                          getString(
                              context, "gdp_timesheet_mark_day_dont_find"),
                          style: LelloTextStyles.subBody(theme)))
                ],
              ),
            ),
          );
        } else if (state is TimesheetCertificateLoadedState &&
            state.list.isNotEmpty) {
          return Expanded(
            child: DismissKeyboard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...List.generate(
                              state.list.length,
                              (index) {
                                var item = state.list[index];
                                return CertificateCard(
                                  entity: item,
                                  onTap: () {
                                    widget.controller.getCertificateArchive(
                                        item.archiveHash);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimens.spacingSmall),
                      PrimaryButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: getString(context, "back")),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is TimesheetCertificateFailedState) {
          return Expanded(
            child: Center(
              child: ErrorMessageWidget(
                  message: getString(context, "request_fine_error_message")),
            ),
          );
        }
        return Container();
      },
    );
  }

  Future _saveFile(File file, BuildContext context, String fileName) async {
    try {
      Directory? appDocDir = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getExternalStorageDirectory();
      if (appDocDir == null) {
        throw Exception("canot_download_file");
      }
      String appDocPath = appDocDir.path;
      try {
        var path = '$appDocPath/$fileName';
        await file.copy(path);
        OpenFile.open(path);
      } catch (e) {
        print(e);
      }
    } catch (e) {
      Flushbar(
        duration: const Duration(seconds: 5),
        message: getString(context, "canot_download_file"),
      ).show(context);
    }
  }
}
