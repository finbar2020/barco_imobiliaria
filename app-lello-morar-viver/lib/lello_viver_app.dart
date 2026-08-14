import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/home/presentation/page/home_navigation_page.dart';
import 'package:morar/feature/me/presentation/pages/me_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/lello_app.dart';
import 'package:morar_viver/feature/onboarding/presentation/page/onboarding_viver_page.dart';
import 'package:morar_viver/feature/splash/presentation/page/splash_page.dart';
import 'package:shared_features/shared_features.dart';
import 'package:morar/generated/l10n.dart';

class LelloViverApp extends StatefulWidget {
  static Map<String, WidgetBuilder> routes =
      _createCutomRoutes(LelloApp.routes);

  @override
  State<LelloViverApp> createState() => _LelloViverAppState();

  // ignore: library_private_types_in_public_api
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
        SharedApplicationRoute.home,
        (value) => (BuildContext context) => HomeNavigationPage(
              isGeneric: true,
              changeTheme: change,
              talkToLelloWhatsAppNumber:
                FlavorConfig.config.supportMoradorWhatsAppNumber,
            ));

    //update me
    customRoutes.update(
        ApplicationRoute.me,
        (value) => (BuildContext context) =>
            MePage(isGeneric: true, changeTheme: change));

    //update registration with BrandConfiguration
    customRoutes.update(
        SharedApplicationRoute.registration,
        (value) => (BuildContext context) {
              return RegistrationPage(
                appOriginEnum: AppOriginEnum.owner,
                appContainer: ApplicationContainer.instance(),
                customTermsModal: (BuildContext modalContext) async {
                  await showDialog(
                    context: modalContext,
                    builder: (dialogContext) => RegistrationUseTermsDialog(
                      customTermsUrl: FlavorConfig.isHubert
                          ? FlavorConfig.config.termsOfServiceUrl
                          : null,
                      useViewButton: FlavorConfig.isHubert,
                    ),
                  );
                },
              );
            });

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
        title: 'App para Moradores',
        theme: _theme,
        themeMode: ThemeMode.light,
        darkTheme: LelloTheme.dark,
        routes: LelloViverApp.routes,
        initialRoute: ApplicationRoute.splash,
        localizationsDelegates: const [
          AppLocalization.delegate,
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
          Locale('en', 'BR'),
          Locale('en', 'US'),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
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
