// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField PrimaryAmountFormField({
  Key? key,
  FocusNode? focusNode,
  String? Function(String?)? validator,
  TextInputFormatter? formatter,
  TextInputType? textInputType,
  ValueChanged<String>? onFieldSubmitted,
  FormFieldSetter<String>? onSaved,
  TextInputAction action = TextInputAction.next,
  String? hint,
  ValueChanged<String>? onChanged,
  String? initialValue,
  bool enabled = true,
  int? maxLength,
  bool autoValidate = false,
  double? fontSize,
  TextEditingController? controller,
  TextAlign textAlign = TextAlign.start,
}) {
  return TextFormField(
    key: key,
    focusNode: focusNode,
    enabled: enabled,
    style: TextStyle(
      fontSize: fontSize,
    ),
    initialValue: initialValue,
    inputFormatters: formatter != null ? [formatter] : [],
    validator: validator,
    keyboardType: textInputType,
    onChanged: onChanged,
    maxLength: maxLength,
    onFieldSubmitted: onFieldSubmitted,
    onSaved: onSaved,
    maxLines: textInputType == TextInputType.multiline ? 5 : 1,
    textInputAction: action,
    controller: controller,
    textAlign: textAlign,
    decoration: InputDecoration(
      counterText: "",
      border: InputBorder.none,
      hintText: hint ?? "",
      hintStyle: TextStyle(fontSize: fontSize),
    ),
  );
}
