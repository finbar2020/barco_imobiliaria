import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/dependency/application_container.dart';

class ChangeOwnershipGenericInput extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final List<TextInputFormatter>? formatter;
  final String? Function(String?)? validator;
  final String? selectTypePerson;
  final TextInputType? keyboardType;
  final VoidCallback? selectDate;
  final VoidCallback? clear;
  final bool isRequired;
  final String? hint;
  final Color? borderColor;
  final bool? readyOnly;

  const ChangeOwnershipGenericInput({
    required this.title,
    required this.controller,
    required this.selectTypePerson,
    required this.isRequired,
    this.selectDate,
    this.formatter,
    this.validator,
    this.keyboardType,
    this.hint,
    this.borderColor,
    this.readyOnly,
    this.clear,
    super.key,
  });

  @override
  State<ChangeOwnershipGenericInput> createState() =>
      _ChangeOwnershipGenericInputState();
}

class _ChangeOwnershipGenericInputState
    extends State<ChangeOwnershipGenericInput> {
  final _validator = ApplicationContainer.instance().resolve<Validator>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    return IgnorePointer(
      ignoring: _choicePersonType(),
      child: Opacity(
        opacity: _choicePersonType() ? 0.3 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isRequired ? "${widget.title}*" : widget.title,
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            TextFormField(
              controller: widget.controller,
              textInputAction: TextInputAction.done,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.formatter,
              validator: widget.validator,
              readOnly: widget.readyOnly ?? false,
              decoration: InputDecoration(
                hintText: widget.hint,
                suffixIcon: Container(
                  width: 80,
                  child: Row(
                    children: [
                      widget.clear != null
                          ? InkWell(
                          onTap: widget.clear,
                          child: Icon(Icons.close))
                          : const SizedBox.shrink(),
                      SizedBox(width: Dimens.spacing),
                      widget.selectDate != null
                          ? InkWell(
                              onTap: widget.selectDate,
                              child: Icon(Icons.calendar_month))
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ??
                        LelloTheme.palleteOf(theme).grey().withAlpha(50),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ??
                        LelloTheme.palleteOf(theme).grey().withAlpha(50),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ??
                        LelloTheme.palleteOf(theme).grey().withAlpha(50),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _choicePersonType() {
    return widget.selectTypePerson == null;
  }
}
