import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/domain/entity/employee_list_filter.dart';

class EmployeeFilterWidget extends StatefulWidget {
  final VoidCallback? onClose;
  final void Function(EmployeeListFilter)? onApply;
  final EmployeeListFilter entity;

  EmployeeFilterWidget(
      {Key? key, this.onClose, required this.entity, this.onApply})
      : super(key: key);

  @override
  _EmployeeFilterWidgetState createState() => _EmployeeFilterWidgetState();
}

class _EmployeeFilterWidgetState extends State<EmployeeFilterWidget> {
  final currencyFormat = new NumberFormat.currency(symbol: "R\$");
  final Validator validator = ApplicationContainer.instance().resolve();
  final _formKey = GlobalKey<FormState>();
  String? error;
  final dateFormat = DateFormat.yMd();

  TextEditingController fromBirthDateController =
      new TextEditingController(text: '');
  TextEditingController toBirthDateController =
      new TextEditingController(text: '');
  TextEditingController fromHiringDateController =
      new TextEditingController(text: '');
  TextEditingController toHiringDateController =
      new TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    var theme = LelloTheme.dark;
    var themeContext = Theme.of(context);
    theme = theme.copyWith(
      colorScheme: LelloTheme.dark.colorScheme.copyWith(
        primary: themeContext.primaryColor,
      ),
      primaryColor: themeContext.primaryColor,
    );
    validator.context = context;

    if (widget.entity.dobFrom != null)
      fromBirthDateController.text = dateFormat.format(widget.entity.dobFrom!);
    if (widget.entity.dobTo != null)
      toBirthDateController.text = dateFormat.format(widget.entity.dobTo!);
    if (widget.entity.hiringDateFrom != null)
      fromHiringDateController.text =
          dateFormat.format(widget.entity.hiringDateFrom!);
    if (widget.entity.hiringDateTo != null)
      toHiringDateController.text =
          dateFormat.format(widget.entity.hiringDateTo!);

    return Theme(
      data: theme,
      child: Container(
        padding: EdgeInsets.all(Dimens.spacing),
        color: Color(0xFF2D2D2D),
        child: Column(children: [
          SingleChildScrollView(
            child: _buildContent(theme),
          )
        ]),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(getString(context, "gdp_name"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacing),
          PrimaryTextFormField(
            initialValue: widget.entity.name ?? "",
            onSaved: (value) => widget.entity.name = value,
            hint: "-",
            onFieldSubmitted: (_) => _nextFocus(),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(getString(context, "gdp_role"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacing),
          PrimaryTextFormField(
            initialValue: widget.entity.role ?? "",
            onSaved: (value) => widget.entity.role = value,
            hint: "-",
            onFieldSubmitted: (_) => _nextFocus(),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text('Status', style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacing),
          DropdownButtonFormField(
            isExpanded: true,
            onSaved: (value) {
              widget.entity.conditionName = value as String?;
            },
            items: ['Trabalhando', 'Demitido', 'Férias']
                .map((value) => DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    ))
                .toList(),
            onChanged: (value) {},
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(getString(context, "gdp_salary"),
              style: LelloTextStyles.titleSmall(theme)),
          SizedBox(height: Dimens.spacing),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(getString(context, "payment_filter_from"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacing),
                    PrimaryTextFormField(
                        initialValue: widget.entity.salaryFrom != null
                            ? currencyFormat.format(widget.entity.salaryFrom)
                            : "",
                        onSaved: (value) => widget.entity.salaryFrom =
                            value?.isNotEmpty != true
                                ? null
                                : currencyFormat.parse(value as String)
                                    as double,
                        onFieldSubmitted: (_) => _nextFocus(),
                        textInputType: TextInputType.number,
                        formatter: currencyFormatter(),
                        hint: "R\$ -")
                  ],
                ),
              ),
              SizedBox(width: Dimens.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(getString(context, "payment_filter_to"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacing),
                    PrimaryTextFormField(
                        initialValue: widget.entity.salaryTo != null
                            ? currencyFormat.format(widget.entity.salaryTo)
                            : "",
                        onSaved: (value) => widget.entity.salaryTo =
                            value?.isNotEmpty != true
                                ? null
                                : currencyFormat.parse(value as String)
                                    as double,
                        onFieldSubmitted: (_) => _nextFocus(),
                        textInputType: TextInputType.number,
                        formatter: currencyFormatter(),
                        hint: "R\$ -")
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(getString(context, "gdp_dob"),
              style: LelloTextStyles.titleSmall(theme)),
          SizedBox(height: Dimens.spacing),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(getString(context, "payment_filter_from"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacing),
                    PrimaryTextFormField(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          final date = await datePicker(
                            context,
                            selectedDate: widget.entity.dobFrom,
                            lastDate: widget.entity.dobTo,
                          );
                          setState(() {
                            widget.entity.dobFrom = date;
                            fromBirthDateController.text =
                                dateFormat.format(date);
                          });
                        },
                        controller: fromBirthDateController,
                        onSaved: (value) =>
                            widget.entity.dobFrom = _parseDate(value),
                        onFieldSubmitted: (_) => _nextFocus(),
                        validator: (value) =>
                            validator.validateDate(value ?? "", optional: true),
                        textInputType: TextInputType.number,
                        formatter: fullDateFormatter(),
                        hint: "00/00/0000")
                  ],
                ),
              ),
              SizedBox(width: Dimens.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(getString(context, "payment_filter_to"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacing),
                    PrimaryTextFormField(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          final date = await datePicker(
                            context,
                            selectedDate: widget.entity.dobTo,
                            firstDate: widget.entity.dobFrom,
                          );
                          setState(() {
                            widget.entity.dobTo = date;
                            toBirthDateController.text =
                                dateFormat.format(date);
                          });
                        },
                        controller: toBirthDateController,
                        onSaved: (value) =>
                            widget.entity.dobTo = _parseDate(value),
                        onFieldSubmitted: (_) => _nextFocus(),
                        validator: (value) =>
                            validator.validateDate(value ?? "", optional: true),
                        textInputType: TextInputType.number,
                        formatter: fullDateFormatter(),
                        hint: "00/00/0000")
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(getString(context, "gdp_hiring_date"),
              style: LelloTextStyles.titleSmall(theme)),
          SizedBox(height: Dimens.spacing),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(getString(context, "payment_filter_from"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacing),
                    PrimaryTextFormField(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          final date = await datePicker(
                            context,
                            selectedDate: widget.entity.hiringDateFrom,
                            lastDate: widget.entity.hiringDateTo,
                          );
                          setState(() {
                            widget.entity.hiringDateFrom = date;
                            toHiringDateController.text =
                                dateFormat.format(date);
                          });
                        },
                        controller: fromHiringDateController,
                        onSaved: (value) =>
                            widget.entity.hiringDateFrom = _parseDate(value),
                        onFieldSubmitted: (_) => _nextFocus(),
                        validator: (value) =>
                            validator.validateDate(value ?? "", optional: true),
                        textInputType: TextInputType.number,
                        formatter: fullDateFormatter(),
                        hint: "00/00/0000")
                  ],
                ),
              ),
              SizedBox(width: Dimens.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(getString(context, "payment_filter_to"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacing),
                    PrimaryTextFormField(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          final date = await datePicker(
                            context,
                            selectedDate: widget.entity.hiringDateTo,
                            firstDate: widget.entity.hiringDateFrom,
                          );
                          setState(() {
                            widget.entity.hiringDateTo = date;
                            fromHiringDateController.text =
                                dateFormat.format(date);
                          });
                        },
                        controller: toHiringDateController,
                        onSaved: (value) =>
                            widget.entity.hiringDateTo = _parseDate(value),
                        onFieldSubmitted: (_) => _nextFocus(),
                        validator: (value) =>
                            validator.validateDate(value ?? "", optional: true),
                        textInputType: TextInputType.number,
                        formatter: fullDateFormatter(),
                        hint: "00/00/0000")
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: Dimens.spacing),
          Visibility(
            visible: error?.isNotEmpty == true,
            child: Text(
              error ?? "",
              style: LelloTextStyles.error(theme),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: Dimens.spacing),
          Theme(
            data: Theme.of(context),
            child: PrimaryButton(
              text: getString(context, "find"),
              onPressed: () {
                _submit();
              },
            ),
          ),
          SizedBox(height: Dimens.spacingLarge),
        ],
      ),
    );
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return dateFormat.parse(value);
  }

  void _nextFocus() {
    FocusScope.of(context).nextFocus();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        error = null;
      });
      if (widget.onApply != null) {
        widget.onApply!(widget.entity);
      }
    } else {
      setState(() {
        error = getString(context, "filter_validation_error");
      });
    }
  }
}
