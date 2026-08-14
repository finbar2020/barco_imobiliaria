import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';

class MeEditPassword extends StatefulWidget {
  final MeController controller;
  MeEditPassword({required this.controller});
  @override
  _MeEditPasswordState createState() => _MeEditPasswordState();
}

class _MeEditPasswordState extends State<MeEditPassword> {
  final _formKey = GlobalKey<FormState>();
  final Validator _validator = ApplicationContainer.instance().resolve();
  String? originPassword;
  String? newPassword;
  String? newPasswordConfirm;

  initState() {
    super.initState();
  }

  var focused = false;
  var showPassword = false;
  var showNewPassword = false;
  var showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    return _buildContent(theme);
  }

  Widget _buildContent(ThemeData theme) {
    return _buildForm(theme);
  }

  Widget _buildForm(ThemeData theme) {
    return WillPopScope(
      onWillPop: () async {
        TextInput.finishAutofillContext(shouldSave: false);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: AutofillGroup(
                onDisposeAction: AutofillContextAction.cancel,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                        "${getString(context, "email")}/${getString(context, "cnpj")}",
                        style: LelloTextStyles.bodyBold(theme)),
                    TextFormField(
                      inputFormatters: [cpfOrCnpjFormatter()],
                      autofillHints: [AutofillHints.username],
                      enabled: false,
                      initialValue: widget.controller.bloc.state.me.cpf,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    Text(getString(context, "origin_password"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacingSmall),
                    TextFormField(
                      obscureText: !showPassword,
                      onChanged: (val) => setState(() {
                        originPassword = val;
                      }),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      validator: _validator.validatePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                        hintText: getString(context, "type_password"),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Text(getString(context, "new_password"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacingSmall),
                    TextFormField(
                      enableSuggestions: false,
                      autofillHints: [AutofillHints.newPassword],
                      obscureText: !showNewPassword,
                      onChanged: (val) => setState(() {
                        newPassword = val;
                      }),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      validator: _validator.validatePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            showNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              showNewPassword = !showNewPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                        hintText: getString(context, "type_password"),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Text(getString(context, "new_password_confirm"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacingSmall),
                    TextFormField(
                      enableSuggestions: false,
                      autofillHints: [AutofillHints.newPassword],
                      obscureText: !showConfirmPassword,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (val) => setState(() {
                        newPasswordConfirm = val;
                      }),
                      textInputAction: TextInputAction.done,
                      validator: _validator.validatePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                        hintText: getString(context, "type_password"),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Visibility(
                      visible: widget.controller.bloc.state
                          is MeEditPasswordFailedState,
                      child: Container(
                        padding: EdgeInsets.all(Dimens.spacing),
                        child: Text(getString(context, "income_control_error"),
                            style: LelloTextStyles.error(theme),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingLarge),
                    Visibility(
                      visible: !(widget.controller.bloc.state
                          is MeEditPasswordLoadingState),
                      child: Container(
                        width: double.infinity,
                        child: PrimaryButton(
                            text: getString(context, "save"), onPressed: save),
                      ),
                      replacement: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void save() {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;
    if (form!.validate() && newPasswordConfirm == newPassword) {
      form.save();
      widget.controller.beginEditSavePassword(newPassword!, originPassword!);
    }
  }
}
