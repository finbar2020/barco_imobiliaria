import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_login_form_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/bloc/inactivity/inactivity_cubit.dart';

class LoginTabletLoginStepWidget extends StatefulWidget {
  final EmployeeInfo employee;
  final Function(LoginTabletSteps newStep) changeStep;
  const LoginTabletLoginStepWidget({
    Key? key,
    required this.employee,
    required this.changeStep,
  }) : super(key: key);

  @override
  State<LoginTabletLoginStepWidget> createState() =>
      _LoginTabletLoginStepWidgetState();
}

class _LoginTabletLoginStepWidgetState
    extends State<LoginTabletLoginStepWidget> {
  AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  final InactivityCubit inactivityCubit =
      ApplicationContainer.instance().resolve<InactivityCubit>();

  TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        widget.changeStep(LoginTabletSteps.employees);
        return false;
      },
      child: BlocProvider(
        create: (context) => authenticationStore.bloc,
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            bloc: authenticationStore.bloc,
            listener: (context, state) {
              if (state is AuthenticatedState) {
                _showHome();
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: IgnorePointer(
                  ignoring: state is AuthenticatingState,
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                widget.changeStep(LoginTabletSteps.employees);
                              },
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: LelloTheme.palleteOf(theme).hubText(),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                getString(
                                    context, "login_tablet_enter_password"),
                                style: LelloTextStyles.title(theme),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        LoginTabletLoginFormWidget(
                          employee: widget.employee,
                          passwordTextController: passwordTextController,
                          loginFunction: (credentials) {
                            inactivityCubit.start();
                            authenticationStore.credentials = credentials;
                            authenticationStore.authenticate();
                          },
                          errorMessage: _errorMessage(state),
                        ),
                        if (state is AuthenticatingState) loadingWidget(),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget loadingWidget() {
    ThemeData theme = Theme.of(context);
    return Column(children: [
      SizedBox(height: Dimens.spacingMedium),
      const Center(child: CircularProgressIndicator()),
      SizedBox(height: Dimens.spacing),
      Center(
        child: Text(
          getString(context, "please_wait", defaultText: "Por favor, aguarde"),
          style: LelloTextStyles.body(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).hubText(),
          ),
        ),
      ),
    ]);
  }

  String? _errorMessage(AuthenticationState state) {
    if (state is AuthenticationFailedState) {
      return FailureMessage.get(context, state.error);
    }
    return null;
  }

  void _showHome() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(SharedApplicationRoute.home, (_) => false);
  }
}
