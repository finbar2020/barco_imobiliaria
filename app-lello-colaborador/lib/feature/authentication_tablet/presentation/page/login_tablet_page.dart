import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_bloc.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_state.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_fill_condo_code_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class LoginTabletPage extends StatefulWidget {
  const LoginTabletPage({Key? key}) : super(key: key);
  @override
  State<LoginTabletPage> createState() => _LoginTabletPageState();
}

class _LoginTabletPageState extends State<LoginTabletPage> {
  final TextEditingController condoCodeTextEditingController =
      TextEditingController();
  AuthenticationTabletBloc bloc = ApplicationContainer.instance().resolve();
  bool firstBuild = true;
  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.carimbeira;
    if (firstBuild) {
      _setUp();
    }
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: getString(context, "login"),
          theme: theme,
        ),
        body: BlocProvider(
          create: (context) => bloc,
          child:
              BlocBuilder<AuthenticationTabletBloc, AuthenticationTabletState>(
                  bloc: bloc,
                  builder: (context, state) {
                    if (state is AuthenticationTabletLoadedState) {
                      return LoginTabletLoadedWidget(
                          condominiumCodeInfo: state.condominiumCodeInfo);
                    }
                    return SingleChildScrollView(
                      child: IgnorePointer(
                        ignoring: state is AuthenticationTabletLoadingState,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LoginTabletFillCondoCodeWidget(
                              condoCodeTextEditingController:
                                  condoCodeTextEditingController,
                              signByCodeFunction: bloc.getInfoByCondoCode,
                              isFailure:
                                  state is AuthenticationTabletFailedState,
                            ),
                            if (state is AuthenticationTabletLoadingState)
                              _builLoading(context),
                          ],
                        ),
                      ),
                    );
                  }),
        ),
      ),
    );
  }

  Column _builLoading(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: Dimens.spacingMedium),
        const Center(child: CircularProgressIndicator()),
        SizedBox(height: Dimens.spacing),
        Text(
          getString(context, "please_wait", defaultText: "Por favor, aguarde"),
          style: LelloTextStyles.body(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).hubText(),
          ),
        ),
      ],
    );
  }

  void _setUp() {
    firstBuild = false;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      bloc.getInfoByCondoCode(args);
      setState(() {
        condoCodeTextEditingController.text = args;
      });
    }
  }
}
