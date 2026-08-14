import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/widgets/resin_new_bank_account_form_data.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/widgets/resin_new_bank_account_type_checkbox_widget.dart';

class ResinNewBankAccountFormWidget extends StatefulWidget {
  final List<ResinPerson> resinPeople;
  final List<ResinBank> resinBanks;
  final Function(ResinBankAccount newAccount) createAccountFunction;
  final ResinNewBankAccountFormData formData;
  ResinNewBankAccountFormWidget({
    Key? key,
    required this.resinPeople,
    required this.resinBanks,
    required this.createAccountFunction,
    required this.formData,
  }) : super(key: key);

  @override
  State<ResinNewBankAccountFormWidget> createState() =>
      _ResinNewBankAccountFormWidgetState();
}

class _ResinNewBankAccountFormWidgetState
    extends State<ResinNewBankAccountFormWidget> {
  final Validator validator = ApplicationContainer.instance().resolve();
  FocusNode agencyNode = FocusNode();
  FocusNode accountNode = FocusNode();
  FocusNode digitNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownBottomSheetButton<ResinPerson>(
            title: getString(context, "resin_new_account_select_contact"),
            valueText: widget.formData.selectedPerson != null
                ? "${widget.formData.selectedPerson!.name} - ${widget.formData.selectedPerson!.document}"
                : null,
            maxLines: 2,
            dropDownElements: widget.resinPeople
                .map(
                  (e) => DropdownBottomSheetElement(
                      text: "${e.name} - ${e.document}", value: e),
                )
                .toList(),
            doneFunction: (DropdownBottomSheetElement element) {
              setState(() {
                widget.formData.selectedPerson = element.value;
              });
            },
          ),
          SizedBox(height: Dimens.spacingMedium),
          DropdownBottomSheetButton<ResinBank>(
            title: getString(context, "resin_new_account_select_bank"),
            valueText: widget.formData.selectedBank?.bankName,
            dropDownElements: widget.resinBanks
                .map((e) =>
                    DropdownBottomSheetElement(text: e.bankName, value: e))
                .toList(),
            doneFunction: (DropdownBottomSheetElement element) {
              setState(() {
                widget.formData.selectedBank = element.value;
              });
            },
          ),
          SizedBox(height: Dimens.spacingMedium),
          PrimaryTextFormField(
            textInputType: TextInputType.number,
            controller: widget.formData.agencyController,
            maxLength: 6,
            focusNode: agencyNode,
            labelText: getString(context, "resin_new_account_agency"),
            validator: validator.validateRequired,
            action: TextInputAction.next,
            onFieldSubmitted: (_) => _requestFocus(accountNode),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: PrimaryTextFormField(
                  textInputType: TextInputType.number,
                  controller: widget.formData.accountController,
                  maxLength: 38,
                  focusNode: accountNode,
                  labelText: getString(context, "resin_new_account_account"),
                  validator: validator.validateRequired,
                  action: TextInputAction.next,
                  onFieldSubmitted: (_) => _requestFocus(digitNode),
                ),
              ),
              SizedBox(width: Dimens.spacingMedium),
              Expanded(
                flex: 1,
                child: PrimaryTextFormField(
                  textInputType: TextInputType.number,
                  controller: widget.formData.digitController,
                  maxLength: 1,
                  focusNode: digitNode,
                  labelText: getString(context, "resin_new_account_digit"),
                  validator: validator.validateRequired,
                  action: TextInputAction.done,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getString(context, "resin_bank_account_type"),
            style: LelloTextStyles.subtitle(theme),
          ),
          SizedBox(height: Dimens.spacingSmall),
          ResinNewBankAccountTypeCheckboxWidget(
            accountFormData: widget.formData,
          ),
          SizedBox(height: Dimens.spacingXLarge),
          PrimaryButton(
              text: getString(context, 'send'),
              onPressed: () {
                if (validateFields()) {
                  ResinBankAccount account = ResinBankAccount(
                    bank: widget.formData.selectedBank!,
                    agency: widget.formData.agencyController.text,
                    accountNumber:
                        "${widget.formData.accountController.text}-${widget.formData.digitController.text}",
                    document: widget.formData.selectedPerson!.document,
                    supplierName: widget.formData.selectedPerson!.name,
                    accountType: widget.formData.accountType!,
                  );
                  widget.createAccountFunction(account);
                }
              }),
        ],
      ),
    );
  }

  void _requestFocus(FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  bool validateFields() {
    bool isValid = true;
    if (widget.formData.selectedBank == null) {
      isValid = false;
    }
    if (widget.formData.selectedPerson == null) {
      isValid = false;
    }
    if (widget.formData.agencyController.text.isEmpty) {
      isValid = false;
    }
    if (widget.formData.accountController.text.isEmpty) {
      isValid = false;
    }
    if (widget.formData.digitController.text.isEmpty) {
      isValid = false;
    }
    if (widget.formData.accountType == null) {
      isValid = false;
    }
    if (!isValid) {
      _showSnackBar();
    }
    return isValid;
  }

  void _showSnackBar() {
    String text = getString(context, "resin_new_account_fill_all_fields");
    if (text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
      ));
    }
  }
}
