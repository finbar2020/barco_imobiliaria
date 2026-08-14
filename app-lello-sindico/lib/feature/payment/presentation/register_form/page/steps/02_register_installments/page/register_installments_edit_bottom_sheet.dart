import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payment/domain/entity/installment.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_form.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/domain/entity/supplier_payment_type.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/controllers/register_installments_page_controller.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';

class RegisterInstallmentsEditBottomSheet extends StatefulWidget {
  final RegisterInstallmentsController controller;
  final PaymentDataEntity paymentData;
  final SupplierDataEntity? supplier;
  final List<InstallmentEntity> installments;
  final int index;
  const RegisterInstallmentsEditBottomSheet({
    super.key,
    required this.controller,
    required this.paymentData,
    required this.supplier,
    required this.installments,
    required this.index,
  });

  @override
  State<RegisterInstallmentsEditBottomSheet> createState() =>
      _RegisterInstallmentsEditBottomSheetState();
}

class _RegisterInstallmentsEditBottomSheetState
    extends State<RegisterInstallmentsEditBottomSheet> {
  final dateFormat = DateFormat("dd/MM/yyyy");
  final currencyFormat = NumberFormat.currency(symbol: "R\$");
  String realCurrency = CommonCurrencies().brl.isoCode;
  final Validator _validator = ApplicationContainer.instance().resolve();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController agencyController = TextEditingController();
  final TextEditingController digitController = TextEditingController();

  late InstallmentEntity data;
  late DateTime dueDate;
  late double value;
  late DateTime _firstDate;
  late DateTime _lastDate;
  late List<SupplierPaymentTypeEntity> paymentTypes;
  late SupplierPaymentTypeEntity? paymentType;
  late PaymentFormEntity? paymentForm;
  late ResinBank? selectedBank;
  late String? selectedBankAccountType;

  bool get _hasError {
    if (value <= 0) return true;
    if (paymentType != null && paymentForm == null) return true;
    if (paymentForm?.id == 1004) {
      if (accountController.text.isEmpty) return true;
      if (agencyController.text.isEmpty) return true;
      if (digitController.text.isEmpty) return true;
      if (selectedBankAccountType == null) return true;
      if (selectedBank == null) return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _validator.context = context;
    data = widget.installments[widget.index];
    value = data.value;
    selectedBank = widget.controller.banksList
        .firstWhereOrNull((element) => element.id == data.bankId.toString());
    selectedBankAccountType = data.accountType;
    valueController.text = currencyFormat.format(data.value);
    accountController.text = data.accountNumber ?? "";
    agencyController.text = data.agency ?? "";
    digitController.text = data.accountDigit ?? "";
    dueDate = data.dueDate;
    dateController.text = dateFormat.format(dueDate);
    paymentTypes = widget.supplier?.supplierPaymentTypes
            .where((e) => e != null)
            .map((e) => e!.copyWith(
                  paymentForms: e.paymentForms
                      .where((e) => e != null)
                      .map((e) => e!.copyWith())
                      .toList(),
                ))
            .toList() ??
        [];
    if (data.paymentTypeId != null) {
      paymentType = paymentTypes
          .firstWhereOrNull((element) => element.id == data.paymentTypeId);
    } else {
      paymentType = paymentTypes.first;
    }
    paymentForm = paymentType?.paymentForms.first;

    if (paymentForm?.id == 1004 && selectedBank == null) {
      //setar bank, agency, account, digit
      selectedBank = widget.controller.banksList.firstWhereOrNull((element) =>
          element.id == paymentForm?.bankData?.bank?.code.toString());
      selectedBankAccountType = paymentForm?.bankData?.type;
      accountController.text = paymentForm?.bankData?.account ?? "";
      agencyController.text = paymentForm?.bankData?.agency ?? "";
      digitController.text = paymentForm?.bankData?.digit ?? "";
    }

    if (widget.index == 0) {
      _firstDate = DateTime.now();
    } else {
      _firstDate = widget.installments[widget.index - 1].dueDate
          .add(const Duration(days: 1));
    }
    if (widget.index == widget.installments.length - 1) {
      _lastDate = DateTime.now().add(const Duration(days: 365));
    } else {
      _lastDate = widget.installments[widget.index + 1].dueDate
          .subtract(const Duration(days: 1));
    }
  }

  @override
  void dispose() {
    valueController.dispose();
    accountController.dispose();
    agencyController.dispose();
    digitController.dispose();
    super.dispose();
  }

  void saveForm() {}

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimens.spacing, vertical: Dimens.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Parcela ${widget.index + 1}/${widget.installments.length}",
                style: LelloTextStyles.titleSmall(theme)),
            const SizedBox(height: 16.0),
            Row(
              children: [
                labelValue(
                    "Valor da parcela",
                    TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [currencyFormatter()],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: LelloTheme.palleteOf(theme).grey(),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          this.value = currencyFormat.parse(value) as double;
                        });
                      },
                      controller: valueController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return getString(context, "validation_required");
                        }
                        return null;
                      },
                    ),
                    theme),
                const SizedBox(width: 16.0),
                labelValue(
                    "Data de vencimento",
                    TextField(
                      readOnly: true,
                      controller: dateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        final date = await datePicker(
                          context,
                          firstDate: _firstDate,
                          lastDate: _lastDate,
                          selectedDate: dueDate,
                        );
                        setState(() {
                          dueDate = date;
                          dateController.text = dateFormat.format(dueDate);
                        });
                      },
                    ),
                    theme),
              ],
            ),
            _buildErrorAlert(),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  getString(context, "payments_payment_type_label"),
                  style: LelloTextStyles.bodyBold(theme)?.copyWith(
                    color: pallete.grey(),
                    fontSize: Dimens.spacing,
                  ),
                ),
                SizedBox(height: Dimens.spacingSmall),
                DropdownButtonFormField<SupplierPaymentTypeEntity?>(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                  isExpanded: true,
                  value: paymentType,
                  items: paymentTypes
                      .map((type) => DropdownMenuItem(
                          value: type, child: Text(type.name ?? "")))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      paymentType = value!;
                      paymentForm = paymentType?.paymentForms.first;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  getString(context, "payments_payment_method_label"),
                  style: LelloTextStyles.bodyBold(theme)?.copyWith(
                    color: pallete.grey(),
                    fontSize: Dimens.spacing,
                  ),
                ),
                SizedBox(height: Dimens.spacingSmall),
                DropdownButtonFormField<PaymentFormEntity?>(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                  isExpanded: true,
                  value: paymentType?.paymentForms.first,
                  items: paymentType?.paymentForms
                      .map((type) => DropdownMenuItem(
                          value: type, child: Text(type?.name ?? "")))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      paymentForm = value!;
                    });
                  },
                ),
              ],
            ),
            if (paymentForm?.id == 1004)
              Column(
                children: [
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        getString(context, "payments_bank_label"),
                        style: LelloTextStyles.bodyBold(theme)?.copyWith(
                          color: pallete.grey(),
                          fontSize: Dimens.spacing,
                        ),
                      ),
                      DropdownSearch<ResinBank>(
                        popupProps: const PopupProps.menu(showSearchBox: true),
                        suffixProps: const DropdownSuffixProps(
                          clearButtonProps: ClearButtonProps(isVisible: true),
                        ),
                        items: (filter, loadProps) =>
                            widget.controller.banksList,
                        compareFn: (i, s) => i.id == s.id,
                        itemAsString: (item) =>
                            "${item.bankCode} - ${item.bankName}",
                        onSelected: (item) =>
                            setState(() => selectedBank = item),
                        selectedItem: selectedBank,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        getString(context, "payments_agency_label"),
                        style: LelloTextStyles.bodyBold(theme)?.copyWith(
                          color: pallete.grey(),
                          fontSize: Dimens.spacing,
                        ),
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                      TextField(
                        controller: agencyController,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          counterText: "",
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      labelValue(
                          getString(context, "resin_new_account_account"),
                          TextField(
                            maxLength: 11,
                            controller: accountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: "",
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          theme),
                      const SizedBox(width: 16.0),
                      labelValue(
                          getString(context, "resin_new_account_digit"),
                          TextField(
                            maxLength: 1,
                            controller: digitController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: "",
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          theme),
                      const SizedBox(width: 16.0),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        getString(context, "payments_account_type_label"),
                        style: LelloTextStyles.bodyBold(theme)?.copyWith(
                          color: pallete.grey(),
                          fontSize: Dimens.spacing,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                        ),
                        value: selectedBankAccountType,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                              value: "C",
                              child: Text(getString(
                                  context, "payments_current_account_label"))),
                          DropdownMenuItem(
                              value: "P",
                              child: Text(getString(
                                  context, "payments_savings_account_label"))),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedBankAccountType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 24.0),
            PrimaryButton(
              onPressed: _hasError
                  ? null
                  : () {
                      var result = data.copyWith(
                        dueDate: dueDate,
                        value: currencyFormat
                            .parse(valueController.text)
                            .toDouble(),
                        bankId: selectedBank == null
                            ? null
                            : int.parse(selectedBank!.bankCode),
                        accountNumber: accountController.text,
                        agency: agencyController.text,
                        accountDigit: digitController.text,
                        paymentTypeId: paymentType?.id,
                        paymentFormId: paymentForm?.id,
                        accountType: selectedBankAccountType,
                      );
                      Navigator.of(context).pop(result);
                    },
              text: getString(context, "save"),
            ),
            const SizedBox(height: 24.0),
            SecondaryButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: getString(context, "cancel"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorAlert() {
    if (value > 0) {
      return const SizedBox.shrink();
    } else {
      return Row(
        children: [
          const Icon(
            Icons.error,
            color: Colors.orange,
          ),
          const SizedBox(height: 8.0),
          Text(
            getString(context, "payments_installment_value_error"),
            style: const TextStyle(color: Colors.orange),
          ),
        ],
      );
    }
  }

  Widget labelValue(String label, Widget field, ThemeData theme) {
    final pallete = LelloTheme.palleteOf(theme);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: LelloTextStyles.bodyBold(theme)?.copyWith(
              color: pallete.grey(),
              fontSize: Dimens.spacing,
            ),
          ),
          SizedBox(height: Dimens.spacingSmall),
          field,
        ],
      ),
    );
  }
}
