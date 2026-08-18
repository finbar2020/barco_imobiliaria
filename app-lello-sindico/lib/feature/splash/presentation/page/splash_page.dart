import 'dart:async';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';
import 'package:lello/feature/splash/domain/use_case/get_boot_data/get_boot_data.dart';
import 'package:shared_features/feature/start_security/start_security.dart';
import 'package:shared_features/shared_features.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  static const SPLASH_DURATION = 3000;

  final GetBootData _getBootData = ApplicationContainer.instance().resolve();
  final AuthenticationBloc _loginBloc =
      ApplicationContainer.instance().resolve();
  final LocalAuthentication auth = LocalAuthentication();
  final SessionBloc _sessionBloc = ApplicationContainer.instance().resolve();
  PackageInfo? packageInfo;

  bool _isAuthenticating = false;
  bool _authenticationFailed = false;
  bool _splashCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    blockedApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Quando o app volta para o foreground após ter falhado a autenticação
    if (state == AppLifecycleState.resumed &&
        _splashCompleted &&
        _authenticationFailed &&
        !_isAuthenticating) {
      setState(() {
        _authenticationFailed = true;
      });
    }
  }

  Future<void> blockedApp() async {
    Environment env = ApplicationContainer.instance().resolve<Environment>();
    bool blocked = await SecurityCheck.checkSecurity();
    if (!blocked || !env.isProduction) {
      _getBootData().then(
        (bootData) {
          AppUpdateConfig.checkNeedsUpdate(appOriginEnum: AppOriginEnum.owner)
              .then(
                  (checkNeedsUpdate) =>
                      handleBootData(bootData, checkNeedsUpdate),
                  onError: (err) => handleBootData(bootData, null));
        },
      ).onError((error, stackTrace) {
        _startTimeout(false, null);
      });
      return;
    }
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        SharedApplicationRoute.startSecurity,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: Container(
        color: LightPallete().primary(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 22, right: 10.0, left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/logo.svg",
                        width: 51,
                        height: 51,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "digital",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.18,
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: Dimens.spacingSmall,
                  // ),
                  // Text(
                  //   "Lello para Síndicos",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 27,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //     letterSpacing: 0.18,
                  //   ),
                  // ),
                ],
              ),
              Column(
                children: [
                  if (_authenticationFailed) ...[
                    PrimaryButton(
                      onPressed:
                          _isAuthenticating ? null : _retryAuthentication,
                      buttonColor: pallete.background(),
                      child: Text(
                        getString(context, "splash_auth"),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                  ],
                  Text(
                    _getVersion(),
                    style: TextStyle(
                      fontSize: 12,
                      color: LelloTheme.palleteOf(theme).customColor(),
                      letterSpacing: 0.18,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getVersion() {
    packageInfo = AppInfo.instance.packageInfo;
    if (packageInfo != null) {
      return "versão ${packageInfo!.version}";
    } else {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          packageInfo = value;
        });
      });
      return "";
    }
  }

  Future<void> handleBootData(
      Try<BootData> result, UpdateCheckResponse? checkNeedsUpdate) async {
    if (result is Success<BootData>) {
      var data = result.get();
      _startTimeout(data.showOnBoarding ?? false, checkNeedsUpdate);
    }
  }

  void _startTimeout(
      bool onBoarding, UpdateCheckResponse? checkNeedsUpdate) async {
    Timer(const Duration(milliseconds: SPLASH_DURATION), () async {
      if (checkNeedsUpdate != null &&
          checkNeedsUpdate.needsUpdate != null &&
          checkNeedsUpdate.needsUpdate != NeedsUpdate.none) {
        AppUpdateConfig.showDialogUpDate(
          context: context,
          appOriginEnum: AppOriginEnum.manager,
          criticalUpdateRequired:
              checkNeedsUpdate.needsUpdate == NeedsUpdate.mandatory,
          dismissAction: () {
            if (onBoarding) {
              _showOnBoarding();
            } else {
              _showNext();
            }
          },
          continueSplashAction: onBoarding ? _showOnBoarding : _showNext,
        );
      } else {
        if (onBoarding) {
          _showOnBoarding();
        } else {
          _showNext();
        }
      }
    });
  }

  void _showNext() {
    setState(() {
      _splashCompleted = true;
    });

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
      setState(() {
        _authenticationFailed = true;
        _isAuthenticating = false;
      });
    }
  }

  Future<void> _authenticateUser() async {
    if (_isAuthenticating) {
      return;
    }

    setState(() {
      _isAuthenticating = true;
      _authenticationFailed = false;
    });

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
        setState(() {
          _isAuthenticating = false;
        });
        _showHome();
      } else {
        setState(() {
          _authenticationFailed = true;
          _isAuthenticating = false;
        });
      }
    } catch (e) {
      setState(() {
        _authenticationFailed = true;
        _isAuthenticating = false;
      });
    }
  }

  void _retryAuthentication() {
    if (_loginBloc.state is AuthenticatedState) {
      _checkAuth();
    }
  }

  void _showHome() {
    Navigator.pushReplacementNamed(context, ApplicationRoute.home);
  }

  void _showLogin({required AuthenticationBloc bloc}) {
    Navigator.pushReplacementNamed(context, ApplicationRoute.login,
        arguments: AuthArguments(goToRegister: false));
  }

  Future<bool> requestPersmission() async {
    PermissionStatus? statuses = await Permission.notification.status;
    debugPrint("STATUS => $statuses");
    if (statuses == PermissionStatus.granted) {
      return false;
    } else {
      return true;
    }
  }
}
