import 'package:colaborador/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

class LoginTabletLoginFormWidget extends StatefulWidget {
  final EmployeeInfo employee;
  final TextEditingController passwordTextController;
  final Function(Credentials credentials) loginFunction;
  final String? errorMessage;
  const LoginTabletLoginFormWidget({
    Key? key,
    required this.employee,
    required this.passwordTextController,
    required this.loginFunction,
    this.errorMessage,
  }) : super(key: key);

  @override
  State<LoginTabletLoginFormWidget> createState() =>
      _LoginTabletLoginFormWidgetState();
}

class _LoginTabletLoginFormWidgetState
    extends State<LoginTabletLoginFormWidget> {
  bool _isObscure = true;
  final passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.spacingLarge),
        Card(
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10000.0),
                      child: CustomCachedNetworkImage(
                        link: widget.employee.pictureLink,
                        errorImageAssetsPath: "assets/user_placeholder.svg",
                        isAnonymous: true,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Dimens.spacing),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getString(context, "login_tablet_sign_name"),
                              style: LelloTextStyles.bodyBold(theme)?.copyWith(
                                color: LelloTheme.palleteOf(theme).hubText(),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.employee.nameFormatted,
                              style: LelloTextStyles.body(theme)?.copyWith(
                                color: LelloTheme.palleteOf(theme).hubText(),
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Dimens.spacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getString(context, "login_tablet_sign_cpf"),
                              style: LelloTextStyles.bodyBold(theme)?.copyWith(
                                color: LelloTheme.palleteOf(theme).hubText(),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.employee.cpfFormatted,
                              style: LelloTextStyles.body(theme)?.copyWith(
                                color: LelloTheme.palleteOf(theme).hubText(),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: Dimens.spacingLarge),
        Text(
          getString(context, "password"),
          style: LelloTextStyles.subtitleBold(theme),
        ),
        SizedBox(height: Dimens.spacing),
        _buildPasswordInput(),
        if (widget.errorMessage != null)
          Text(
            widget.errorMessage!,
            style: LelloTextStyles.error(theme),
            textAlign: TextAlign.center,
          ),
        SizedBox(height: Dimens.spacing),
        TertiaryButton(
          text: getString(context, "forgot_password"),
          onPressed: () => _forgotPassword(),
        ),
        SizedBox(height: Dimens.spacingXLarge),
        PrimaryButton(
          text: getString(context, "login_tablet_sign_sign"),
          onPressed: () {
            _requestLogin();
          },
        ),
      ],
    );
  }

  void _requestLogin() {
    FocusScope.of(context).requestFocus(FocusNode()); //dismiss keyboard
    widget.loginFunction(
      Credentials(
        username: widget.employee.cpf,
        password: widget.passwordTextController.text,
      ),
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      obscureText: _isObscure,
      controller: widget.passwordTextController,
      focusNode: passwordNode,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: getString(context, "type_password"),
        suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }),
      ),
    );
  }

  void _forgotPassword() {
    Navigator.pushNamed(context, SharedApplicationRoute.resetPassword,
        arguments: ApplicationContainer.instance());
  }
}
