// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lello/core/dependency/application_container.dart';

// import 'package:essentials/essentials.dart';

// import '../pendency_list/controller/payment_pendency_controller.dart';

// class PaymentFilterWidget extends StatefulWidget {
//   final bool isPendency;
//   const PaymentFilterWidget({
//     Key? key,
//     this.isPendency = false,
//   }) : super(key: key);

//   @override
//   _PaymentFilterWidgetState createState() => _PaymentFilterWidgetState();
// }

// class _PaymentFilterWidgetState extends State<PaymentFilterWidget> {
//   final Validator validator = ApplicationContainer.instance().resolve();
//   final _formKey = GlobalKey<FormState>();
//   String? error;
//   final dateFormat = DateFormat.yMd();
//   final controller =
//       ApplicationContainer.instance().resolve<PaymentPendencyController>();

//   TextEditingController createdDateFromDateController =
//       TextEditingController(text: '');
//   TextEditingController createdDateToController =
//       TextEditingController(text: '');

//   @override
//   Widget build(BuildContext context) {
//     var theme = LelloTheme.dark;
//     var themeContext = Theme.of(context);
//     theme = theme.copyWith(
//       colorScheme: theme.colorScheme.copyWith(
//         primary: themeContext.primaryColor,
//       ),
//       primaryColor: themeContext.primaryColor,
//     );
//     validator.context = context;

//     createdDateFromDateController.text =
//         dateFormat.format(controller.createdDateFrom);

//     createdDateToController.text = dateFormat.format(controller.createdDateTo);

//     return Theme(
//       data: theme,
//       child: Container(
//         padding: EdgeInsets.all(Dimens.spacing),
//         color: const Color(0xFF2D2D2D),
//         child: Column(
//           children: [
//             SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       getString(context, "payment_filter_expiration"),
//                       style: LelloTextStyles.titleSmall(theme),
//                     ),
//                     SizedBox(height: Dimens.spacing),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Text(
//                                 getString(context, "payment_filter_from"),
//                                 style: LelloTextStyles.bodyBold(theme),
//                               ),
//                               SizedBox(height: Dimens.spacing),
//                               PrimaryTextFormField(
//                                 onTap: () async {
//                                   FocusScope.of(context)
//                                       .requestFocus(FocusNode());
//                                   final date = await datePicker(
//                                     context,
//                                     selectedDate: controller.createdDateFrom,
//                                     lastDate: controller.createdDateTo,
//                                   );
//                                   setState(
//                                     () {
//                                       controller.createdDateFrom = date;
//                                       createdDateFromDateController.text =
//                                           dateFormat.format(date);
//                                     },
//                                   );
//                                 },
//                                 controller: createdDateFromDateController,
//                                 onSaved: (value) => controller
//                                     .filter.createdDateFrom = _parseDate(value),
//                                 onFieldSubmitted: (_) => _nextFocus(),
//                                 validator: (value) => validator
//                                     .validateDate(value ?? "", optional: true),
//                                 textInputType: TextInputType.number,
//                                 formatter: fullDateFormatter(),
//                                 hint: "00/00/0000",
//                               )
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: Dimens.spacingMedium),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Text(
//                                 getString(context, "payment_filter_to"),
//                                 style: LelloTextStyles.bodyBold(theme),
//                               ),
//                               SizedBox(height: Dimens.spacing),
//                               PrimaryTextFormField(
//                                 onTap: () async {
//                                   FocusScope.of(context)
//                                       .requestFocus(FocusNode());
//                                   final date = await datePicker(
//                                     context,
//                                     selectedDate: controller.createdDateTo,
//                                     firstDate: controller.createdDateFrom,
//                                   );
//                                   setState(
//                                     () {
//                                       controller.createdDateTo = DateTime(
//                                         date.year,
//                                         date.month,
//                                         date.day,
//                                         23,
//                                         59,
//                                         59,
//                                       );
//                                       createdDateToController.text =
//                                           dateFormat.format(
//                                         DateTime(
//                                           date.year,
//                                           date.month,
//                                           date.day,
//                                           23,
//                                           59,
//                                           59,
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 },
//                                 controller: createdDateToController,
//                                 onSaved: (value) => controller
//                                     .filter.createdDateTo = _parseDate(value),
//                                 onFieldSubmitted: (_) => _nextFocus(),
//                                 validator: (value) => validator
//                                     .validateDate(value ?? "", optional: true),
//                                 textInputType: TextInputType.number,
//                                 formatter: fullDateFormatter(),
//                                 hint: "00/00/0000",
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(height: Dimens.spacingMedium),
//                     Text(
//                       getString(context, "register_payment_document_cpf"),
//                       style: LelloTextStyles.bodyBold(theme),
//                     ),
//                     SizedBox(height: Dimens.spacing),
//                     PrimaryTextFormField(
//                       initialValue: controller.identifier,
//                       hint: "-",
//                       onFieldSubmitted: (_) => _nextFocus(),
//                       onChanged: (value) => controller.identifier = value,
//                       validator: (value) =>
//                           validator.validateCPForCNPJ(value, optional: true),
//                       textInputType: TextInputType.number,
//                       formatter: cpfOrCnpjFormatter(),
//                     ),
//                     SizedBox(height: Dimens.spacingMedium),
//                     Text(getString(context, "register_payment_document_number"),
//                         style: LelloTextStyles.bodyBold(theme)),
//                     SizedBox(height: Dimens.spacing),
//                     PrimaryTextFormField(
//                       initialValue: controller.numDoc,
//                       hint: "-",
//                       textInputType: TextInputType.number,
//                       onChanged: (value) {
//                         controller.numDoc = value;
//                       },
//                       onFieldSubmitted: (_) => _nextFocus(),
//                     ),
//                     SizedBox(height: Dimens.spacing),
//                     Visibility(
//                       visible: error?.isNotEmpty == true,
//                       child: Text(
//                         error ?? "",
//                         style: LelloTextStyles.error(theme),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     SizedBox(height: Dimens.spacing),
//                     PrimaryButton(
//                       buttonColor: theme.primaryColor,
//                       onPressed: _submit,
//                       child: Text(
//                         getString(context, "find"),
//                         style: TextStyle(
//                           color: theme.colorScheme.onPrimary,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: Dimens.spacingMedium),
//                     SecondaryButton(
//                       text: getString(context, "report_clear_filters"),
//                       buttonBorderColor: theme.colorScheme.onPrimary,
//                       onPressed: () {
//                         controller.clearFilters();
//                         _submit();
//                       },
//                     ),
//                     SizedBox(height: Dimens.spacingLarge),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   DateTime? _parseDate(String? value) {
//     if (value == null || value.isEmpty) return null;
//     return dateFormat.parse(value);
//   }

//   void _nextFocus() {
//     FocusScope.of(context).nextFocus();
//   }

//   void _submit() {
//     final form = _formKey.currentState;
//     if (form!.validate()) {
//       form.save();
//       setState(() {
//         error = null;
//       });
//       controller.filter.forcePendencyStatus = widget.isPendency;
//       controller.getFilter(isPendency: widget.isPendency);
//       Navigator.of(context).pop();
//     } else {
//       setState(
//         () {
//           error = getString(context, "filter_validation_error");
//         },
//       );
//     }
//   }
// }
