import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payment/domain/entity/accounting_account_type.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/presentation/register_form/controllers/register_form_page_controller.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/03_register_ledger_account/controllers/register_ledger_account_controller.dart';

class RegisterLedgerAccount extends StatefulWidget {
  final int step;
  final RegisterFormPageController controller;
  final Function(PaymentDataEntity paymentdata) onChange;
  const RegisterLedgerAccount(
      {super.key,
      required this.step,
      required this.controller,
      required this.onChange});

  @override
  State<RegisterLedgerAccount> createState() => _RegisterLedgerAccountState();
}

class _RegisterLedgerAccountState extends State<RegisterLedgerAccount> {
  final Validator _validator = ApplicationContainer.instance().resolve();
  final RegisterLedgerAccountController controller =
      ApplicationContainer.instance().resolve();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController balanceController = TextEditingController();
  final currencyFormat = NumberFormat.currency(symbol: "R\$");
  String realCurrency = CommonCurrencies().brl.isoCode;
  late Money balanceValue;

  late PaymentDataEntity paymentData;
  SupplierDataEntity? supplier;
  List<LedgerAccountEntity?> ledgerAccountDropdownItems = [];
  List<LedgerAccountEntity?> allLedgerAccounts = [];
  List<LedgerAccountEntity?> extraordinaryLedgerAccounts = [];
  List<LedgerAccountType> accountingLedgerTypes = getLedgerAccountTypes();
  LedgerAccountType? selectedLedgerAccountType;
  LedgerAccountEntity? selectedLedgerAccount;

  @override
  void initState() {
    super.initState();
    _validator.context = (context);
    paymentData = widget.controller.paymentData;

    if (widget.controller.supplier == null) {
      return;
    }

    supplier = widget.controller.supplier;

    if (paymentData.ledgerAccount != null) {
      var isOrdinary = supplier?.supplierLedgerAccounts?.ordinary
          .firstWhereOrNull(
              (element) => element!.id == paymentData.ledgerAccount);
      var isExtra = supplier?.supplierLedgerAccounts?.extraordinary
          .firstWhereOrNull(
              (element) => element!.id == paymentData.ledgerAccount);
      var isAll = supplier?.supplierLedgerAccounts?.extraordinary
          .firstWhereOrNull(
              (element) => element!.id == paymentData.ledgerAccount);

      if (isOrdinary != null) {
        selectedLedgerAccountType = LedgerAccountType.ordinary;
        selectedLedgerAccount = isOrdinary;
      } else if (isExtra != null) {
        selectedLedgerAccountType = LedgerAccountType.extraordinary;
        selectedLedgerAccount = isExtra;
      } else if (isAll != null) {
        selectedLedgerAccountType = LedgerAccountType.all;
        selectedLedgerAccount = isAll;
      }
    }
  }

  Money moneyParse(double value) {
    return Money.fromInt(int.parse((value * 100).toStringAsFixed(0)),
        isoCode: realCurrency);
  }

  Future<double?> getBalanceValue() async {
    final result = await controller.getLedgerAccountBalance(
        widget.controller.condoId, selectedLedgerAccount!.id!.toString());
    return result;
  }

  void setBalanceValue(double value) {
    balanceValue = moneyParse(value);
    balanceController.text = balanceValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.supplier == null) {
      return Container();
    }
    ThemeData theme = Theme.of(context);
    var labelStyle = LelloTextStyles.subtitleBold(theme)!.copyWith(
      color: LelloTheme.palleteOf(theme).text(),
    );
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getString(context, "payments_ledger_account_title"),
                    style: LelloTextStyles.titleSmall(theme)),
                SizedBox(
                  height: Dimens.spacingSmall,
                ),
                Text(
                  getString(context, "payments_ledger_account_subtitle"),
                  style: LelloTextStyles.subtitleBold(theme),
                ),
                SizedBox(
                  height: Dimens.spacingMedium,
                ),
                Text(getString(context, "payments_ledger_account_choose_type"),
                    style: LelloTextStyles.subtitleBold(theme)),
              ],
            ),
            SizedBox(
              height: Dimens.spacing,
            ),
            Text(getString(context, "payments_ledger_account_type_label"),
                style: labelStyle),
            SizedBox(
              height: Dimens.spacing,
            ),
            _buildLedgerAccountTypeDropdown(theme),
            SizedBox(
              height: Dimens.spacing,
            ),
            if (selectedLedgerAccountType != null)
              _buildLedgerAccountDropdownFromSelectedType(
                  theme, selectedLedgerAccountType!),
            SizedBox(
              height: Dimens.spacingMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLedgerAccountTypeDropdown(ThemeData theme) {
    var curent = selectedLedgerAccountType == LedgerAccountType.all
        ? LedgerAccountType.ordinary
        : selectedLedgerAccountType;
    return DropdownButtonFormField<LedgerAccountType>(
      value: curent,
      items: accountingLedgerTypes.map((type) {
        return DropdownMenuItem<LedgerAccountType>(
          value: type,
          child: Text(ledgerAccountTypeToString(type)),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.spacingSmall),
        ),
      ),
      onChanged: (value) {
        setState(() {
          selectedLedgerAccountType = value;
          selectedLedgerAccount = null;
          paymentData.ledgerAccount = null;
          ledgerAccountDropdownItems =
              _getLedgerAccountsByType(selectedLedgerAccountType!);
          widget.onChange(paymentData);
        });
      },
      hint: Text(getString(context, "payments_ledger_account_type_hint")),
      onSaved: (_) {},
    );
  }

  bool loadingBalance = false;
  double? balance;
  Widget _buildLedgerAccountDropdownFromSelectedType(
      ThemeData theme, LedgerAccountType ledgerAccountType) {
    var labelStyle = LelloTextStyles.subtitleBold(theme)!.copyWith(
      color: LelloTheme.palleteOf(theme).text(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLedgerAccountTypeLabel(labelStyle),
        SizedBox(
          height: Dimens.spacing,
        ),
        _buildLedgerAccountDropdown(),
        SizedBox(
          height: Dimens.spacing,
        ),
        _buildAllLedgerAccountsCheckbox(theme, ledgerAccountType),
        if (loadingBalance)
          const CircularProgressIndicator()
        else if (selectedLedgerAccountType == LedgerAccountType.extraordinary &&
            selectedLedgerAccount != null)
          _buildValueField(theme, LelloTheme.palleteOf(theme))
      ],
    );
  }

  Widget _buildLedgerAccountTypeLabel(TextStyle labelStyle) {
    return selectedLedgerAccountType == LedgerAccountType.ordinary ||
            selectedLedgerAccountType == LedgerAccountType.all
        ? Text(
            getString(context, "payments_ledger_account_ordinary_accounts"),
            style: labelStyle,
          )
        : Text(
            getString(
                context, "payments_ledger_account_extraordinary_accounts"),
            style: labelStyle,
          );
  }

  Widget _buildLedgerAccountDropdown() {
    ledgerAccountDropdownItems =
        _getLedgerAccountsByType(selectedLedgerAccountType!);

    if (!ledgerAccountDropdownItems.contains(selectedLedgerAccount)) {
      selectedLedgerAccount = null;
    }

    return DropdownButtonFormField<LedgerAccountEntity>(
      isExpanded: true,
      items: ledgerAccountDropdownItems.map((account) {
        return DropdownMenuItem<LedgerAccountEntity>(
          value: account,
          child: Text(
              '${account?.id ?? getString(context, "payments_ledger_account_account_not_provided")} - ${account?.name ?? getString(context, "payments_ledger_account_name_not_provided")}'),
        );
      }).toList(),
      value: selectedLedgerAccount,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.spacingSmall),
        ),
      ),
      onChanged: (value) {
        setState(() {
          selectedLedgerAccount = value;
          if (value != null && value.id != null) {
            paymentData.ledgerAccount = value.id;

            if (selectedLedgerAccountType == LedgerAccountType.extraordinary &&
                selectedLedgerAccount != null) {
              loadingBalance = true;
              getBalanceValue().then((value) {
                setState(() {
                  balance = value;
                  loadingBalance = false;
                });
              });
            } else {
              balance = null;
              loadingBalance = false;
            }
          }
          widget.onChange(paymentData);
        });
      },
      hint: Text(getString(context, "payments_ledger_account_select_hint")),
      onSaved: (newValue) {},
      validator: (value) {
        return _validator.validateRequired(null);
      },
    );
  }

  Widget _buildAllLedgerAccountsCheckbox(
      ThemeData theme, LedgerAccountType type) {
    if (type == LedgerAccountType.extraordinary) return Container();
    if (type == LedgerAccountType.ordinary &&
        ledgerAccountDropdownItems.isEmpty) {
      selectedLedgerAccountType = LedgerAccountType.all;
    }
    return Row(
      children: [
        Checkbox(
          value: selectedLedgerAccountType == LedgerAccountType.all,
          onChanged: (value) {
            if (ledgerAccountDropdownItems.isNotEmpty || value == true) {
              setState(() {
                selectedLedgerAccountType =
                    value! ? LedgerAccountType.all : LedgerAccountType.ordinary;
                selectedLedgerAccount = null;
                widget.onChange(paymentData);
              });
            }
          },
        ),
        Text(getString(context, "payments_ledger_account_show_all_accounts"),
            style: LelloTextStyles.subtitleBold(theme)),
      ],
    );
  }

  Widget _buildValueField(ThemeData theme, ColorPallete pallete) {
    if (balance == null) {
      return Row(
        children: [
          const Icon(
            Icons.error,
            color: Colors.orange,
          ),
          SizedBox(width: Dimens.spacingSmall),
          Expanded(
            child: Text(
              getString(context, "payments_balance_error"),
              style: LelloTextStyles.subtitleBold(theme)!
                  .copyWith(color: Colors.orange),
            ),
          ),
        ],
      );
    }

    setBalanceValue(balance!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: pallete.grey().withAlpha(150), width: 1.5),
      ),
      height: 50,
      child: Row(
        children: [
          Text(
            getString(context, "payments_balance_label"),
            style:
                LelloTextStyles.body(theme)?.copyWith(fontSize: Dimens.spacing),
          ),
          SizedBox(width: Dimens.spacingSmall),
          Flexible(
            child: PrimaryAmountFormField(
              textAlign: TextAlign.end,
              fontSize: Dimens.spacing,
              enabled: false,
              controller: balanceController,
              action: TextInputAction.done,
              formatter: currencyFormatter(),
            ),
          ),
        ],
      ),
    );
  }

  List<LedgerAccountEntity?> _getLedgerAccountsByType(
      LedgerAccountType ledgerAccountType) {
    if (supplier?.supplierLedgerAccounts != null) {
      switch (ledgerAccountType) {
        case LedgerAccountType.extraordinary:
          return supplier!.supplierLedgerAccounts!.extraordinary;
        case LedgerAccountType.ordinary:
          return supplier!.supplierLedgerAccounts!.ordinary;

        case LedgerAccountType.all:
          return supplier!.supplierLedgerAccounts!.all;
      }
    } else {
      return [];
    }
  }
}
