import 'dart:async';
import 'dart:io';

import 'package:essentials/configs/flavor_config.dart';
import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';
import 'package:lello/feature/splash/domain/use_case/get_boot_data/get_boot_data.dart';
import 'package:shared_features/shared_features.dart';

class SplashViverPage extends StatefulWidget {
  @override
  _SplashViverPageState createState() => _SplashViverPageState();
}

class _SplashViverPageState extends State<SplashViverPage> {
  static const SPLASH_DURATION = 3000;

  final GetBootData _getBootData = ApplicationContainer.instance().resolve();
  final LocalAuthentication auth = LocalAuthentication();
  final AuthenticationBloc _loginBloc =
      ApplicationContainer.instance().resolve();
  final SessionBloc _sessionBloc = ApplicationContainer.instance().resolve();

  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    _getBootData().then((value) => handleBootData(value));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isHubert = FlavorConfig.isHubert;

    if (isHubert) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: LightPallete().hubertSindico(),
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: LightPallete().hubertSindico(),
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 22, right: 10.0, left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/logo_hubert.svg",
                        width: 140,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Aplicativo para Síndicos",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.18,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _getVersion(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      letterSpacing: 0.18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2F2F1),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xFFF2F2F1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Image.asset("assets/ic_splash_top.png"),
              ),
              Column(
                children: [
                  Image.asset("assets/logo_carimbeira_sindico.png"),
                  SizedBox(height: Dimens.spacingSmall),
                  Text("App para Síndicos",
                      style: LelloTextStyles.title(theme)!.copyWith(
                        color: Colors.orange,
                      )),
                  SizedBox(height: Dimens.spacingSmall),
                  Text(
                    _getVersion(),
                    style: LelloTextStyles.captionBold(theme)!
                        .copyWith(color: theme.colorScheme.shadow),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Powered by",
                          style: LelloTextStyles.captionBold(theme)!
                              .copyWith(color: theme.colorScheme.shadow)),
                      SizedBox(width: Dimens.spacingSmall),
                      SvgPicture.asset(
                        "assets/ic_splash_logo_lello.svg",
                        height: 25.0,
                        width: 25.0,
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/ic_splash_bottom.png",
                  height: 160.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getVersion() {
    if (packageInfo != null)
      return "V ${packageInfo!.version}";
    else {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          packageInfo = value;
        });
      });
      return "";
    }
  }

  Future<void> handleBootData(Try<BootData> result) async {
    if (result is Success<BootData>) {
      var data = result.get();
      _startTimeout(data.showOnBoarding ?? false);
    }
  }

  void _startTimeout(bool onBoarding) async {
    Timer(Duration(milliseconds: SPLASH_DURATION), () async {
      if (onBoarding) {
        _showOnBoarding();
      } else {
        _showNext();
      }
    });
  }

  void _showNext() {
    if (_loginBloc.state is AuthenticatedState) {
      _checkAuth();
    } else {
      _showLogin(bloc: _loginBloc);
    }
  }

  void _showOnBoarding() {
    Navigator.pushReplacementNamed(context, ApplicationRoute.onBoarding);
  }

  Future<void> _checkAuth() async {
    try {
      bool isSplashIgnoreBiometric =
          await _sessionBloc.iSsplashIgnoreBiometricActive();
      if (isSplashIgnoreBiometric) {
        _showHome();
        return;
      }

      bool isSupported = await auth.isDeviceSupported();
      if (!isSupported) {
        _showHome();
        return;
      }

      await _authenticateUser();
    } catch (e) {
      exit(0);
    }
  }

  Future<void> _authenticateUser() async {
    try {
      Iterable<AuthMessages> authMessages = <AuthMessages>[
        IOSAuthMessages(
          cancelButton: getString(context, "spash_biometric_cancel"),
          goToSettingsButton: getString(context, "spash_biometric_settings"),
          goToSettingsDescription:
              getString(context, "spash_biometric_settings_description"),
          lockOut: getString(context, "spash_biometric_lockout"),
          localizedFallbackTitle:
              getString(context, "spash_biometric_fallback"),
        ),
        AndroidAuthMessages(
          cancelButton: getString(context, "spash_biometric_cancel"),
          biometricHint: getString(context, "spash_biometric_hint"),
          biometricNotRecognized:
              getString(context, "spash_biometric_not_recognized"),
          biometricRequiredTitle:
              getString(context, "spash_biometric_required_title"),
          goToSettingsButton: getString(context, "spash_biometric_settings"),
          goToSettingsDescription:
              getString(context, "spash_biometric_settings_description"),
          signInTitle: getString(context, "spash_biometric_signin_title"),
        ),
      ];

      await auth.stopAuthentication();

      bool isAuthenticated = await auth.authenticate(
        localizedReason: getString(context, "spash_biometric"),
        authMessages: authMessages,
      );

      if (isAuthenticated) {
        _showHome();
      } else {
        exit(0);
      }
    } catch (e) {
      exit(0);
    }
  }

  void _showHome() {
    Navigator.pushReplacementNamed(context, ApplicationRoute.home);
  }

  void _showLogin({required AuthenticationBloc bloc}) {
    Navigator.pushReplacementNamed(context, ApplicationRoute.login,
        arguments: AuthArguments(goToRegister: false));
  }
}
