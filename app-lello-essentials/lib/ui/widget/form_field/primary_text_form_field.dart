// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField PrimaryTextFormField(
    {Key? key,
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
    TextEditingController? controller,
    String? labelText,
    Function()? onTap}) {
  return TextFormField(
    key: key,
    focusNode: focusNode,
    enabled: enabled,
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
    decoration: InputDecoration(
        counterText: "",
        labelText: labelText,
        border: OutlineInputBorder(),
        hintText: hint ?? ""),
    onTap: onTap,
  );
}
