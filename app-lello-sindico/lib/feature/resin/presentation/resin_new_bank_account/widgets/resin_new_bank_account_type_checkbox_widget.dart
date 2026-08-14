import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account_type.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/widgets/resin_new_bank_account_form_data.dart';

class ResinNewBankAccountTypeCheckboxWidget extends StatefulWidget {
  final ResinNewBankAccountFormData accountFormData;
  const ResinNewBankAccountTypeCheckboxWidget({
    Key? key,
    required this.accountFormData,
  }) : super(key: key);

  @override
  State<ResinNewBankAccountTypeCheckboxWidget> createState() =>
      _ResinNewBankAccountTypeCheckboxWidgetState();
}

class _ResinNewBankAccountTypeCheckboxWidgetState
    extends State<ResinNewBankAccountTypeCheckboxWidget> {
  late ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: _receiptCheckbox(ResinBankAccountType.current,
              getString(context, "resin_bank_account_type_current")),
        ),
        SizedBox(width: Dimens.spacingSmall),
        Flexible(
          child: _receiptCheckbox(ResinBankAccountType.saving,
              getString(context, "resin_bank_account_type_saving")),
        ),
      ],
    );
  }

  Row _receiptCheckbox(ResinBankAccountType type, String text) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            activeColor: theme.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            side: BorderSide(
              width: 1.0,
              color: LelloTheme.palleteOf(theme).grey(),
            ),
            value: widget.accountFormData.accountType == type,
            onChanged: (val) {
              _updateType(type);
            },
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              _updateType(type);
            },
            child: Text(
              text,
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
            ),
          ),
        )
      ],
    );
  }

  void _updateType(ResinBankAccountType type) {
    setState(() {
      if (widget.accountFormData.accountType != type) {
        widget.accountFormData.accountType = type;
      } else {
        widget.accountFormData.accountType = null;
      }
    });
  }
}
