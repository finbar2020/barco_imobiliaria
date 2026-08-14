import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';

class BalanceDetailFilterWidget extends StatefulWidget {
  final VoidCallback? onClose;
  final void Function(CondominiumBalanceDetailFilter)? onApply;
  final CondominiumBalanceDetailFilter entity;

  BalanceDetailFilterWidget(
      {Key? key, this.onClose, required this.entity, this.onApply})
      : super(key: key);

  @override
  _BalanceDetailFilterWidgetState createState() =>
      _BalanceDetailFilterWidgetState();
}

class _BalanceDetailFilterWidgetState extends State<BalanceDetailFilterWidget> {
  final currencyFormat = new NumberFormat.currency(symbol: "R\$");
  final Validator validator = ApplicationContainer.instance().resolve();
  final _formKey = GlobalKey<FormState>();
  String? error;
  final dateFormat = DateFormat.yMd();

  TextEditingController startDateController =
      new TextEditingController(text: '');
  TextEditingController endDateController = new TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.dark;
    final themeContext = Theme.of(context);
    validator.context = context;

    if (widget.entity.startDate != null)
      startDateController.text = dateFormat.format(widget.entity.startDate!);
    if (widget.entity.endDate != null)
      endDateController.text = dateFormat.format(widget.entity.endDate!);
    return Container(
      padding: EdgeInsets.all(Dimens.spacing),
      color: Color(0xFF2D2D2D),
      child: Column(children: [
        SingleChildScrollView(
          child: _buildContent(theme, themeContext),
        )
      ]),
    );
  }

  Widget _buildContent(ThemeData theme, ThemeData themeContext) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Dimens.spacingMedium),
          Text(getString(context, "condominium_balance_detail_period"),
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
                            selectedDate: widget.entity.startDate,
                            lastDate: widget.entity.endDate,
                          );
                          setState(() {
                            widget.entity.startDate = date;
                            startDateController.text = dateFormat.format(date);
                          });
                        },
                        controller: startDateController,
                        onSaved: (value) =>
                            widget.entity.startDate = _parseDate(value!),
                        onFieldSubmitted: (_) => _nextFocus(),
                        validator: (value) =>
                            validator.validateDate(value!, optional: true),
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
                            selectedDate: widget.entity.endDate,
                            firstDate: widget.entity.startDate,
                          );
                          setState(() {
                            widget.entity.endDate = date;
                            endDateController.text = dateFormat.format(date);
                          });
                        },
                        controller: endDateController,
                        onSaved: (value) =>
                            widget.entity.endDate = _parseDate(value!),
                        onFieldSubmitted: (_) => _nextFocus(),
                        validator: (value) =>
                            validator.validateDate(value!, optional: true),
                        textInputType: TextInputType.number,
                        formatter: fullDateFormatter(),
                        hint: "00/00/0000")
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: Dimens.spacing),
          Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: widget.entity.orderByDate,
                  activeColor: themeContext.primaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      widget.entity.orderByDate = value!;
                    });
                  },
                ),
              ),
              Expanded(
                  child: Text(
                      getString(
                          context, "condominium_balance_detail_order_by_date"),
                      style: LelloTextStyles.bodyBold(theme))),
            ],
          ),
          Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: widget.entity.orderByCount,
                  activeColor: themeContext.primaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      widget.entity.orderByCount = value!;
                    });
                  },
                ),
              ),
              Expanded(
                  child: Text(
                      getString(context,
                          "condominium_balance_detail_order_by_account"),
                      style: LelloTextStyles.bodyBold(theme))),
            ],
          ),
          Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: widget.entity.onlyReceita,
                  activeColor: themeContext.primaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      widget.entity.onlyReceita = value!;
                    });
                  },
                ),
              ),
              Expanded(
                  child: Text(
                      getString(
                          context, "condominium_balance_detail_only_recipe"),
                      style: LelloTextStyles.bodyBold(theme))),
            ],
          ),
          Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: widget.entity.onlyDespesa,
                  activeColor: themeContext.primaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      widget.entity.onlyDespesa = value!;
                    });
                  },
                ),
              ),
              Expanded(
                  child: Text(
                      getString(
                          context, "condominium_balance_detail_only_expense"),
                      style: LelloTextStyles.bodyBold(theme))),
            ],
          ),
          SizedBox(height: Dimens.spacing),
          Text(
              getString(
                  context, "condominium_balance_detail_accounting_account"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacing),
          PrimaryTextFormField(
            initialValue: "",
            onSaved: (value) => value,
            hint: "-",
            onFieldSubmitted: (_) => _nextFocus(),
          ),
          Visibility(
            visible: error?.isNotEmpty == true,
            child: Text(
              error ?? "",
              style: LelloTextStyles.error(theme),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: Dimens.spacing),
          PrimaryButton(
            text: getString(context, "find"),
            onPressed: () {
              _submit();
            },
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
