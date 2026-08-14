import 'dart:async';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/bloc/inactivity/inactivity_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const SPLASH_DURATION = 3000;

  late AuthenticationBloc _loginBloc;
  final InactivityCubit inactivityCubit =
      ApplicationContainer.instance().resolve<InactivityCubit>();

  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();

    _loginBloc = ApplicationContainer.instance().resolve();
    _startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: LelloTheme.palleteOf(Theme.of(context)).primary()));

    return Scaffold(
      body: Container(
        color: LelloTheme.palleteOf(Theme.of(context)).primary(),
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      "assets/ic_colaborador.svg",
                      width: 51,
                      height: 51,
                    ),
                  ),
                  SizedBox(
                    height: Dimens.spacingSmall,
                  ),
                  const Text(
                    "App para Colaboradores",
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
            ),
            Text(
              _getVersion(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                letterSpacing: 0.18,
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getVersion() {
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

  void _startTimeout() async {
    Timer(const Duration(milliseconds: SPLASH_DURATION), () async {
      await _migrationSharedToHive();
      _showNext();
    });
  }

  void _showNext() {
    if (_loginBloc.state is AuthenticatedState) {
      _checkNextStep();
      inactivityCubit.start();
    } else {
      _showLogin(bloc: _loginBloc);
    }
  }

  void _showHome() {
    Navigator.pushReplacementNamed(context, SharedApplicationRoute.home);
  }

  void _showLogin({required AuthenticationBloc bloc}) {
    Navigator.pushReplacementNamed(context, SharedApplicationRoute.login,
        arguments: AuthArguments(goToRegister: false));
  }

  void _checkNextStep() async {
    //TODO: Retornar apos dialog de notificaçao finalizado
    // bool checkPermission = await requestPersmission();
    // if (checkPermission == true) {
    //   _showNotification();
    // } else {
    _showHome();
    // }
  }

  void _showNotification() {
    Navigator.pushReplacementNamed(
        context, ApplicationRoute.permissionNotification);
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

  Future<void> _migrationSharedToHive() async {
    //move tablet info from shared to hive
    var sharedPreferences = await SharedPreferences.getInstance();
    var condoCode = sharedPreferences.get(SharedPreferencesKeys.condoCode);
    if (condoCode is String && condoCode.isNotEmpty == true) {
      await sharedPreferences.remove(SharedPreferencesKeys.condoCode);
      await sharedPreferences.remove(SharedPreferencesKeys.isTabletSession);
      await TabletSessionUtils.setCondoCode(condoCode);
    }
  }
}
