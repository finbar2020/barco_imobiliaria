import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/bloc/cnd_state.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/controller/cnd_controller.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/widget/cnd_error_dialog.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/widget/cnd_form.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class CertificateNoOutstandingDebtPage extends StatefulWidget {
  const CertificateNoOutstandingDebtPage({super.key});

  @override
  State<CertificateNoOutstandingDebtPage> createState() =>
      _CertificateNoOutstandingDebtPageState();
}

class _CertificateNoOutstandingDebtPageState
    extends State<CertificateNoOutstandingDebtPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = ApplicationContainer.instance()
      .resolve<CertificateNoOutstandingDebtController>();

  @override
  void initState() {
    controller.getEasyFixUnit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final env = ApplicationContainer.instance().resolve<Environment>();
    final validator = ApplicationContainer.instance().resolve<Validator>();
    validator.context = context;
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "cnd_title",
        ),
        body: BlocConsumer(
          bloc: controller.bloc,
          listener: (context, state) async {
            if (state is CertificateNoOutstandingDebtSucessState) {
              if (state.pdf.isNotEmpty) {
                await viewFile(fileBase64: state.pdf).then(
                  (value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFScreen(
                          pdfFile: value,
                          title: 'Certidão Negativa de Débito',
                          canDownload: true),
                    ),
                  ),
                );
                Navigator.of(context).pop();
              }
            }
            if (state is HasOutstandingDebtState) {
              await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => CndErrorDialog());
            }
          },
          builder: (context, state) {
            if (state is UnitProfileFailureState) {
              return Padding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: UnexpectedErrorWidget(),
              );
            }

            if (state is CertificateNoOutstandingDebtFailureState) {
              if (controller.email.isNotEmpty &&
                  controller.mobilePhone.isNotEmpty &&
                  controller.phone.isNotEmpty)
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: UnexpectedErrorWidget(),
                );
            }

            if (state is UnitProfileLoadingState ||
                state is CertificateNoOutstandingDebtLoadingState) {
              return Center(child: LoadingWidget());
            }
            if (state is UnitProfileLoadedState) {
              return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: Dimens.spacing),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        color: LelloTheme.palleteOf(theme).backgroundDark(),
                        width: double.infinity,
                        height: Dimens.spacingLarge,
                        child: Center(
                          child: Text(
                            '${controller.sessionBloc.state.session?.condominium?.name ?? ''} - ${controller.sessionBloc.state.session?.unity?.title ?? ''}',
                            overflow: TextOverflow.ellipsis,
                            style: LelloTextStyles.body(theme),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimens.spacingLarge),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimens.spacingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getString(context, "cnd_update_data_message"),
                              style: LelloTextStyles.titleSmallBold(theme),
                            ),
                            SizedBox(height: Dimens.spacing),
                            Text(
                              getString(context, "cnd_update_data_continue"),
                              style: LelloTextStyles.subtitle(theme),
                              textAlign: TextAlign.justify,
                              textWidthBasis: TextWidthBasis.longestLine,
                            ),
                            SizedBox(height: Dimens.spacingLarge),
                            CertificateNoOutstandingDebtForm(
                              unit: state.unit,
                              formKey: _formKey,
                            ),
                            SizedBox(height: Dimens.spacingXLarge),
                            PrimaryButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  controller.generateCertificateNoOutstandingDebt(
                                      unitProfile: controller
                                          .requestCertificateNoOutstandingDebt);
                                }
                              },
                              text: getString(context, "cnd_generate"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ));
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<File> viewFile({required String fileBase64}) async {
    Uint8List bytes = base64.decode(fileBase64);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    String fileName = "cnd_$formattedDate.pdf";

    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + fileName);
    await file.writeAsBytes(bytes);

    return file;
  }
}
