import 'package:flutter/material.dart';
import 'package:morar/feature/easy_fix/domain/entity/city_entity.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/controllers/change_address_controller.dart';

import 'package:essentials/essentials.dart';

import '../../../../../core/dependency/application_container.dart';

class ChangeAddressForm extends StatefulWidget {
  final Key formKey;
  const ChangeAddressForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  @override
  State<ChangeAddressForm> createState() => _ChangeAddressFormState();
}

class _ChangeAddressFormState extends State<ChangeAddressForm> {
  @override
  Widget build(BuildContext context) {
    final Validator _validator = ApplicationContainer.instance().resolve();
    final controller =
        ApplicationContainer.instance().resolve<ChangeAddressController>();
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
              "${getString(context, "profile_update_email")}*",
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            TextFormField(
              autofillHints: [AutofillHints.email],
              initialValue: controller.email,
              keyboardType: TextInputType.text,
              onChanged: (value) => controller.email = value,
              textInputAction: TextInputAction.next,
              validator: _validator.validateEmail,
              decoration: InputDecoration(
                hintText: getString(context, "type_email"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "${getString(context, "cellphone_number")}*",
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            TextFormField(
              autofillHints: [AutofillHints.telephoneNumber],
              inputFormatters: [cellphoneWithDDDFormatter()],
              initialValue: controller.phoneFormatted(controller.cellphone),
              onChanged: (value) => controller.cellphone = value,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: _validator.validateCellPhone,
              decoration: InputDecoration(
                hintText: "(99) 99999-9999",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "${getString(context, "cep")}*",
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .5,
              child: TextFormField(
                autofillHints: [AutofillHints.postalCode],
                inputFormatters: [cepFormatter()],
                initialValue: controller.cep,
                onChanged: (value) => controller.cep = value,
                onEditingComplete: () async {
                  await controller.getAddressByCep(cep: controller.cep);
                  setState(() {});
                },
                onSaved: (newValue) async {
                  await controller.getAddressByCep(cep: controller.cep);
                  setState(() {});
                },
                focusNode: FocusNode(),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (text) => _validator.validateExactLength(text, 9),
                decoration: InputDecoration(
                  hintText: "99999-999",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "${getString(context, "address_full")}*",
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            TextFormField(
              autofillHints: [AutofillHints.postalAddress],
              controller: controller.addressController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: _validator.validateExisting,
              decoration: InputDecoration(
                hintText: getString(context, "type_address"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getString(context, "address_number")}*",
                        style: LelloTextStyles.bodyBold(theme),
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                      TextFormField(
                        controller: controller.addressNumberController,
                        autofillHints: [AutofillHints.postalAddress],
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: _validator.validateExisting,
                        decoration: InputDecoration(
                          hintText: "0000",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Dimens.spacingMedium),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getString(context, "address_complement"),
                        style: LelloTextStyles.bodyBold(theme),
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                      TextFormField(
                        controller: controller.addressComplementController,
                        autofillHints: [AutofillHints.postalAddress],
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "${getString(context, "address_neighbor")}*",
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            TextFormField(
              controller: controller.addressNeighborhoodController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: _validator.validateExisting,
              decoration: InputDecoration(
                hintText: getString(context, "address_neighbor"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getString(context, "address_state"),
                        style: LelloTextStyles.bodyBold(theme),
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: controller.addressStateController.text,
                        items: List.from(
                          controller.states
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ),
                              )
                              .toList(),
                        ),
                        onChanged: (value) async {
                          controller.addressStateController.text =
                              value ?? controller.addressStateController.text;
                          controller.cities = await controller.getCities(
                            condominiumId: controller.session.condominium!.id!,
                            uf: controller.addressStateController.text,
                          );
                          controller.addressCity = controller.cities.first;
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: getString(context, "address_state"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Dimens.spacingMedium),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getString(context, "address_city"),
                        style: LelloTextStyles.bodyBold(theme),
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                      DropdownButtonFormField<City>(
                        isExpanded: true,
                        value: controller.addressCity,
                        items: List.from(
                          controller.cities
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.name),
                                  value: e,
                                ),
                              )
                              .toList(),
                        ),
                        onChanged: (value) {
                          controller.addressCity =
                              value ?? controller.addressCity;
                        },
                        decoration: InputDecoration(
                          hintText: getString(context, "address_city"),
                          border: OutlineInputBorder(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
