import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/splash/domain/entity/boot_data.dart';
import 'package:morar/feature/splash/domain/use_case/set_boot_data/set_boot_data.dart';
import 'package:shared_features/shared_features.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  SetBootData setBootData = ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(flex: 3),
              // Título
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  getString(context, "on_boarding_title"),
                  style: LelloTextStyles.headline(theme)!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              // Descrição
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  getString(context, "on_boarding_description"),
                  style: LelloTextStyles.titleSmall(theme),
                  textAlign: TextAlign.left,
                ),
              ),
              Spacer(flex: 3),
              // Botão Me cadastrar
              PrimaryButton(
                text: getString(context, "sign_up"),
                onPressed: _register,
              ),
              SizedBox(height: Dimens.spacingMedium),
              // Link "Já tem cadastro ou senha?"
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getString(context, "already_have_account"),
                      style: LelloTextStyles.subBody(theme)!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: Dimens.spacingXSmall),
                    GestureDetector(
                      child: Text(
                        getString(context, "sign_in"),
                        style: TextStyle(
                          color: pallete.buttonSystem(),
                          decoration: TextDecoration.underline,
                          decorationColor: pallete.buttonSystem(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: _login,
                    ),
                  ],
                ),
              ),
              Spacer(flex: 2),
              // Versão
              Center(
                child: Text(
                  _getVersion(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getVersion() {
    final packageInfo = AppInfo.instance.packageInfo;
    if (packageInfo != null) {
      return "Versão ${packageInfo.version}";
    }
    return "";
  }

  void _register() async {
    await askPermission();
    Navigator.popAndPushNamed(context, SharedApplicationRoute.login,
        arguments: AuthArguments(goToRegister: true));
    _onBoardingViewed();
  }

  void _login() {
    Navigator.pushReplacementNamed(context, SharedApplicationRoute.login,
        arguments: AuthArguments(goToRegister: false));
    _onBoardingViewed();
  }

  Future<void> askPermission() async {
    await [
      Permission.camera,
      Permission.notification,
    ].request();
  }

  void _onBoardingViewed() async {
    final data = BootData()..showOnBoarding = false;
    await setBootData.call(data);
  }
}
