import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payment/domain/entity/contract.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_document_type.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/presentation/register_form/controllers/register_form_page_controller.dart';
import 'package:lello/feature/payment/presentation/widget/payment_search_supplier/widget/payment_search_supplier_widget.dart';

class RegisterFormStepData extends StatefulWidget {
  final int step;
  final RegisterFormPageController controller;
  final Function(PaymentDataEntity paymentdata) onChange;
  const RegisterFormStepData(
      {super.key,
      required this.step,
      required this.controller,
      required this.onChange});

  @override
  State<RegisterFormStepData> createState() => _RegisterFormStepDataState();
}

class _RegisterFormStepDataState extends State<RegisterFormStepData> {
  final Validator _validator = ApplicationContainer.instance().resolve();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var dueDateController = TextEditingController();

  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  NumberFormat currencyFormat = NumberFormat.currency(symbol: "R\$");
  String realCurrency = CommonCurrencies().brl.isoCode;
  late PaymentDataEntity paymentData;
  SupplierDataEntity? supplierData;
  List<PaymentDocumentType> documentTypes = getPaymentDocumentTypes();
  var todayNoTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    _validator.context = (context);
    paymentData = widget.controller.paymentData;
    supplierData = widget.controller.supplier;
    if (paymentData.dueDate != null &&
        paymentData.dueDate!.isBefore(todayNoTime)) {
      {
        paymentData.dueDate = null;
      }
    }
  }

  void nextFocus() {
    FocusScope.of(context).nextFocus();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var labelStyle = LelloTextStyles.subtitleBold(theme)!.copyWith(
      color: LelloTheme.palleteOf(theme).text(),
    );

    dueDateController.text = paymentData.dueDate != null
        ? dateFormat.format(paymentData.dueDate!)
        : "";
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimens.spacingSmall,
            ),
            Text(getString(context, "payments_form_title"),
                style: theme.textTheme.titleLarge),
            SizedBox(
              height: Dimens.spacingSmall,
            ),
            Text(
              getString(context, "payments_form_subtitle"),
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: Dimens.spacingSmall,
            ),
            PaymentSearchSupplierWidget(
              showDocumentInput: true,
              initialSuplierId: paymentData.idSupplier,
              onChange: (document, supplier) {
                setState(() {
                  paymentData.idSupplier = supplier?.id;
                  paymentData.documentSupplier = supplier?.document ?? document;
                  if (supplier != null) {
                    widget.controller.supplier = supplier;
                  }
                  onChange(paymentData);
                });
              },
            ),
            SizedBox(
              height: Dimens.spacingSmall,
            ),
            Text(
              getString(context, "payments_form_contract_number_label"),
              style: labelStyle,
            ),
            SizedBox(
              height: Dimens.spacingSmall,
            ),
            _buildContractField(theme),
            SizedBox(
              height: Dimens.spacingSmall,
            ),
            Text(
              getString(context, "payments_form_document_type_label"),
              style: labelStyle,
            ),
            SizedBox(
              height: Dimens.spacingSmall,
            ),
            _buildDocumentTypeDropdown(theme),
            Text(
              getString(context, "payments_form_document_number_label"),
              style: labelStyle,
            ),
            SizedBox(height: Dimens.spacingSmall),
            PrimaryTextFormField(
              initialValue: paymentData.documentNumber ?? "",
              onSaved: (value) {
                paymentData.documentNumber = value;
                onChange(paymentData);
              },
              hint: getString(context, "payments_form_document_hint"),
              textInputType: TextInputType.number,
              onChanged: (value) {
                paymentData.documentNumber = value;
                onChange(paymentData);
              },
            ),
            SizedBox(height: Dimens.spacingSmall),
            // Campo de Data de Vencimento
            Text(
              "${getString(context, "payments_send_financial_label_due")} *",
              style: labelStyle,
            ),
            SizedBox(height: Dimens.spacingSmall),
            PrimaryTextFormField(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: paymentData.dueDate,
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: CalendarTheme(context),
                          child: child!,
                        );
                      });
                  if (date != null) {
                    setState(() {
                      paymentData.dueDate = (date);
                      dueDateController.text = dateFormat.format(date);
                      onChange(paymentData);
                    });
                  }
                },
                controller: dueDateController,
                textInputType: TextInputType.number,
                formatter: fullDateFormatter(),
                autoValidate: true,
                validator: (value) => _validator.validateRequired(value),
                hint: "00/00/0000"),
            SizedBox(height: Dimens.spacingSmall),
            Text(
              getString(context, "payments_form_total_value_label"),
              style: labelStyle,
            ),
            SizedBox(height: Dimens.spacingSmall),
            PrimaryTextFormField(
              initialValue: currencyFormat.format(paymentData.totalValue ?? 0),
              onSaved: (value) {
                paymentData.totalValue = double.parse(value ?? "0");
                onChange(paymentData);
              },
              hint: getString(context, "payments_form_total_value_hint"),
              autoValidate: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return getString(context, "validation_required");
                }
                if (Money.parse(value, isoCode: realCurrency).toDouble() == 0) {
                  return getString(context, "validation_required");
                }
                _validator.validateRequired(value);
                return null;
              },
              textInputType: TextInputType.number,
              formatter: currencyFormatter(),
              onFieldSubmitted: (value) => nextFocus(),
              onChanged: (value) {
                paymentData.totalValue =
                    Money.parse(value, isoCode: realCurrency).toDouble();
                onChange(paymentData);
              },
            ),
            SizedBox(height: Dimens.spacingSmall),
            Text(
              getString(context, "payments_form_observations_label"),
              style: labelStyle,
            ),
            SizedBox(height: Dimens.spacingSmall),
            PrimaryTextFormField(
              initialValue: paymentData.observation ?? "",
              onSaved: (value) {
                paymentData.observation = value;
                onChange(paymentData);
              },
              hint: getString(context, "payments_form_observations_hint"),
              textInputType: TextInputType.multiline,
              maxLength: 255,
              validator: (value) => _validator.validateMaxLength(value, 255),
              onChanged: (value) {
                paymentData.observation = value;
                onChange(paymentData);
              },
            ),
          ],
        ),
      ),
    );
  }

  void onChange(PaymentDataEntity paymentData) {
    if (_formKey.currentState!.validate()) {
      widget.onChange(paymentData);
    }
  }

  Widget _buildDocumentTypeDropdown(ThemeData theme) {
    return DropdownButtonFormField<PaymentDocumentType>(
      items: documentTypes.map((type) {
        return DropdownMenuItem<PaymentDocumentType>(
          value: type,
          child: Text(paymentDocumentTypeToString(type)),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: paymentData.documentType != null
                ? LelloTheme.palleteOf(theme).primary()
                : LelloTheme.palleteOf(theme).buttonSystem(),
          ),
          borderRadius: BorderRadius.circular(Dimens.spacingSmall),
        ),
      ),
      value: paymentData.documentType,
      validator: (value) {
        if (value == null) return getString(context, "validation_required");
        String documentType = paymentDocumentTypeToString(value);
        return _validator.validateRequired(documentType);
      },
      onChanged: (value) {
        setState(() {
          paymentData.documentType = value;
          onChange(paymentData);
        });
      },
      onSaved: (newValue) {
        paymentData.documentType = newValue;
        onChange(paymentData);
      },
    );
  }

  Widget _buildContractField(ThemeData theme) {
    if (supplierData != null && supplierData!.contracts.isNotEmpty) {
      ContractEntity? initialValue;

      for (var contract in supplierData!.contracts) {
        if (contract!.code == paymentData.idContract.toString()) {
          initialValue = contract;
          break;
        }
      }
      initialValue ??= supplierData!.contracts.first;

      return DropdownButtonFormField<ContractEntity?>(
        value: initialValue,
        onChanged: (ContractEntity? newValue) {
          setState(() {
            paymentData.idContract = newValue?.id;
            onChange(paymentData);
          });
        },
        items: supplierData!.contracts
            .map<DropdownMenuItem<ContractEntity>>((ContractEntity? contract) {
          return DropdownMenuItem<ContractEntity>(
            value: contract,
            child: Text(contract?.code ?? ''),
          );
        }).toList(),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: paymentData.documentType != null
                  ? LelloTheme.palleteOf(theme).primary()
                  : LelloTheme.palleteOf(theme).buttonSystem(),
            ),
            borderRadius: BorderRadius.circular(Dimens.spacingSmall),
          ),
        ),
      );
    } else {
      return PrimaryTextFormField(
        initialValue: paymentData.idContract != null
            ? paymentData.idContract.toString()
            : "",
        onSaved: (value) {
          paymentData.idContract = int.parse(value ?? "0");
        },
        onChanged: (value) {
          paymentData.idContract = int.parse(value);
          onChange(paymentData);
        },
        textInputType: TextInputType.number,
        hint: getString(context, "payments_form_document_hint"),
        onFieldSubmitted: (value) => nextFocus(),
      );
    }
  }
}
