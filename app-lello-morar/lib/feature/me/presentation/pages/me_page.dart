import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:morar/feature/me/presentation/pages/me_delete_account_error.dart';
import 'package:morar/feature/me/presentation/pages/me_delete_account_success.dart';
import 'package:morar/feature/me/presentation/widgets/me_edit.dart';
import 'package:morar/feature/me/presentation/widgets/me_edit_password.dart';
import 'package:morar/feature/me/presentation/widgets/me_edit_phone.dart';
import 'package:morar/feature/me/presentation/widgets/me_last_update_info.dart';
import 'package:morar/feature/me/presentation/widgets/me_page/me_profile_widget.dart';
import 'package:shared_features/shared_features.dart';

class MePageArgs {
  bool? autoEditMode = false;
  bool? emailRequired = false;
  bool? phoneRequired = false;
  bool? backAfterSave = false;
  MePageArgs(
      {this.autoEditMode,
      this.emailRequired,
      this.phoneRequired,
      this.backAfterSave});
}

class MePage extends StatefulWidget {
  final bool isGeneric;
  final Function(ThemeData)? changeTheme;
  const MePage({
    Key? key,
    this.isGeneric = false,
    this.changeTheme,
  }) : super(key: key);
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final MeController controller =
      ApplicationContainer.instance().resolve<MeController>();
  final AuthenticationBloc authenticationBloc =
      ApplicationContainer.instance().resolve();
  var didSetup = false;
  MePageArgs? arguments;

  @override
  void initState() {
    super.initState();
  }

  bool _didInitializedArgs = false;
  @override
  void didChangeDependencies() {
    if (!_didInitializedArgs) {
      arguments = ModalRoute.of(context)!.settings.arguments as MePageArgs?;
      controller.meLoad(forceUpdate: arguments?.autoEditMode == true);
    }
    _didInitializedArgs = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener(
      bloc: authenticationBloc,
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          if (widget.isGeneric) {
            widget.changeTheme?.call(LelloTheme.viverDefaultTheme);
          }
          Navigator.pushNamedAndRemoveUntil(
              context, SharedApplicationRoute.login, (route) => false,
              arguments: AuthArguments(
                goToRegister: false,
              ));
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          if (arguments?.backAfterSave == true) return true;
          if (controller.bloc.state is MeEditState ||
              controller.bloc.state is MeEditPasswordState) {
            controller.revertEdit();
            return false;
          }
          return true;
        },
        child: Theme(
          data: theme,
          child: Scaffold(
            body: _buildContent(theme),
            appBar: CustomAppBar(
              title: "profile_title",
              actions: [MeLastUpdateInfo(controller: controller)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return BlocProvider.value(
      value: controller.bloc,
      child: BlocConsumer(
          bloc: controller.bloc,
          listener: (context, state) {
            if ((state is MeEditPhoneChangedState ||
                    state is MeEditEmailChangedState) &&
                !(state is MeEditRequestingCodeState) &&
                !(state is MeEditRequestCodeFailedState)) {
              var isPhoneCheck = state is MeEditPhoneChangedState;
              var isEmailCheck = state is MeEditEmailChangedState;
              Modal.showBottomSheet(
                  context: context,
                  builder: (context) => MeEditPhoneInfo(
                      controller: controller,
                      isPhoneCheck: isPhoneCheck,
                      isEmailCheck: isEmailCheck));
            }
            if (state is MeEditValidateCodeState) {
              Navigator.of(context).pop();
            }
            if (state is MeEditSucceededState) {
              TextInput.finishAutofillContext(shouldSave: true);
              controller.meLoad(forceUpdate: true);
              arguments?.backAfterSave == true
                  ? Navigator.pushReplacementNamed(
                      context, ApplicationRoute.meSuccess)
                  : Navigator.pushNamed(context, ApplicationRoute.meSuccess);
            }
            if (state is MeDeleteAccountSuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeDeleteAccountSuccessPage(
                    controller: controller,
                  ),
                ),
              );
            }
            if (state is MeDeleteAccountFailedState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeDeleteAccountErrorPage(),
                ),
              );
            } else if (state is MeLoadedState) {
              if (arguments?.autoEditMode == true) {
                controller.setRequiredFields(
                    phone: arguments?.phoneRequired,
                    email: arguments?.emailRequired);
                arguments?.autoEditMode = false;
                controller.beginEdit();
              }
            }
          },
          builder: (context, state) {
            if (state is MeEditState) return _buildEdit(theme, state);
            if (state is MeEditPasswordState ||
                state is MeEditPasswordFailedState)
              return _buildEditPassword(theme, state as MeEditPasswordState);
            else
              return _buildInfo(theme, state as MeState);
          }),
    );
  }

  Widget _buildInfo(ThemeData theme, MeState state) {
    if (state is MeLoadingState) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SingleChildScrollView(
        child: MeProfileWidget(
      isGeneric: widget.isGeneric,
      changeTheme: widget.changeTheme,
    ));
  }

  Widget _buildEdit(ThemeData theme, MeEditState state) {
    if (state is MeEditValidateCodeState) {
      return BlocProvider(
        create: (context) =>
            ApplicationContainer.instance().resolve<CodeValidationBloc>(),
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: CodeValidationPage(
            appContainer: ApplicationContainer.instance(),
            codeRequest: state.codeRequest!,
            digits: (state.codeRequest?.token.isEmpty ?? false) ? 6 : 4,
            onSuccess: (validation) {
              controller.mapSave(codeValidation: validation);
            },
            onRestart: () {
              controller.resendToken();
            },
          ),
        ),
      );
    } else if (state is MeEditLoadingState) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (state is MeEditFailedState) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Center(
          child: Text(
            getString(context, "pendency_load_failed"),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return MeEdit(controller: controller);
    }
  }

  Widget _buildEditPassword(ThemeData theme, MeEditPasswordState state) {
    return MeEditPassword(controller: controller);
  }
}
