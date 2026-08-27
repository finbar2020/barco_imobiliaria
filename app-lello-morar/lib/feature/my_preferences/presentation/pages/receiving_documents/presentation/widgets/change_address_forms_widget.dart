import 'package:essentials/essentials.dart' hide Switch;
import 'package:flutter/material.dart';
import 'package:morar/feature/my_preferences/domain/entities/street_type_entity.dart';

import '../../../../../../../core/dependency/application_container.dart';
import '../../../../../../easy_fix/domain/entity/city_entity.dart';
import '../../../../../domain/entities/unit_addess_data_entity.dart';
import '../bloc/receiving_documents_bloc.dart';

class ChangeAddressFormsWidget extends StatefulWidget {
  const ChangeAddressFormsWidget({
    required this.bloc,
    required this.condoAddress,
    required this.unitAddress,
    required this.onChanged,
    required this.useUnitAddress,
    Key? key,
  }) : super(key: key);

  final AddressDataEntity condoAddress;
  final AddressDataEntity unitAddress;
  final ReceivingDocumentsBloc bloc;
  final bool useUnitAddress;
  final ValueChanged<AddressDataEntity> onChanged;

  @override
  State<ChangeAddressFormsWidget> createState() =>
      _ChangeAddressFormsWidgetState();
}

class _ChangeAddressFormsWidgetState extends State<ChangeAddressFormsWidget> {
  final formKey = GlobalKey<FormState>();
  final zipCodeController = TextEditingController();
  final streetType = TextEditingController();
  final streetNameController = TextEditingController();
  final streetNumberController = TextEditingController();
  final complementController = TextEditingController();
  final neighborhood = TextEditingController();
  final stateController = TextEditingController();
  final city = TextEditingController();

  final zipCodeFocus = FocusNode();
  final streetTypeFocus = FocusNode();
  final streetNameFocus = FocusNode();
  final streetNumberFocus = FocusNode();
  final complementFocus = FocusNode();
  final neighborhoodFocus = FocusNode();
  final stateFocus = FocusNode();
  final cityFocus = FocusNode();

  bool isFieldsEnabled = true;
  String? zipCodeError = null;
  bool useMyUnitAddress = false;
  bool hasChanges = false;
  bool changingByFlag = false;

  @override
  void initState() {
    super.initState();
    useMyUnitAddress = !widget.useUnitAddress;
    isFieldsEnabled = !useMyUnitAddress;
    _fillFields(!useMyUnitAddress ? widget.unitAddress : widget.condoAddress);
  }

  @override
  Widget build(BuildContext context) {
    final Validator _validator = ApplicationContainer.instance().resolve();
    _validator.context = context;
    final theme = Theme.of(context);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: AutofillGroup(
              onDisposeAction: AutofillContextAction.cancel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getString(context, 'add_another_address'),
                    style: LelloTextStyles.subtitleBold(theme),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(
                    getString(context, 'fill_the_fields_address'),
                    style: LelloTextStyles.subtitle(theme),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Row(
                    children: [
                      Switch(
                        value: useMyUnitAddress,
                        onChanged: (value) {
                          changingByFlag = true;
                          setState(() {
                            useMyUnitAddress = value;
                            isFieldsEnabled = !value;
                            formKey.currentState?.reset();
                            if (value) {
                              _fillFields(widget.condoAddress);
                            }
                          });
                          changingByFlag = false;
                          _checkIfHasChanges();
                        },
                      ),
                      SizedBox(width: Dimens.spacing),
                      Text(
                        getString(context, 'use_my_unit_address'),
                        style: LelloTextStyles.bodyBold(theme),
                      )
                    ],
                  ),
                  SizedBox(height: Dimens.spacing),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${getString(context, "cep")}*",
                              style: LelloTextStyles.bodyBold(theme),
                            ),
                            SizedBox(height: Dimens.spacing),
                            TextFormField(
                              autofillHints: [AutofillHints.postalCode],
                              inputFormatters: [cepFormatter()],
                              controller: zipCodeController,
                              enabled: isFieldsEnabled,
                              onChanged: (text) async {
                                if (text.length == 9) {
                                  _checkIfHasChanges();
                                  if (!changingByFlag) {
                                    final result = await widget.bloc
                                        .getAddressByCep(cep: text);
                                    result.fold((error) {
                                      zipCodeError = error.errorMessage;
                                      setState(() {});
                                    }, (info) async {
                                      await _processZipCodeResult(info);
                                    });
                                  }
                                }
                              },
                              focusNode: zipCodeFocus,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (text) =>
                                  _validator.validateExactLength(text, 9),
                              decoration: InputDecoration(
                                  hintText: "99999-999",
                                  border: OutlineInputBorder(),
                                  errorText: zipCodeError),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Dimens.spacing),
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Logradouro*',
                              style: LelloTextStyles.bodyBold(theme),
                            ),
                            SizedBox(height: Dimens.spacingSmall),
                            DropdownButtonFormField<StreetTypeEntity>(
                              isExpanded: true,
                              focusNode: streetTypeFocus,
                              value: widget.bloc.streetType,
                              validator: (value) =>
                                  _validator.validateRequired(value?.name),
                              items: List.from(
                                widget.bloc.streetTypes
                                    .map(
                                      (e) => DropdownMenuItem(
                                        child: Text(e.name),
                                        value: e,
                                      ),
                                    )
                                    .toList(),
                              ),
                              onChanged: isFieldsEnabled
                                  ? (value) {
                                      _checkIfHasChanges();
                                      widget.bloc.streetType =
                                          value ?? widget.bloc.streetType;
                                    }
                                  : null,
                              decoration: InputDecoration(
                                hintText: 'Logradouro',
                                border: OutlineInputBorder(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Endereço*",
                              style: LelloTextStyles.bodyBold(theme),
                            ),
                            SizedBox(height: Dimens.spacingSmall),
                            TextFormField(
                              autofillHints: [AutofillHints.postalAddress],
                              controller: streetNameController,
                              keyboardType: TextInputType.text,
                              onChanged: (text) => _checkIfHasChanges(),
                              enabled: isFieldsEnabled,
                              focusNode: streetNameFocus,
                              textInputAction: TextInputAction.next,
                              validator: _validator.validateExisting,
                              decoration: InputDecoration(
                                hintText: "Preencha com o nome do logradouro",
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
                              "${getString(context, "address_number")}*",
                              style: LelloTextStyles.bodyBold(theme),
                            ),
                            SizedBox(height: Dimens.spacingSmall),
                            TextFormField(
                              controller: streetNumberController,
                              focusNode: streetNumberFocus,
                              onChanged: (text) => _checkIfHasChanges(),
                              autofillHints: [AutofillHints.postalAddress],
                              keyboardType: TextInputType.text,
                              enabled: isFieldsEnabled,
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
                    ],
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Text(
                    "${getString(context, "address_neighbor")}*",
                    style: LelloTextStyles.bodyBold(theme),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  TextFormField(
                    controller: neighborhood,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: neighborhoodFocus,
                    onChanged: (text) => _checkIfHasChanges(),
                    enabled: isFieldsEnabled,
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
                              '${getString(context, "address_state")}*',
                              style: LelloTextStyles.bodyBold(theme),
                            ),
                            SizedBox(height: Dimens.spacingSmall),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              focusNode: stateFocus,
                              value: stateController.text,
                              validator: (value) =>
                                  _validator.validateRequired(value),
                              items: List.from(
                                widget.bloc.states
                                    .map(
                                      (e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ),
                                    )
                                    .toList(),
                              ),
                              onChanged: isFieldsEnabled
                                  ? (value) async {
                                      stateController.text =
                                          value ?? stateController.text;
                                      _checkIfHasChanges();
                                      await widget.bloc.getCities(
                                        uf: stateController.text,
                                      );
                                      setState(() {});
                                    }
                                  : null,
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
                              '${getString(context, "address_city")}*',
                              style: LelloTextStyles.bodyBold(theme),
                            ),
                            SizedBox(height: Dimens.spacingSmall),
                            DropdownButtonFormField<City>(
                              isExpanded: true,
                              focusNode: cityFocus,
                              value: widget.bloc.addressCity,
                              validator: (value) =>
                                  _validator.validateExisting(value?.name),
                              items: List.from(
                                widget.bloc.cities
                                    .map(
                                      (e) => DropdownMenuItem(
                                        child: Text(e.name),
                                        value: e,
                                      ),
                                    )
                                    .toList(),
                              ),
                              onChanged: isFieldsEnabled
                                  ? (value) {
                                      _checkIfHasChanges();
                                      city.text = value?.name ?? city.text;
                                      widget.bloc.addressCity =
                                          value ?? widget.bloc.addressCity;
                                    }
                                  : null,
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
                  SizedBox(height: Dimens.spacingMedium),
                  Text(
                    getString(context, "address_complement"),
                    style: LelloTextStyles.bodyBold(theme),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  TextFormField(
                    controller: complementController,
                    autofillHints: [AutofillHints.postalAddress],
                    keyboardType: TextInputType.text,
                    onChanged: (text) => _checkIfHasChanges(),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  PrimaryButton(
                    onPressed: hasChanges
                        ? () {
                            if (formKey.currentState?.validate() == true) {
                              widget.onChanged(
                                AddressDataEntity(
                                  zipCode: zipCodeController.text,
                                  streetName: streetNameController.text,
                                  number: streetNumberController.text,
                                  complement: complementController.text,
                                  neighborhood: neighborhood.text,
                                  state: stateController.text,
                                  cityName: widget.bloc.addressCity?.name ?? '',
                                  streetType: 'Rua',
                                ),
                              );
                              Navigator.pop(context);
                            }
                          }
                        : null,
                    text: getString(context, 'conclude'),
                    buttonColor: LelloTheme.palleteOf(theme).buttonSystem(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _processZipCodeResult(ViaCepInfo info) async {
    streetNameController.text = info.logradouro ?? '';
    neighborhood.text = info.bairro ?? '';
    city.text = info.localidade ?? '';
    stateController.text = info.uf ?? '';
    streetNumberController.clear();
    complementController.clear();

    await widget.bloc.getCities(uf: info.uf ?? '');
    widget.bloc.streetType = null;
    widget.bloc.addressCity = widget.bloc.cities.singleWhere(
      (element) =>
          element.name ==
          removeDiacritics(info.localidade?.toUpperCase() ?? ""),
    );

    zipCodeError = null;
    // Recalcula depois do preenchimento automático (o onChanged do CEP
    // avaliou antes dos campos serem preenchidos).
    _checkIfHasChanges();
  }

  void _fillFields(AddressDataEntity address) {
    zipCodeController.text = address.zipCode;
    streetNameController.text = address.streetName;
    streetNumberController.text = address.number;
    complementController.text = address.complement;
    neighborhood.text = address.neighborhood;
    stateController.text = address.state;
    city.text = address.cityName;
    streetType.text = address.streetType;

    if (widget.bloc.streetTypes.isEmpty) {
      widget.bloc.getStreetTypes().then((value) {
        widget.bloc.streetType = widget.bloc.streetTypes.firstWhereOrNull(
          (element) =>
              element.name.toLowerCase() == address.streetType.toLowerCase(),
        );
        setState(() {});
      });
    } else {
      widget.bloc.streetType = widget.bloc.streetTypes.firstWhereOrNull(
        (element) =>
            element.name.toLowerCase() == address.streetType.toLowerCase() ||
            element.type.toLowerCase() == address.streetType.toLowerCase(),
      );
    }
    widget.bloc.getCities(uf: address.state).then((value) async {
      await Future.delayed(Duration(milliseconds: 100), () {
        widget.bloc.addressCity = widget.bloc.cities.firstWhere(
          (element) =>
              removeDiacritics(element.name).toLowerCase() ==
              removeDiacritics(address.cityName).toLowerCase(),
          orElse: () => widget.bloc.cities.first,
        );
        setState(() {
          changingByFlag = false;
        });
      });
    });
  }

  void _checkIfHasChanges() {
    setState(() {
      hasChanges = zipCodeController.text != widget.unitAddress.zipCode ||
          streetNameController.text != widget.unitAddress.streetName ||
          streetNumberController.text != widget.unitAddress.number ||
          complementController.text != widget.unitAddress.complement ||
          neighborhood.text != widget.unitAddress.neighborhood ||
          stateController.text != widget.unitAddress.state ||
          city.text != widget.unitAddress.cityName;
    });
  }
}
