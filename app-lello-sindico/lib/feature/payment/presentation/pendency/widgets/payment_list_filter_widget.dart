// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/presentation/pendency/controller/payment_pendency_controller.dart';

class PaymentListFilterWidget extends StatefulWidget {
  final bool isPendency;

  const PaymentListFilterWidget({super.key, required this.isPendency});

  @override
  _PaymentListFilterWidgetState createState() =>
      _PaymentListFilterWidgetState();
}

class _PaymentListFilterWidgetState extends State<PaymentListFilterWidget> {
  final Validator validator = ApplicationContainer.instance().resolve();
  final _formKey = GlobalKey<FormState>();
  String? error;
  final dateFormat = DateFormat.yMd();
  final controller =
      ApplicationContainer.instance().resolve<PaymentPendencyController>();

  TextEditingController startDateController = TextEditingController(text: '');
  TextEditingController endDateController = TextEditingController(text: '');

  DateTime? startDate;
  DateTime? endDate;
  String? numDoc;

  @override
  void initState() {
    super.initState();
    startDate = controller.startDate;
    endDate = controller.endDate;
    numDoc = controller.numDoc;
    startDateController.text =
        startDate != null ? dateFormat.format(startDate!) : '';
    endDateController.text = endDate != null ? dateFormat.format(endDate!) : '';
  }

  @override
  Widget build(BuildContext context) {
    var theme = LelloTheme.dark;
    var themeContext = Theme.of(context);
    theme = theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: themeContext.primaryColor,
      ),
      primaryColor: themeContext.primaryColor,
    );
    validator.context = context;

    return Theme(
      data: theme,
      child: Container(
        padding: EdgeInsets.all(Dimens.spacing),
        color: const Color(0xFF2D2D2D),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      getString(context, "payment_filter_expiration"),
                      style: LelloTextStyles.titleSmall(theme),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "${getString(context, "payment_filter_from")}:",
                                style: LelloTextStyles.bodyBold(theme),
                              ),
                              SizedBox(height: Dimens.spacing),
                              PrimaryTextFormField(
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  final date = await datePicker(
                                    context,
                                    selectedDate: startDate,
                                    lastDate: endDate,
                                  );
                                  setState(
                                    () {
                                      startDate = date;
                                      startDateController.text =
                                          dateFormat.format(date);
                                    },
                                  );
                                },
                                controller: startDateController,
                                onSaved: (value) =>
                                    startDate = _parseDate(value) ?? startDate,
                                onFieldSubmitted: (_) => _nextFocus(),
                                validator: (value) => validator
                                    .validateDate(value ?? "", optional: true),
                                textInputType: TextInputType.number,
                                formatter: fullDateFormatter(),
                                hint: "00/00/0000",
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: Dimens.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "${getString(context, "payment_filter_to")}:",
                                style: LelloTextStyles.bodyBold(theme),
                              ),
                              SizedBox(height: Dimens.spacing),
                              PrimaryTextFormField(
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  final date = await datePicker(
                                    context,
                                    selectedDate: endDate,
                                    firstDate: startDate,
                                  );
                                  setState(
                                    () {
                                      endDate = date;
                                      endDateController.text =
                                          dateFormat.format(
                                        DateTime(
                                          date.year,
                                          date.month,
                                          date.day,
                                          23,
                                          59,
                                          59,
                                        ),
                                      );
                                    },
                                  );
                                },
                                controller: endDateController,
                                onSaved: (value) =>
                                    endDate = _parseDate(value) ?? endDate,
                                onFieldSubmitted: (_) => _nextFocus(),
                                validator: (value) => validator
                                    .validateDate(value ?? "", optional: true),
                                textInputType: TextInputType.number,
                                formatter: fullDateFormatter(),
                                hint: "00/00/0000",
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Text(getString(context, "payment_filter_payment_number"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacing),
                    PrimaryTextFormField(
                      initialValue: numDoc,
                      hint: "-",
                      textInputType: TextInputType.number,
                      onChanged: (value) {
                        numDoc = value;
                      },
                      onFieldSubmitted: (_) => _nextFocus(),
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
                    PrimaryButton(
                      buttonColor: theme.primaryColor,
                      onPressed: _submit,
                      child: Text(
                        getString(context, "find"),
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    SecondaryButton(
                      text: getString(context, "report_clear_filters"),
                      buttonBorderColor: theme.colorScheme.onPrimary,
                      onPressed: () {
                        setState(() {
                          startDate = null;
                          endDate = null;
                          numDoc = null;
                          startDateController.clear();
                          endDateController.clear();
                        });
                        controller.clearFilters(isPendency: widget.isPendency);
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: Dimens.spacingLarge),
                  ],
                ),
              ),
            )
          ],
        ),
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
      controller.setFilter(
        start: startDate,
        end: endDate,
        doc: numDoc,
      );
      if (widget.isPendency) {
        controller.getInstallmentsInApproval(
            onlyInApprovalStatus: widget.isPendency);
      } else {
        controller.getContasPagar();
      }

      Navigator.of(context).pop();
    } else {
      setState(
        () {
          error = getString(context, "filter_validation_error");
        },
      );
    }
  }
}
