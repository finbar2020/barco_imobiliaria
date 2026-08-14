import 'dart:convert';
import 'dart:io';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';

import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:colaborador/feature/proof/presentation/bloc/proof_bloc.dart';
import 'package:colaborador/feature/proof/presentation/bloc/proof_state.dart';
import 'package:colaborador/feature/proof/presentation/widgets/proof_card_widget.dart';
import 'package:colaborador/feature/proof/presentation/widgets/proof_select_date_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';

class ProofPage extends StatefulWidget {
  const ProofPage({Key? key}) : super(key: key);

  @override
  State<ProofPage> createState() => _ProofPageState();
}

class _ProofPageState extends State<ProofPage> {
  TextEditingController datePickerController = TextEditingController(
      text: DateFormat("dd/MM/yyyy").format(DateTime.now()));
  ProofBloc proofBloc = ApplicationContainer.instance().resolve();
  ValueNotifier<DateTime> dateNotifier = ValueNotifier(DateTime.now());
  String? dateTimeClockIn;
  String? date;
  @override
  void initState() {
    super.initState();

    //proofBloc.showMyProofs(date: dateNotifier.value);
    dateNotifier.addListener(() {
      datePickerController.text =
          DateFormat("dd/MM/yyyy").format(dateNotifier.value);
    });
  }

  @override
  void dispose() {
    dateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Environment env = ApplicationContainer.instance().resolve<Environment>();
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: const CustomAppBar(title: "proof_page_title"),
          body: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: BlocProvider.value(
              value: proofBloc,
              child: BlocConsumer<ProofBloc, ProofState>(
                  listener: (context, state) {
                if (state is ProofLoadedState) {
                  if (state.base64 != null) {
                    viewFile(fileBase64: state.base64!, fileTime: "", date: "")
                        .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFScreen(
                                    pdfFile: value,
                                    title: 'Comprovante Registro de Ponto',
                                    canDownload: true),
                              ),
                            ));
                  }
                }
              }, builder: (context, state) {
                if (state is ProofLoadingState) {
                  return Column(
                    children: [
                      Expanded(
                        child: LoadingWidget(
                          message:
                              getString(context, "proof_page_loading_message"),
                        ),
                      ),
                    ],
                  );
                }

                if (state is ProofFailedState) {
                  return ErrorHandlingWidget(
                    errorCode: state.errorCode,
                    error: state.errorDescription,
                    reTryFunction: () => proofBloc.showMyProofs(
                      date: dateNotifier.value,
                    ),
                    backFunction: () => Navigator.pop(context, true),
                    isProduction: env.isProduction,
                  );
                }

                if (state is ProofLoadedState) {
                  return _proofPageBody(
                      context: context,
                      theme: theme,
                      state: state,
                      proofs: state.proofs);
                }

                return Container();
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _proofPageBody(
      {required BuildContext context,
      required ThemeData theme,
      required ProofState state,
      required List<ProofEntity> proofs}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              ProofSelectDateWidget(
                controller: datePickerController,
                onTap: (DateTime date) {
                  dateNotifier.value = date;
                  proofBloc.showMyProofs(date: date);
                },
              ),
              SizedBox(height: Dimens.spacing),
              if (proofs.isEmpty)
                Text(
                  getString(context, 'proof_clock_in_empty'),
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
              if (proofs.isNotEmpty)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(context, 'proof_clock_in'),
                          style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).text(),
                          )),
                      SizedBox(height: Dimens.spacingSmall),
                      Expanded(
                        child: ListView.separated(
                            itemCount: proofs.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                                      color: LelloTheme.palleteOf(theme)
                                          .separator(),
                                    ),
                            itemBuilder: (BuildContext context, int index) {
                              return ProofCardWidget(
                                dateTimeClockIn: proofs[index].dateTimeClockIn,
                                onTap: () async {
                                  var proofFileName = proofs[index].proofName;

                                  if (proofFileName == null) {
                                    Flushbar(
                                      message: getString(
                                          context, "proof_file_not_fount"),
                                      duration: const Duration(seconds: 5),
                                    ).show(context);
                                  } else {
                                    proofBloc.showMyProofFile(
                                        fileName: proofFileName);
                                    dateTimeClockIn =
                                        proofs[index].dateTimeClockIn;
                                    date = DateFormat("dd/MM/yyyy")
                                        .format(dateNotifier.value)
                                        .toString();
                                  }
                                },
                              );
                            }),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: Dimens.spacing),
        _buildButtons(context),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingXSmall),
      child: Column(
        children: [
          PrimaryButton(
              text: getString(context, "back"),
              onPressed: (() => Navigator.pop(context))),
        ],
      ),
    );
  }

  Future<File> viewFile(
      {required String fileBase64, String? fileTime, String? date}) async {
    String? dateFormatted;
    date != ""
        ? dateFormatted = date?.replaceAll("/", "_")
        : dateFormatted = "";
    fileTime ?? "";

    Uint8List bytes = base64.decode(fileBase64);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/comprovante_de_ponto-$dateFormatted-$fileTime.pdf");
    await file.writeAsBytes(bytes);
    return file;
  }
}
