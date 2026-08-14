import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/permission_notification_page.dart';
import 'package:lello/feature/access_management/presentation/pages/access_management_page.dart';
import 'package:lello/feature/accountability/presentation/approval/page/accountability_approval_success_page.dart';
import 'package:lello/feature/accountability/presentation/approval/page/accountability_confirmation_page.dart';
import 'package:lello/feature/accountability/presentation/detail/page/accountability_detail_page.dart';
import 'package:lello/feature/accountability/presentation/detail/page/accountability_details_grouped_entries_page.dart';
import 'package:lello/feature/accountability/presentation/detail/page/accountability_send_recommendation_error_page.dart';
import 'package:lello/feature/accountability/presentation/detail/page/accountability_send_recommendation_success_page.dart';
import 'package:lello/feature/accountability/presentation/list/page/accountability_page.dart';
import 'package:lello/feature/accountability/presentation/question_create/page/question_create_details_page.dart';
import 'package:lello/feature/accountability/presentation/question_create/page/question_create_error_page.dart';
import 'package:lello/feature/accountability/presentation/question_create/page/question_create_page.dart';
import 'package:lello/feature/accountability/presentation/question_create/page/question_create_success_page.dart';
import 'package:lello/feature/accountability/presentation/question_list/page/question_list_detail_page.dart';
import 'package:lello/feature/accountability/presentation/question_list/page/question_list_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_analysis/agreements_analysis_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_history/agreements_history_card_details_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_history/agreements_history_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_in_progress/agreements_in_progress_card_details_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_in_progress/agreements_in_progress_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_proposals/agreements_proposals_card_details_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_proposals/agreements_proposals_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_proposals/agreements_status_changed_success_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_rules/agreements_rules_page.dart';
import 'package:lello/feature/condominium/presentation/detail/page/condominium_balance_detail_page.dart';
import 'package:lello/feature/dashboard_preferences/presentation/page/notifications_preferences_page.dart';
import 'package:lello/feature/dashboard_preferences/presentation/page/notifications_preferences_suceeded_page.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_page.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_selected_page.dart';
import 'package:lello/feature/documents/integration/sindico_documents_menu_strategy.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_controller.dart';
import 'package:lello/feature/gdp/employee/presentation/page/employee_list_page.dart';
import 'package:lello/feature/gdp/employee/presentation/page/employee_page.dart';
import 'package:lello/feature/gdp/payslip/presentation/page/payslip_employees_page.dart';
import 'package:lello/feature/gdp/payslip/presentation/page/payslip_month_page.dart';
import 'package:lello/feature/gdp/payslip/presentation/page/payslip_selection_page.dart';
import 'package:lello/feature/gdp/presentation/page/gdp_main_page.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/page/quick_fix_page.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/page/quick_fix_report_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_menu_page.dart';
import 'package:lello/feature/gdp/vacation/presentation/page/schedule_vacation_details_page.dart';
import 'package:lello/feature/gdp/vacation/presentation/page/schedule_vacation_failure_page.dart';
import 'package:lello/feature/gdp/vacation/presentation/page/schedule_vacation_page.dart';
import 'package:lello/feature/gdp/vacation/presentation/page/schedule_vacation_suceeded_page.dart';
import 'package:lello/feature/gdp/vacation/presentation/page/schedule_vacation_summary_page.dart';
import 'package:lello/feature/gdp/vacation/presentation/page/vacation_employees_page.dart';
import 'package:lello/feature/gdp/vacation/presentation/page/vacation_page.dart';
import 'package:lello/feature/comfort/presentation/page/comodities_page.dart';
import 'package:lello/feature/home/presentation/page/home_page.dart';
import 'package:lello/feature/home_cards_preferences/pages/preferences_home_cards_page.dart';
import 'package:lello/feature/income/presentation/billets/detail/page/billet_detail_page.dart';
import 'package:lello/feature/income/presentation/billets/page/billets_page.dart';
import 'package:lello/feature/income/presentation/dasboard/page/income_dashboard_page.dart';
import 'package:lello/feature/income/presentation/detail/page/income_detail_page.dart';
import 'package:lello/feature/income/presentation/page/income_main_page.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/schedule_events_bloc.dart';
import 'package:lello/feature/maintenance_management/domain/entity/legal_obligation_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/home/pages/maintenance_management_filters_page.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/pages/legal_obligation_activity_history_page.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/pages/legal_obligation_page.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/task_init_step_page.dart';
import 'package:lello/feature/me/presentation/page/me_code_validation_page.dart';
import 'package:lello/feature/me/presentation/page/me_edit_failure.dart';
import 'package:lello/feature/me/presentation/page/me_edit_success.dart';
import 'package:lello/feature/me/presentation/page/me_page.dart';
import 'package:lello/feature/nonpayment/presentation/detail/page/nonpayments_detail_page.dart';
import 'package:lello/feature/nonpayment/presentation/page/nonpayments_page.dart';
import 'package:lello/feature/onboarding/presentation/page/on_boarding_page.dart';
import 'package:lello/feature/payment/presentation/approval/page/payment_approval_page.dart';
import 'package:lello/feature/payment/presentation/approval/page/payment_approval_rejected_page.dart';
import 'package:lello/feature/payment/presentation/approval/page/payment_approval_success_page.dart';
import 'package:lello/feature/payment/presentation/history_list/page/payment_history_details_page.dart';
import 'package:lello/feature/payment/presentation/history_list/page/payment_history_list_page.dart';
import 'package:lello/feature/payment/presentation/list/page/payment_list_page.dart';
import 'package:lello/feature/payment/presentation/main_page/payment_main_page.dart';
import 'package:lello/feature/payment/presentation/pendency/page/check_token/check_token_page.dart';
import 'package:lello/feature/payment/presentation/pendency/page/details/pendency_details_page.dart';
import 'package:lello/feature/payment/presentation/pendency/page/list/payment_pendency_list_page.dart';
import 'package:lello/feature/payment/presentation/pendency/page/validation_method/validation_method_page.dart';
import 'package:lello/feature/payment/presentation/register/page/payment_illegible_document_page.dart';
import 'package:lello/feature/payment/presentation/register/page/payment_processing_files_page.dart';
import 'package:lello/feature/payment/presentation/register/page/payment_review_document_page.dart';
import 'package:lello/feature/payment/presentation/register/page/payment_send_document_page.dart';
import 'package:lello/feature/payment/presentation/register/widget/payment_registration_suceeded_page.dart';
import 'package:lello/feature/payment/presentation/register/widget/payment_registration_unknown_provider_warning.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/page/payment_send_financial_department_faliure_page.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/page/payment_send_financial_department_page.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/page/payment_send_financial_department_success_page.dart';
import 'package:lello/feature/payroll/presentation/page/payroll_detail_page.dart';
import 'package:lello/feature/payroll/presentation/page/payroll_entry_list_page.dart';
import 'package:lello/feature/payroll/presentation/page/payroll_page.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_close_report_success_page.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_details_report_page.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_page.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_preview_reply_page.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_preview_report_page.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_reply_page.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_reply_success_page.dart';
import 'package:lello/feature/resin/presentation/resin_attention_page/page/resin_attention_page.dart';
import 'package:lello/feature/resin/presentation/resin_create_refund_success_error/page/resin_create_refund_success_error_page.dart';
import 'package:lello/feature/resin/presentation/resin_history_advance/page/resin_history_advance_page.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/page/resin_history_refund_page.dart';
import 'package:lello/feature/resin/presentation/resin_menu/page/resin_menu_page.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/page/resin_new_advance_page.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/page/resin_new_bank_account_page.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/page/resin_new_refund_page.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/page/resin_receipt_details_page.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/page/resin_send_receipt_page.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/space/presentation/page/space_detail_page.dart';
import 'package:lello/feature/space/presentation/page/space_list_page.dart';
import 'package:lello/feature/space/presentation/page/space_menu_page.dart';
import 'package:lello/feature/space/registration/presentation/page/space_registration_lello_page.dart';
import 'package:lello/feature/space/registration/presentation/page/space_registration_lello_success_page.dart';
import 'package:lello/feature/space/registration/presentation/page/space_registration_option_page.dart';
import 'package:lello/feature/space/registration/presentation/page/space_registration_page.dart';
import 'package:lello/feature/space/registration/presentation/page/space_registration_success_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_calendar_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_cancel_confirmation_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_control_main_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_failed_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_history_calendar_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_list_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_raffle_draw_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_raffle_draw_success_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_registration_date_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_registration_maintenance_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_registration_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_registration_raffle_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_registration_reservation_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_registration_space_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_registration_time_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_report.page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_success_page.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_calendar_history_widget.dart';
import 'package:lello/feature/splash/presentation/page/splash_page.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_management_add_page.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_management_edit_page.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_management_page.dart';
import 'package:lello/feature/unit/presentation/page/unit_detail_page.dart';
import 'package:lello/feature/unit/presentation/page/units_page.dart';
import 'package:lello/feature/vox/presentation/menu/vox_menus.dart';
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
import 'package:shared_features/feature/start_security/locked_start_security_page.dart';
import 'package:shared_features/shared_features.dart';

import 'feature/dashboard_preferences/presentation/page/notifications_preferences_failure_page.dart';
import 'package:lello/feature/maintenance_management/presentation/home/pages/maintenance_management_page.dart';
import 'package:lello/feature/maintenance_management/presentation/create_task/pages/create_task_page.dart';
import 'package:lello/feature/maintenance_management/presentation/create_task/pages/create_routine_page.dart';
import 'package:lello/feature/maintenance_management/presentation/reports_view/pages/visualize_reports_page.dart';
import 'package:lello/feature/maintenance_management/presentation/reports_view/bloc/visualize_reports_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/reports_view/bloc/dashboard_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/reports_view/bloc/dashboard_event.dart';
import 'package:lello/feature/maintenance_management/presentation/reports_view/cubit/rotine_chart_cubit.dart';
import 'package:lello/feature/maintenance_management/presentation/reports_view/cubit/ordem_servico_chart_cubit.dart';
import 'package:lello/feature/maintenance_management/presentation/reports_view/cubit/efficiency_chart_cubit.dart';
import 'package:lello/feature/maintenance_management/presentation/reports_view/cubit/categories_chart_cubit.dart';
import 'package:lello/feature/maintenance_management/presentation/reports_view/cubit/environment_equipment_chart_cubit.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/agenda_tasks_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/calendar_indicators_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/pages/agenda_page.dart';
import 'package:lello/feature/maintenance_management/domain/repository/maintenance_management_repository.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_formulary_by_month_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/create_task/pages/create_routine_detail_page.dart';
import 'package:lello/feature/maintenance_management/presentation/create_task/bloc/create_routine_bloc.dart';
import 'package:lello/feature/maintenance_management/domain/entity/procedure_options_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_details_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/create_task/enums/task_creation_type.dart';
import 'feature/maintenance_management/presentation/task/pages/task_details_page.dart';
import 'feature/maintenance_management/presentation/task/pages/task_history_page.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/pages/chat_conversations_page.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/pages/chat_messages_page.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/bloc/chat_conversations_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/bloc/chat_messages_bloc.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_channel_entity.dart';
import 'package:lello/feature/maintenance_management/data/service/websocket_service.dart';
import 'feature/me/presentation/page/me_edit_page.dart';
import 'feature/me/presentation/page/me_edit_password_page.dart';
import 'feature/payment/presentation/payment_details/payment_details_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LelloApp extends StatefulWidget {
  const LelloApp({super.key});

  // Routes precisa ser estático e acessível publicamente
  static var routes = {
    ApplicationRoute.splash: (BuildContext context) => const SplashPage(),
    ApplicationRoute.onBoarding: (BuildContext context) =>
        const OnBoardingPage(),
    SharedApplicationRoute.login: (BuildContext context) => LoginPage(
        appContainer: ApplicationContainer.instance(),
        appOriginEnum: AppOriginEnum.manager),
    SharedApplicationRoute.registration: (BuildContext context) =>
        RegistrationPage(
          appOriginEnum: AppOriginEnum.manager,
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.registrationSuccess: (BuildContext context) =>
        RegistrationSucceedPage(),
    SharedApplicationRoute.registrationWarning: (BuildContext context) =>
        RegistrationLelloUserWarningPage(
            appContainer: ApplicationContainer.instance(),
            appOriginEnum: AppOriginEnum.manager),
    SharedApplicationRoute.registrationFailure: (BuildContext context) =>
        RegistrationFailurePage(),
    SharedApplicationRoute.registrationNoDataFailure: (BuildContext context) =>
        RegistrationLelloUserNoDataPage(appOriginEnum: AppOriginEnum.manager),
    ApplicationRoute.home: (BuildContext context) => const HomePage(),
    SharedApplicationRoute.expiredSession: (BuildContext context) =>
        ExpiredSessionPage(
            appContainer: ApplicationContainer.instance(),
            appOriginEnum: AppOriginEnum.manager),
    SharedApplicationRoute.accessSettingsPermissionDenied:
        (BuildContext context) => const AcessSettingsPermissionDeniedPage(),
    ApplicationRoute.approvePaymentDetail: (BuildContext context) =>
        const PendencyDetailsPage(),
    ApplicationRoute.paymentPendencyValidateStep: (BuildContext context) =>
        const ValidationMethodPage(),
    ApplicationRoute.paymentCheckToken: (BuildContext context) =>
        const CheckTokenPage(),
    ApplicationRoute.approvePayment: (BuildContext context) =>
        const PaymentApprovalPage(),
    ApplicationRoute.approvePaymentSuccess: (BuildContext context) =>
        PaymentApprovalSuccessPage(),
    ApplicationRoute.approvePaymentRejected: (BuildContext context) =>
        const PaymentApprovalRejectedPage(),
    ApplicationRoute.resetPassword: (BuildContext context) =>
        ResetPasswordPage(appOriginEnum: AppOriginEnum.manager),
    ApplicationRoute.resetPasswordWarning: (BuildContext context) =>
        ResetPasswordWarningPage(
          appContainer: ApplicationContainer.instance(),
        ),
    ApplicationRoute.resetPasswordSuccess: (BuildContext context) =>
        ResetPasswordSuccessPage(),
    ApplicationRoute.me: (BuildContext context) => const MePage(),
    ApplicationRoute.meEdit: (BuildContext context) => const MeEditPage(),
    ApplicationRoute.meEditPassword: (BuildContext context) =>
        const MeEditPasswordPage(),
    ApplicationRoute.meCodeValidation: (BuildContext context) =>
        const MeCodeValidationPage(),
    ApplicationRoute.meSuccess: (BuildContext context) =>
        const MeEditSuccessPage(),
    ApplicationRoute.meFailure: (BuildContext context) =>
        const MeEditFailurePage(),
    ApplicationRoute.notificationsPreferences: (BuildContext context) =>
        const NotificationsPreferencesPage(),
    ApplicationRoute.notificationsPreferencesSuceeded: (BuildContext context) =>
        const NotificationsPreferencesSucceededPage(),
    ApplicationRoute.notificationsPreferencesFailure: (BuildContext context) =>
        const NotificationsPreferencesFailurePage(),
    ApplicationRoute.payment: (BuildContext context) => PaymentMainPage(),
    ApplicationRoute.paymentList: (BuildContext context) =>
        const PaymentListPage(),
    ApplicationRoute.paymentDetail: (BuildContext context) =>
        const PaymentDetailsPage(),
    ApplicationRoute.units: (BuildContext context) => const UnitsPage(),
    ApplicationRoute.unitDetail: (BuildContext context) =>
        const UnitDetailPage(),
    ApplicationRoute.paymentSendDocuments: (BuildContext context) =>
        const PaymentSendDocumentPage(),
    ApplicationRoute.paymentReviewDocuments: (BuildContext context) =>
        const PaymentReviewDocumentPage(),
    ApplicationRoute.paymentProcessingFiles: (BuildContext context) =>
        const PaymentProcessingFilesPage(),
    ApplicationRoute.paymentIllegibleDocuments: (BuildContext context) =>
        const PaymentIllegibleDocumentPage(),
    // ApplicationRoute.registerPayment: (BuildContext context) =>
    //     const PaymentRegistrationPage(),
    ApplicationRoute.registerPaymentUnknownProvider: (BuildContext context) =>
        const PaymentRegistrationWarningUnknownProvider(),
    ApplicationRoute.registerPaymentSuccess: (BuildContext context) =>
        PaymentRegistrationSucceededPage(),
    ApplicationRoute.paymentHistory: (BuildContext context) =>
        const PaymentHistoryListPage(),
    ApplicationRoute.paymentHistoryDetails: (BuildContext context) =>
        const PaymentHistoryDetailsPage(),
    ApplicationRoute.paymentPendency: (BuildContext context) =>
        const PaymentPendencyListPage(),
    ApplicationRoute.paymentSendFinancialDepartment: (BuildContext context) =>
        const PaymentSendFinancialDepartmentPage(),
    ApplicationRoute.paymentSendFinancialDepartmentSuccessPage:
        (BuildContext context) =>
            const PaymentSendFinancialDepartmentSuccessPage(),
    ApplicationRoute.paymentSendFinancialDepartmentFaliurePage:
        (BuildContext context) =>
            const PaymentSendFinancialDepartmentFaliurePage(),
    ApplicationRoute.income: (BuildContext context) => const IncomeMainPage(),
    ApplicationRoute.billets: (BuildContext context) => const BilletsPage(),
    ApplicationRoute.incomeDashboard: (BuildContext context) =>
        const IncomeDashboardPage(),
    ApplicationRoute.incomeDetail: (BuildContext context) =>
        const IncomeDetailPage(),
    ApplicationRoute.billetDetail: (BuildContext context) =>
        const BilletDetailPage(),
    ApplicationRoute.accountability: (BuildContext context) =>
        const AccountabilityPage(),
    ApplicationRoute.accountabilityDetail: (BuildContext context) =>
        const AccountabilityDetailPage(),
    ApplicationRoute.accountabilityDetailGrouped: (BuildContext context) =>
        AccountabilityDetailsGroupedEntriesPage(),
    ApplicationRoute.accountabilityConfirmation: (BuildContext context) =>
        AccountabilityConfirmationPage(),
    ApplicationRoute.accountabilitySuccess: (BuildContext context) =>
        AccountabilityApprovalSuccessPage(),
    ApplicationRoute.accountabilitySendRecommendationSuccess:
        (BuildContext context) => const SendRecommendationSuccessPage(),
    ApplicationRoute.accountabilitySendRecommendationFailure:
        (BuildContext context) => const SendRecommendationErrorPage(),
    ApplicationRoute.accountabilityNewQuestion: (BuildContext context) =>
        QuestionCreatePage(),
    ApplicationRoute.accountabilityNewQuestionSuccess: (BuildContext context) =>
        QuestionCreateSuccessPage(),
    ApplicationRoute.accountabilityNewQuestionError: (BuildContext context) =>
        QuestionCreateErrorPage(),
    ApplicationRoute.accountabilityDoubtSummaryPage: (BuildContext context) =>
        const QuestionCreateDetailsPage(),
    ApplicationRoute.accountabilityQuestionListPage: (BuildContext context) =>
        const QuestionListPage(),
    ApplicationRoute.accountabilityQuestionListDetailPage:
        (BuildContext context) => QuestionListDetailPage(),
    ApplicationRoute.accessManagement: (BuildContext context) =>
        const AccessManagementPage(),
    ApplicationRoute.nonPayments: (BuildContext context) =>
        const NonPaymentsPage(),
    ApplicationRoute.nonPaymentsDetail: (BuildContext context) =>
        const NonPaymentsDetailPage(),
    ApplicationRoute.gdp: (BuildContext context) => GdpMainPage(),
    ApplicationRoute.gdpEmployeeList: (BuildContext context) =>
        EmployeeListPage(),
    ApplicationRoute.gdpEmployee: (BuildContext context) => EmployeePage(),
    ApplicationRoute.gdpPayslipMonth: (BuildContext context) =>
        const PayslipMonthPage(),
    ApplicationRoute.gdpPayslipEmployees: (BuildContext context) =>
        const PayslipEmployeesPage(),
    ApplicationRoute.gdpPayslipSelection: (BuildContext context) =>
        const PayslipSelectionPage(),
    ApplicationRoute.gdpVacationEmployees: (BuildContext context) =>
        const VacationEmployeesPage(),
    ApplicationRoute.gdpVacation: (BuildContext context) =>
        const VacationPage(),
    ApplicationRoute.gdpScheduleVacation: (BuildContext context) =>
        const ScheduleVacationPage(),
    ApplicationRoute.gdpScheduleVacationSucceeded: (BuildContext context) =>
        ScheduleVacationSucceededPage(),
    ApplicationRoute.gdpScheduleVacationFailure: (BuildContext context) =>
        ScheduleVacationFailurePage(),
    ApplicationRoute.gdpVacationSummary: (BuildContext context) =>
        ScheduleVacationSummaryPage(),
    ApplicationRoute.gdpVacationDetails: (BuildContext context) =>
        ScheduleVacationDetailsPage(),
    ApplicationRoute.gdpQuickFix: (BuildContext context) =>
        const QuickFixPage(),
    ApplicationRoute.gdpQuickFixReport: (BuildContext context) =>
        const QuickFixReportPage(),
    ApplicationRoute.gdpTimesheetMenu: (BuildContext context) =>
        const TimesheetMenuPage(),
    ApplicationRoute.payroll: (BuildContext context) => const PayrollPage(),
    ApplicationRoute.payrollDetail: (BuildContext context) =>
        const PayrollDetailPage(),
    ApplicationRoute.payrollEntry: (BuildContext context) =>
        const PayrollEntryListPage(),
    ApplicationRoute.balanceDetail: (BuildContext context) =>
        const CondominiumBalanceDetailPage(),
    ApplicationRoute.space: (BuildContext context) => const SpaceMenuPage(),
    ApplicationRoute.spaceReservationControl: (BuildContext context) =>
        const ReservationControlMainPage(),
    ApplicationRoute.spaceReservationCalendar: (BuildContext context) =>
        const ReservationCalendarPage(),
    ApplicationRoute.spaceReservationCalendarHistory: (BuildContext context) =>
        const ReservationHistoryCalendarPage(),
    ApplicationRoute.spaceReservationConfirmCancel: (BuildContext context) =>
        ReservationCancelConfirmationPage(),
    ApplicationRoute.spaceReservationDayCalendar: (BuildContext context) =>
        ReservationListPage(),
    ApplicationRoute.spaceReservationReport: (BuildContext context) =>
        ReservationReportPage(),
    ApplicationRoute.spaceReservationRegistrationSpace:
        (BuildContext context) => const ReservationRegistrationSpacePage(),
    ApplicationRoute.spaceReservationHistory: (BuildContext context) =>
        const ReservationCalendarHistoryWidget(),
    ApplicationRoute.spaceReservationRegistrationDate: (BuildContext context) =>
        ReservationRegistrationDatePage(),
    ApplicationRoute.spaceReservationRegistrationTime: (BuildContext context) =>
        ReservationRegistrationTimePage(),
    ApplicationRoute.spaceReservationRegistration: (BuildContext context) =>
        ReservationRegistrationPage(),
    ApplicationRoute.spaceReservationRegistrationMaintenance:
        (BuildContext context) => ReservationRegistrationMaintenancePage(),
    ApplicationRoute.spaceReservationRegistrationReservation:
        (BuildContext context) => ReservationRegistrationReservationPage(),
    ApplicationRoute.spaceReservationSuccess: (BuildContext context) =>
        ReservationSuccessPage(),
    ApplicationRoute.spaceReservationFailed: (BuildContext context) =>
        ReservationFailedPage(),
    ApplicationRoute.spaceReservationRegistrationRaffle:
        (BuildContext context) => ReservationRegistrationRafflePage(),
    ApplicationRoute.spaceReservationDrawRaffle: (BuildContext context) =>
        const ReservationRaffleDrawPage(),
    ApplicationRoute.spaceReservationDrawRaffleSuccess:
        (BuildContext context) => ReservationRaffleDrawSuccessPage(),
    ApplicationRoute.announcementsMenu: (BuildContext context) =>
        const VoxAnnouncementsMenu(),
    ApplicationRoute.warningsAndFines: (BuildContext context) =>
        const VoxWarningsFinesMenu(),
    ApplicationRoute.spaceList: (BuildContext context) => const SpaceListPage(),
    ApplicationRoute.spaceRegistrationOption: (BuildContext context) =>
        SpaceRegistrationOptionPage(),
    ApplicationRoute.spaceRegistrationLello: (BuildContext context) =>
        SpaceRegistrationLelloPage(),
    ApplicationRoute.spaceRegistration: (BuildContext context) =>
        const SpaceRegistrationPage(),
    ApplicationRoute.spaceRegistrationLelloSuccess: (BuildContext context) =>
        SpaceRegistrationLelloSuccessPage(),
    ApplicationRoute.spaceRegistrationSuccess: (BuildContext context) =>
        SpaceRegistrationSuccessPage(),
    ApplicationRoute.spaceDetail: (BuildContext context) =>
        const SpaceDetailPage(),
    ApplicationRoute.questionCreate: (BuildContext context) =>
        QuestionCreatePage(),
    ApplicationRoute.documents: (BuildContext context) => DocumentsPage(
          controller:
              ApplicationContainer.instance().resolve<DocumentsController>(),
          strategy: SindicoDocumentsMenuStrategy(
              ApplicationContainer.instance().resolve<SessionBloc>()),
        ),
    ApplicationRoute.documentsMinutes: (BuildContext context) =>
        DocumentsSelectedPage(
          controller:
              ApplicationContainer.instance().resolve<DocumentsController>(),
          title: "documents_minutes",
        ),
    ApplicationRoute.documentsNotices: (BuildContext context) =>
        DocumentsSelectedPage(
          controller:
              ApplicationContainer.instance().resolve<DocumentsController>(),
          title: "documents_notices",
        ),
    ApplicationRoute.documentsCirculars: (BuildContext context) =>
        DocumentsSelectedPage(
          controller:
              ApplicationContainer.instance().resolve<DocumentsController>(),
          title: "documents_circulars",
        ),
    ApplicationRoute.documentsDivers: (BuildContext context) =>
        DocumentsSelectedPage(
          controller:
              ApplicationContainer.instance().resolve<DocumentsController>(),
          title: "documents_divers",
        ),
    ApplicationRoute.reportsBook: (BuildContext context) => const ReportsPage(),
    ApplicationRoute.reportPreview: (BuildContext context) =>
        const ReportsPreviewReportPage(),
    ApplicationRoute.reportDetails: (BuildContext context) =>
        const ReportsDetailsReportPage(),
    ApplicationRoute.reportReply: (BuildContext context) =>
        const ReportsReplyPage(),
    ApplicationRoute.reportPreviewReply: (BuildContext context) =>
        const ReportsPreviewReplyPage(),
    ApplicationRoute.reportReplySuccess: (BuildContext context) =>
        const ReportsReplySuccessPage(),
    ApplicationRoute.reportsCloseReportSuccess: (BuildContext context) =>
        ReportsCloseReportSuccessPage(),
    ApplicationRoute.agreements: (BuildContext context) =>
        const AgreementsPage(),
    ApplicationRoute.agreementsProposals: (BuildContext context) =>
        const AgreementsProposalsPage(),
    ApplicationRoute.agreementsAnalysis: (BuildContext context) =>
        const AgreementsAnalysisPage(),
    ApplicationRoute.agreementsInProgress: (BuildContext context) =>
        const AgreementsInProgressPage(),
    ApplicationRoute.agreementsHistory: (BuildContext context) =>
        const AgreementsHistoryPage(),
    ApplicationRoute.agreementsRules: (BuildContext context) =>
        const AgreementsRulesPage(),
    ApplicationRoute.agreementsProposalsCardDetails: (BuildContext context) =>
        const AgreementsProposalsCardDetailsPage(),
    ApplicationRoute.agreementsInProgressCardDetails: (BuildContext context) =>
        const AgreementsInProgressCardDetailsPage(),
    ApplicationRoute.agreementsHistoryCardDetails: (BuildContext context) =>
        AgreementsHistoryCardDetailsPage(),
    ApplicationRoute.agreementsStatusChangedSuccess: (BuildContext context) =>
        const AgreementsStatusChangedSuccessPage(),
    ApplicationRoute.resinMenu: (BuildContext context) => const ResinMenuPage(),
    ApplicationRoute.resinAdvanceNew: (BuildContext context) =>
        const ResinNewAdvancePage(),
    ApplicationRoute.resinNewBankAccount: (BuildContext context) =>
        const ResinNewBankAccountPage(),
    ApplicationRoute.resinAdvanceHistory: (BuildContext context) =>
        const ResinHistoryAdvancePage(),
    ApplicationRoute.resinRefundHistory: (BuildContext context) =>
        const ResinHistoryRefundPage(),
    ApplicationRoute.resinCreateRefundSuccessError: (BuildContext context) =>
        const ResinCreateRefundSuccessErrorPage(),
    ApplicationRoute.resinRefundNew: (BuildContext context) =>
        const ResinNewRefundPage(),
    ApplicationRoute.resinReceiptDetails: (BuildContext context) =>
        const ResinReceiptDetailsPage(),
    ApplicationRoute.resinSendReceipts: (BuildContext context) =>
        const ResinSendReceiptPage(),
    ApplicationRoute.staffAccessManagement: (BuildContext context) =>
        const StaffAccessManagementPage(),
    ApplicationRoute.staffAccessManagementAdd: (BuildContext context) =>
        const StaffAccessManagementAddPage(),
    ApplicationRoute.staffAccessManagementEdit: (BuildContext context) =>
        const StaffAccessManagementEditPage(),
    ApplicationRoute.resinAttentionLimit: (BuildContext context) =>
        const ResinAttentionPage(),
    SharedApplicationRoute.comfort: (BuildContext context) => ComfortPage(
        appContainer: ApplicationContainer.instance(),
        appOriginEnum: AppOriginEnum.manager),
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
    SharedApplicationRoute.resetPasswordWarning: (BuildContext context) =>
        ResetPasswordWarningPage(
          appContainer: ApplicationContainer.instance(),
        ),
    SharedApplicationRoute.resetPasswordSuccess: (BuildContext context) =>
        ResetPasswordSuccessPage(),
    ApplicationRoute.permissionNotification: (BuildContext context) =>
        const PermissionNotificationPage(),
    ApplicationRoute.preferencesHome: (BuildContext context) =>
        const PreferencesHomeCardsPage(),
    ApplicationRoute.comodities: (BuildContext context) =>
        const ComoditiesPage(),
    SharedApplicationRoute.startSecurity: (BuildContext context) =>
        BlockedApp(),
    ApplicationRoute.maintenanceManagement: (BuildContext context) =>
        const MaintenanceManagementPage(),
    ApplicationRoute.maintenanceManagementLegalObligation:
        (BuildContext context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return LegalObligationPage(
        hasEmployee: args?['hasEmployee'] as bool? ?? false,
        hasTechnicalInspection:
            args?['hasTechnicalInspection'] as bool? ?? false,
      );
    },
    ApplicationRoute.maintenanceManagementLegalObligationActivityHistory:
        (BuildContext context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final item = args['item'] as LegalObligationItemEntity;
      final listCategoryLabel = args['listCategoryLabel'] as String?;
      final obligationTypeValue = args['obligationTypeValue'] as String;

      return LegalObligationActivityHistoryPage(
        item: item,
        obligationTypeValue: obligationTypeValue,
        listCategoryLabel: listCategoryLabel,
      );
    },
    ApplicationRoute.maintenanceManagementCreateTask: (BuildContext context) =>
        const CreateTaskPage(),
    ApplicationRoute.maintenanceManagementCreateRoutine:
        (BuildContext context) {
      final taskType =
          ModalRoute.of(context)!.settings.arguments as TaskCreationType?;
      return CreateRoutinePage(taskType: taskType ?? TaskCreationType.routine);
    },
    ApplicationRoute.maintenanceManagementCreateRoutineDetail:
        (BuildContext context) {
      final args = ModalRoute.of(context)!.settings.arguments as ({
        CreateRoutineBloc bloc,
        TaskCreationType taskType,
        String optionType,
      });
      final bloc = args.bloc;
      final taskType = args.taskType;
      final optionType = args.optionType;
      final state = bloc.state;
      if (state is CreateRoutineLoadedState && state.selectedOption != null) {
        return CreateRoutineDetailPage(
          selectedProcedure: state.selectedOption!,
          taskType: taskType,
          optionType: optionType,
          bloc: bloc,
        );
      } else {
        return CreateRoutineDetailPage(
          selectedProcedure: ProcedureOptionEntity(
            id: '',
            title: 'Erro',
            titleKey: '',
            description: 'Erro ao carregar procedimento',
            urlImage: '',
            procedureGroup: null,
            firstResponsible: null,
          ),
          taskType: taskType,
          optionType: optionType,
        );
      }
    },
    ApplicationRoute.maintenanceManagementFilters: (BuildContext context) =>
        const MaintenanceManagementFiltersPage(),

    ApplicationRoute.maintenanceManagementReports: (BuildContext context) =>
        MultiBlocProvider(
          providers: [
            BlocProvider<VisualizeReportsBloc>(
              create: (context) => ApplicationContainer.instance()
                  .resolve<VisualizeReportsBloc>(),
            ),
            BlocProvider<DashboardBloc>(
              create: (context) => DashboardBloc()..add(LoadInitialDataEvent()),
            ),
            BlocProvider<RoutineChartCubit>(
              create: (context) => RoutineChartCubit(
                ApplicationContainer.instance()
                    .resolve<GetFormularyByMonthUseCase>(),
              ),
            ),
            BlocProvider<ServiceOrderChartCubit>(
              create: (context) => ServiceOrderChartCubit(
                ApplicationContainer.instance()
                    .resolve<MaintenanceManagementRepository>(),
              ),
            ),
            BlocProvider<EfficiencyChartCubit>(
              create: (context) => EfficiencyChartCubit(
                ApplicationContainer.instance()
                    .resolve<GetFormularyByMonthUseCase>(),
              ),
            ),
            BlocProvider<CategoriesChartCubit>(
              create: (context) => CategoriesChartCubit(
                ApplicationContainer.instance()
                    .resolve<MaintenanceManagementRepository>(),
              ),
            ),
            BlocProvider<EnvironmentEquipmentChartCubit>(
              create: (context) => EnvironmentEquipmentChartCubit(),
            ),
            BlocProvider<AgendaTasksBloc>(
              create: (context) =>
                  ApplicationContainer.instance().resolve<AgendaTasksBloc>(),
            ),
            BlocProvider<CalendarIndicatorsBloc>(
              create: (context) => ApplicationContainer.instance()
                  .resolve<CalendarIndicatorsBloc>(),
            ),
          ],
          child: const VisualizeReportsPage(),
        ),
    ApplicationRoute.agenda: (BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider<AgendaTasksBloc>(
              create: (context) =>
                  ApplicationContainer.instance().resolve<AgendaTasksBloc>(),
            ),
            BlocProvider<CalendarIndicatorsBloc>(
              create: (context) => ApplicationContainer.instance()
                  .resolve<CalendarIndicatorsBloc>(),
            ),
            BlocProvider<ScheduleEventsBloc>(
              create: (context) =>
                  ApplicationContainer.instance().resolve<ScheduleEventsBloc>(),
            ),
          ],
          child: const AgendaPage(),
        ),
    ApplicationRoute.maintenanceManagementTaskDetails: (context) {
      final taskId = ModalRoute.of(context)!.settings.arguments as String? ??
          'mock-task-id';
      return TaskDetailsPage(taskId: taskId);
    },
    ApplicationRoute.maintenanceManagementTaskInitStep: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final taskId = args['taskId'] as String;
      final task = args['task'] as TaskDetailsEntity;
      final eventId = args['eventId'] as String;
      return TaskInitStepPage(
        taskId: taskId,
        task: task,
        eventId: eventId,
      );
    },
    ApplicationRoute.maintenanceManagementTaskHistory: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final taskId = args['taskId'] as String;
      final taskName = args['taskName'] as String;
      return TaskHistoryPage(taskId: taskId, taskName: taskName);
    },
    ApplicationRoute.maintenanceManagementChatConversations: (context) {
      final taskId = ModalRoute.of(context)!.settings.arguments as String?;
      return BlocProvider<ChatConversationsBloc>(
        create: (context) =>
            ApplicationContainer.instance().resolve<ChatConversationsBloc>(),
        child: ChatConversationsPage(taskId: taskId),
      );
    },
    ApplicationRoute.maintenanceManagementChatMessages: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final channel = args['channel'] as ChatChannelEntity;
      final ttJwtToken = args['ttJwtToken'] as String?;
      final taskId = args['taskId'] as String?;
      return BlocProvider<ChatMessagesBloc>(
        create: (context) =>
            ApplicationContainer.instance().resolve<ChatMessagesBloc>(),
        child: ChatMessagesPage(
          channel: channel,
          ttJwtToken: ttJwtToken,
          taskId: taskId,
        ),
      );
    },
  };

  @override
  State<LelloApp> createState() => _LelloAppState();
}

class _LelloAppState extends State<LelloApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // App foi para background ou está sendo fechado
      _closeWebSocketConnection();
    }
  }

  Future<void> _closeWebSocketConnection() async {
    try {
      final webSocketService =
          ApplicationContainer.instance().resolve<WebSocketService>();
      await webSocketService.disconnect();
    } catch (e) {
      // Ignora erro se o serviço não estiver disponível
    }
  }

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
          title: 'Lello',
          theme: LelloTheme.light,
          themeMode: ThemeMode.light,
          routes: LelloApp.routes,
          initialRoute: ApplicationRoute.splash,
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

            Intl.defaultLocale = '${result.languageCode}_${result.countryCode}';
            return result;
          },
        ),
      );
}
