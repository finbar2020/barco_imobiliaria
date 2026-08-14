import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart' hide Switch;

class ChangeEmailWidget extends StatefulWidget {
  const ChangeEmailWidget({
    required this.email,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final String email;
  final ValueChanged<String> onChanged;

  @override
  State<ChangeEmailWidget> createState() => _ChangeEmailWidgetState();
}

class _ChangeEmailWidgetState extends State<ChangeEmailWidget> {
  late final TextEditingController _controller;
  bool _usePersonalEmail = false;
  late final FocusNode _focusNode;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                getString(context, 'add_another_email'),
                style: LelloTextStyles.subtitleBold(theme),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, 'fill_the_fields_email'),
                style: LelloTextStyles.subtitle(theme),
              ),
              SizedBox(height: Dimens.spacing),
              Row(
                children: [
                  Switch(
                    value: _usePersonalEmail,
                    onChanged: (value) {
                      setState(() {
                        _usePersonalEmail = value;
                        _controller.text = value ? widget.email : '';
                      });
                      if (_controller.text.isNotEmpty)
                        _formKey.currentState?.validate();
                    },
                  ),
                  SizedBox(width: Dimens.spacing),
                  Text(
                    getString(context, 'user_personal_email'),
                    style: LelloTextStyles.bodyBold(theme),
                  )
                ],
              ),
              SizedBox(height: Dimens.spacingMedium),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  enabled: !_usePersonalEmail,
                  focusNode: _focusNode,
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value?.isEmpty == true || value?.isEmail == false) {
                      return getString(context, 'validation_invalid_email');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText:
                        '${getString(context, 'preferences_zero_paper_digital')} *',
                    labelStyle: LelloTextStyles.bodyBold(theme),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: LelloTextStyles.bodyBold(theme),
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    hintText:
                        getString(context, 'preferences_zero_paper_digital'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              PrimaryButton(
                onPressed: _controller.text.isEmpty
                    ? null
                    : () {
                        if (_formKey.currentState?.validate() == true) {
                          widget.onChanged(_controller.text);
                          Navigator.pop(context);
                        }
                      },
                text: getString(context, 'conclude'),
                buttonColor: LelloTheme.palleteOf(theme).buttonSystem(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
