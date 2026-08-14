import 'dart:io';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/payment_screens.dart';
import 'package:lello/feature/payment/presentation/register/bloc/payment_registration_event.dart';
import 'package:lello/feature/payment/presentation/register/controllers/payment_registration_controller.dart';
import 'package:lello/feature/payment/presentation/register/widget/empty_folder_widget.dart';
import 'package:lello/feature/payment/presentation/register/widget/payment_delete_file_dialog.dart';
import 'package:lello/feature/payment/presentation/widget/payment_exit_proccess_dialog.dart';

class PaymentReviewDocumentPage extends StatefulWidget {
  const PaymentReviewDocumentPage({super.key});

  @override
  State<PaymentReviewDocumentPage> createState() =>
      _PaymentReviewDocumentPageState();
}

class _PaymentReviewDocumentPageState extends State<PaymentReviewDocumentPage>
    with WidgetsBindingObserver {
  final controller =
      ApplicationContainer.instance().resolve<PaymentRegistrationController>();
  List<File> files = [];

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (ModalRoute.of(context)?.isCurrent == false) return;
    switch (state) {
      case AppLifecycleState.detached:
        controller.sendPaymentAnalyticsTimerStop();
        break;
      default:
        break;
    }
  }

  void _showFilePicker() {
    controller.pickFiles(context).then((filesList) async {
      if (filesList.isNotEmpty) {
        controller.bloc.add(PaymentSendDocumentLoadingEvent());
        List<File> newValidFiles = [];
        newValidFiles = await controller.validateFiles(context, filesList);
        if (newValidFiles.isEmpty) {
          controller.bloc.add(PaymentSendDocumentFailureEvent(
            error: KnownFailure('', 'Nenhum arquivo válido foi selecionado.'),
          ));
        } else {
          controller.files.addAll(newValidFiles);
          controller.bloc
              .add(PaymentSendDocumentSuccessEvent(files: newValidFiles));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    files = controller.files;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder(
        bloc: controller.bloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PrimaryAppBar(
              theme: theme,
              title: getString(context, "register_payment_title"),
              onBackArrowPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PaymentExitProccessDialog(
                        onConfirm: () {
                          controller.dispose();
                          controller.navigateToPaymentMainAndClearStack(context,
                              PaymentScreens.paymentReviewDocumentPage);
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      );
                    });
              },
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getString(context, "register_payment_send_document_title"),
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: Dimens.spacing,
                  ),
                  PrimaryButton(
                    onPressed: () {
                      controller.reviewDocumentsAddButtonAnalyticsLog();
                      _showFilePicker();
                    },
                    buttonColor: LelloTheme.palleteOf(theme).buttonSystem(),
                    text:
                        getString(context, "register_payment_add_new_document"),
                  ),
                  const SizedBox(height: 8),
                  Text(getString(context, "register_payment_formats"),
                      style: LelloTextStyles.caption(theme)!
                          .copyWith(color: LelloTheme.palleteOf(theme).grey())),
                  const SizedBox(height: 16),
                  files.isNotEmpty
                      ? Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                files.length > 1
                                    ? getStringWithParams(
                                        context,
                                        "register_payment_found_documents",
                                        [files.length.toString()])
                                    : getString(context,
                                        "register_payment_one_document_found"),
                                style: LelloTextStyles.subtitle(theme)!
                                    .copyWith(
                                        color:
                                            LelloTheme.palleteOf(theme).grey()),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: files.length,
                                  itemBuilder: (context, index) {
                                    final file = files[index];
                                    return Column(
                                      children: [
                                        _buildDocumentTile(
                                            context, file, index),
                                        file != files.last
                                            ? Divider(
                                                color:
                                                    LelloTheme.palleteOf(theme)
                                                        .separator(),
                                              )
                                            : Container(),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: EmptyFolderWidget(
                          height: height,
                          width: width,
                          theme: theme,
                        )),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InvertedPrimaryButton(
                        onPressed: () => _onBackButtonPressed(context),
                        text: getString(context, "back"),
                        buttonColor: Colors.black,
                        width: 110,
                      ),
                      PrimaryButton(
                        onPressed: () => _onAdvanceButtonPressed(),
                        text: getString(context, "next"),
                        buttonColor: theme.secondaryHeaderColor,
                        width: 110,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildDocumentTile(BuildContext context, File file, int index) {
    final theme = Theme.of(context);
    int fileSizeInBytes = file.lengthSync();
    String fileFormat = file.path.split('.').last;
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    return ListTile(
      leading: _buildFileIcon(file),
      title: Text(file.path.split('/').last),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${fileSizeInMB.toStringAsFixed(2)}MB",
            style: LelloTextStyles.caption(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).grey()),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PrimaryButton(
                  text: getString(context, "view"),
                  onPressed: fileFormat == "pdf"
                      ? () async => controller.renderPdf(context, file)
                      : () async => controller.renderImage(context, file),
                  height: 30,
                ),
              ),
              SizedBox(
                width: Dimens.spacingSmall,
              ),
              Expanded(
                child: InvertedPrimaryButton(
                  text: getString(context, "exclude"),
                  onPressed: () => _onDelete(index),
                  height: 30,
                ),
              ),
              SizedBox(
                height: Dimens.spacingSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileIcon(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    if (extension == "pdf") {
      return SvgPicture.asset("assets/ic_pdf_document.svg",
          width: 40, height: 40);
    } else {
      return SvgPicture.asset("assets/ic_img_document.svg",
          width: 40, height: 40);
    }
  }

  void _onDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PaymentDeleteFileDialog(
          onConfirm: () {
            controller.bloc.add(PaymentSendDocumentLoadingEvent());
            setState(() {
              controller.files.removeAt(index);
            });
            Navigator.pop(context);
            controller.bloc
                .add(PaymentSendDocumentSuccessEvent(files: controller.files));
          },
          onCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _onAdvanceButtonPressed() {
    // Navegar para a página PaymentProcessingFilesPage
    controller.reviewDocumentsContinueButtonAnalyticsLog();
    Navigator.of(context).pushNamed(ApplicationRoute.paymentProcessingFiles);
  }

  void _onBackButtonPressed(BuildContext context) {
    controller.dispose();
    controller.reviewDocumentsBackButtonAnalyticsLog();
    Navigator.of(context)
        .popUntil(ModalRoute.withName(ApplicationRoute.paymentSendDocuments));
  }
}
