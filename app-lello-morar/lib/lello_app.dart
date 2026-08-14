import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/permission_notification_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_attention_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_insert_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/accountability/presentation/page/accountability_info_details_page.dart';
import 'package:morar/feature/accountability/presentation/page/accountability_info_page.dart';
import 'package:morar/feature/accountability/presentation/page/accountability_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_billet_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_choice_payment_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_day_payment_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_details_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_installment_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_recommendation_payment_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_success_page.dart';
import 'package:morar/feature/billets/presentation/pages/billets_info_page.dart';
import 'package:morar/feature/billets/presentation/pages/billets_page.dart';
import 'package:morar/feature/change_ownership/presentation/page/change_ownership_page.dart';
import 'package:morar/feature/change_ownership/presentation/page/change_ownership_resume_page.dart';
import 'package:morar/feature/digital_meeting/presentation/page/digital_meeting_page.dart';
import 'package:morar/feature/digital_meeting/presentation/page/digital_meeting_web_view_page.dart';
import 'package:morar/feature/documents/integration/documents_routing.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/pages/cnd_page.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/pages/change_address_page.dart';
import 'package:morar/feature/home/presentation/page/home_navigation_page.dart';
import 'package:morar/feature/ia_bella/presentation/page/ia_bella_page.dart';
import 'package:morar/feature/insurance/presentation/pages/insurance_page.dart';
import 'package:morar/feature/mailing/presentation/page/mailing_page.dart';
import 'package:morar/feature/me/presentation/pages/me_edit_success.dart';
import 'package:morar/feature/me/presentation/pages/me_page.dart';
import 'package:morar/feature/my_preferences/presentation/my_preferences_page.dart';
import 'package:morar/feature/my_preferences/presentation/pages/in_care/presentation/in_care_page.dart';
import 'package:morar/feature/my_preferences/presentation/pages/receiving_documents/presentation/pages/receiving_documents_page.dart';
import 'package:morar/feature/onboarding/presentation/page/on_boarding_page.dart';
import 'package:morar/feature/preferences/presentation/pages/home_cards/pages/preferences_home_cards_page.dart';
import 'package:morar/feature/preferences/presentation/pages/preferences_menu_page.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/pages/preferences_zero_paper_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_report_details_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_report_reply_failure_attachment_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_report_reply_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_report_reply_success_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_reports_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_new_report_failure_attachment_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_new_report_success_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_register_new_report_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_review_new_report_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_page.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/splash/presentation/page/splash_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/pending_requests/pending_requests_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/sub_user_page.dart';
import 'package:morar/feature/tdb/presentation/pages/tdb_page.dart';
import 'package:morar/feature/vehicles/presentation/pages/VehicleErrorPage.dart';
import 'package:morar/feature/vehicles/presentation/pages/add_vehicle_page.dart';
import 'package:morar/feature/vehicles/presentation/pages/edit_vehicle_page.dart';
import 'package:morar/feature/vehicles/presentation/pages/sucess_case_page.dart';
import 'package:morar/feature/vehicles/presentation/pages/vehicle_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_my_requests_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_rate_request_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_rating_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/pages/comfort_partner_reviews_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_my_favorites/comfort_disfavor_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_my_favorites/comfort_my_favorites_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_partner_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_review_sent_success_page.dart';
import 'package:shared_features/feature/start_security/locked_start_security_page.dart';
import 'package:shared_features/shared_features.dart';

import 'feature/easy_fix/presentation/change_address/pages/change_address_failure_page.dart';
import 'feature/easy_fix/presentation/change_address/pages/change_address_success_page.dart';
import 'feature/easy_fix/presentation/change_address/pages/update_unit_data_page.dart';
import 'feature/sub_user/presentation/pages/contacts/sub_user_contact_info_page.dart';
import 'feature/sub_user/presentation/pages/contacts/sub_user_contacts_page.dart';
import 'feature/sub_user/presentation/pages/edit/sub_user_edit_page.dart';
import 'feature/sub_user/presentation/pages/facial_biometric/sub_user_facial_biometric_error.dart';
import 'feature/sub_user/presentation/pages/facial_biometric/sub_user_facial_biometric_success.dart';
import 'feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_page.dart';
import 'feature/sub_user/presentation/pages/service/sub_user_service_off_page.dart';
import 'feature/sub_user/presentation/pages/service/sub_user_service_on_page.dart';
import 'generated/l10n.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LelloApp extends StatefulWidget {
  static Map<String, WidgetBuilder> routes = {
    SharedApplicationRoute.splash: (BuildContext context) => SplashPage(),
    SharedApplicationRoute.login: (BuildContext context) => LoginPage(
          appContainer: ApplicationContainer.instance(),
          appOriginEnum: AppOriginEnum.owner,
        ),
    ApplicationRoute.onBoarding: (BuildContext context) => OnBoardingPage(),
    SharedApplicationRoute.registration: (BuildContext context) =>
        RegistrationPage(
          appOriginEnum: AppOriginEnum.owner,
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.registrationSuccess: (BuildContext context) =>
        RegistrationSucceedPage(),
    SharedApplicationRoute.registrationWarning: (BuildContext context) =>
        RegistrationLelloUserWarningPage(
          appContainer: ApplicationContainer.instance(),
          appOriginEnum: AppOriginEnum.owner,
        ),
    SharedApplicationRoute.registrationFailure: (BuildContext context) =>
        RegistrationFailurePage(),
    SharedApplicationRoute.registrationNoDataFailure: (BuildContext context) =>
        RegistrationLelloUserNoDataPage(
          appOriginEnum: AppOriginEnum.owner,
        ),
    SharedApplicationRoute.resetPassword: (BuildContext context) =>
        ResetPasswordPage(appOriginEnum: AppOriginEnum.owner),
    SharedApplicationRoute.resetPasswordWarning: (BuildContext context) =>
        ResetPasswordWarningPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.resetPasswordSuccess: (BuildContext context) =>
        ResetPasswordSuccessPage(),
    SharedApplicationRoute.home: (BuildContext context) => HomeNavigationPage(),
    SharedApplicationRoute.expiredSession: (BuildContext context) =>
        ExpiredSessionPage(
            appContainer: ApplicationContainer.instance(),
            appOriginEnum: AppOriginEnum.owner),
    ApplicationRoute.me: (BuildContext context) => MePage(),
    ApplicationRoute.meSuccess: (BuildContext context) => MeEditSuccessPage(),
    ApplicationRoute.vehiclePage: (BuildContext context) => VehiclePage(),
    ApplicationRoute.newVehiclePage: (BuildContext context) => AddVehiclePage(),
    ApplicationRoute.editVehiclePage: (BuildContext context) =>
        EditVehiclePage(),
    ApplicationRoute.vehicleSucceeded: (BuildContext context) =>
        VehicleSucessPage(),
    ApplicationRoute.vehicleErrorPage: (BuildContext context) =>
        VehicleErrorPage(),
    ApplicationRoute.subUser: (BuildContext context) => SubUserPage(),
    ApplicationRoute.subUserPendingRequests: (BuildContext context) =>
        PendingRequestsPage(),
    ApplicationRoute.subUserContact: (BuildContext context) =>
        SubUserContactsPage(),
    ApplicationRoute.subUserConfirm: (BuildContext context) =>
        SubUserContactInfoPage(isConfirm: true),
    ApplicationRoute.subUserInvitation: (BuildContext context) =>
        SubUserSendInvitePage(),
    ApplicationRoute.subUserNewContact: (BuildContext context) =>
        SubUserContactInfoPage(),
    ApplicationRoute.subUserEdit: (BuildContext context) => SubUserEditPage(),
    ApplicationRoute.subUserServiceOn: (BuildContext context) =>
        SubUserServiceOnPage(),
    ApplicationRoute.subUserServiceOff: (BuildContext context) =>
        SubUserServiceOffPage(),
    ApplicationRoute.subUserFacialBiometricSuccess: (BuildContext context) =>
        SubUserFacialBiometricSuccessPage(),
    ApplicationRoute.subUserFacialBiometricError: (BuildContext context) =>
        SubUserFacialBiometricErrorPage(),
    ApplicationRoute.mailing: (BuildContext context) => MailingPage(),
    ApplicationRoute.billets: (BuildContext context) => BilletsPage(),
    ApplicationRoute.billetsInfo: (BuildContext context) => BilletsInfoPage(),
    ApplicationRoute.documents: (BuildContext context) =>
        buildMorarDocumentsPage(context),
    ApplicationRoute.accountability: (BuildContext context) =>
        AccountabilityPage(),
    ApplicationRoute.accountabilityInfo: (BuildContext context) =>
        AccountabilityInfoPage(),
    ApplicationRoute.accountabilityInfoDetails: (BuildContext context) =>
        AccountabilityInfoDetailsPage(),
    ApplicationRoute.reserve: (BuildContext context) => ReservationPage(),
    ApplicationRoute.digitalMeeting: (BuildContext context) =>
        DigitalMeetingPage(),
    ApplicationRoute.digitalMeetingWebView: (BuildContext context) =>
        DigitalMeetingWebViewPage(),
    ApplicationRoute.accessControl: (BuildContext context) =>
        AccessControlPage(),
    ApplicationRoute.accessControlInsert: (BuildContext context) =>
        AccessControlInsertPage(),
    ApplicationRoute.accessControlAttention: (BuildContext context) =>
        AccessControlAttentionPage(),
    ApplicationRoute.reports: (BuildContext context) => ReportsPage(),
    ApplicationRoute.myReports: (BuildContext context) => MyReportsPage(),
    ApplicationRoute.myReportDetails: (BuildContext context) =>
        MyReportDetailsPage(),
    ApplicationRoute.myReportReply: (BuildContext context) =>
        MyReportReplyPage(),
    ApplicationRoute.registerNewReport: (BuildContext context) =>
        RegisterNewReportPage(),
    ApplicationRoute.reviewNewReport: (BuildContext context) =>
        ReviewNewReportPage(),
    ApplicationRoute.newReportSuccess: (BuildContext context) =>
        NewReportSuccessPage(),
    ApplicationRoute.myReportReplySuccess: (BuildContext context) =>
        MyReportReplySuccessPage(),
    ApplicationRoute.myReportReplyFailureAttachment: (BuildContext context) =>
        MyReportReplyFailureAttachmentPage(),
    ApplicationRoute.reportNewReportFailureAttachment: (BuildContext context) =>
        ReportsNewReportFailureAttachmentPage(),
    ApplicationRoute.insurance: (BuildContext context) => InsurancePage(),
    SharedApplicationRoute.comfort: (BuildContext context) => ComfortPage(
        appContainer: ApplicationContainer.instance(),
        appOriginEnum: AppOriginEnum.owner),
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
    ApplicationRoute.agreements: (BuildContext context) => AgreementsPage(),
    ApplicationRoute.agreementsRecommendationPayment: (BuildContext context) =>
        AgreementsRecommendationPaymentPage(),
    ApplicationRoute.agreementsChoicePayment: (BuildContext context) =>
        AgreementsChoicePaymentPage(),
    ApplicationRoute.agreementDayPayment: (BuildContext context) =>
        AgreementsDayPaymentPage(),
    ApplicationRoute.agreementSuccessSend: (BuildContext context) =>
        AgreementsSuccessPage(),
    ApplicationRoute.agreementBillet: (BuildContext context) =>
        AgreementsBilletPage(),
    ApplicationRoute.agreementInstallment: (BuildContext context) =>
        AgreementsInstallmentPage(),
    ApplicationRoute.agreementDetail: (BuildContext context) =>
        AgreementsDetailsPage(),
    ApplicationRoute.tdb: (BuildContext context) => TdbPage(),
    ApplicationRoute.preferencesZeroPaper: (BuildContext context) =>
        PreferencesZeroPaperPage(),
    ApplicationRoute.preferencesHome: (BuildContext context) =>
        PreferencesHomeCardsPage(),
    ApplicationRoute.preferences: (BuildContext context) =>
        PreferencesMenuPage(),
    ApplicationRoute.permissionNotification: (BuildContext context) =>
        PermissionNotificationPage(),
    ApplicationRoute.updateUnitData: (BuildContext context) =>
        UpdateUnitDataPage(),
    ApplicationRoute.changeAddress: (BuildContext context) =>
        ChangeAddressPage(),
    ApplicationRoute.changeAddressSuccess: (BuildContext context) =>
        ChangeAddressSuccessPage(),
    ApplicationRoute.changeAddressFailure: (BuildContext context) =>
        ChangeAddressFailurePage(),
    ApplicationRoute.certificateNoOutstandingDebt: (BuildContext context) =>
        CertificateNoOutstandingDebtPage(),
    ApplicationRoute.changeOwnership: (BuildContext context) =>
        ChangeOwnership(),
    ApplicationRoute.changeOwnershipResume: (BuildContext context) =>
        ChangeOwnershipResumePage(),
    SharedApplicationRoute.startSecurity: (BuildContext context) =>
        BlockedApp(),
    ApplicationRoute.iaBella: (BuildContext context) => IABellaPage(),
    ApplicationRoute.myPreferences: (BuildContext context) =>
        MyPreferencesPage(),
    ApplicationRoute.receivingDocuments: (BuildContext context) =>
        ReceivingDocumentsPage(),
    ApplicationRoute.inCare: (BuildContext context) => InCarePage(),
  };

  @override
  State<LelloApp> createState() => _LelloAppState();
}

class _LelloAppState extends State<LelloApp> {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<SessionBloc>(
            create: (context) =>
                ApplicationContainer.instance().resolve<SessionBloc>(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'Lello para Moradores',
          theme: LelloTheme.light,
          themeMode: ThemeMode.light,
          darkTheme: LelloTheme.dark,
          routes: LelloApp.routes,
          initialRoute: SharedApplicationRoute.splash,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
            DatadogNavigationObserver(datadogSdk: DatadogSdk.instance),
          ],
          localizationsDelegates: [
            AppLocalization.delegate,
            S.delegate,
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
