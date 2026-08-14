import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_features/shared_features.dart';

class LoginTabletFillCondoCodeWidget extends StatefulWidget {
  final TextEditingController condoCodeTextEditingController;
  final Function(String condoCode) signByCodeFunction;
  final bool isFailure;
  const LoginTabletFillCondoCodeWidget({
    Key? key,
    required this.condoCodeTextEditingController,
    required this.signByCodeFunction,
    this.isFailure = false,
  }) : super(key: key);

  @override
  State<LoginTabletFillCondoCodeWidget> createState() =>
      _LoginTabletFillCondoCodeWidgetState();
}

class _LoginTabletFillCondoCodeWidgetState
    extends State<LoginTabletFillCondoCodeWidget> {
  final FocusNode codeInputNode = FocusNode();

  ValueNotifier<bool> buttonEnableNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    buttonEnableNotifier.value =
        widget.condoCodeTextEditingController.text.isNotEmpty;
  }

  @override
  void dispose() {
    buttonEnableNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(context, "login_tablet_condo_code_title"),
              style: LelloTextStyles.title(theme),
            ),
            SizedBox(height: Dimens.spacingLarge),
            Text(getString(context, "login_tablet_condo_code"),
                style: LelloTextStyles.bodyBold(theme)),
            SizedBox(height: Dimens.spacingSmall),
            _buildCodeInput(),
            if (widget.isFailure)
              Container(
                padding: EdgeInsets.only(top: Dimens.spacingSmall),
                child: Text(
                  getString(context, "login_tablet_invalid_code"),
                  style: LelloTextStyles.body(theme)
                      ?.copyWith(color: LelloTheme.palleteOf(theme).error()),
                ),
              ),
            InkWell(
              onTap: () {
                _backLogin(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Dimens.spacing),
                child: Text(
                    getString(context, "login_tablet_condo_code_sign_with_cpf"),
                    style: LelloTextStyles.bodyBold(theme)
                        ?.copyWith(decoration: TextDecoration.underline)),
              ),
            ),
            SizedBox(height: Dimens.spacingLarge),
            ValueListenableBuilder(
              valueListenable: buttonEnableNotifier,
              builder: (context, value, child) => PrimaryButton(
                text: getString(context, "login_tablet_sign_sign"),
                onPressed: buttonEnableNotifier.value
                    ? () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        widget.signByCodeFunction(
                            widget.condoCodeTextEditingController.text);
                      }
                    : null,
              ),
            ),
          ],
        ));
  }

  Widget _buildCodeInput() {
    return TextFormField(
      focusNode: codeInputNode,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      controller: widget.condoCodeTextEditingController,
      onChanged: (value) {
        buttonEnableNotifier.value = value.isNotEmpty;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "123456",
      ),
    );
  }

  void _backLogin(BuildContext context) async {
    var preferences = await SharedPreferences.getInstance();
    try {
      await preferences.setString(SharedPreferencesKeys.condoCode, "").then(
          (value) => Navigator.pushReplacementNamed(
              context, SharedApplicationRoute.login));
    } catch (ex) {}
  }
}
