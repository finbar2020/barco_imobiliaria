import 'dart:developer';
import 'dart:io';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payment/domain/entity/payment_screens.dart';
import 'package:lello/feature/payment/presentation/register/bloc/payment_registration_event.dart';
import 'package:lello/feature/payment/presentation/register/bloc/payment_registration_state.dart';
import 'package:lello/feature/payment/presentation/register/page/payment_review_document_page.dart';
import 'package:lello/feature/payment/presentation/register/widget/empty_folder_widget.dart';
import 'package:lello/feature/payment/presentation/register/widget/payment_add_document_icon.dart';
import 'package:lello/feature/payment/presentation/register/widget/payment_delete_file_dialog.dart';
import 'package:lello/feature/payment/presentation/register/widget/payment_registration_loading.dart';
import 'package:lello/feature/payment/presentation/register/widget/payment_registration_news_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import '../controllers/payment_registration_controller.dart';

class PaymentSendDocumentPage extends StatefulWidget {
  const PaymentSendDocumentPage({super.key});

  @override
  _PaymentSendDocumentPageState createState() =>
      _PaymentSendDocumentPageState();
}

class _PaymentSendDocumentPageState extends State<PaymentSendDocumentPage>
    with WidgetsBindingObserver {
  final controller =
      ApplicationContainer.instance().resolve<PaymentRegistrationController>();
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  String? svgString;
  int _current = 0;
  bool isFirstFileAddition = true;

  @override
  void initState() {
    super.initState();
    controller.sendPaymentAnalyticsTimerStart();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNewsDialog();
    });
    _loadSvg();
  }

  Future<void> _loadSvg() async {
    String svg = await rootBundle.loadString('assets/ic_document_add.svg');
    svg = controller.getSvgStringWithPrimaryColor(context, svg);
    setState(() {
      svgString = svg;
    });
  }

  @override
  void dispose() {
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

  void _showNewsDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PaymentRegistrationNewsDialog(
              onContinuePressedEvent:
                  controller.newsDialogContinueButtonAnalyticsLog,
              onBackPressedEvent:
                  controller.newsDialogCancelButtonAnalyticsLog);
        });
  }

  void onModalDismissed() {
    controller.files.clear();
    isFirstFileAddition = true;
  }

  void _showFilePicker(bool clearFiles) {
    if (clearFiles) {
      controller.files.clear();
    }
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
          _current = controller.files.length - 1;
          controller.bloc
              .add(PaymentSendDocumentSuccessEvent(files: newValidFiles));
        }
        if (isFirstFileAddition) {
          isFirstFileAddition = false;
          _showAddedFilesModal();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            buttonCarouselController.jumpToPage(_current);
          });
        }
      }
    });
  }

  //TODO: Refactor this method to apply SOC pattern
  void _showAddedFilesModal() async {
    final theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return BlocBuilder(
            bloc: controller.bloc,
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                height: height * 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          controller.files.isEmpty
                              ? EmptyFolderWidget(
                                  height: height,
                                  width: width,
                                  theme: theme,
                                )
                              : CarouselSlider.builder(
                                  itemCount: controller.files.length,
                                  carouselController: buttonCarouselController,
                                  options: CarouselOptions(
                                    height: 400,
                                    enlargeCenterPage: false,
                                    viewportFraction: 1.0,
                                    enableInfiniteScroll: false,
                                    initialPage: _current,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                        log(_current.toString());
                                      });
                                    },
                                  ),
                                  itemBuilder: (context, index, realIndex) {
                                    if (controller.bloc.state
                                        is PaymentSendDocumentLoadingState) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    return SizedBox(
                                      width: 250,
                                      height: 400,
                                      child: Stack(
                                        children: [
                                          controller.files[index].path
                                                  .endsWith('.pdf')
                                              ? PdfViewer.file(
                                                 controller
                                                      .files[index].path,
                                                )
                                              : img.Image.file(
                                                  controller.files[index],
                                                  fit: BoxFit.contain,
                                                ),
                                          controller.files[index].path
                                                  .endsWith('.pdf')
                                              ? Positioned.fill(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () async =>
                                                          controller.renderPdf(
                                                              context,
                                                              controller.files[
                                                                  index]),
                                                    ),
                                                  ),
                                                )
                                              : Positioned.fill(
                                                  child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () async =>
                                                        controller.renderImage(
                                                            context,
                                                            controller
                                                                .files[index]),
                                                  ),
                                                ))
                                        ],
                                      ),
                                    );
                                  },
                                ),
                          if (controller.files.isNotEmpty)
                            Positioned(
                              top: 4,
                              right: 32,
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  'assets/ic_close_red.svg',
                                  width: 40,
                                  height: 40,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PaymentDeleteFileDialog(
                                        onConfirm: () {
                                          controller.bloc.add(
                                              PaymentSendDocumentLoadingEvent());
                                          setState(() {
                                            controller.files.removeAt(_current);
                                            if (controller.files.isNotEmpty) {
                                              _current = _current >=
                                                      controller.files.length
                                                  ? controller.files.length - 1
                                                  : _current;
                                            } else {
                                              _current = 0;
                                            }

                                            buttonCarouselController
                                                .jumpToPage(_current);
                                          });
                                          Navigator.pop(context);
                                          controller.bloc.add(
                                              PaymentSendDocumentSuccessEvent(
                                                  files: controller.files));
                                        },
                                        onCancel: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          else
                            Container(),
                          Positioned(
                            left: 8,
                            top: height * 0.2,
                            child: Transform.translate(
                              offset: const Offset(0, -12),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  'assets/ic_arrow_left.svg',
                                  width: 24,
                                  height: 24,
                                  color: controller.files.isEmpty
                                      ? theme.disabledColor
                                      : Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_current > 0) {
                                      _current = _current - 1;
                                    }
                                  });
                                  buttonCarouselController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.linear,
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: height * 0.2,
                            child: Transform.translate(
                              offset: const Offset(0, -12),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  'assets/ic_arrow_right.svg',
                                  width: 24,
                                  height: 24,
                                  color: controller.files.isEmpty
                                      ? theme.disabledColor
                                      : Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_current <
                                        controller.files.length - 1) {
                                      _current = _current + 1;
                                    }
                                  });
                                  buttonCarouselController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.linear,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    PrimaryButton(
                      text: getString(
                          context, "register_payment_add_new_document"),
                      onPressed: () {
                        controller.addDocumentsButtonAnalyticsLog();
                        _showFilePicker(false);
                        log(controller.files.toString());
                      },
                      buttonColor: LelloTheme.palleteOf(theme).buttonSystem(),
                    ),
                    SizedBox(
                      height: Dimens.spacingSmall,
                    ),
                    PrimaryButton(
                      text: getString(context, "next"),
                      onPressed: controller.files.isEmpty
                          ? null
                          : () {
                              controller.bloc
                                  .add(PaymentSendDocumentLoadingEvent());
                              controller.bloc.add(
                                  PaymentSendDocumentSuccessEvent(
                                      files: controller.files));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PaymentReviewDocumentPage(),
                                ),
                              );
                            },
                      buttonColor: controller.files.isEmpty
                          ? theme.disabledColor
                          : theme.primaryColor,
                    ),
                    SizedBox(
                      height: Dimens.spacingSmall,
                    ),
                  ],
                ),
              );
            });
      },
    ).then((value) {
      onModalDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder(
        bloc: controller.bloc,
        builder: (context, state) {
          if (state is PaymentSendDocumentLoadingState) {
            return const PaymentRegistrationLoading();
          } else {
            return Theme(
                data: theme,
                child: PopScope(
                  canPop: true,
                  onPopInvokedWithResult: (didPop, result) {
                    if (didPop) {
                      controller.sendPaymentAnalyticsTimerStop();
                      controller.backArrowAnalyticsLog(
                          PaymentScreens.paymentSendDocumentPage);
                    }
                  },
                  child: Scaffold(
                    appBar: PrimaryAppBar(
                      iconColor: theme.primaryColor,
                      theme: theme,
                      title: getString(context, "register_payment_title"),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (svgString != null)
                            PaymentAddDocumentIcon(
                              svgString: svgString!,
                              width: 250,
                              height: 250,
                            )
                          else
                            SvgPicture.asset(
                              'assets/ic_empty_folder.svg',
                              width: 250,
                              height: 250,
                            ),
                          Text(
                            getString(context,
                                "register_payment_send_document_title"),
                            style: theme.textTheme.headlineSmall!.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: Dimens.spacingSmall,
                          ),
                          Flexible(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: getString(context,
                                          "register_payment_send_document_text"),
                                      style: LelloTextStyles.bodyBold(theme)),
                                  const WidgetSpan(
                                    child: SizedBox(width: 4.0),
                                  ),
                                  TextSpan(
                                    text: getString(context,
                                        "register_payment_send_document_text2"),
                                    style: LelloTextStyles.body(theme),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Dimens.spacingSmall,
                          ),
                          PrimaryButton(
                            onPressed: () {
                              controller.addDocumentsButtonAnalyticsLog();
                              _showFilePicker(true);
                            },
                            buttonColor:
                                LelloTheme.palleteOf(theme).buttonSystem(),
                            text: getString(
                                context, "register_payment_add_new_document"),
                          ),
                          SizedBox(
                            height: Dimens.spacingSmall,
                          ),
                          Text(getString(context, "register_payment_formats"),
                              style: LelloTextStyles.caption(theme)!.copyWith(
                                  color: LelloTheme.palleteOf(theme).grey())),
                        ],
                      ),
                    ),
                  ),
                ));
          }
        });
  }
}

extension ColorToHex on Color {
  String toHex() => '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
}
