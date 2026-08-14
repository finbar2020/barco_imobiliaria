// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/controller/cnd_controller.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';

import '../../../../../core/dependency/application_container.dart';

class CertificateNoOutstandingDebtForm extends StatefulWidget {
  final EasyFixUnit unit;
  final Key formKey;
  const CertificateNoOutstandingDebtForm({
    Key? key,
    required this.unit,
    required this.formKey,
  }) : super(key: key);

  @override
  State<CertificateNoOutstandingDebtForm> createState() =>
      _CertificateNoOutstandingDebtFormState();
}

class _CertificateNoOutstandingDebtFormState
    extends State<CertificateNoOutstandingDebtForm> {
  @override
  Widget build(BuildContext context) {
    final Validator _validator = ApplicationContainer.instance().resolve();
    final controller = ApplicationContainer.instance()
        .resolve<CertificateNoOutstandingDebtController>();
    _validator.context = context;
    final theme = Theme.of(context);
    return Form(
      key: widget.formKey,
      child: AutofillGroup(
        onDisposeAction: AutofillContextAction.cancel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              getString(context, "full_name"),
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            TextFormField(
              initialValue: widget.unit.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "${getString(context, "profile_update_email")}*",
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            TextFormField(
              autofillHints: [AutofillHints.email],
              initialValue: widget.unit.email,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: _validator.validateEmail,
              decoration: InputDecoration(
                hintText: getString(context, "confirm_email"),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.email = value;
              },
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "cpf_cnpj"),
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            TextFormField(
              inputFormatters: [cpfFormatter()],
              initialValue: widget.unit.cpfCnpj,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "${getString(context, "phone_required")}*",
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            TextFormField(
              autofillHints: [AutofillHints.telephoneNumber],
              inputFormatters: [landlinePhoneWithDDDFormatter()],
              initialValue: controller.landlineFormatted(widget.unit.phone),
              onChanged: (value) {
                controller.phone = value;
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: _validator.validateLandlinePhone,
              decoration: InputDecoration(
                hintText:
                    "${getString(context, "confirm_phone")} (00) 0000-0000",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "${getString(context, "mobile_phone_required")}*",
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            TextFormField(
              autofillHints: [AutofillHints.telephoneNumber],
              inputFormatters: [cellphoneWithDDDFormatter()],
              initialValue:
                  controller.mobilePhoneFormatted(widget.unit.cellphone),
              onChanged: (value) {
                controller.mobilePhone = value;
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: _validator.validateCellPhone,
              decoration: InputDecoration(
                hintText:
                    "${getString(context, "confirm_mobile_phone")} (00) 00000-0000",
                border: OutlineInputBorder(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
