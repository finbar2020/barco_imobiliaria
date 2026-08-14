import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';

class PhoneFormField extends FormField<String> {
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode focusNode;
  final bool enabled;

  PhoneFormField(
      {FormFieldSetter<String>? onSaved,
      required this.focusNode,
      FormFieldValidator<String>? validator,
      String initialValue = "",
      this.enabled = true,
      this.onFieldSubmitted,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            enabled: enabled,
            initialValue: initialValue,
            builder: (FormFieldState<String> state) {
              return _buildForm(state as _PhoneFormFieldState, focusNode);
            });

  static Widget _buildForm(_PhoneFormFieldState state, FocusNode focusNode) {
    return state.buildWidget(focusNode);
  }

  @override
  FormFieldState<String> createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends FormFieldState<String> {
  final _validator = ApplicationContainer.instance().resolve<Validator>();

  String ddd = "";
  String phone = "";

  final phoneNode = FocusNode();
  var dddNode = FocusNode();

  String _getPhone() {
    String val = "";
    if (ddd.isNotEmpty) {
      val = "($ddd)";
    }
    if (phone.isNotEmpty) {
      val += phone;
    }
    return val;
  }

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  String? _initialDDD() {
    final String initial = widget.initialValue ?? "";
    if (initial.isNotEmpty) {
      if (initial.startsWith("(") && initial.length > 4)
        return initial.substring(1, 3);
      if (initial.length > 9) return initial.substring(0, 2);
    }
    return null;
  }

  String? _initialPhone() {
    final initial = widget.initialValue?.trim() ?? "";
    if (initial.isNotEmpty) {
      if (initial.startsWith("(")) {
        if (initial.length > 5) {
          return initial.substring(4).trim();
        }
      } else {
        if (initial.length > 9)
          return initial.substring(2, initial.length);
        else
          return initial;
      }
    }
    return null;
  }

  Widget buildWidget(FocusNode? node) {
    if (node != null) {
      dddNode = node;
    }
    _validator.context = context;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: TextFormField(
            validator: _validator.validateRequired,
            focusNode: dddNode,
            enabled: widget.enabled,
            initialValue: _initialDDD(),
            maxLength: 2,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              if (value.length == 2) {
                FocusScope.of(context).requestFocus(phoneNode);
              }
              ddd = value;
              didChange(_getPhone());
            },
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(phoneNode),
            onSaved: (value) => ddd = value ?? "",
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "00", counterText: ""),
          ),
        ),
        SizedBox(width: Dimens.spacing),
        Expanded(
          child: TextFormField(
            validator: _validator.validateCellPhone,
            focusNode: phoneNode,
            initialValue: _initialPhone(),
            enabled: widget.enabled,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            maxLength: 9,
            onFieldSubmitted: (value) => widget.onFieldSubmitted != null
                ? widget.onFieldSubmitted!(value)
                : () {},
            onChanged: (value) {
              if (value.length == 0) {
                FocusScope.of(context).requestFocus(dddNode);
              }
              phone = value;
              didChange(_getPhone());
            },
            onSaved: (value) => phone = value ?? '',
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "999999999",
                counterText: ""),
          ),
        )
      ],
    );
  }
}
