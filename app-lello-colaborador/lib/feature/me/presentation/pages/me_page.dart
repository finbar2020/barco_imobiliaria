import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:colaborador/feature/me/presentation/pages/me_delete_account_error.dart';
import 'package:colaborador/feature/me/presentation/pages/me_delete_account_success.dart';
import 'package:colaborador/feature/me/presentation/pages/me_edit_success.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_edit.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_edit_password.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_edit_phone.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_last_update_info.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_widget.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_features/shared_features.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final MeBloc bloc = ApplicationContainer.instance().resolve();
  final AuthenticationBloc authenticationBloc =
      ApplicationContainer.instance().resolve();
  var didSetup = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener(
      bloc: authenticationBloc,
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          Navigator.pushNamedAndRemoveUntil(
              context, SharedApplicationRoute.login, (route) => false,
              arguments: AuthArguments(
                goToRegister: false,
              ));
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          if (bloc.state is MeEditState || bloc.state is MeEditPasswordState) {
            bloc.revertEdit();
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
              actions: [MeLastUpdateInfo(meBloc: bloc)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer(
          bloc: bloc,
          listener: (context, state) {
            if (state is MeEditPhoneChangedState &&
                state is! MeEditRequestingCodeState &&
                state is! MeEditRequestCodeFailedState) {
              var currentState = state;
              Modal.showBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: MeEditPhoneInfo(
                          bloc: bloc,
                          isEmailCheck: currentState.isEmail,
                          isPhoneCheck: currentState.isPhone,
                        ),
                      ));
            }
            if (state is MeEditValidateCodeState) {
              Navigator.of(context).pop();
            }
            if (state is MeEditSucceededState) {
              TextInput.finishAutofillContext(shouldSave: true);
              Navigator.pushNamed(context, ApplicationRoute.meSuccess,
                  arguments: MeEditSuccessPageArgs(onConfirm: () {
                bloc.beginLoad(true);
              }));
            }
            if (state is MeDeleteAccountSuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeDeleteAccountSuccessPage(
                    meBloc: bloc,
                  ),
                ),
              );
            }
            if (state is MeDeleteAccountFailedState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MeDeleteAccountErrorPage(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is MeEditState) return _buildEdit(theme, state);
            if (state is MeEditPasswordState ||
                state is MeEditPasswordFailedState) {
              return _buildEditPassword(theme, state as MeEditPasswordState);
            } else {
              return _buildInfo(theme, state as MeState);
            }
          }),
    );
  }

  Widget _buildInfo(ThemeData theme, MeState state) {
    if (state is MeLoadingState) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return const MeProfileWidget();
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
            appOriginEnum: AppOriginEnum.employee,
            onSuccess: (validation) {
              bloc.beginSave(codeValidation: validation);
            },
            onRestart: () {
              bloc.resendToken();
            },
          ),
        ),
      );
    } else if (state is MeEditLoadingState) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: const Center(child: CircularProgressIndicator()),
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
      return const MeEdit();
    }
  }

  Widget _buildEditPassword(ThemeData theme, MeEditPasswordState state) {
    return const MeEditPassword();
  }
}
