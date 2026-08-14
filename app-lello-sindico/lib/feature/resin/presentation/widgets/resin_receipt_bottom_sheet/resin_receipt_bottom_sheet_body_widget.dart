import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_digital_document.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipt_bottom_sheet/resin_receipt_bottom_sheet_checkbox_widget.dart';
import 'package:path/path.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../../core/dependency/application_container.dart';

class ResinReceiptBottomSheetBodyWidget extends StatefulWidget {
  final ResinRefundReceipt? receipt;
  final int? maxFileSizePermitted;

  const ResinReceiptBottomSheetBodyWidget({
    super.key,
    this.receipt,
    this.maxFileSizePermitted,
  });

  @override
  State<ResinReceiptBottomSheetBodyWidget> createState() =>
      _ResinReceiptBottomSheetBodyWidgetState();
}

class _ResinReceiptBottomSheetBodyWidgetState
    extends State<ResinReceiptBottomSheetBodyWidget> {
  late ResinRefundReceipt newReceipt;
  @override
  void initState() {
    super.initState();
    newReceipt = widget.receipt ??
        ResinRefundReceipt(
          receiptValue: 0.0,
          sendDate: DateTime.now(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    NumberFormat formatCurrency = NumberFormat.currency(symbol: "R\$");
    TextEditingController valueController = TextEditingController(
        text: formatCurrency.format(newReceipt.receiptValue));

    return DismissKeyboard(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: 0.80 * MediaQuery.of(context).size.height),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Dimens.spacingMedium,
            0.0,
            Dimens.spacingMedium,
            MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  color: LelloTheme.palleteOf(theme).grey(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AttachFilesBottomSheet.show(
                            appContainer: ApplicationContainer.instance(),
                            context: context,
                            aspectRatioPresets: [
                              CropAspectRatioPreset.original,
                            ],
                            maxFileSizePermitted: widget.maxFileSizePermitted,
                          ).then((filesList) {
                            if (filesList.isNotEmpty) {
                              filesList.first.readAsBytes().then((bytes) {
                                setState(() {
                                  newReceipt.digitalDocument =
                                      ResinRefundDigitalDocument(
                                          bytes: base64Encode(bytes),
                                          name: basename(filesList.first.path),
                                          file: filesList.first);
                                });
                              });
                            }
                          });
                        },
                        child: Center(
                          child: newReceipt.digitalDocument?.file == null
                              ? SvgPicture.asset("assets/image_selector.svg",
                                  height: 240.0, width: 240.0)
                              : FileIcon(
                                  file: newReceipt.digitalDocument!.file!,
                                  deleteFile: () => setState(() {
                                    newReceipt.digitalDocument = null;
                                  }),
                                  imageIconSize: 240.0,
                                ),
                        ),
                      ),
                      SizedBox(height: Dimens.spacing),
                      Text(
                        getString(
                            context, "resin_receipts_insert_receipt_value"),
                        style: LelloTextStyles.subtitle(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).text()),
                      ),
                      SizedBox(height: Dimens.spacing),
                      PrimaryAmountFormField(
                        fontSize:
                            LelloTextStyles.title(theme)?.fontSize ?? 24.0,
                        textInputType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: (value) {
                          newReceipt.receiptValue =
                              formatCurrency.parse(value) as double;
                        },
                        controller: valueController,
                        action: TextInputAction.done,
                        formatter: currencyFormatter(),
                      ),
                      SizedBox(height: Dimens.spacing),
                      ResinReceiptBottomSheetCheckboxWidget(
                        receipt: newReceipt,
                      ),
                      SizedBox(height: Dimens.spacing),
                      _buildButtons(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingMedium),
      child: Column(
        children: [
          PrimaryButton(
            onPressed: () {
              if (_validateFields(context)) {
                Navigator.pop(context, newReceipt);
              }
            },
            text: getString(context, "resin_receipts_insert_add"),
          ),
          SizedBox(height: Dimens.spacingMedium),
          SecondaryButton(
            onPressed: () {
              Navigator.pop(context);
            },
            buttonBorderColor: Colors.white,
            child: Text(getString(context, "back")),
          ),
        ],
      ),
    );
  }

  bool _validateFields(BuildContext context) {
    String? invalidKey;
    if (newReceipt.receiptType == null) {
      invalidKey = "resin_receipts_insert_select_receipt_type";
    }
    if (newReceipt.receiptValue == 0.0) {
      invalidKey = "resin_receipts_insert_fill_receipt_value";
    }
    if (newReceipt.digitalDocument == null) {
      invalidKey = "resin_receipts_insert_insert_receipt_document";
    }
    if (invalidKey == null) {
      return true;
    }
    _showSnackBar(context, getString(context, invalidKey));
    return false;
  }

  void _showSnackBar(BuildContext context, String? message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 4),
    ).show(context);
  }
}
