import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lello/core/dependency/application_container.dart';

class StaffAccessManagementGenericInput extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final List<TextInputFormatter>? formatter;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? selectDate;
  final TextInputAction? action;
  final Function(String)? onChanged;
  const StaffAccessManagementGenericInput({
    required this.title,
    required this.controller,
    this.onChanged,
    this.selectDate,
    this.formatter,
    this.validator,
    this.keyboardType,
    this.action = TextInputAction.done,
    super.key,
  });

  @override
  State<StaffAccessManagementGenericInput> createState() =>
      _ChangeOwnershipGenericInputState();
}

class _ChangeOwnershipGenericInputState
    extends State<StaffAccessManagementGenericInput> {
  final _validator = ApplicationContainer.instance().resolve<Validator>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.title}*",
          style: LelloTextStyles.bodyBold(theme),
        ),
        SizedBox(height: Dimens.spacingSmall),
        TextFormField(
          controller: widget.controller,
          textInputAction: widget.action,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.formatter,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            suffixIcon: widget.selectDate != null
                ? InkWell(
                    onTap: widget.selectDate, child: Icon(Icons.calendar_month))
                : null,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
