import 'package:essentials/configs/brand_configuration.dart';
import 'package:essentials/configs/flavor_config.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/home/presentation/page/home_page.dart';
import 'package:lello/feature/me/presentation/page/me_page.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/lello_app.dart';
import 'package:shared_features/shared_features.dart';
import 'package:sindico_viver/feature/onboarding/presentation/page/onboarding_viver_page.dart';
import 'package:sindico_viver/feature/splash/presentation/page/splash_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LelloViverApp extends StatefulWidget {
  static var routes = _createCutomRoutes(LelloApp.routes);

  @override
  State<LelloViverApp> createState() => _LelloViverAppState();

  static _LelloViverAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_LelloViverAppState>();

  static Map<String, WidgetBuilder> _createCutomRoutes(
      Map<String, WidgetBuilder> routes) {
    var customRoutes = routes;

    //update splash
    customRoutes.update(ApplicationRoute.splash,
        (value) => (BuildContext context) => SplashViverPage());

    //update onboarding
    customRoutes.update(ApplicationRoute.onBoarding,
        (value) => (BuildContext context) => OnBoardingViverPage());

    //update home
    customRoutes.update(
        ApplicationRoute.home,
        (value) => (BuildContext context) =>
            HomePage(isGeneric: true, changeTheme: change));

    //update me
    customRoutes.update(
        ApplicationRoute.me,
        (value) => (BuildContext context) =>
            MePage(isGeneric: true, changeTheme: change));

    //update registration with custom terms modal for Hubert
    customRoutes.update(
        SharedApplicationRoute.registration,
        (value) => (BuildContext context) => RegistrationPage(
              appOriginEnum: AppOriginEnum.manager,
              appContainer: ApplicationContainer.instance(),
              customTermsModal: (BuildContext context) async {
                return showDialog(
                  context: context,
                  builder: (context) => RegistrationUseTermsDialog(
                    isGeneric: true,
                    appName: "App para Síndicos",
                    useViewButton: FlavorConfig.isHubert,
                    customTermsUrl: FlavorConfig.isHubert
                        ? FlavorConfig.config.termsOfServiceUrl
                        : null,
                  ),
                );
              },
            ));

    return customRoutes;
  }
}

Function(ThemeData)? change;

class _LelloViverAppState extends State<LelloViverApp> {
  ThemeData _theme = LelloTheme.viverDefaultTheme;
  @override
  Widget build(BuildContext context) {
    change = changeTheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionBloc>(
          create: (context) =>
              ApplicationContainer.instance().resolve<SessionBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'App para Síndicos',
        theme: _theme,
        themeMode: ThemeMode.light,
        darkTheme: LelloTheme.dark,
        routes: LelloViverApp.routes,
        initialRoute: ApplicationRoute.splash,
        localizationsDelegates: [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('pt', 'BR'),
          const Locale('en', 'BR'),
          const Locale('en', 'US'),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          //final result = supportedLocales.first;
          final result = supportedLocales.firstWhere(
              (element) =>
                  (element.countryCode == locale!.countryCode &&
                      element.languageCode == locale.languageCode) ||
                  (locale.countryCode == null &&
                      element.languageCode == locale.languageCode),
              orElse: () => supportedLocales.first);

          Intl.defaultLocale = '${result.languageCode}_${result.countryCode}';
          return result;
        },
      ),
    );
  }

  void changeTheme(ThemeData theme) {
    setState(() {
      _theme = theme;
    });
  }
}
