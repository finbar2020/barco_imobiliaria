import 'package:colaborador/core/background/sync_digital_points_worker.dart';
import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/bloc/inactivity/inactivity_state.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/core/widgets/permission_notification_page.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/page/login_tablet_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_detector_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_register_error_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_register_success_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_request_error_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_request_success_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/location_timeout_error_page.dart';
import 'package:colaborador/feature/documents/presentation/benefits/page/benefits_page.dart';
import 'package:colaborador/feature/documents/presentation/document_file/page/document_file_page.dart';
import 'package:colaborador/feature/documents/presentation/income_report/page/income_report_page.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/page/pay_stub_page.dart';
import 'package:colaborador/feature/documents/presentation/vacation/page/vacation_page.dart';
import 'package:colaborador/feature/employee_referral/presentation/pages/employee_referral_error_page.dart';
import 'package:colaborador/feature/employee_referral/presentation/pages/employee_referral_page.dart';
import 'package:colaborador/feature/employee_referral/presentation/pages/employee_referral_success_page.dart';
import 'package:colaborador/feature/home/presentation/page/comfort_route_wrapper_page.dart';
import 'package:colaborador/feature/home/presentation/page/home_navigation_page.dart';
import 'package:colaborador/feature/home_cards_preferences/pages/preferences_home_cards_page.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/page/manual_timesheet_page.dart';
import 'package:colaborador/feature/me/presentation/pages/me_edit_success.dart';
import 'package:colaborador/feature/me/presentation/pages/me_page.dart';
import 'package:colaborador/feature/preferences/presentation/pages/notifications_preferences.dart';
import 'package:colaborador/feature/proof/presentation/page/proof_page.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/sick_note/presentation/page/sick_note_page.dart';
import 'package:colaborador/feature/sick_note/presentation/page/sick_note_register_error_page.dart';
import 'package:colaborador/feature/sick_note/presentation/page/sick_note_register_success_page.dart';
import 'package:colaborador/feature/splash/presentation/page/splash_page.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/page/timesheet_detail_page.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/page/timesheet_info_page.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/page/timesheet_page.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/observers/route_stack_observer.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/access_settings_permission_denied/presentation/page/access_settings_permission_denied_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_my_requests_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_rate_request_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_rating_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/pages/comfort_partner_reviews_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_my_favorites/comfort_disfavor_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_my_favorites/comfort_my_favorites_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_partner_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_review_sent_success_page.dart';
import 'package:shared_features/feature/gdp/employee/presentation/page/employee_list_page.dart';
import 'package:shared_features/feature/gdp/employee/presentation/page/employee_page.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/page/payroll_detail_page.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/page/payroll_entry_list_page.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/page/payroll_page.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/page/payslip_employees_page.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/page/payslip_month_page.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/page/payslip_selection_page.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/page/schedule_vacation_page.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/page/schedule_vacation_suceeded_page.dart';
import 'package:shared_features/feature/gdp/presentation/page/gdp_main_page.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/page/quick_fix_page.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/page/quick_fix_report_page.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_list.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_menu.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_not_allowed_warning.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_request_success.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_sign_success.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_signatures.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_details_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_failure_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/schedule_vacation_summary_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/vacation_employees_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/vacation_page.dart';
import 'package:shared_features/shared_features.dart';

import 'core/widgets/inactivity_bloc_builder_widget.dart';
import 'feature/manual_timesheet/presentation/page/manual_timesheet_register_error_page.dart';
import 'feature/manual_timesheet/presentation/page/manual_timesheet_register_success_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LelloApp extends StatefulWidget {
  const LelloApp({Key? key}) : super(key: key);

  static Map<String, Widget Function(BuildContext)> routes = {
    // Shared Routes
    SharedApplicationRoute.login: (BuildContext context) => LoginPage(
        appContainer: ApplicationContainer.instance(),
        appOriginEnum: AppOriginEnum.employee),
    SharedApplicationRoute.loginTablet: (BuildContext context) =>
        const LoginTabletPage(),
    SharedApplicationRoute.registration: (BuildContext context) =>
        RegistrationPage(
          appOriginEnum: AppOriginEnum.employee,
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
        ),
    SharedApplicationRoute.registrationSuccess: (BuildContext context) =>
        RegistrationSucceedPage(),
    SharedApplicationRoute.registrationWarning: (BuildContext context) =>
        RegistrationLelloUserWarningPage(
          appContainer: ApplicationContainer.instance(),
          appOriginEnum: AppOriginEnum.employee,
        ),
    SharedApplicationRoute.registrationFailure: (BuildContext context) =>
        RegistrationFailurePage(),
    SharedApplicationRoute.registrationNoDataFailure: (BuildContext context) =>
        const RegistrationLelloUserNoDataPage(
          appOriginEnum: AppOriginEnum.employee,
        ),
    SharedApplicationRoute.resetPassword: (BuildContext context) =>
        ResetPasswordPage(appOriginEnum: AppOriginEnum.employee),
    SharedApplicationRoute.resetPasswordWarning: (BuildContext context) =>
        ResetPasswordWarningPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.resetPasswordSuccess: (BuildContext context) =>
        ResetPasswordSuccessPage(),
    SharedApplicationRoute.home: (BuildContext context) =>
        const HomeNavigationPage(),
    SharedApplicationRoute.accessSettingsPermissionDenied:
        (BuildContext context) => const AcessSettingsPermissionDeniedPage(),
    SharedApplicationRoute.splash: (BuildContext context) => const SplashPage(),
    SharedApplicationRoute.expiredSession: (BuildContext context) =>
        ExpiredSessionPage(
          appContainer: ApplicationContainer.instance(),
          appOriginEnum: AppOriginEnum.employee,
        ),
    SharedApplicationRoute.comfort: (BuildContext context) => ComfortPage(
        appContainer: ApplicationContainer.instance(),
        appOriginEnum: AppOriginEnum.employee),
    SharedApplicationRoute.comfortPartner: (BuildContext context) =>
        const ComfortPartnerPage(),
    SharedApplicationRoute.comfortMyFavorites: (BuildContext context) =>
        ComfortMyFavoritesPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.comfortMyRequests: (BuildContext context) =>
        ComfortMyRequestsPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.comfortRateRequest: (BuildContext context) =>
        ComfortRateRequestPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.comfortReviewSentSuccess: (BuildContext context) =>
        const ComfortReviewSentSuccessPage(),
    SharedApplicationRoute.comfortDisfavorSuccess: (BuildContext context) =>
        const ComfortDisfavorSuccessPage(),
    SharedApplicationRoute.comfortSuccessRateRequest: (BuildContext context) =>
        const ComfortRatingSuccessPage(),
    SharedApplicationRoute.comfortPartnerReviews: (BuildContext context) =>
        ComfortPartnerReviewsPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdp: (BuildContext context) => GdpMainPage(
        appContainer: ApplicationContainer.instance(),
        appOriginEnum: AppOriginEnum.employee),
    SharedApplicationRoute.gdpEmployeeList: (BuildContext context) =>
        EmployeeListPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpEmployee: (BuildContext context) => EmployeePage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpPayslipMonth: (BuildContext context) =>
        PayslipMonthPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpPayslipEmployees: (BuildContext context) =>
        PayslipEmployeesPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpPayslipSelection: (BuildContext context) =>
        PayslipSelectionPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpVacationEmployees: (BuildContext context) =>
        VacationEmployeesPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpVacation: (BuildContext context) =>
        GDPVacationPage(appContainer: ApplicationContainer.instance()),
    SharedApplicationRoute.gdpScheduleVacation: (BuildContext context) =>
        ScheduleVacationPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpScheduleVacationSucceeded:
        (BuildContext context) => ScheduleVacationSucceededPage(),
    SharedApplicationRoute.gdpScheduleVacationFailure: (BuildContext context) =>
        ScheduleVacationFailurePage(),
    SharedApplicationRoute.gdpVacationSummary: (BuildContext context) =>
        ScheduleVacationSummaryPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpVacationDetails: (BuildContext context) =>
        ScheduleVacationDetailsPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpQuickFix: (BuildContext context) => QuickFixPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpQuickFixReport: (BuildContext context) =>
        QuickFixReportPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpTimesheetMenu: (BuildContext context) =>
        TimesheetMenuPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpTimesheetWarning: (BuildContext context) =>
        TimesheetNotAllowedWarning(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpTimesheetList: (BuildContext context) =>
        TimesheetListPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpTimesheetSign: (BuildContext context) =>
        TimesheetSignaturesPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdpTimesheetSignSuccess: (BuildContext context) =>
        TimesheetSignSuccessSuccess(),
    SharedApplicationRoute.gdpTimesheetRequestSuccess: (BuildContext context) =>
        TimesheetRequestSuccess(),
    SharedApplicationRoute.gdppayroll: (BuildContext context) => PayrollPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.gdppayrollDetail: (BuildContext context) =>
        PayrollDetailPage(),
    SharedApplicationRoute.gdppayrollEntry: (BuildContext context) =>
        PayrollEntryListPage(
          appContainer: ApplicationContainer.instance(),
        ),

    // App Colaborador Routes
    ApplicationRoute.comfortEmbedded: (BuildContext context) =>
        const ComfortRouteWrapperPage(),
    ApplicationRoute.me: (BuildContext context) => const MePage(),
    ApplicationRoute.meSuccess: (BuildContext context) =>
        const MeEditSuccessPage(),
    ApplicationRoute.faceDetectionView: (BuildContext context) =>
        const FaceDetectorPage(),
    ApplicationRoute.faceRegisterSuccess: (BuildContext context) =>
        const FaceRegisterSuccessPage(),
    ApplicationRoute.faceRegisterError: (BuildContext context) =>
        const FaceRegisterErrorPage(),
    ApplicationRoute.faceRequestSuccess: (BuildContext context) =>
        const FaceRequestSuccessPage(),
    ApplicationRoute.faceRequestError: (BuildContext context) =>
        const FaceRequestErrorPage(),
    ApplicationRoute.faceLocationTimeoutError: (BuildContext context) =>
        const LocationTimeoutErrorPage(),
    ApplicationRoute.sickNote: (BuildContext context) => const SickNotePage(),
    ApplicationRoute.sickNoteRegisterSuccess: (BuildContext context) =>
        const SickNoteRegisterSuccessPage(),
    ApplicationRoute.sickNoteRegisterError: (BuildContext context) =>
        const SickNoteRegisterErrorPage(),
    ApplicationRoute.timesheet: (BuildContext context) => const TimesheetPage(),
    ApplicationRoute.timesheetDetail: (BuildContext context) =>
        const TimesheetDetailPage(),
    ApplicationRoute.timesheetInfo: (BuildContext context) =>
        const TimesheetInfoPage(),
    ApplicationRoute.proof: (BuildContext context) => const ProofPage(),
    ApplicationRoute.incomeReportList: (BuildContext context) =>
        const IncomeReportPage(),
    ApplicationRoute.payStubList: (BuildContext context) => const PayStubPage(),
    ApplicationRoute.benefitsList: (BuildContext context) =>
        const BenefitsPage(),
    ApplicationRoute.vacationList: (BuildContext context) =>
        const VacationPage(),
    ApplicationRoute.documentFilePage: (BuildContext context) =>
        const DocumentFilePage(),
    ApplicationRoute.manualTimesheet: (BuildContext context) =>
        const ManualTimeSheetPage(),
    ApplicationRoute.manualTimesheetRegisterSuccess: (BuildContext context) =>
        const ManualTimeSheetRegisterSuccessPage(),
    ApplicationRoute.manualTimesheetRegisterError: (BuildContext context) =>
        const ManualTimeSheetRegisterErrorPage(),
    ApplicationRoute.employeeReferral: (BuildContext context) =>
        const EmployeeReferralPage(),
    ApplicationRoute.employeeReferralRegisterSuccess: (BuildContext context) =>
        const EmployeeReferralSuccessPage(),
    ApplicationRoute.employeeReferralRegisterError: (BuildContext context) =>
        const EmployeeReferralErrorPage(),
    ApplicationRoute.permissionNotification: (BuildContext context) =>
        const PermissionNotificationPage(),
    ApplicationRoute.preferencesNotification: (BuildContext context) =>
        const PreferencesNotificationPage(),
    ApplicationRoute.preferencesHome: (BuildContext context) =>
        PreferencesHomeCardsPage(),
  };

  @override
  State<LelloApp> createState() => _LelloAppState();
}

class _LelloAppState extends State<LelloApp> with WidgetsBindingObserver {
  final InactivityCubit _inactivityCubit =
      ApplicationContainer.instance().resolve();

  final syncPointsWorker =
      ApplicationContainer.instance().resolve<SyncDigitalPointsWorker>();

  @override
  void initState() {
    syncPointsWorker.schedule();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (_inactivityCubit.isActive()) {
        _inactivityCubit.reset();
      } else {
        // Handle timeout.
      }
    } else if (state == AppLifecycleState.detached) {
      var isTabletSession =
          await TabletSessionUtils.getIsTabletSession(AppOriginEnum.employee);
      if (isTabletSession == true) {
        _inactivityCubit.cancel();
        ApplicationContainer.instance()
            .resolve<SessionBloc>()
            .logoutPipeline()
            .then((value) => navigatorKey.currentState!.pushReplacementNamed(
                  SharedApplicationRoute.login,
                ));
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionBloc>(
          create: (context) =>
              ApplicationContainer.instance().resolve<SessionBloc>(),
        ),
      ],
      child: Listener(
        onPointerDown: (_) =>
            _inactivityCubit.isActive() ? _inactivityCubit.reset() : null,
        child: BlocListener<InactivityCubit, InactivityState>(
          bloc: _inactivityCubit,
          listener: (context, state) async {
            if (state.runtimeType == TimeoutExpiredState) {
              await ApplicationContainer.instance()
                  .resolve<SessionBloc>()
                  .logoutPipeline();

              // ignore: use_build_context_synchronously
              await navigatorKey.currentState!.pushReplacementNamed(
                SharedApplicationRoute.login,
              );
            }
          },
          child: MaterialApp(
            navigatorObservers: [
              RouteStackObserver(),
            ],
            builder: (context, child) {
              return Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (context) {
                      return Scaffold(
                        body: Stack(
                          children: [
                            child!,
                            InactivityBlocBuilder(
                              inactivityCubit: _inactivityCubit,
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              );
            },
            debugShowCheckedModeBanner: false,
            title: 'Colaborador',
            theme: LelloTheme.carimbeira,
            navigatorKey: navigatorKey,
            themeMode: ThemeMode.light,
            routes: LelloApp.routes,
            initialRoute: SharedApplicationRoute.splash,
            localizationsDelegates: const [
              AppLocalization.delegate,
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
              //final result = supportedLocales.first;
              final result = supportedLocales.firstWhere(
                  (element) =>
                      (element.countryCode == locale!.countryCode &&
                          element.languageCode == locale.languageCode) ||
                      (locale.countryCode == null &&
                          element.languageCode == locale.languageCode),
                  orElse: () => supportedLocales.first);

              Intl.defaultLocale =
                  '${result.languageCode}_${result.countryCode}';
              return result;
            },
          ),
        ),
      ),
    );
  }
}
