import 'dart:async';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/splash/domain/entity/boot_data.dart';
import 'package:morar/feature/splash/domain/use_case/get_boot_data/get_boot_data.dart';
import 'package:shared_features/feature/start_security/start_security.dart';
import 'package:shared_features/shared_features.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  static const SPLASH_DURATION = 3000;

  final GetBootData _getBootData = ApplicationContainer.instance().resolve();
  final LocalAuthentication auth = LocalAuthentication();
  late AuthenticationBloc _loginBloc;
  late SessionBloc _sessionBloc;
  PackageInfo? packageInfo;

  UpdateCheckResponse? checkNeedsUpdate;
  bool _isAuthenticating = false;
  bool _authenticationFailed = false;
  bool _splashCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loginBloc = ApplicationContainer.instance().resolve();
    _sessionBloc = ApplicationContainer.instance().resolve();
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
        backgroundColor: pallete.primary(),
        elevation: 0,
      ),
      body: Container(
        color: pallete.primary(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 22, right: 10.0, left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Column(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      "assets/logo.svg",
                      width: 51,
                      height: 51,
                    ),
                  ),
                  SizedBox(
                    height: Dimens.spacingSmall,
                  ),
                  Text(
                    "Lello para Moradores",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: LelloTheme.palleteOf(theme).customColor(),
                      letterSpacing: 0.18,
                    ),
                  ),
                  SizedBox(
                    height: Dimens.spacingXSmall,
                  ),
                  Text(
                    getString(context, "splash_subtitle"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: LelloTheme.palleteOf(theme).customColor(),
                      letterSpacing: 0.15,
                    ),
                  ),
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
                        style: TextStyle(
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
      _startTimeout(data.showOnBoarding!, checkNeedsUpdate);
    }
  }

  void _startTimeout(
      bool onBoarding, UpdateCheckResponse? checkNeedsUpdate) async {
    Timer(Duration(milliseconds: SPLASH_DURATION), () async {
      if (checkNeedsUpdate != null &&
          checkNeedsUpdate.needsUpdate != null &&
          checkNeedsUpdate.needsUpdate != NeedsUpdate.none) {
        AppUpdateConfig.showDialogUpDate(
          context: context,
          appOriginEnum: AppOriginEnum.owner,
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
      _checkAuth(_loginBloc.state as AuthenticatedState);
    } else {
      _showLogin();
    }
  }

  void _showOnBoarding() {
    Navigator.pushReplacementNamed(context, ApplicationRoute.onBoarding);
  }

  Future<void> _checkAuth(AuthenticatedState state) async {
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

    // Garantir que o app está em foreground antes de autenticar
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    if (lifecycleState != null && lifecycleState != AppLifecycleState.resumed) {
      // Aguardar o app estar em foreground
      await Future.delayed(Duration(milliseconds: 100));

      // Verificar novamente
      final newState = WidgetsBinding.instance.lifecycleState;
      if (newState != null && newState != AppLifecycleState.resumed) {
        setState(() {
          _authenticationFailed = true;
          _isAuthenticating = false;
        });
        return;
      }
    }

    setState(() {
      _isAuthenticating = true;
      _authenticationFailed = false;
    });

    try {
      Iterable<AuthMessages> authMessages = <AuthMessages>[
        IOSAuthMessages(
          cancelButton: getString(context, "spash_biometric_cancel"),
          localizedFallbackTitle:
              getString(context, "spash_biometric_fallback"),
        ),
        AndroidAuthMessages(
          cancelButton: getString(context, "spash_biometric_cancel"),
          signInHint: getString(context, "spash_biometric_hint"),
          signInTitle: getString(context, "spash_biometric_signin_title"),
        ),
      ];

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
    // Garantir que o app está em foreground antes de tentar autenticar novamente
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    if (lifecycleState != null && lifecycleState != AppLifecycleState.resumed) {
      return;
    }

    if (_loginBloc.state is AuthenticatedState) {
      _checkAuth(_loginBloc.state as AuthenticatedState);
    }
  }

  void _showHome() {
    Navigator.pushReplacementNamed(context, SharedApplicationRoute.home);
  }

  void _showLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, SharedApplicationRoute.login,
          arguments: AuthArguments(goToRegister: false));
    }
  }
}
