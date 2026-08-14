import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/me/presentation/bloc/me_state.dart';
import 'package:lello/feature/me/presentation/controller/me_controller.dart';

class MeEditPasswordPage extends StatefulWidget {
  const MeEditPasswordPage({
    super.key,
  });

  @override
  MeEditPasswordPageState createState() => MeEditPasswordPageState();
}

class MeEditPasswordPageState extends State<MeEditPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final Validator _validator = ApplicationContainer.instance().resolve();
  final controller = ApplicationContainer.instance().resolve<MeController>();
  String? originPassword;
  String? newPassword;
  String? newPasswordConfirm;

  @override
  initState() {
    super.initState();
  }

  bool focused = false;
  bool showPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    return Scaffold(
      appBar: PrimaryAppBar(
        title: getString(context, "profile_title"),
        theme: theme,
        actions: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: Dimens.spacing),
              child: Text(
                "${controller.lastGetMeUpdateDifference}${controller.lastSwitchRolesUpdateDifference}",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: LelloTheme.palleteOf(theme).grey(), fontSize: 10),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: WillPopScope(
            onWillPop: () async {
              TextInput.finishAutofillContext(shouldSave: false);
              return true;
            },
            child: Form(
              key: _formKey,
              child: DismissKeyboard(
                child: AutofillGroup(
                  onDisposeAction: AutofillContextAction.cancel,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                          "${getString(context, "email")}/${getString(context, "cnpj")}",
                          style: LelloTextStyles.bodyBold(theme)),
                      TextFormField(
                        inputFormatters: [cpfOrCnpjFormatter()],
                        autofillHints: const [AutofillHints.username],
                        enabled: false,
                        initialValue: controller.me!.cpf,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
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
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
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
                          border: const OutlineInputBorder(),
                          hintText: getString(context, "type_password"),
                        ),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      Text(getString(context, "new_password"),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacingSmall),
                      TextFormField(
                        enableSuggestions: false,
                        autofillHints: const [AutofillHints.newPassword],
                        obscureText: !showNewPassword,
                        onChanged: (val) => setState(() {
                          newPassword = val;
                        }),
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
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
                          border: const OutlineInputBorder(),
                          hintText: getString(context, "type_password"),
                        ),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      Text(getString(context, "new_password_confirm"),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacingSmall),
                      TextFormField(
                        enableSuggestions: false,
                        autofillHints: const [AutofillHints.newPassword],
                        obscureText: !showConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
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
                          border: const OutlineInputBorder(),
                          hintText: getString(context, "type_password"),
                        ),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      Visibility(
                        visible: controller.meBloc.state
                            is MeEditPasswordFailedState,
                        child: Container(
                          padding: EdgeInsets.all(Dimens.spacing),
                          child: Text(
                              getString(context, "income_control_error"),
                              style: LelloTextStyles.error(theme),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Visibility(
                        visible: controller.meBloc.state
                            is! MeEditPasswordLoadingState,
                        replacement:
                            const Center(child: CircularProgressIndicator()),
                        child: PrimaryButton(
                            buttonColor: theme.primaryColor,
                            text: getString(context, "save"),
                            onPressed: save),
                      ),
                    ],
                  ),
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
      TextInput.finishAutofillContext(shouldSave: true);
      form.save();
      controller.beginEditSavePassword(
          password: newPassword!, originPassword: originPassword!);
    }
  }
}
