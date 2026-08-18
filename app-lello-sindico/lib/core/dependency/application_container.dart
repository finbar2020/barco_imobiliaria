import 'dart:async';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:chopper/chopper.dart' as chopper;
import 'package:essentials/essentials.dart';
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:get_it/get_it.dart';
import 'package:lello/core/aws_uploader/aws_uploader.dart';
import 'package:lello/core/aws_uploader/aws_uploader_impl.dart';
import 'package:lello/core/database/account/account_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_agreement_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_installments_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_quote_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_rules_days_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_rules_installments_dao.dart';
import 'package:lello/core/database/condominium/condominium_dao.dart';
import 'package:lello/core/database/condominium_balance/condominium_balance_dao.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_debits_dao.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_detail_dao.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_summary_dao.dart';
import 'package:lello/core/database/employee/employee_dao.dart';
import 'package:lello/core/database/income/income_dao.dart';
import 'package:lello/core/database/layout/layout_dao.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/me/me_dao.dart';
import 'package:lello/core/database/pendency/pendency_dao.dart';
import 'package:lello/core/database/reservation_summary/reservation_summary_dao.dart';
import 'package:lello/core/database/resident/resident_dao.dart';
import 'package:lello/core/database/resin/resin_bank_accounts/resin_bank_accounts_dao.dart';
import 'package:lello/core/database/resin/resin_banks/resin_banks_dao.dart';
import 'package:lello/core/database/resin/resin_people/resin_people_dao.dart';
import 'package:lello/core/database/resin/resin_refunds/resin_refunds_dao.dart';
import 'package:lello/core/database/space/space_dao.dart';
import 'package:lello/core/database/unit/unit_dao.dart';
import 'package:lello/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:lello/core/messaging/use_case/ghost_notification_usecase_impl.dart';
import 'package:lello/core/network/authorization_header_interceptor.dart';
import 'package:lello/core/uploader/uploader.dart';
import 'package:lello/core/uploader/uploader_impl.dart';
import 'package:lello/core/widget/expire_cache.dart';
import 'package:lello/feature/access_management/data/data_source/access_management_api.dart';
import 'package:lello/feature/access_management/data/data_source/access_management_remote_data_source.dart';
import 'package:lello/feature/access_management/data/data_source/access_management_remote_data_source_impl.dart';
import 'package:lello/feature/access_management/data/repository/access_management_repository_impl.dart';
import 'package:lello/feature/access_management/domain/repository/access_management_repository.dart';
import 'package:lello/feature/access_management/domain/usecase/check_seventh_service/access_management_check_service.dart';
import 'package:lello/feature/access_management/domain/usecase/check_seventh_service/access_management_check_service_impl.dart';
import 'package:lello/feature/access_management/domain/usecase/facial_biometric/facial_biometric_usecase.dart';
import 'package:lello/feature/access_management/domain/usecase/facial_biometric/facial_biometric_usecase_impl.dart';
import 'package:lello/feature/access_management/domain/usecase/send_invite/send_invite.dart';
import 'package:lello/feature/access_management/domain/usecase/send_invite/send_invite_impl.dart';
import 'package:lello/feature/access_management/presentation/bloc/access_management_bloc.dart';
import 'package:lello/feature/access_management/presentation/controller/access_management_controller.dart';
import 'package:lello/feature/account/data/data_source/local/account_local_data_source.dart';
import 'package:lello/feature/account/data/data_source/local/account_local_data_source_impl.dart';
import 'package:lello/feature/account/data/data_source/remote/account_api.dart';
import 'package:lello/feature/account/data/data_source/remote/account_remote_data_source.dart';
import 'package:lello/feature/account/data/data_source/remote/account_remote_data_source_impl.dart';
import 'package:lello/feature/account/data/repository/account_repository_impl.dart';
import 'package:lello/feature/account/domain/repository/account_repository.dart';
import 'package:lello/feature/account/domain/use_case/list/list_accounts.dart';
import 'package:lello/feature/account/domain/use_case/list/list_accounts_impl.dart';
import 'package:lello/feature/accountability/data/data_source/accountability_api.dart';
import 'package:lello/feature/accountability/data/data_source/accountability_remote_data_source.dart';
import 'package:lello/feature/accountability/data/data_source/accountability_remote_data_source_impl.dart';
import 'package:lello/feature/accountability/data/data_source/approval/accountability_approval_api.dart';
import 'package:lello/feature/accountability/data/data_source/approval/accountability_approval_remote_data_source.dart';
import 'package:lello/feature/accountability/data/data_source/approval/accountability_approval_remote_data_source_impl.dart';
import 'package:lello/feature/accountability/data/repository/accountability_approval_repository_impl.dart';
import 'package:lello/feature/accountability/data/repository/accountability_repository_impl.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_approval_repository.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';
import 'package:lello/feature/accountability/domain/use_case/approve_accountability/approve_accountability_usecase.dart';
import 'package:lello/feature/accountability/domain/use_case/approve_recommendation/approve_recommendation_usecase.dart';
import 'package:lello/feature/accountability/domain/use_case/get_accountability/get_accountability_usecase.dart';
import 'package:lello/feature/accountability/domain/use_case/get_accountability_period/get_accountability_period.dart';
import 'package:lello/feature/accountability/domain/use_case/get_question_types/get_question_type_usecase.dart';
import 'package:lello/feature/accountability/domain/use_case/list_doubt/list_doubt_usecase.dart';
import 'package:lello/feature/accountability/domain/use_case/send_new_question/send_new_question_impl.dart';
import 'package:lello/feature/accountability/presentation/approval/bloc/accountability_approval_bloc.dart';
import 'package:lello/feature/accountability/presentation/approval/controller/accountability_approval_controller.dart';
import 'package:lello/feature/accountability/presentation/detail/bloc/accountability_detail_bloc.dart';
import 'package:lello/feature/accountability/presentation/detail/controller/accountability_detail_controller.dart';
import 'package:lello/feature/accountability/presentation/list/bloc/accountability_bloc.dart';
import 'package:lello/feature/accountability/presentation/list/controller/accountability_controller.dart';
import 'package:lello/feature/accountability/presentation/question_create/bloc/question_create_bloc.dart';
import 'package:lello/feature/accountability/presentation/question_create/controller/question_create_controller.dart';
import 'package:lello/feature/accountability/presentation/question_list/bloc/question_list_bloc.dart';
import 'package:lello/feature/accountability/presentation/question_list/controller/question_list_controller.dart';
import 'package:lello/feature/agreements/data/data_source/local/agreements_local_data_source.dart';
import 'package:lello/feature/agreements/data/data_source/local/agreements_local_data_source_impl.dart';
import 'package:lello/feature/agreements/data/data_source/remote/agreements_api.dart';
import 'package:lello/feature/agreements/data/data_source/remote/agreements_remote_data_source.dart';
import 'package:lello/feature/agreements/data/data_source/remote/agreements_remote_data_source_impl.dart';
import 'package:lello/feature/agreements/data/repository/agreements_repository_impl.dart';
import 'package:lello/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:lello/feature/agreements/domain/use_case/agreement_update_status_use_case.dart';
import 'package:lello/feature/agreements/domain/use_case/agreement_update_status_use_case_impl.dart';
import 'package:lello/feature/agreements/domain/use_case/change_rules_use_case.dart';
import 'package:lello/feature/agreements/domain/use_case/change_rules_use_case_impl.dart';
import 'package:lello/feature/agreements/domain/use_case/get_all_agreements_info_use_case.dart';
import 'package:lello/feature/agreements/domain/use_case/get_all_agreements_info_use_case_impl.dart';
import 'package:lello/feature/agreements/domain/use_case/get_analysis_use_case.dart';
import 'package:lello/feature/agreements/domain/use_case/get_analysis_use_case_impl.dart';
import 'package:lello/feature/agreements/domain/use_case/get_rules_use_case.dart';
import 'package:lello/feature/agreements/domain/use_case/get_rules_use_case_impl.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:lello/feature/agreements/presentation/controllers/agreements_controller.dart';
import 'package:lello/feature/vox/data/data_source/remote/vox_api.dart';
import 'package:lello/feature/vox/data/data_source/remote/vox_remote_data_source.dart';
import 'package:lello/feature/vox/data/data_source/remote/vox_remote_data_source_impl.dart';
import 'package:lello/feature/vox/data/repository/vox_repository_impl.dart';
import 'package:lello/feature/vox/domain/repository/vox_repository.dart';
import 'package:lello/feature/vox/domain/use_case/create_document/create_document.dart';
import 'package:lello/feature/vox/domain/use_case/create_document/create_document_impl.dart';
import 'package:lello/feature/vox/domain/use_case/get_document/get_document.dart';
import 'package:lello/feature/vox/domain/use_case/get_document/get_document_impl.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_reasons/list_document_reasons.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_reasons/list_document_reasons_impl.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_templates/list_document_templates.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_templates/list_document_templates_impl.dart';
import 'package:lello/feature/vox/domain/use_case/list_documents/list_documents.dart';
import 'package:lello/feature/vox/domain/use_case/list_documents/list_documents_impl.dart';
import 'package:lello/feature/vox/domain/use_case/request_document/request_document.dart';
import 'package:lello/feature/vox/domain/use_case/request_document/request_document_impl.dart';
import 'package:lello/feature/vox/domain/use_case/upload_document_image/upload_document_image.dart';
import 'package:lello/feature/vox/domain/use_case/upload_document_image/upload_document_image_impl.dart';
import 'package:lello/feature/vox/presentation/history/vox_history_cache.dart';
import 'package:lello/feature/vox/presentation/request/vox_reasons_cache.dart';
import 'package:lello/feature/vox/presentation/request/vox_templates_cache.dart';
import 'package:lello/feature/condominium/data/data_source/local/condominium_balance_detail_local_data_source.dart';
import 'package:lello/feature/condominium/data/data_source/local/condominium_balance_detail_local_data_source_impl.dart';
import 'package:lello/feature/condominium/data/data_source/local/condominium_balance_local_data_source.dart';
import 'package:lello/feature/condominium/data/data_source/local/condominium_balance_local_data_source_impl.dart';
import 'package:lello/feature/condominium/data/data_source/remote/condominium_balance_api.dart';
import 'package:lello/feature/condominium/data/data_source/remote/condominium_balance_remote_data_source.dart';
import 'package:lello/feature/condominium/data/data_source/remote/condominium_balance_remote_data_source_impl.dart';
import 'package:lello/feature/condominium/data/data_source/remote/condominium_simple_remote_data_source.dart';
import 'package:lello/feature/condominium/data/data_source/remote/condominium_simple_remote_data_source_impl.dart';
import 'package:lello/feature/condominium/data/repository/condominium_balance_detail_repository_impl.dart';
import 'package:lello/feature/condominium/data/repository/condominium_balance_repository_impl.dart';
import 'package:lello/feature/condominium/data/repository/condominium_simple_repository_impl.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_balance_detail_repository.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_balance_repository.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_simple_repository.dart';
import 'package:lello/feature/condominium/domain/use_case/get_simple_condominium/get_simple_condominium.dart';
import 'package:lello/feature/condominium/domain/use_case/get_simple_condominium/get_simple_condominium_impl.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance_impl.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance_detail/load_condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance_detail/load_condominium_balance_detail_impl.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_bloc.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl.dart';
import 'package:lello/feature/condominium/presentation/detail/bloc/condominium_balance_detail_bloc.dart';
import 'package:lello/feature/condominium/presentation/detail/bloc/condominium_balance_detail_bloc_impl.dart';
import 'package:lello/feature/consultant_lello/controller/consultant_lello_controller.dart';
import 'package:lello/feature/consultant_lello/data/data_source/remote/consultant_lello_api.dart';
import 'package:lello/feature/consultant_lello/data/data_source/remote/consultant_lello_remote_data_source.dart';
import 'package:lello/feature/consultant_lello/data/data_source/remote/consultant_lello_remote_data_source_impl.dart';
import 'package:lello/feature/consultant_lello/data/repository/consultant_lello_repository_impl.dart';
import 'package:lello/feature/consultant_lello/domain/repository/consultant_lello_repository.dart';
import 'package:lello/feature/consultant_lello/domain/use_case/list/consultant_lello_use_case.dart';
import 'package:lello/feature/consultant_lello/domain/use_case/list/consultant_lello_use_case_impl.dart';
import 'package:lello/feature/dashboard/data/data_source/local/pendency_local_data_source.dart';
import 'package:lello/feature/dashboard/data/data_source/local/pendency_local_data_source_impl.dart';
import 'package:lello/feature/dashboard/data/data_source/remote/pendency_api.dart';
import 'package:lello/feature/dashboard/data/data_source/remote/pendency_remote_data_source.dart';
import 'package:lello/feature/dashboard/data/data_source/remote/pendency_remote_data_source_impl.dart';
import 'package:lello/feature/dashboard/data/repository/pendency_repository_impl.dart';
import 'package:lello/feature/dashboard/domain/repository/pendency_repository.dart';
import 'package:lello/feature/dashboard/domain/use_case/list_pendency/list_pendency.dart';
import 'package:lello/feature/dashboard/domain/use_case/list_pendency/list_pendency_impl.dart';
import 'package:lello/feature/dashboard/domain/use_case/update_pendency/update_pendency.dart';
import 'package:lello/feature/dashboard/domain/use_case/update_pendency/update_pendency_impl.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_bloc_impl.dart';
import 'package:lello/feature/dashboard_preferences/data/data_source/remote/notifications_preferences_api.dart';
import 'package:lello/feature/dashboard_preferences/data/data_source/remote/notifications_preferences_remote_data_source.dart';
import 'package:lello/feature/dashboard_preferences/data/data_source/remote/notifications_preferences_remote_data_source_impl.dart';
import 'package:lello/feature/dashboard_preferences/data/repository/notifications_preferences_repository_impl.dart';
import 'package:lello/feature/dashboard_preferences/domain/repository/notifications_preferences_repository.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/get_notifications_preferences/get_notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/get_notifications_preferences/get_notifications_preferences_impl.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/update_notifications_preferences/update_notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/update_notifications_preferences/update_notifications_preferences_impl.dart';
import 'package:lello/feature/dashboard_preferences/presentation/bloc/notifications_preferences_bloc.dart';
import 'package:lello/feature/dashboard_preferences/presentation/controller/notifications_preferences_controller.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_api.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_remote_data_source.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_remote_data_source_impl.dart';
import 'package:shared_features/feature/documents/data/repository/documents_repository_impl.dart';
import 'package:shared_features/feature/documents/domain/repository/documents_repository.dart';
import 'package:shared_features/feature/documents/domain/use_case/download_document/download_document.dart';
import 'package:shared_features/feature/documents/domain/use_case/download_document/download_document_impl.dart';
import 'package:shared_features/feature/documents/domain/use_case/get_extracted_text/get_extracted_text.dart';
import 'package:shared_features/feature/documents/domain/use_case/get_extracted_text/get_extracted_text_impl.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_bloc.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_controller.dart';
import 'package:shared_features/core/database/documents/cached_documents_store.dart';
import 'package:lello/feature/documents/integration/sindico_shared_session.dart';
import 'package:lello/feature/documents/integration/sindico_documents_analytics.dart';
import 'package:lello/feature/gdp/data/data_source/local/employee_local_data_source.dart';
import 'package:lello/feature/gdp/data/data_source/local/employee_local_data_source_impl.dart';
import 'package:lello/feature/gdp/data/data_source/remote/employee_api.dart';
import 'package:lello/feature/gdp/data/data_source/remote/employee_remote_data_source.dart';
import 'package:lello/feature/gdp/data/data_source/remote/employee_remote_data_source_impl.dart';
import 'package:lello/feature/gdp/data/repository/employee_repository_impl.dart';
import 'package:lello/feature/gdp/domain/repository/employee_repository.dart';
import 'package:lello/feature/gdp/domain/use_case/get_employee/get_employee.dart';
import 'package:lello/feature/gdp/domain/use_case/get_employee/get_employee_impl.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee_impl.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_bloc.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_bloc_impl.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_bloc.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/list/employee_list_bloc_impl.dart';
import 'package:lello/feature/gdp/payslip/data/data_source/payslip_api.dart';
import 'package:lello/feature/gdp/payslip/data/data_source/payslip_remote_data_source.dart';
import 'package:lello/feature/gdp/payslip/data/data_source/payslip_remote_data_source_impl.dart';
import 'package:lello/feature/gdp/payslip/data/repository/payslip_repository_impl.dart';
import 'package:lello/feature/gdp/payslip/domain/repository/payslip_repository.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip_impl.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file_impl.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_bloc.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_bloc_impl.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_bloc.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_bloc_impl.dart';
import 'package:lello/feature/gdp/quick_fix/data/data_source/remote/employee_report_api.dart';
import 'package:lello/feature/gdp/quick_fix/data/data_source/remote/employee_report_remote_data_source.dart';
import 'package:lello/feature/gdp/quick_fix/data/data_source/remote/employee_report_remote_data_source_impl.dart';
import 'package:lello/feature/gdp/quick_fix/data/repository/employee_report_repository_impl.dart';
import 'package:lello/feature/gdp/quick_fix/domain/repository/employee_report_repository.dart';
import 'package:lello/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report_impl.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_bloc.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_bloc_impl.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_bloc.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_bloc_impl.dart';
import 'package:lello/feature/gdp/timesheet/data/data_source/timesheet_api.dart';
import 'package:lello/feature/gdp/timesheet/data/data_source/timesheet_remote_data_source.dart';
import 'package:lello/feature/gdp/timesheet/data/data_source/timesheet_remote_data_source_impl.dart';
import 'package:lello/feature/gdp/timesheet/data/repository/timesheet_repository_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_check_in_data/get_check_in_data.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_check_in_data/get_check_in_data_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_day_appointments/get_day_appointments.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_day_appointments/get_day_appointments_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_employee_detail/get_employee_detail.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_employee_detail/get_employee_detail_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_groupped_occurrence/get_grouped_occurrence.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_groupped_occurrence/get_grouped_occurrence_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_list_employee/get_list_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_list_employee/get_list_employee_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_manual_appointments/get_manual_appointments.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_manual_appointments/get_manual_appointments_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_month_resume/get_month_resume.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_month_resume/get_month_resume_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_certificate/get_occurrence_certificate.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_certificate/get_occurrence_certificate_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_detail/get_occurrence_detail.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_detail/get_occurrence_detail_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_vacation/get_occurrence_vacation.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_vacation/get_occurrence_vacation_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_point_mirror/get_point_mirror.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_point_mirror/get_point_mirror_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_vacation_receipt/get_vacation_receipt.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_vacation_receipt/get_vacation_receipt_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_control_occurrence/post_control_occurrence.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_control_occurrence/post_control_occurrence_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_manual_appointment/post_manual_appointment.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_manual_appointment/post_manual_appointment_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/put_signature_notify/post_signature_notify.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/put_signature_notify/post_signature_notify_impl.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet/timesheet_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_add_appointment/timesheet_add_appointment_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_certificate/timesheet_certificate_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments/timesheet_day_appointments_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments_details_bloc/timesheet_day_appointments_details_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_details_list/timesheet_details_list_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_list_pending_appointments/timesheet_list_pending_appointments_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_bloc_impl.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_occurrence/timesheet_occurrence_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_point_mirror/timesheet_point_mirror_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/day_appointments_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/day_appointments_details_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/detail_list_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/list_pending_appointments_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_add_appointment.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_certificate_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_occurrence_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_point_mirror_controller.dart';
import 'package:lello/feature/gdp/vacation/data/data_source/vacation_api.dart';
import 'package:lello/feature/gdp/vacation/data/data_source/vacation_remote_data_source.dart';
import 'package:lello/feature/gdp/vacation/data/data_source/vacation_remote_data_source_impl.dart';
import 'package:lello/feature/gdp/vacation/data/repository/vacation_repository_impl.dart';
import 'package:lello/feature/gdp/vacation/domain/repository/vacation_repository.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation_impl.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days_impl.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period_impl.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation_impl.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/details/vacation_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/details/vacation_bloc_impl.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_bloc_impl.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc_impl.dart';
import 'package:lello/feature/home/presentation/bloc/home_bloc.dart';
import 'package:lello/feature/home/presentation/bloc/home_bloc_impl.dart';
import 'package:lello/feature/home/presentation/controllers/home_analytics_timer_controller.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc.dart';
import 'package:lello/feature/home/presentation/widget/sliver/bloc/home_sliver_app_bar_bloc.dart';
import 'package:lello/feature/home/presentation/widget/sliver/bloc/home_sliver_app_bar_bloc_impl.dart';
import 'package:lello/feature/home_cards_preferences/bloc/preferences_home_cards_bloc.dart';
import 'package:lello/feature/home_cards_preferences/controller/preferences_home_cards_controller.dart';
import 'package:lello/feature/income/data/data_source/local/income_local_data_source.dart';
import 'package:lello/feature/income/data/data_source/local/income_local_data_source_impl.dart';
import 'package:lello/feature/income/data/data_source/remote/billets_api.dart';
import 'package:lello/feature/income/data/data_source/remote/billets_remote_data_source.dart';
import 'package:lello/feature/income/data/data_source/remote/billets_remote_data_source_impl.dart';
import 'package:lello/feature/income/data/data_source/remote/income_api.dart';
import 'package:lello/feature/income/data/data_source/remote/income_remote_data_source.dart';
import 'package:lello/feature/income/data/data_source/remote/income_remote_data_source_impl.dart';
import 'package:lello/feature/income/data/repository/billets_repository.dart';
import 'package:lello/feature/income/data/repository/billets_repository_impl.dart';
import 'package:lello/feature/income/data/repository/income_repository_impl.dart';
import 'package:lello/feature/income/domain/repository/income_repository.dart';
import 'package:lello/feature/income/domain/use_case/download_billet_usecase.dart';
import 'package:lello/feature/income/domain/use_case/get_billet_period_availability/get_billet_period_availability.dart';
import 'package:lello/feature/income/domain/use_case/get_billet_period_availability/get_billet_period_availability_impl.dart';
import 'package:lello/feature/income/domain/use_case/get_billets.dart';
import 'package:lello/feature/income/domain/use_case/get_billets_impl.dart';
import 'package:lello/feature/income/domain/use_case/get_monthly_income/get_income.dart';
import 'package:lello/feature/income/domain/use_case/get_monthly_income/get_monthly_income_impl.dart';
import 'package:lello/feature/income/domain/use_case/get_units_by_billets/get_units_by_billets.dart';
import 'package:lello/feature/income/domain/use_case/get_units_by_billets/get_units_by_billets_impl.dart';
import 'package:lello/feature/income/presentation/billets/bloc/billets_bloc.dart';
import 'package:lello/feature/income/presentation/billets/controller/billets_controller.dart';
import 'package:lello/feature/income/presentation/billets/detail/bloc/billets_details_bloc.dart';
import 'package:lello/feature/income/presentation/billets/detail/controller/billets_details_controller.dart';
import 'package:lello/feature/income/presentation/dasboard/bloc/income_dashboard_bloc.dart';
import 'package:lello/feature/income/presentation/dasboard/controller/income_dashboard_controller.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/reset_schedule_event_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_bloc_impl.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/agenda_tasks_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/calendar_indicators_bloc.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_calendar_days_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/bloc/legal_obligation_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/legal_obligation/bloc/legal_obligation_bloc_impl.dart';
import 'package:lello/feature/maintenance_management/presentation/task/bloc/task_edit/task_edit_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/task/bloc/init_step/task_init_step_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/task/bloc/task_report/task_report_bloc.dart';
import 'package:lello/feature/me/data/data_source/local/me_local_data_source.dart';
import 'package:lello/feature/me/data/data_source/local/me_local_data_source_impl.dart';
import 'package:lello/feature/me/data/data_source/remote/me_api.dart';
import 'package:lello/feature/me/data/data_source/remote/me_remote_data_source.dart';
import 'package:lello/feature/me/data/data_source/remote/me_remote_data_source_impl.dart';
import 'package:lello/feature/me/data/repository/me_repository_impl.dart';
import 'package:lello/feature/me/data/repository/profile_picture_repository_impl.dart';
import 'package:lello/feature/me/domain/repository/me_repository.dart';
import 'package:lello/feature/me/domain/repository/profile_picture_repository.dart';
import 'package:lello/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:lello/feature/me/domain/use_case/get_me/get_me_impl.dart';
import 'package:lello/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:lello/feature/me/domain/use_case/log_me_out/log_me_out_impl.dart';
import 'package:lello/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:lello/feature/me/domain/use_case/save_me/save_me_impl.dart';
import 'package:lello/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:lello/feature/me/domain/use_case/update_password_me/update_password_me_impl.dart';
import 'package:lello/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture.dart';
import 'package:lello/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture_impl.dart';
import 'package:lello/feature/me/presentation/bloc/me_bloc.dart';
import 'package:lello/feature/me/presentation/controller/me_controller.dart';
import 'package:lello/feature/nonpayment/data/data_source/remote/nonpayments_api.dart';
import 'package:lello/feature/nonpayment/data/data_source/remote/nonpayments_remote_data_source.dart';
import 'package:lello/feature/nonpayment/data/data_source/remote/nonpayments_remote_data_source_impl.dart';
import 'package:lello/feature/nonpayment/data/repository/nonpayments_repository.dart';
import 'package:lello/feature/nonpayment/data/repository/nonpayments_repository_impl.dart';
import 'package:lello/feature/nonpayment/domain/use_case/get_nonpayments.dart';
import 'package:lello/feature/nonpayment/domain/use_case/get_nonpayments_impl.dart';
import 'package:lello/feature/nonpayment/presentation/bloc/nonpayments_bloc.dart';
import 'package:lello/feature/nonpayment/presentation/controller/nonpayments_controller.dart';
import 'package:lello/feature/payment/data/data_source/approval/payment_approval_api.dart';
import 'package:lello/feature/payment/data/data_source/approval/payment_approval_remote_data_source.dart';
import 'package:lello/feature/payment/data/data_source/approval/payment_approval_remote_data_source_impl.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_api.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_ledger_account_balance_datasource.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_ledger_account_balance_datasource_impl.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_process_file_remote_data_source.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_process_file_remote_data_source_impl.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_remote_data_source.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_remote_data_source_impl.dart';
import 'package:lello/feature/payment/data/repository/payment_approval_repository_impl.dart';
import 'package:lello/feature/payment/data/repository/payment_ledger_account_balance_repository_impl.dart';
import 'package:lello/feature/payment/data/repository/payment_process_file_repository_impl.dart';
import 'package:lello/feature/payment/data/repository/payment_file_repository_impl.dart';
import 'package:lello/feature/payment/data/repository/payment_repository_impl.dart';
import 'package:lello/feature/payment/domain/repository/payment_approval_repository.dart';
import 'package:lello/feature/payment/domain/repository/payment_ledger_account_balance_repository.dart';
import 'package:lello/feature/payment/domain/repository/payment_process_file_repository.dart';
import 'package:lello/feature/payment/domain/repository/payment_file_repository.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/aws_get_url/aws_get_url.dart';
import 'package:lello/feature/payment/domain/use_case/aws_get_url/aws_get_url_impl.dart';
import 'package:lello/feature/payment/domain/use_case/check_approval_profile/check_approval_profile.dart';
import 'package:lello/feature/payment/domain/use_case/check_approval_profile/check_approval_profile_impl.dart';
import 'package:lello/feature/payment/domain/use_case/check_token/check_token.dart';
import 'package:lello/feature/payment/domain/use_case/check_token/check_token_impl.dart';
import 'package:lello/feature/payment/domain/use_case/contas_pagar/contas_pagar.dart';
import 'package:lello/feature/payment/domain/use_case/contas_pagar/contas_pagar_impl.dart';
import 'package:lello/feature/payment/domain/use_case/find_payment_by_barcode/find_payment_by_barcode.dart';
import 'package:lello/feature/payment/domain/use_case/find_payment_by_barcode/find_payment_by_barcode_impl.dart';
import 'package:lello/feature/payment/domain/use_case/find_spupplier/find_spupplier.dart';
import 'package:lello/feature/payment/domain/use_case/find_spupplier/find_spupplier_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_installments/get_installments.dart';
import 'package:lello/feature/payment/domain/use_case/get_installments/get_installments_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_ledger_account_balance/get_ledger_account_balance.dart';
import 'package:lello/feature/payment/domain/use_case/get_ledger_account_balance/get_ledger_account_balance_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_ledger_accounts/get_ledger_accounts.dart';
import 'package:lello/feature/payment/domain/use_case/get_ledger_accounts/get_ledger_accounts_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_payment/get_payment.dart';
import 'package:lello/feature/payment/domain/use_case/get_payment/get_payment_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_pendency/get_pendency.dart';
import 'package:lello/feature/payment/domain/use_case/get_pendency/get_pendency_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_spupplier/get_spupplier.dart';
import 'package:lello/feature/payment/domain/use_case/get_spupplier/get_spupplier_impl.dart';
import 'package:lello/feature/payment/domain/use_case/intallments_in_approval/get_installments_in_approval.dart';
import 'package:lello/feature/payment/domain/use_case/intallments_in_approval/get_installments_in_approval_impl.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment/list_payment.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment/list_payment_impl.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment_history/list_payment_history.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment_history/list_payment_history_impl.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment/register_payment.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment/register_payment_impl.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment_approval/register_payment_approval.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment_approval/register_payment_approval_impl.dart';
import 'package:lello/feature/payment/domain/use_case/send_documents/send_documents.dart';
import 'package:lello/feature/payment/domain/use_case/send_documents/send_documents_impl.dart';
import 'package:lello/feature/payment/domain/use_case/send_payment/send_payment.dart';
import 'package:lello/feature/payment/domain/use_case/send_payment/send_payment_impl.dart';
import 'package:lello/feature/payment/domain/use_case/send_token/send_token.dart';
import 'package:lello/feature/payment/domain/use_case/send_token/send_token_impl.dart';
import 'package:lello/feature/payment/domain/use_case/update_installments/update_installments.dart';
import 'package:lello/feature/payment/domain/use_case/update_installments/update_installments_impl.dart';
import 'package:lello/feature/payment/domain/use_case/update_ledger_account/update_ledger_account.dart';
import 'package:lello/feature/payment/domain/use_case/update_ledger_account/update_ledger_account_impl.dart';
import 'package:lello/feature/payment/domain/use_case/upload_documents_aws/upload_documents.dart';
import 'package:lello/feature/payment/domain/use_case/upload_documents_aws/upload_documents_impl.dart';
import 'package:lello/feature/payment/domain/use_case/upload_payment_file/upload_payment_file.dart';
import 'package:lello/feature/payment/domain/use_case/upload_payment_file/upload_payment_file_impl.dart';
import 'package:lello/feature/payment/presentation/approval/bloc/payment_approval_bloc.dart';
import 'package:lello/feature/payment/presentation/approval/bloc/payment_approval_bloc_impl.dart';
import 'package:lello/feature/payment/presentation/history_list/bloc/payment_history_list_bloc.dart';
import 'package:lello/feature/payment/presentation/history_list/controller/payment_history_list_controller.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/check_token_bloc/check_token_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/details_bloc/pendency_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/list_bloc/payment_pendency_list_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/validation_method_bloc/validation_method_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/controller/payment_pendency_controller.dart';
import 'package:lello/feature/payment/presentation/register/bloc/payment_registration_bloc.dart';
import 'package:lello/feature/payment/presentation/register_form/bloc/register_form_page_bloc.dart';
import 'package:lello/feature/payment/presentation/register_form/controllers/register_form_page_controller.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/bloc/register_installments_page_bloc.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/controllers/register_installments_page_controller.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/03_register_ledger_account/controllers/register_ledger_account_controller.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/bloc/send_payment_bloc.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/controllers/send_payment_controller.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/bloc/payment_send_financial_department_bloc.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/controller/payment_send_financial_department_controller.dart';
import 'package:lello/feature/payment/presentation/widget/payment_search_supplier/bloc/payment_search_supplier_bloc.dart';
import 'package:lello/feature/payment/presentation/widget/payment_search_supplier/controllers/payment_search_supplier_controller.dart';
import 'package:lello/feature/payroll/data/data_source/payroll/payroll_api.dart';
import 'package:lello/feature/payroll/data/data_source/payroll/payroll_remote_data_source.dart';
import 'package:lello/feature/payroll/data/data_source/payroll/payroll_remote_data_source_impl.dart';
import 'package:lello/feature/payroll/data/data_source/payroll_entry/payroll_entry_api.dart';
import 'package:lello/feature/payroll/data/data_source/payroll_entry/payroll_entry_remote_data_source.dart';
import 'package:lello/feature/payroll/data/data_source/payroll_entry/payroll_entry_remote_data_source_impl.dart';
import 'package:lello/feature/payroll/data/repository/payroll_entry_repository_impl.dart';
import 'package:lello/feature/payroll/data/repository/payroll_repository_impl.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_entry_repository.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_repository.dart';
import 'package:lello/feature/payroll/domain/use_case/get_payroll/get_payroll.dart';
import 'package:lello/feature/payroll/domain/use_case/get_payroll/get_payroll_impl.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll/list_payroll.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll/list_payroll_impl.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll_entry/list_payroll_entry.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll_entry/list_payroll_entry_impl.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/controller/payroll_controller.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_bloc.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/controller/payroll_entry_controller.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/payroll_entry_bloc.dart';
import 'package:lello/feature/reports_book/data/data_source/reports_book_api.dart';
import 'package:lello/feature/reports_book/data/data_source/reports_book_data_source.dart';
import 'package:lello/feature/reports_book/data/data_source/reports_book_data_source_impl.dart';
import 'package:lello/feature/reports_book/data/repository/reports_book_repository_impl.dart';
import 'package:lello/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:lello/feature/reports_book/domain/use_case/close_report.dart';
import 'package:lello/feature/reports_book/domain/use_case/close_report_impl.dart';
import 'package:lello/feature/reports_book/domain/use_case/get_report.dart';
import 'package:lello/feature/reports_book/domain/use_case/get_report_impl.dart';
import 'package:lello/feature/reports_book/domain/use_case/get_reports.dart';
import 'package:lello/feature/reports_book/domain/use_case/get_reports_impl.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_attachment.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_attachment_impl.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_content.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_content_impl.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_bloc.dart';
import 'package:lello/feature/reports_book/presentation/controller/report_controller.dart';
import 'package:lello/feature/resident/bloc/residents_bloc.dart';
import 'package:lello/feature/resident/data/data_source/local/resident_local_data_source.dart';
import 'package:lello/feature/resident/data/data_source/local/resident_local_data_source_impl.dart';
import 'package:lello/feature/resident/data/data_source/remote/resident_api.dart';
import 'package:lello/feature/resident/data/data_source/remote/resident_remote_data_source.dart';
import 'package:lello/feature/resident/data/data_source/remote/resident_remote_data_source_impl.dart';
import 'package:lello/feature/resident/data/repository/resident_repository_impl.dart';
import 'package:lello/feature/resident/domain/repository/resident_repository.dart';
import 'package:lello/feature/resident/domain/use_case/list_residents.dart';
import 'package:lello/feature/resident/domain/use_case/list_residents_impl.dart';
import 'package:lello/feature/resin/data/data_source/local/resin_local_data_source.dart';
import 'package:lello/feature/resin/data/data_source/local/resin_local_data_source_impl.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin/resin_api.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin/resin_remote_data_source.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin/resin_remote_data_source_impl.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin_bank/resin_bank_api.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin_bank/resin_bank_remote_data_source.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin_bank/resin_bank_remote_data_source_impl.dart';
import 'package:lello/feature/resin/data/repository/resin_bank_repository_impl.dart';
import 'package:lello/feature/resin/data/repository/resin_repository_impl.dart';
import 'package:lello/feature/resin/domain/repository/resin_bank_repository.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_bank_account/create_resin_bank_account.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_bank_account/create_resin_bank_account_impl.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_refund/create_resin_refund.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_refund/create_resin_refund_impl.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_bank_account/delete_resin_bank_account.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_bank_account/delete_resin_bank_account_impl.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_refund/delete_resin_refund.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_refund/delete_resin_refund_impl.dart';
import 'package:lello/feature/resin/domain/use_case/edit_resin_refund/edit_resin_refund.dart';
import 'package:lello/feature/resin/domain/use_case/edit_resin_refund/edit_resin_refund_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_bank_accounts/get_resin_bank_accounts.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_bank_accounts/get_resin_bank_accounts_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_banks/get_resin_banks.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_banks/get_resin_banks_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_check_max_value/get_resin_check_max_value.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_check_max_value/get_resin_check_max_value_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_params/get_resin_params.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_params/get_resin_params_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_people/get_resin_people.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_people/get_resin_people_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refund_details/get_resin_refund_details.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refund_details/get_resin_refund_details_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refunds/get_resin_refunds.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refunds/get_resin_refunds_impl.dart';
import 'package:lello/feature/resin/domain/use_case/upload_new_receipt/upload_new_receipt.dart';
import 'package:lello/feature/resin/domain/use_case/upload_new_receipt/upload_new_receipt_impl.dart';
import 'package:lello/feature/resin/presentation/resin_history_advance/bloc/resin_history_advance_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_history_advance/controller/resin_history_advance_controller.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/bloc/resin_history_refund_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/controller/resin_history_refund_controller.dart';
import 'package:lello/feature/resin/presentation/resin_menu/bloc/resin_menu_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_menu/controller/resin_menu_controller.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/bloc/resin_new_advance_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/controller/resin_new_advance_controller.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/controller/resin_new_bank_account_controller.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/bloc/resin_new_refund_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/controller/resin_new_refund_controller.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/bloc/resin_receipt_details_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/controller/resin_receipt_details_controller.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/bloc/resin_send_receipt_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/controller/resin_send_receipt_controller.dart';
import 'package:lello/feature/session/data/data_source/session_local_data_source.dart';
import 'package:lello/feature/session/data/data_source/session_local_data_source_impl.dart';
import 'package:lello/feature/session/data/repository/session_repository_impl.dart';
import 'package:lello/feature/session/domain/repository/session_repository.dart';
import 'package:lello/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:lello/feature/session/domain/use_case/load_session/load_session_impl.dart';
import 'package:lello/feature/session/domain/use_case/save_session/save_session.dart';
import 'package:lello/feature/session/domain/use_case/save_session/save_session_impl.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc_impl.dart';
import 'package:lello/feature/space/data/data_source/local/space_local_data_source.dart';
import 'package:lello/feature/space/data/data_source/local/space_local_data_source_impl.dart';
import 'package:lello/feature/space/data/data_source/remote/space_api.dart';
import 'package:lello/feature/space/data/data_source/remote/space_remote_data_source.dart';
import 'package:lello/feature/space/data/data_source/remote/space_remote_data_source_impl.dart';
import 'package:lello/feature/space/data/data_source/remote/space_type_remote_data_source.dart';
import 'package:lello/feature/space/data/data_source/remote/space_type_remote_data_source_impl.dart';
import 'package:lello/feature/space/data/repository/space_file_repositry_impl.dart';
import 'package:lello/feature/space/data/repository/space_repostiory_impl.dart';
import 'package:lello/feature/space/data/repository/space_type_repository_impl.dart';
import 'package:lello/feature/space/domain/repository/space_file_repository.dart';
import 'package:lello/feature/space/domain/repository/space_repository.dart';
import 'package:lello/feature/space/domain/repository/space_type_repository.dart';
import 'package:lello/feature/space/domain/use_case/list_space/list_space.dart';
import 'package:lello/feature/space/domain/use_case/list_space/list_space_impl.dart';
import 'package:lello/feature/space/domain/use_case/list_space_type/list_space_type.dart';
import 'package:lello/feature/space/domain/use_case/list_space_type/list_space_type_impl.dart';
import 'package:lello/feature/space/registration/data/data_source/space_registartion_request_remote_data_source.dart';
import 'package:lello/feature/space/registration/data/data_source/space_registartion_request_remote_data_source_impl.dart';
import 'package:lello/feature/space/registration/data/data_source/space_registration_request_api.dart';
import 'package:lello/feature/space/registration/data/repository/space_registration_request_repository_impl.dart';
import 'package:lello/feature/space/registration/domain/repository/space_registrtion_request_repository.dart';
import 'package:lello/feature/space/registration/domain/use_case/register_space/register_space.dart';
import 'package:lello/feature/space/registration/domain/use_case/register_space/register_space_impl.dart';
import 'package:lello/feature/space/registration/domain/use_case/request_space_registration/request_space_registration.dart';
import 'package:lello/feature/space/registration/domain/use_case/request_space_registration/request_space_registration_impl.dart';
import 'package:lello/feature/space/registration/domain/use_case/update_space/update_space.dart';
import 'package:lello/feature/space/registration/domain/use_case/update_space/update_space_impl.dart';
import 'package:lello/feature/space/registration/domain/use_case/upload_space_file/upload_space_file.dart';
import 'package:lello/feature/space/registration/domain/use_case/upload_space_file/upload_space_file_impl.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_bloc_impl.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc_impl.dart';
import 'package:lello/feature/space/reservation/data/data_source/local/reservation_summary/reservation_summary_local_data_source.dart';
import 'package:lello/feature/space/reservation/data/data_source/local/reservation_summary/reservation_summary_local_data_source_impl.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation/reservation_api.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation/reservation_remote_data_source.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation/reservation_remote_data_source_impl.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_rule/reservation_rule_api.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_rule/reservation_rule_remote_data_source.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_rule/reservation_rule_remote_data_source_impl.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_summary/reservation_summary_api.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_summary/reservation_summary_remote_data_source.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_summary/reservation_summary_remote_data_source_impl.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_time/reservation_time_api.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_time/reservation_time_remote_data_source.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_time/reservation_time_remote_data_source_impl.dart';
import 'package:lello/feature/space/reservation/data/repository/reservation_repository_impl.dart';
import 'package:lello/feature/space/reservation/data/repository/reservation_rule_repository_impl.dart';
import 'package:lello/feature/space/reservation/data/repository/reservation_summary_repository_impl.dart';
import 'package:lello/feature/space/reservation/data/repository/reservation_time_repository_impl.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_rule_repository.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_summary_repository.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_time_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/cancel_reservation/cancel_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/cancel_reservation/cancel_reservation_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/delete_reservation/delete_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/delete_reservation/delete_reservation_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/draw_raffle/draw_raffle.dart';
import 'package:lello/feature/space/reservation/domain/use_case/draw_raffle/draw_raffle_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_raffle/get_raffle.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_raffle/get_raffle_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_change_rules/get_reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_change_rules/get_reservation_change_rules_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_rule/get_reservation_rule.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_rule/get_reservation_rule_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_all_reservations/list_all_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_all_reservations/list_all_reservation_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation/list_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation/list_reservation_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_summary/list_reservation_summary.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_summary/list_reservation_summary_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_time/list_reservation_time.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_time/list_reservation_time_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/post_reservation_change_rules/post_reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/domain/use_case/post_reservation_change_rules/post_reservation_change_rules_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_maintenance/register_maintenance.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_maintenance/register_maintenance_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_raffle/register_raffle.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_raffle/register_raffle_impl.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_reservation/register_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_reservation/register_reservation_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_cancellation/reservation_cancellation_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_cancellation/reservation_canellation_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_calendar/reservation_change_calendar_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_calendar/reservation_change_calendar_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_filter/reservation_filter_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_filter/reservation_filter_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_list/reservation_list_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_list/reservation_list_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_raffle_draw_bloc/reservation_raffle_draw_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_raffle_draw_bloc/reservation_raffle_draw_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_maintenance/reservation_registration_maintenance_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_maintenance/reservation_registration_maintenance_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_raffle/reservation_registration_raffle_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_raffle/reservation_registration_reservation_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_reservation/reservation_registration_reservation_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_reservation/reservation_registration_reservation_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_time/reservation_registration_time_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_time/reservation_registration_time_bloc_impl.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/space_list/space_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/space_list/space_bloc_impl.dart';
import 'package:lello/feature/splash/data/data_source/boot_data_source.dart';
import 'package:lello/feature/splash/data/data_source/boot_data_source_impl.dart';
import 'package:lello/feature/splash/data/repository/boot_data_repository_impl.dart';
import 'package:lello/feature/splash/domain/repository/boot_data_repository.dart';
import 'package:lello/feature/splash/domain/use_case/get_boot_data/get_boot_data.dart';
import 'package:lello/feature/splash/domain/use_case/get_boot_data/get_boot_data_impl.dart';
import 'package:lello/feature/splash/domain/use_case/set_boot_data/set_boot_data.dart';
import 'package:lello/feature/splash/domain/use_case/set_boot_data/set_boot_data_impl.dart';
import 'package:lello/feature/staff_access_management/data/data_source/staff_access_management_api.dart';
import 'package:lello/feature/staff_access_management/data/data_source/staff_access_management_data_source.dart';
import 'package:lello/feature/staff_access_management/data/data_source/staff_access_management_data_source_impl.dart';
import 'package:lello/feature/staff_access_management/data/repository/staff_access_management_repository_impl.dart';
import 'package:lello/feature/staff_access_management/domain/repository/staff_access_management_repository.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/deactivate_non_manager_user/deactivate_non_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/deactivate_non_manager_user/deactivate_non_manager_user_impl.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/get_building_manager_users/get_building_manager_users.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/get_building_manager_users/get_building_manager_users_impl.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/post_non_user/post_non_user.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/post_non_user/post_non_user_impl.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/put_building_manager_user/put_building_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/use_case/put_building_manager_user/put_building_manager_user_impl.dart';
import 'package:lello/feature/staff_access_management/presentation/bloc/staff_access_management_bloc.dart';
import 'package:lello/feature/staff_access_management/presentation/controller/staff_access_management_controller.dart';
import 'package:lello/feature/unit/data/data_source/local/unit_local_data_source.dart';
import 'package:lello/feature/unit/data/data_source/local/unit_local_data_source_impl.dart';
import 'package:lello/feature/unit/data/data_source/remote/unit_api.dart';
import 'package:lello/feature/unit/data/data_source/remote/unit_remote_data_source.dart';
import 'package:lello/feature/unit/data/data_source/remote/unit_remote_data_source_impl.dart';
import 'package:lello/feature/unit/data/repository/unit_repository_impl.dart';
import 'package:lello/feature/unit/domain/repository/unit_repository.dart';
import 'package:lello/feature/unit/domain/use_case/list_unit_resident/list_unit_resident.dart';
import 'package:lello/feature/unit/domain/use_case/list_unit_resident/list_unit_resident_impl.dart';
import 'package:lello/feature/unit/domain/use_case/list_units/list_units_usecase.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_bloc.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_bloc_impl.dart';
import 'package:lello/feature/unit/presentation/bloc/units/units_bloc.dart';
import 'package:lello/feature/unit/presentation/controllers/unit_controller.dart';
import 'package:lello/feature/vehicles/data/datasource/vehicle_api.dart';
import 'package:lello/feature/vehicles/data/datasource/vehicle_datasource.dart';
import 'package:lello/feature/vehicles/data/datasource/vehicle_datasource_impl.dart';
import 'package:lello/feature/vehicles/domain/repository/i_vehicle_repository.dart';
import 'package:lello/feature/vehicles/domain/usecases/get_vehicles_usecase.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/database/banners/banners_args_dao.dart';
import 'package:shared_features/core/database/banners/banners_dao.dart';
import 'package:shared_features/core/network/refresh_authenticator_interceptor.dart';
import 'package:shared_features/feature/attach_files/bloc/attach_files_bloc.dart';
import 'package:shared_features/feature/attach_files/store/attach_files_store.dart';
import 'package:shared_features/feature/authentication/data/data_source/remote/authentication_api.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/banners/data/data_source/local/banners_local_data_source.dart';
import 'package:shared_features/feature/banners/data/data_source/local/banners_local_data_source_impl.dart';
import 'package:shared_features/feature/banners/data/data_source/remote/banners_api.dart';
import 'package:shared_features/feature/banners/data/data_source/remote/banners_remote_data_source.dart';
import 'package:shared_features/feature/banners/data/data_source/remote/banners_remote_data_source_impl.dart';
import 'package:shared_features/feature/banners/data/repository/banners_repository_impl.dart';
import 'package:shared_features/feature/banners/domain/repository/banners_repository.dart';
import 'package:shared_features/feature/banners/domain/use_case/get_banners/get_banners.dart';
import 'package:shared_features/feature/banners/domain/use_case/get_banners/get_banners_impl.dart';
import 'package:shared_features/feature/banners/presentation/bloc/banners_bloc.dart';
import 'package:shared_features/feature/banners/presentation/controllers/banners_controller.dart';
import 'package:shared_features/feature/code_validation/data/data_source/code_validation_api.dart';
import 'package:shared_features/feature/code_validation/presentation/store/code_validation_store.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_api.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_remote_data_source.dart';
import 'package:shared_features/feature/comfort/data/data_source/comfort_remote_data_source_impl.dart';
import 'package:shared_features/feature/comfort/data/repository/comfort_repository_impl.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/cancel_request/cancel_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/cancel_request/cancel_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/change_partner_favorite_status/change_partner_favorite_status.dart';
import 'package:shared_features/feature/comfort/domain/use_case/change_partner_favorite_status/change_partner_favorite_status_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/create_coupon_request/create_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/create_coupon_request/create_coupon_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/find_request_purchase/find_request_purchase.dart';
import 'package:shared_features/feature/comfort/domain/use_case/find_request_purchase/find_request_purchase_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partner_reviews/get_all_partner_reviews.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partner_reviews/get_all_partner_reviews_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partners/get_all_partners.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partners/get_all_partners_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_my_requests/get_my_requests.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_my_requests/get_my_requests_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_coupons/get_partner_coupons.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_coupons/get_partner_coupons_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_is_favorite/get_partner_is_favorite.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_is_favorite/get_partner_is_favorite_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_subcategories/get_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_subcategories/get_subcategories_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/request_partners/request_partners.dart';
import 'package:shared_features/feature/comfort/domain/use_case/request_partners/request_partners_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/resend_request/resend_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/resend_request/resend_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/send_review_request/send_review_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/send_review_request/send_review_request_impl.dart';
import 'package:shared_features/feature/comfort/domain/use_case/update_request/update_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/update_request/update_request_impl.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/bloc/comfort_my_request_item_actions_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/controller/comfort_my_request_item_actions_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/controller/comfort_my_request_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/controller/comfort_partner_reviews_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/ghost_notification/data/data_source/ghost_notification_api.dart';
import 'package:shared_features/feature/notifications/data/data_source/notifications_api.dart';
import 'package:shared_features/feature/registration/data/data_source/registration_api.dart';
import 'package:shared_features/feature/registration/presentation/store/registration_store.dart';
import 'package:shared_features/feature/reset_password/data/data_source/password_reset_api.dart';
import 'package:shared_features/shared_features.dart';

import '../../feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc_impl.dart';
import '../../feature/maintenance_management/api/maintenance_management_api.dart';
import '../../feature/maintenance_management/data/data_source/maintenance_management_remote_data_source.dart';
import '../../feature/maintenance_management/data/data_source/maintenance_management_remote_data_source_impl.dart';
import '../../feature/maintenance_management/data/repository/maintenance_management_repository_impl.dart';
import '../../feature/maintenance_management/domain/repository/maintenance_management_repository.dart';
import '../../feature/maintenance_management/domain/use_cases/get_assets_lookup_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_condominium_info_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_maintenance_task_events_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_schedule_events_use_case.dart';

import '../../feature/maintenance_management/domain/use_cases/get_maintenance_tasks_filter_options_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_legal_obligations_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/download_legal_obligation_file_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/upload_legal_obligation_file_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/send_technical_inspection_email_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/request_legal_obligation_renewal_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_procedure_options_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_formulary_by_month_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_locals_lookup_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_task_by_sector_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_task_by_month_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_task_by_local_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_task_by_asset_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_task_summary_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_task_details_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_task_formularies_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_task_files_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/create_task_from_schedule_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/edit_schedule_event_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/delete_schedule_event_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_event_details_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/submit_form_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_schedule_event_history_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/create_task_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/get_task_report_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/chat/get_chat_channels_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/chat/get_chat_messages_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/chat/send_chat_message_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/chat/create_chat_channel_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/chat/subscribe_to_channel_use_case.dart';
import '../../feature/maintenance_management/domain/use_cases/chat/unsubscribe_from_channel_use_case.dart';
import '../../feature/maintenance_management/domain/repository/chat_repository.dart';
import '../../feature/maintenance_management/data/repository/chat_repository_impl.dart';
import '../../feature/maintenance_management/data/service/websocket_service.dart';
import '../../feature/maintenance_management/presentation/chat/bloc/chat_conversations_bloc.dart';
import '../../feature/maintenance_management/presentation/chat/bloc/chat_conversations_event.dart';
import '../../feature/maintenance_management/presentation/chat/bloc/chat_conversations_state.dart';
import '../../feature/maintenance_management/presentation/chat/bloc/chat_messages_bloc.dart';
import '../../feature/maintenance_management/presentation/chat/bloc/chat_messages_event.dart';
import '../../feature/maintenance_management/presentation/chat/bloc/chat_messages_state.dart';

import '../../feature/maintenance_management/presentation/home/widgets/task_summary/bloc/task_summary_bloc.dart';
import '../../feature/maintenance_management/presentation/create_task/bloc/create_routine_bloc.dart';
import '../../feature/maintenance_management/presentation/home/bloc/maintenance_management_bloc.dart';
import '../../feature/maintenance_management/presentation/home/bloc/maintenance_management_bloc_impl.dart';
import '../../feature/maintenance_management/presentation/home/bloc/maintenance_management_current_week/maintenance_management_current_week_bloc.dart';
import '../../feature/maintenance_management/presentation/home/bloc/maintenance_management_current_week/maintenance_management_current_week_bloc_impl.dart';
import '../../feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_bloc.dart';
import '../../feature/maintenance_management/presentation/legal_obligation/bloc/legal_obligation_bloc.dart';
import '../../feature/maintenance_management/presentation/legal_obligation/bloc/legal_obligation_bloc_impl.dart';
import '../../feature/maintenance_management/presentation/agenda/bloc/schedule_events_bloc.dart';
import '../../feature/maintenance_management/presentation/reports_view/bloc/visualize_reports_bloc.dart';
import '../../feature/maintenance_management/presentation/reports_view/bloc/visualize_reports_bloc_impl.dart';
import '../../feature/maintenance_management/presentation/task/bloc/task_details_bloc.dart';
import '../../feature/maintenance_management/presentation/task/bloc/task_details_bloc_impl.dart';
import '../../feature/maintenance_management/presentation/task/bloc/task_history_bloc.dart';
import '../../feature/payment/presentation/list/bloc/payment_list_bloc.dart';
import '../../feature/payment/presentation/register/controllers/payment_registration_controller.dart';
import '../../feature/resident/controller/residents_controller.dart';
import '../../feature/resin/presentation/resin_new_bank_account/bloc/resin_new_bank_account_bloc.dart';
import '../../feature/unit/domain/use_case/list_units/list_simple_units_usecase.dart';
import '../../feature/unit/presentation/bloc/vehicles/vehicles_bloc.dart';
import '../../feature/unit/presentation/controllers/unit_details_controller.dart';
import '../../feature/vehicles/data/repository/vehicle_repository.dart';

class ApplicationContainer extends SharedApplicationContainer {
  static final ApplicationContainer _instance =
      ApplicationContainer._internal();

  ApplicationContainer._internal();

  factory ApplicationContainer.instance() {
    return _instance;
  }

  final GetIt locator = GetIt.asNewInstance();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> setUp(Environment environment) async {
    if (_isInitialized) {
      return;
    }
    _setupDependencies(environment);
    await afterSetup();
    _isInitialized = true;
  }

  void _setupDependencies(Environment environment) {
    final database = LelloDatabase();

    locator.registerSingleton(environment);

    locator.registerLazySingleton<ApiPerformaceMonitor>(
        () => ApiPerformaceMonitor());
    locator.registerLazySingleton(() => ChopperClient(
            baseUrl: Uri.tryParse(environment.apiUrl),
            converter: const JsonConverter(),
            errorConverter: ApiFailureConverter(),
            authenticator: RefreshAuthenticatorInterceptor(
              dataSource: resolve(),
              refreshToken: resolve(),
            ),
            interceptors: [
              AuthorizationHeaderInterceptor(
                dataSource: resolve(),
                monitor: resolve(),
              ),
              if (!environment.isProduction) CurlInterceptor(),
              PrettyChopperLogger(
                level: environment.isProduction
                    ? chopper.Level.none
                    : chopper.Level.body,
              ),
            ]));
    locator.registerFactory<Validator>(() => ValidatorImpl());
    locator.registerFactory(() => AttachFilesBloc());
    locator.registerLazySingleton(() => AttachFilesStore(bloc: resolve()));

    locator.registerLazySingleton<Uploader>(() => UploaderImpl(
          environment: resolve(),
          getToken: resolve(),
          session: resolve(),
        ));
    //splash
    locator.registerFactory<BootDataSource>(() => BootDataSourceImpl());
    locator
        .registerLazySingleton<BootDataRepository>(() => BootDataRepositoryImpl(
              dataSource: resolve(),
            ));
    locator.registerLazySingleton<GetBootData>(() => GetBootDataImpl(
          repository: resolve(),
        ));
    locator.registerLazySingleton<SetBootData>(() => SetBootDataImpl(
          repository: resolve(),
        ));

    //login
    locator.registerFactory<AuthenticationApi>(() => AuthenticationApi.create(
          resolve(),
        ));
    locator.registerFactory<GetToken>(() => GetTokenImpl(
          repository: resolve(),
        ));
    locator.registerFactory<AuthenticateFirebase>(
        () => AuthenticateFirebaseImpl());
    locator.registerFactory<AccessTokenLocalDataSource>(
        () => AccessTokenLocalDataSourceImpl());
    locator.registerFactory<AccessTokenRemoteDataSource>(
        () => AccessTokenRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<RefreshTokenRemoteDataSource>(() =>
        RefreshTokenRemoteDataSourceImpl(
            baseUrl: Uri.tryParse(environment.apiUrl)));
    locator
        .registerFactory<AccessTokenRepository>(() => AccessTokenRepositoryImpl(
              remoteDataSource: resolve(),
              dataSource: resolve(),
            ));
    locator.registerFactory<RefreshTokenRepository>(() =>
        RefreshTokenRepositoryImpl(
            remoteDataSource: resolve(), dataSource: resolve()));
    locator.registerFactory<Logout>(() => LogoutImpl(
        repository: resolve(),
        pendencyRepository: resolve<PendencyRepository>(),
        sessionRepository: resolve<SessionRepository>()));

    locator.registerFactory<LogMeOut>(() => LogMeOutImpl(
          accessTokenRepository: resolve(),
          sessionRepository: resolve(),
          meRepository: resolve(),
          db: database,
        ));
    locator.registerFactory<Authenticate>(() => AuthenticateImpl(
          repository: resolve(),
          authenticateFirebase: resolve(),
        ));
    locator.registerFactory<SwitchRoles>(() => SwitchRolesImpl(
          repository: resolve(),
          authenticateFirebase: resolve(),
        ));
    locator.registerFactory<RefreshToken>(() =>
        RefreshTokenImpl(repository: resolve(), authenticationBloc: resolve()));
    locator.registerFactory<DeleteAccount>(() => DeleteAccountImpl(
          repository: resolve(),
        ));
    locator.registerLazySingleton(() => AuthenticationBloc());

    locator.registerLazySingleton(
      () => AuthenticationStore(
        bloc: resolve(),
        authenticateUsecase: resolve(),
        logoutUsecase: resolve(),
        getToken: resolve(),
        switchRoles: resolve(),
        connectionController: resolve(),
        appOrigin: AppOriginEnum.owner,
      ),
    );

    //connection
    locator.registerFactory<ConnectionRemoteDataSource>(
      () => ConnectionRemoteDataSourceImpl(
        baseUrl: getBaseUrl(),
      ),
    );
    locator
        .registerFactory<ConnectionRepository>(() => ConnectionRepositoryImpl(
              remoteDataSource: resolve(),
            ));
    locator.registerFactory<ConnectionUseCase>(() => ConnectionUseCaseImpl(
          repository: resolve(),
        ));
    locator.registerLazySingleton(
      () => ConnectionController(
        connectionUseCase: resolve(),
      ),
    );

    //registration
    locator.registerFactory<RegistrationApi>(() => RegistrationApi.create(
          resolve(),
        ));
    locator.registerFactory<AwsUploader>(() => AwsUploaderImpl(
          getToken: resolve(),
          session: resolve(),
        ));
    locator.registerFactory<ProfilePictureRepository>(
        () => ProfilePictureRepositoryImpl(
              uploader: resolve(),
            ));
    locator.registerFactory<RegistrationRemoteDataSource>(
        () => RegistrationRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<RegistrationRepository>(
        () => RegistrationRepositoryImpl(
              dataSource: resolve(),
            ));
    locator.registerFactory<Register>(() => RegisterImpl(
          repository: resolve(),
        ));
    locator.registerFactory<GetMyUser>(() => GetMyUserImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<UploadProfilePicture>(() => UploadProfilePictureImpl(
              uploader: resolve(),
              sessionBloc: resolve(),
            ));
    locator.registerLazySingleton(() => RegistrationBloc());
    locator.registerLazySingleton(
      () => RegistrationStore(
        bloc: resolve(),
        requestValidationCode: resolve(),
        registerUsecase: resolve(),
        authenticate: resolve(),
        myUser: resolve(),
        sessionBloc: resolve<SessionBloc>(),
        uploadRegistrationPicture: resolve<UploadProfilePicture>(),
        getDados2faUseCase: resolve(),
        request2faUseCase: resolve(),
        validate2faUseCase: resolve(),
        idEmpresa: FlavorConfig.config.idEmpresa,
      ),
    );

    //code validation
    locator.registerFactory<CodeValidationApi>(() => CodeValidationApi.create(
          resolve(),
        ));

    locator.registerLazySingleton(() => CodeValidationBloc());
    locator.registerLazySingleton(
      () => CodeValidationStore(
        bloc: resolve(),
        validateCode: resolve(),
        requestValidationCode: resolve(),
        validate2fa: resolve(),
      ),
    );
    locator.registerFactory<CodeValidationRemoteDataSource>(
        () => CodeValidationRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<CodeValidationRepository>(
        () => CodeValidationRepositoryImpl(
              dataSource: resolve(),
            ));
    locator
        .registerFactory<RequestValidationCode>(() => RequestValidationCodeImpl(
              repository: resolve(),
            ));
    locator.registerFactory<ValidateCode>(() => ValidateCodeImpl(
          repository: resolve(),
        ));

    locator.registerFactory<GetDados2fa>(
        () => GetDados2faImpl(repository: resolve()));
    locator.registerFactory<Request2fa>(
        () => Request2faImpl(repository: resolve()));
    locator.registerFactory<Validate2fa>(
        () => Validate2faImpl(repository: resolve()));

    //me
    locator.registerFactory<MeApi>(() => MeApi.create(
          resolve(),
        ));
    locator.registerLazySingleton<MeDao>(() => database.meDao);
    locator.registerLazySingleton<LayoutDao>(() => database.layoutDao);
    locator
        .registerLazySingleton<CondominiumDao>(() => database.condominiumDao);
    locator.registerFactory<MeRepository>(() => MeRepositoryImpl(
          localDataSource: resolve(),
          remoteDataSource: resolve(),
          baseUrl: environment.apiUrl,
        ));
    locator.registerFactory<GetMe>(() => GetMeImpl(
          repository: resolve(),
        ));
    locator.registerFactory<SaveMe>(() => SaveMeImpl(
          repository: resolve(),
        ));
    locator.registerFactory<UpdatePasswordMe>(() => UpdatePasswordMeImpl(
          repository: resolve(),
        ));
    locator.registerFactory<MeLocalDataSource>(() => MeLocalDataSourceImpl(
          meDao: resolve(),
          condominiumDao: resolve(),
          condominiumBalanceDao: resolve(),
          condominiumBalanceDebitsDao: resolve(),
          condominiumBalanceDetailDao: resolve(),
          condominiumBalanceSummaryDao: resolve(),
          layoutDao: resolve(),
        ));
    locator.registerFactory<MeRemoteDataSource>(() => MeRemoteDataSourceImpl(
          api: resolve(),
          idEmpresa: FlavorConfig.config.idEmpresa,
        ));

    locator.registerFactory<MeBloc>(() => MeBloc());

    locator.registerLazySingleton(
      () => MeController(
        authenticationStore: resolve(),
        getMeUseCase: resolve(),
        logMeOut: resolve(),
        meBloc: resolve(),
        sessionBloc: resolve(),
        deleteUserUseCase: resolve(),
        getDados2faUseCase: resolve(),
        request2faUseCase: resolve(),
        saveMeUseCase: resolve(),
        updatePasswordMeUseCase: resolve(),
        uploadProfilePictureUseCase: resolve(),
        disableFcm: resolve(),
        getConsultantUseCase: resolve(),
      ),
    );

    // locator.registerFactory<MeDeleteBloc>(() => MeDeleteBloc());
    // locator.registerLazySingleton(
    //   () => MeDeleteController(
    //       deleteUserUseCase: resolve(), meDeleteBloc: resolve()),
    // );

    // locator.registerFactory<MeBloc>(() => MeBlocImpl(
    //       getMe: resolve(),
    //       sessionBloc: resolve(),
    //       logMeOut: resolve(),
    //       requestValidationCode: resolve(),
    //       saveMe: resolve(),
    //       uploadProfilePicture: resolve(),
    //       updatePasswordMe: resolve(),
    //       authenticationBloc: resolve(),
    //       deleteUser: resolve(),
    //     ));

    //session
    locator.registerFactory<SessionLocalDataSource>(
        () => SessionLocalDataSourceImpl());
    locator.registerFactory<SessionRepository>(() => SessionRepositoryImpl(
          sessionDataSource: resolve(),
        ));
    locator.registerFactory<LoadSession>(() => LoadSessionImpl(
          getMe: resolve(),
          repository: resolve(),
        ));
    locator.registerFactory<SaveSession>(() => SaveSessionImpl(
          repository: resolve(),
        ));
    locator.registerLazySingleton<SessionBloc>(() => SessionBlocImpl(
          authenticationStore: resolve(),
          loadSession: resolve(),
          saveSesion: resolve(),
          switchRoles: resolve(),
        ));

    //pendency
    locator.registerFactory<PendencyApi>(() => PendencyApi.create(
          resolve(),
        ));
    locator.registerLazySingleton<PendencyDao>(() => database.pendencyDao);
    locator.registerFactory<PendencyLocalDataSource>(
        () => PendencyLocalDataSourceImpl(
              dao: resolve(),
            ));
    locator.registerFactory<PendencyRemoteDataSource>(
        () => PendencyRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<PendencyRepository>(() => PendencyRepositoryImpl(
          localDataSource: resolve(),
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<ListPendency>(() => ListPendencyImpl(
          repository: resolve(),
        ));
    locator.registerFactory<UpdatePendency>(() => UpdatePendencyImpl(
          repository: resolve(),
        ));
    locator.registerFactory<GetPendency>(() => GetPendencyImpl(
          repository: resolve(),
        ));

    //dashboard
    locator.registerLazySingleton<DashboardBloc>(() => DashboardBlocImpl(
          listPendency: resolve(),
          sessionBloc: resolve(),
          updatePendency: resolve(),
        ));

    //BANNERS
    locator.registerFactory<BannersApi>(() => BannersApi.create(resolve()));
    locator.registerFactory<BannersBloc>(() => BannersBloc());
    locator.registerLazySingleton(() => BannersController(
        appOriginEnum: AppOriginEnum.manager,
        bloc: resolve(),
        getBannersUseCase: resolve(),
        sessionBloc: resolve<SessionBloc>(),
        expireCache: environment.isProduction
            ? ExpireCache.banners
            : ExpireCache.bannersHomolog));
    locator.registerFactory<BannersLocalDataSource>(
        () => BannersLocalDataSourceImpl(
              argsDao: resolve(),
              bannersDao: resolve(),
            ));
    locator.registerLazySingleton<BannersDao>(() => BannersDao());
    locator.registerLazySingleton<BannersArgsDao>(() => BannersArgsDao());
    locator.registerFactory<BannersRemoteDataSource>(
        () => BannersRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<BannersRepository>(() => BannersRepositoryImpl(
          remoteDataSource: resolve(),
          localDataSource: resolve(),
        ));
    locator.registerFactory<GetBannersUseCase>(
        () => GetBannersUseCaseImpl(repository: resolve()));

    // notifications
    locator.registerFactory<NotificationsApi>(
        () => NotificationsApi.create(resolve()));
    locator.registerFactory<NotificationsRemoteDataSource>(
        () => NotificationsRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<NotificationsRepository>(
        () => NotificationsRepositoryImpl(remoteDataSource: resolve()));

    locator.registerLazySingleton(() => NotificationListBloc());
    locator.registerLazySingleton(() => NotificationController(
          bloc: resolve<NotificationListBloc>(),
          sessionBloc: resolve<SessionBloc>(),
          getNotifications: resolve(),
          markAllReadNotificationUseCase: resolve(),
          deleteAllReadNotificationUseCase: resolve(),
          deleteNotificationUseCase: resolve(),
          readNotifications: resolve(),
          notificationResumeUseCase: resolve(),
          appOriginEnum: AppOriginEnum.manager,
        ));
    locator.registerFactory<GetNotifications>(
        () => GetNotificationsImpl(repository: resolve()));
    locator.registerFactory<ReadNotification>(
        () => ReadNotificationsImpl(repository: resolve()));
    locator.registerFactory<MarkAllReadNotification>(
        () => MarkAllReadNotificationImpl(repository: resolve()));
    locator.registerFactory<DeleteAllReadNotification>(
        () => DeleteAllReadNotificationImpl(repository: resolve()));
    locator.registerFactory<DeleteNotification>(
        () => DeleteNotificationImpl(repository: resolve()));
    locator.registerFactory<NotificationResume>(
        () => NotificationResumeImpl(repository: resolve()));
    locator.registerFactory<SendPushCallback>(
        () => SendPushCallbackImpl(repository: resolve()));

    //COMFORT
    locator.registerFactory<ComfortApi>(() => ComfortApi.create(resolve()));
    locator
        .registerFactory<ComfortMyRequestsBloc>(() => ComfortMyRequestsBloc());
    locator.registerLazySingleton(
      () => ComfortMyRequestsController(
          comfortMyRequestsBloc: resolve(),
          getMyRequestsUseCase: resolve(),
          changePartnerFavoriteStatusUseCase: resolve(),
          postRateRequestUseCase: resolve(),
          resendRequestUseCase: resolve(),
          subcategoriesUseCase: resolve(),
          sessionBloc: resolve<SessionBloc>(),
          getToken: resolve(),
          appOriginEnum: AppOriginEnum.manager),
    );
    locator.registerFactory<ComfortPartnersBloc>(() => ComfortPartnersBloc());
    locator.registerFactory<ComfortPartnerCouponsBloc>(
        () => ComfortPartnerCouponsBloc());
    locator.registerLazySingleton(() => ComfortPartnersController(
          comfortPartnersBloc: resolve(),
          comfortPartnerCouponsBloc: resolve(),
          getAllPartnersUseCase: resolve(),
          getPartnerCouponsUseCase: resolve(),
          getPartnerIsFavoriteUseCase: resolve(),
          findRequestPurchaseUseCase: resolve(),
          changePartnerFavoriteStatusUseCase: resolve(),
          createCouponRequestUseCase: resolve(),
          postRateRequestUseCase: resolve(),
          requestPartnersUseCase: resolve(),
          getToken: resolve(),
          appOriginEnum: AppOriginEnum.manager,
          sessionBloc: resolve<SessionBloc>(),
        ));
    locator.registerFactory<ComfortPartnerReviewsBloc>(
        () => ComfortPartnerReviewsBloc());
    locator.registerLazySingleton(
      () => ComfortPartnerReviewsController(
          getAllPartnerReviewsUseCase: resolve(),
          sessionBloc: resolve<SessionBloc>(),
          appOriginEnum: AppOriginEnum.manager,
          comfortPartnerReviewsBloc: resolve()),
    );

    locator.registerFactory<ComfortMyRequestItemActionsBloc>(
        () => ComfortMyRequestItemActionsBloc());
    locator.registerFactory<ComfortMyRequestItemActionsController>(
        () => ComfortMyRequestItemActionsController(
              sessionBloc: resolve<SessionBloc>(),
              resendRequestUseCase: resolve(),
              cancelRequestUseCase: resolve(),
              updateRequestUseCase: resolve(),
              appOriginEnum: AppOriginEnum.manager,
              bloc: resolve(),
            ));

    locator.registerFactory<ComfortRemoteDataSource>(
        () => ComfortRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<ComfortRepository>(() => ComfortRepositoryImpl(
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<RequestPartnersUseCase>(
        () => RequestPartnersUseCaseImpl(repository: resolve()));
    locator.registerFactory<GetPartnerCouponsUseCase>(
        () => GetPartnerCouponsUseCaseImpl(repository: resolve()));
    locator.registerFactory<GetAllPartnersUseCase>(
        () => GetAllPartnersUseCaseImpl(repository: resolve()));
    locator.registerFactory<GetPartnerIsFavoriteUseCase>(
        () => GetPartnerIsFavoriteUseCaseImpl(repository: resolve()));
    locator.registerFactory<GetMyRequestsUseCase>(
        () => GetMyRequestsUseCaseImpl(repository: resolve()));
    locator.registerFactory<ChangePartnerFavoriteStatusUseCase>(
        () => ChangePartnerFavoriteStatusUseCaseImpl(repository: resolve()));
    locator.registerFactory<CreateCouponRequestUseCase>(
        () => CreateCouponRequestUseCaseImpl(repository: resolve()));
    locator.registerFactory<SendReviewRequestUseCase>(
        () => SendReviewRequestUseCaseImpl(repository: resolve()));
    locator.registerFactory<FindRequestPurchaseUseCase>(
        () => FindRequestPurchaseUseCaseImpl(repository: resolve()));
    locator.registerFactory<GetAllPartnerReviewsUseCase>(
        () => GetAllPartnerReviewsUseCaseImpl(repository: resolve()));
    locator.registerFactory<ResendRequestUseCase>(
        () => ResendRequestUseCaseImpl(repository: resolve()));
    locator.registerFactory<CancelRequestUseCase>(
        () => CancelRequestUseCaseImpl(repository: resolve()));
    locator.registerFactory<UpdateRequestUseCase>(
        () => UpdateRequestUseCaseImpl(repository: resolve()));
    locator.registerFactory<GetSubcategoriesUseCase>(
        () => GetSubcategoriesUseCaseImpl(repository: resolve()));

    //sliverNotificationsPreferencesRemoteDataSource
    locator.registerFactory<HomeSliverAppBarBloc>(
        () => HomeSliverAppBarBlocImpl());

    //home

    locator.registerLazySingleton(
      () => HomeAnalyticsTimerController(
        sessionBloc: resolve(),
      ),
    );
    locator.registerFactory<RegisterFcm>(() => RegisterFcmImpl(
          repository: resolve(),
        ));
    locator.registerFactory<HomeBloc>(() => HomeBlocImpl(
          registerFcm: resolve(),
          sessionBloc: resolve(),
          deviceIdentifierService: resolve(),
        ));
    locator.registerFactory<HomeDialogBloc>(() => HomeDialogBlocImpl(
          sessionBloc: resolve(),
        ));

    locator.registerLazySingleton(() => DeviceIdentifierService());

    //access management

    locator.registerFactory<GetImageFromCameraViewPickerUsecase>(
        () => GetImageFromCameraViewPickerUsecase());
    locator
        .registerFactory<AccessManagementApi>(() => AccessManagementApi.create(
              resolve(),
            ));
    locator.registerFactory<AccessManagementRemoteDataSource>(
        () => AccessManagementRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<AccessManagementRepository>(
        () => AccessManagementRepositoryImpl(
              dataSource: resolve(),
              uploader: resolve(),
            ));

    locator.registerFactory<AccessManagementCheckServiceCase>(
        () => AccessManagementCheckServiceCaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<FacialBiometricUsecase>(
        () => FacialBiometricUsecaseImpl(
              repository: resolve(),
              awsUploadFileUsecase: resolve(),
            ));
    locator.registerFactory<SendInviteUsecase>(() => SendInviteUsecaseImpl(
          repository: resolve(),
        ));
    locator.registerFactory<AccessManagementBloc>(() => AccessManagementBloc());
    locator.registerLazySingleton(
      () => AccessManagementController(
        accessManagementBloc: resolve(),
        checkServiceCase: resolve(),
        sessionBloc: resolve(),
        facialBiometric: resolve(),
        getImageFromCameraViewPickerUsecase: resolve(),
      ),
    );

    locator.registerFactory<PreferencesHomeCardsBloc>(
        () => PreferencesHomeCardsBloc());
    locator.registerLazySingleton(() => PreferencesHomeCardsController(
          sessionBloc: resolve<SessionBloc>(),
          bloc: resolve(),
        ));
    //AWS
    locator.registerFactory<AwsUploadFileUsecase>(
        () => AwsUploadFileUsecaseImpl());

    locator.registerFactory<DisableFcm>(() => DisableFcmImpl(
          repository: resolve(),
          accessTokenRepository: resolve(),
        ));

    //payment approval
    locator.registerFactory<PaymentApprovalApi>(() => PaymentApprovalApi.create(
          resolve(),
        ));
    locator.registerFactory<PaymentApprovalRemoteDataSource>(
        () => PaymentApprovalRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<PaymentApprovalRepository>(
        () => PaymentApprovalRepositoryImpl(
              dataSource: resolve(),
            ));
    locator.registerFactory<RegisterPaymentApproval>(
        () => RegisterPaymentApprovalImpl(
              repository: resolve(),
            ));
    locator.registerFactory<PaymentApprovalBloc>(() => PaymentApprovalBlocImpl(
          requestValidationCode: resolve(),
          sessionBloc: resolve(),
          listAccounts: resolve(),
          registerPaymentApproval: resolve(),
        ));

    //reset password
    locator.registerFactory<PasswordResetApi>(() => PasswordResetApi.create(
          resolve(),
        ));
    locator.registerFactory<PasswordResetRemoteDataSource>(
        () => PasswordResetRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<PasswordResetRepository>(
        () => PasswordResetRepositoryImpl(
              dataSource: resolve(),
            ));
    locator.registerFactory<ResetPassword>(() => ResetPasswordImpl(
          repository: resolve(),
        ));
    locator.registerFactory<ResetPassword2fa>(
        () => ResetPassword2faImpl(repository: resolve()));
    locator.registerFactory<ResetPasswordBloc>(() => ResetPasswordBloc());
    locator.registerLazySingleton(
      () => ResetPasswordController(
        resetPasswordBloc: resolve(),
        requestValidationCodeUseCase: resolve(),
        resetPasswordUseCase: resolve(),
        myUserUseCase: resolve(),
        loginStore: resolve(),
        getDados2faUseCase: resolve(),
        request2faUseCase: resolve(),
        validate2faUseCase: resolve(),
        resetPassword2fa: resolve(),
        idEmpresa: FlavorConfig.config.idEmpresa,
      ),
    );
    //condominium balance
    locator.registerLazySingleton<CondominiumBalanceDao>(
        () => database.condominiumBalanceDao);
    locator.registerLazySingleton<CondominiumBalanceDetailDao>(
        () => database.condominiumBalanceDetailDao);
    locator.registerLazySingleton<CondominiumBalanceDebitsDao>(
        () => database.condominiumBalanceDebitsDao);
    locator.registerLazySingleton<CondominiumBalanceSummaryDao>(
        () => database.condominiumBalanceSummaryDao);
    locator.registerFactory<CondominiumBalanceApi>(
        () => CondominiumBalanceApi.create(
              resolve(),
            ));
    locator.registerFactory<CondominiumBalanceRemoteDataSource>(
        () => CondominiumBalanceRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<CondominiumBalanceLocalDataSource>(
        () => CondominiumBalanceLocalDataSourceImpl(
              condominiumBalanceDao: resolve(),
            ));
    locator.registerFactory<CondominiumBalanceDetailLocalDataSource>(
        () => CondominiumBalanceDetailLocalDataSourceImpl(
              condominiumBalanceDetailDao: resolve(),
              condominiumBalanceDebitsDao: resolve(),
              condominiumBalanceSummaryDao: resolve(),
            ));
    locator.registerFactory<CondominiumBalanceRepository>(
        () => CondominiumBalanceRepositoryImpl(
              remoteDataSource: resolve(),
              localDataSource: resolve(),
            ));
    locator.registerFactory<CondominiumBalanceDetailRepository>(
        () => CondominiumBalanceDetailRepositoryImpl(
              remoteDataSource: resolve(),
              localDataSource: resolve(),
            ));
    locator.registerFactory<BalanceDetailBloc>(() => BalanceDetailBlocImpl(
          sessionBloc: resolve(),
          loadCondominiumBalanceDetail: resolve(),
        ));
    locator.registerFactory<LoadCondominiumBalanceDetail>(
        () => LoadCondominiumBalanceDetailImpl(
              repository: resolve(),
            ));
    locator.registerFactory<LoadCondominiumBalance>(
        () => LoadCondominiumBalanceImpl(
              repository: resolve(),
            ));
    locator.registerFactory<CondominiumBalanceBloc>(
        () => CondominiumBalanceBlocImpl(
              loadCondominiumBalance: resolve(),
              sessionBloc: resolve(),
            ));

    locator.registerLazySingleton<MaintenanceManagementBloc>(
      () => MaintenanceManagementBlocImpl(
        resolve(),
        resolve(),
        resolve(),
      ),
    );
    locator.registerLazySingleton<MaintenanceManagementCurrentWeekBloc>(
      () => MaintenanceManagementCurrentWeekBlocImpl(
        resolve(),
      ),
    );

    locator.registerFactory<MaintenanceManagementLastWeekBloc>(
      () => MaintenanceManagementLastWeekBlocImpl(
        resolve(),
      ),
    );

    //accounts
    locator.registerLazySingleton<AccountDao>(() => database.accountDao);
    locator.registerFactory<AccountApi>(() => AccountApi.create(
          resolve(),
        ));
    locator.registerFactory<AccountLocalDataSource>(
        () => AccountLocalDataSourceImpl(
              dao: resolve(),
            ));
    locator.registerFactory<AccountRemoteDataSource>(
        () => AccountRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<AccountRepository>(() => AccountRepositoryImpl(
          localDataSource: resolve(),
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<ListAccounts>(() => ListAccountsImpl(
          repository: resolve(),
        ));

    //payment
    locator.registerFactory<PaymentApi>(() => PaymentApi.create(
          resolve(),
        ));
    locator.registerFactory<PaymentProcessFileRemoteDataSource>(
        () => PaymentProcessFileRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<PaymentProcessFileRepository>(
        () => PaymentProcessFileRepositoryImpl(
              awsUploader: resolve(),
              dataSource: resolve(),
            ));
    locator
        .registerFactory<FindPaymentByBarcode>(() => FindPaymentByBarcodeImpl(
              repository: resolve(),
            ));
    locator
        .registerFactory<AwsGetUrl>(() => AwsGetUrlImpl(repository: resolve()));
    locator.registerFactory<UploadDocuments>(() => UploadDocumentsImpl(
          repository: resolve(),
        ));
    locator.registerFactory<SendDocuments>(() => SendDocumentsImpl(
          repository: resolve(),
        ));
    locator.registerFactory<RegisterPayment>(() => RegisterPaymentImpl(
          repository: resolve(),
        ));
    locator.registerFactory<GetPayment>(() => GetPaymentImpl(
          repository: resolve(),
        ));
    locator.registerFactory<GetInstallments>(() => GetInstallmentsImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<PaymentFileRepository>(() => PaymentFileRepositoryImpl(
              uploader: resolve(),
            ));
    locator.registerFactory<UploadPaymentFile>(() => UploadPaymentFileImpl(
          uploader: resolve(),
        ));
    locator.registerLazySingleton(
      () => PaymentRegistrationController(
        getUrlUseCase: resolve(),
        uploadDocumentsUseCase: resolve(),
        sendDocumentsUseCase: resolve(),
        bloc: resolve(),
        sessionBloc: resolve(),
        getToken: resolve(),
      ),
    );
    locator.registerLazySingleton<PaymentSendDocumentBloc>(
        () => PaymentSendDocumentBloc());
    locator.registerLazySingleton<PaymentRemoteDataSource>(
        () => PaymentRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<PaymentRepository>(() => PaymentRepositoryImpl(
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<ListPayment>(() => ListPaymentImpl(
          repository: resolve(),
        ));
    locator.registerLazySingleton(() => PaymentPendencyListBloc());
    locator.registerLazySingleton(() => PaymentListBloc());
    locator.registerLazySingleton(() => PendencyBloc());
    locator.registerLazySingleton(() => CheckTokenBloc());
    locator.registerLazySingleton(
      () => PaymentPendencyController(
        listPaymentUsecase: resolve(),
        getInstallmentUsecase: resolve(),
        getInstallmentInApprovalUsecase: resolve(),
        getSupplierUseCase: resolve(),
        getLedgerAccountsUseCase: resolve(),
        getContasPagarUseCase: resolve(),
        sendTokenUseCase: resolve(),
        checkTokenUseCase: resolve(),
        checkApprovalProfileUseCase: resolve(),
        updateInstallmentsUseCase: resolve(),
        updateLedgerAccountUseCase: resolve(),
        loadCondominiumBalanceUseCase: resolve(),
        sessionBloc: resolve(),
        listBloc: resolve(),
        detailsBloc: resolve(),
        validationMethodBloc: resolve(),
        checkTokenBloc: resolve(),
        paymentListBloc: resolve(),
      ),
    );

    locator.registerFactory<ListPaymentHistory>(() => ListPaymentHistoryImpl(
          repository: resolve(),
        ));
    locator.registerLazySingleton<PaymentHistoryListBloc>(
        () => PaymentHistoryListBloc());
    locator.registerLazySingleton(
      () => PaymentHistoryController(
        listPaymentHistoryUseCase: resolve(),
        sessionBloc: resolve(),
        bloc: resolve(),
      ),
    );

    locator.registerFactory<GetSupplier>(() => GetSupplierImpl(
          repository: resolve(),
        ));

    locator.registerFactory<GetLedgerAccounts>(() => GetLedgerAccountsImpl(
          repository: resolve(),
        ));

    locator.registerFactory<GetInstallmentsInApproval>(
        () => GetInstallmentsInApprovalImpl(repository: resolve()));

    locator.registerFactory<SendToken>(() => SendTokenImpl(
          repository: resolve(),
        ));

    locator.registerFactory<CheckToken>(
        () => CheckTokenImpl(repository: resolve()));

    locator.registerFactory<ContasPagar>(() => ContasPagarImpl(
          repository: resolve(),
        ));

    locator.registerFactory<UpdateInstallments>(() => UpdateInstallmentsImpl(
          repository: resolve(),
        ));

    locator.registerFactory<UpdateLedgerAccount>(() => UpdateLedgerAccountImpl(
          repository: resolve(),
        ));

    locator.registerFactory<CheckApprovalProfile>(
        () => CheckApprovalProfileImpl(repository: resolve()));

    locator.registerFactory<FindSupplier>(() => FindSupplierImpl(
          repository: resolve(),
        ));

    locator.registerFactory<PaymentSearchSupplierListBloc>(
        () => PaymentSearchSupplierListBloc());

    locator.registerFactory<ValidationMethodBloc>(() => ValidationMethodBloc());

    locator.registerFactory(
      () => PaymentSearchSupplierController(
        resolve(),
        resolve(),
        resolve(),
        resolve(),
      ),
    );

    locator.registerFactory<PaymentSendFinancialDepartmentListBloc>(
        () => PaymentSendFinancialDepartmentListBloc());

    locator.registerFactory<SendPayment>(() => SendPaymentImpl(
          repository: resolve(),
        ));
    locator.registerFactory(
      () => PaymentSendFinancialDepartmentController(resolve(),
          sessionBloc: resolve(), bloc: resolve(), getToken: resolve()),
    );
    locator.registerFactory<RegisterInstallmentsBloc>(
        () => RegisterInstallmentsBloc());

    locator.registerFactory(
      () => RegisterInstallmentsController(
        sessionBloc: resolve(),
        bloc: resolve(),
        getResinBanksUseCase: resolve(),
      ),
    );

    locator.registerFactory<RegisterLedgerAccountController>(
        () => RegisterLedgerAccountController(resolve()));

    locator.registerFactory<PaymentLedgerAccountBalanceDataSource>(
        () => PaymentLedgerAccountBalanceDatasourceImpl(
              resolve(),
            ));

    locator.registerFactory<PaymentLedgerAccountBalanceRepository>(
        () => PaymentLedgerAccountBalanceRepositoryImpl(
              resolve(),
            ));

    locator.registerFactory<GetLedgerAccountBalance>(
        () => GetLedgerAccountBalanceImpl(
              resolve(),
            ));

    locator.registerFactory<RegisterFormPageBloc>(() => RegisterFormPageBloc());

    locator.registerFactory(
      () => RegisterFormPageController(
          resolve(), resolve(), resolve(), resolve()),
    );

    locator.registerFactory(() => SendPaymentController(
          bloc: resolve(),
          sendPaymentUseCase: resolve(),
          sessionBloc: resolve(),
        ));

    locator.registerFactory<SendPaymentBloc>(() => SendPaymentBloc());
    //units
    locator.registerLazySingleton<UnitDao>(() => database.unitDao);
    locator.registerFactory<UnitApi>(() => UnitApi.create(
          resolve(),
        ));
    locator.registerFactory<UnitLocalDataSource>(() => UnitLocalDataSourceImpl(
          dao: resolve(),
        ));
    locator
        .registerFactory<UnitRemoteDataSource>(() => UnitRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<UnitRepository>(() => UnitRepositoryImpl(
          localDataSource: resolve(),
          remoteDataSource: resolve(),
        ));
    locator.registerLazySingleton(() => ListUnitSimpleUsecase(
          repository: resolve(),
        ));
    locator.registerLazySingleton(() => ListUnitsUsecase(
          repository: resolve(),
        ));
    locator.registerFactory<ListUnitResident>(() => ListUnitResidentImpl(
          repository: resolve(),
        ));
    locator.registerLazySingleton<GetSimpleCondominiumUsecase>(
      () => GetSimpleCondominiumUsecaseImpl(
        repository: resolve(),
      ),
    );
    locator.registerLazySingleton<CondominiumSimpleRepository>(
      () => CondominiumSimpleRepositoryImpl(
        dataSource: resolve(),
      ),
    );
    locator.registerLazySingleton<CondominiumSimpleRemoteDataSource>(
      () => CondominiumSimpleRemoteDataSourceImpl(
        api: resolve(),
      ),
    );
    locator.registerLazySingleton(() => UnitsController(
          getSimpleCondominiumUsecase: resolve(),
          listUnitSimpleUsecase: resolve(),
          listUnitsUsecase: resolve(),
          sessionBloc: resolve(),
          unitsBloc: resolve(),
        ));
    locator.registerLazySingleton(() => UnitsBloc());
    locator.registerLazySingleton(
      () => VehicleApi.create(
        resolve(),
      ),
    );
    locator.registerLazySingleton<VehicleRemoteDataSource>(
      () => VehicleRemoteDataSourceImpl(
        api: resolve(),
      ),
    );
    locator.registerLazySingleton<VehicleRepository>(
      () => VehicleRepositoryImpl(
        remoteDataSource: resolve(),
      ),
    );
    locator.registerLazySingleton(
      () => GetVehiclesUsecase(
        repository: resolve(),
      ),
    );
    locator.registerLazySingleton(
      () => UnitDetailsController(
        sessionBloc: resolve(),
        getVehiclesUsecase: resolve(),
        vehiclesBloc: resolve(),
      ),
    );
    locator.registerFactory<UnitDetailBloc>(() => UnitDetailBlocImpl(
          listUnitResident: resolve(),
          sendInvite: resolve(),
        ));
    locator.registerLazySingleton(() => VehiclesBloc());
    //residents
    locator.registerLazySingleton<ResidentDao>(() => database.residentDao);
    locator.registerFactory<ResidentApi>(() => ResidentApi.create(
          resolve(),
        ));
    locator.registerFactory<ResidentLocalDataSource>(
        () => ResidentLocalDataSourceImpl(
              dao: resolve(),
            ));
    locator.registerFactory<ResidentRemoteDataSource>(
        () => ResidentRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory(() => ResidentsBloc());
    locator.registerLazySingleton(
      () => ResidentsController(
        useCaseListResidents: resolve(),
        residentsBloc: resolve(),
        sessionBloc: resolve(),
      ),
    );
    locator.registerFactory<ResidentRepository>(() => ResidentRepositoryImpl(
          localDataSource: resolve(),
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<ListResidents>(() => ListResidentsImpl(
          repository: resolve(),
        ));

    //billets
    locator.registerFactory<GetUnitsByBilletsUseCase>(
        () => GetUnitsByBilletsUseCaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<GetBilletPeriodAvailabilityUseCase>(
        () => GetBilletPeriodAvailabilityUseCaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<BilletsApi>(() => BilletsApi.create(
          resolve(),
        ));
    locator.registerFactory<GetBillets>(() => GetBilletsImpl(
          repository: resolve(),
        ));

    locator.registerLazySingleton(() => BilletsBloc());
    locator.registerFactory(
      () => BilletsController(
        billetsBloc: resolve(),
        getUnitsByBilletsUseCase: resolve(),
        sessionBloc: resolve(),
        getBilletPeriodAvailabilityUseCase: resolve(),
      ),
    );
    locator.registerLazySingleton(() => DownloadBilletUsecase(
          repository: resolve(),
        ));
    locator.registerLazySingleton(
      () => BilletsDetailsController(
        getBillets: resolve(),
        sessionBloc: resolve(),
        downloadBilletUsecase: resolve(),
        bloc: resolve(),
      ),
    );
    locator.registerLazySingleton<BilletsDetailBloc>(() => BilletsDetailBloc());
    locator.registerFactory<BilletsRemoteDataSource>(
        () => BilletsRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<BilletsRepository>(() => BilletsRepositoryImpl(
          remoteDataSource: resolve(),
        ));

    //income dashboard
    locator.registerLazySingleton(
      () => IncomeDashboardController(
          sessionBloc: resolve(),
          incomeDashboardBloc: resolve(),
          getMonthlyIncome: resolve()),
    );
    locator.registerLazySingleton(() => IncomeDashboardBloc());
    locator.registerLazySingleton<IncomeDao>(() => database.incomeDao);
    locator
        .registerFactory<IncomeLocalDataSource>(() => IncomeLocalDataSourceImpl(
              dao: resolve(),
            ));
    locator.registerFactory<IncomeRemoteDataSource>(
        () => IncomeRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<IncomeApi>(() => IncomeApi.create(
          resolve(),
        ));
    locator.registerFactory<IncomeRepository>(() => IncomeRepositoryImpl(
          localDataSource: resolve(),
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<GetIncome>(() => GetIncomeImpl(
          repository: resolve(),
        ));

    //accountability
    locator.registerFactory<AccountabilityApi>(() => AccountabilityApi.create(
          resolve(),
        ));
    locator.registerFactory<AccountabilityRemoteDataSource>(
        () => AccountabilityRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<AccountabilityRepository>(
        () => AccountabilityRepositoryImpl(
              dataSource: resolve(),
            ));
    locator.registerFactory(() => GetAccountabilityUsecase(
          repository: resolve(),
        ));
    locator.registerLazySingleton(() => GetAccountabilityQuestionUsecase(
          repository: resolve(),
        ));
    locator.registerLazySingleton(
      () => ListAccountabilityDoubtUsecase(
        repository: resolve(),
      ),
    );
    locator.registerLazySingleton(() => SendAccountabilityQuestionUsecase(
          repository: resolve(),
        ));
    locator.registerLazySingleton(() => ApproveRecommendationUsecase(
          repository: resolve(),
        ));
    locator.registerLazySingleton(
      () => AccountabilityDetailController(
        bloc: resolve(),
        approveRecommendationUsecase: resolve(),
        getAccountabilityUsecase: resolve(),
      ),
    );
    locator.registerFactory<AccountabilityDetailBloc>(
        () => AccountabilityDetailBloc());
    locator.registerLazySingleton(
      () => QuestionListController(
        sessionBloc: resolve(),
        listAccountabilityDoubtUsecase: resolve(),
        bloc: resolve(),
        baseUrl: environment.apiUrl,
      ),
    );
    locator.registerFactory(() => QuestionListBloc());
    locator.registerLazySingleton(
      () => QuestionCreateController(
        getAccountabilityQuestionUsecase: resolve(),
        sendAccountabilityQuestionUsecase: resolve(),
        bloc: resolve(),
        sessionBloc: resolve(),
      ),
    );
    locator.registerLazySingleton(() => QuestionCreateBloc());
    locator.registerFactory(
      () => AccountabilityApprovalController(
        bloc: resolve(),
        approveAccountabilityUsecase: resolve(),
        sessionBloc: resolve(),
      ),
    );
    locator.registerFactory<AccountabilityApprovalBloc>(
        () => AccountabilityApprovalBloc());
    locator.registerFactory<AccountabilityApprovalApi>(
        () => AccountabilityApprovalApi.create(
              resolve(),
            ));
    locator.registerFactory<AccountabilityApprovalRemoteDataSource>(
        () => AccountabilityApprovalRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<AccountabilityApprovalRepository>(
        () => AccountabilityApprovalRepositoryImpl(
              dataSource: resolve(),
            ));
    locator.registerFactory(
      () => ApproveAccountabilityUsecase(
        repository: resolve(),
      ),
    );
    locator.registerLazySingleton(
      () => AccountabilityController(
        bloc: resolve(),
        sessionBloc: resolve(),
        getAccountabilityPeriodUsecase: resolve(),
      ),
    );
    locator.registerFactory(() => AccountabilityBloc());
    locator.registerFactory(
      () => GetAccountabilityPeriodUsecase(
        repository: resolve(),
      ),
    );
    //non payments
    locator.registerFactory<NonPaymentsBloc>(() => NonPaymentsBloc());
    locator.registerLazySingleton(
      () => NonPaymentController(
        sessionBloc: resolve(),
        getNonPaymentsUseCase: resolve(),
        nonPaymentsBloc: resolve(),
      ),
    );

    locator.registerFactory<GetNonPayments>(() => GetNonPaymentsImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<NonPaymentsRepository>(() => NonPaymentsRepositoryImpl(
              remoteDataSource: resolve(),
            ));
    locator.registerFactory<NonPaymentsRemoteDataSource>(
        () => NonPaymentsRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<NonPaymentsApi>(() => NonPaymentsApi.create(
          resolve(),
        ));

    // //question
    // locator.registerFactory<QuestionRemoteDataSource>(
    //     () => QuestionRemoteDataSourceImpl(
    //           api: resolve(),
    //         ));
    // locator.registerFactory<QuestionApi>(() => QuestionApi.create(
    //       resolve(),
    //     ));
    // locator.registerFactory<QuestionBloc>(() => QuestionBlocImpl(
    //       createQuestion: resolve(),
    //       sessionBloc: resolve(),
    //       loadTypes: resolve(),
    //     ));
    // locator.registerFactory<QuestionsBloc>(() => QuestionsBlocImpl(
    //       loadQuestion: resolve(),
    //       sessionBloc: resolve(),
    //     ));
    // locator.registerFactory<QuestionDetailBloc>(() => QuestionDetailBlocImpl(
    //       getQuestion: resolve(),
    //       sessionBloc: resolve(),
    //     ));
    // locator.registerFactory<LoadQuestion>(() => LoadQuestionImpl(
    //       repository: resolve(),
    //     ));
    // locator.registerFactory<GetQuestion>(() => GetQuestionImpl(
    //       repository: resolve(),
    //     ));
    // locator.registerFactory<LoadTypeQuestion>(() => LoadTypeQuestionImpl(
    //       repository: resolve(),
    //     ));
    // locator.registerFactory<QuestionRepository>(() => QuestionRepositoryImpl(
    //       remoteDataSource: resolve(),
    //     ));
    // locator.registerFactory<CreateQuestion>(() => CreateQuestionImpl(
    //       repository: resolve(),
    //     ));

    //employee
    locator.registerFactory<EmployeeApi>(() => EmployeeApi.create(
          resolve(),
        ));
    locator.registerFactory<ListEmployee>(() => ListEmployeeImpl(
          repository: resolve(),
        ));
    locator.registerFactory<EmployeeLocalDataSource>(
        () => EmployeeLocalDataSourceImpl(
              dao: resolve(),
            ));
    locator.registerFactory<EmployeeRemoteDataSource>(
        () => EmployeeRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<EmployeeRepository>(() => EmployeeRepositoryImpl(
          localDataSource: resolve(),
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<EmployeeListBloc>(() => EmployeeListBlocImpl(
          sessionBloc: resolve(),
          listEmployee: resolve(),
        ));
    locator.registerFactory<GetEmployee>(() => GetEmployeeImpl(
          repository: resolve(),
        ));
    locator.registerFactory<EmployeeBloc>(() => EmployeeBlocImpl(
          sessionBloc: resolve(),
          getEmployee: resolve(),
          sendInviteCase: resolve(),
        ));
    locator.registerLazySingleton<EmployeeDao>(() => database.employeeDao);

    //gdp - quick fix
    locator.registerFactory<EmployeeReportApi>(() => EmployeeReportApi.create(
          resolve(),
        ));
    locator.registerFactory<EmployeeReportRemoteDataSource>(
        () => EmployeeReportRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<EmployeeReportRepository>(
        () => EmployeeReportRepositoryImpl(
              remoteDataSource: resolve(),
            ));
    locator.registerFactory<GetEmployeeReport>(() => GetEmployeeReportImpl(
          repository: resolve(),
        ));
    locator.registerFactory<QuickFixBloc>(() => QuickFixBlocImpl(
          sessionBloc: resolve(),
          listEmployee: resolve(),
        ));
    locator.registerFactory<QuickFixReportBloc>(() => QuickFixReportBlocImpl(
          sessionBloc: resolve(),
          getEmployeeReport: resolve(),
        ));

    //gdp - timesheet
    locator.registerFactory<TimesheetApi>(() => TimesheetApi.create(
          resolve(),
        ));
    locator.registerFactory<TimesheetRemoteDataSource>(
        () => TimesheetRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<TimesheetRepository>(() => TimesheetRepositoryImpl(
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<GetMonthResume>(() => GetMonthResumeImpl(
          repository: resolve(),
        ));
    locator.registerFactory<TimesheetMenuBloc>(() => TimesheetMenuBlocImpl(
          sessionBloc: resolve(),
          monthResume: resolve(),
          getTimesheetPeriods: resolve(),
        ));

    locator.registerLazySingleton(() => TimesheetDayAppointmentsBloc());

    locator.registerFactory<GetDayAppointments>(() => GetDayAppointmentsImpl(
          repository: resolve(),
        ));
    locator.registerLazySingleton(() => DayAppointmentsController(
          bloc: resolve<TimesheetDayAppointmentsBloc>(),
          sessionBloc: resolve<SessionBloc>(),
          getDayAppointments: resolve(),
        ));

    locator.registerFactory(() => TimesheetDetailListsBloc());

    locator.registerFactory<GetOccurrenceDetail>(() => GetOccurrenceDetailImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<PostControlOccurrence>(() => PostControlOccurrenceImpl(
              repository: resolve(),
            ));
    locator
        .registerFactory<GetOccurrenceVacation>(() => GetOccurrenceVacationImpl(
              repository: resolve(),
            ));
    locator.registerFactory<GetVacationReceipt>(() => GetVacationReceiptImpl(
          repository: resolve(),
        ));
    locator.registerFactory(() => ListDetailsController(
          bloc: resolve<TimesheetDetailListsBloc>(),
          sessionBloc: resolve<SessionBloc>(),
          getOccurrenceDetail: resolve(),
          postControlOccurrence: resolve(),
          getOccurenceVacation: resolve(),
          getVacationReceipt: resolve(),
          baseUrl: environment.apiUrl,
        ));

    locator.registerFactory(() => TimesheetDayAppointmentsDetailsBloc());

    locator.registerFactory<GetCheckInData>(() => GetCheckInDataImpl(
          repository: resolve(),
        ));

    locator.registerFactory(() => DayAppointmentsDetailsController(
          bloc: resolve<TimesheetDayAppointmentsDetailsBloc>(),
          sessionBloc: resolve<SessionBloc>(),
          getCheckInData: resolve(),
        ));

    locator.registerFactory<GetOccurrenceCertificate>(
        () => GetOccurrenceCertificateImpl(
              repository: resolve(),
            ));
    locator
        .registerFactory<GetManualAppointments>(() => GetManualAppointmentsImpl(
              repository: resolve(),
            ));

    locator.registerFactory(() => TimesheetCertificateBloc());
    locator.registerFactory(() => TimesheetCertificateController(
          bloc: resolve<TimesheetCertificateBloc>(),
          sessionBloc: resolve<SessionBloc>(),
          getOccurrenceCertificate: resolve(),
          baseUrl: environment.apiUrl,
        ));

    locator.registerFactory(() => TimesheetAddAppointmentBloc());
    locator.registerFactory(() => TimesheetListPendingAppointmentsBloc());
    locator.registerFactory(() => TimesheetAddAppointmentController(
          sessionBloc: resolve<SessionBloc>(),
          bloc: resolve(),
          getManualAppointments: resolve(),
          postManualAppointment: resolve(),
        ));
    locator.registerFactory(() => ListPendingAppointmentsController(
          sessionBloc: resolve<SessionBloc>(),
          bloc: resolve(),
          getManualAppointments: resolve(),
        ));

    locator
        .registerFactory<GetGroupedOccurrence>(() => GetGroupedOccurrenceImpl(
              repository: resolve(),
            ));
    locator
        .registerFactory<PostManualAppointment>(() => PostManualAppointmentImpl(
              repository: resolve(),
            ));
    locator.registerFactory(() => TimesheetOccurrenceBloc());
    locator.registerFactory(() => TimesheetOccurrenceController(
        bloc: resolve<TimesheetOccurrenceBloc>(),
        sessionBloc: resolve<SessionBloc>(),
        getGroupedOccurrence: resolve(),
        postControlOccurrence: resolve(),
        postManualAppointment: resolve()));

    locator.registerFactory<GetListEmployees>(() => GetListEmployeesImpl(
          repository: resolve(),
        ));
    locator.registerFactory<GetEmployeeDetail>(() => GetEmployeeDetailImpl(
          repository: resolve(),
        ));
    locator.registerFactory<PutSignatureNotify>(() => PutSignatureNotifyImpl(
          repository: resolve(),
        ));
    locator.registerFactory(() => TimesheetBloc());
    locator.registerFactory(() => TimesheetController(
        baseUrl: environment.apiUrl,
        bloc: resolve<TimesheetBloc>(),
        sessionBloc: resolve<SessionBloc>(),
        getListTimesheet: resolve(),
        putSignatureNotify: resolve(),
        getEmployeeDetail: resolve()));

    locator.registerFactory<GetPointMirror>(() => GetPointMirrorImpl(
          repository: resolve(),
        ));
    locator.registerFactory(() => TimesheetPointMirrorBloc());
    locator.registerFactory(() => TimesheetPointMirrorController(
          bloc: resolve<TimesheetPointMirrorBloc>(),
          sessionBloc: resolve<SessionBloc>(),
          getPointMirror: resolve(),
          putSignatureOrNotify: resolve(),
        ));

    locator.registerLazySingleton<GetTimesheetPeriodsUsecase>(
        () => GetTimesheetPeriodsUsecaseImpl(
              repository: resolve(),
            ));

    //vacation
    locator.registerFactory<VacationApi>(() => VacationApi.create(
          resolve(),
        ));
    locator.registerFactory<VacationRemoteDataSource>(
        () => VacationRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<VacationRepository>(() => VacationRepositoryImpl(
          remoteDataSource: resolve(),
        ));
    locator
        .registerFactory<ScheduleVacationBloc>(() => ScheduleVacationBlocImpl(
              scheduleVacation: resolve(),
              sessionBloc: resolve(),
            ));
    locator.registerFactory<ScheduleVacation>(() => ScheduleVacationImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<VacationEmployeesBloc>(() => VacationEmployeesBlocImpl(
              sessionBloc: resolve(),
              listEmployee: resolve(),
            ));
    locator.registerFactory<GetVacation>(() => GetVacationImpl(
          repository: resolve(),
        ));
    locator.registerFactory<VacationBloc>(() => VacationBlocImpl(
          sessionBloc: resolve(),
          getVacation: resolve(),
          getVacationPeriod: resolve(),
          getLockedDays: resolve(),
        ));
    locator.registerFactory<GetVacationPeriod>(() => GetVacationPeriodImpl(
          repository: resolve(),
        ));
    locator.registerFactory<GetLockedDays>(() => GetLockedDaysImpl(
          repository: resolve(),
        ));

    //payslip
    locator.registerFactory<PayslipApi>(() => PayslipApi.create(
          resolve(),
        ));
    locator.registerFactory<PayslipRemoteDataSource>(
        () => PayslipRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<PayslipRepository>(() => PayslipRepositoryImpl(
          remoteDataSource: resolve(),
        ));
    locator
        .registerFactory<PayslipEmployeesBloc>(() => PayslipEmployeesBlocImpl(
              sessionBloc: resolve(),
              listEmployee: resolve(),
            ));
    locator.registerFactory<GetPayslip>(() => GetPayslipImpl(
          repository: resolve(),
        ));
    locator.registerFactory<GetPayslipFile>(() => GetPayslipFileImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<PayslipSelectionBloc>(() => PayslipSelectionBlocImpl(
              sessionBloc: resolve(),
              getPayslip: resolve(),
              getPayslipFile: resolve(),
            ));

    //payroll
    locator.registerFactory<PayrollApi>(() => PayrollApi.create(
          resolve(),
        ));
    locator.registerFactory<PayrollRemoteDataSource>(
        () => PayrollRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<PayrollRepository>(() => PayrollRepositoryImpl(
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<GetPayroll>(() => GetPayrollImpl(
          repository: resolve(),
        ));
    locator.registerFactory<ListPayroll>(() => ListPayrollImpl(
          repository: resolve(),
        ));

    locator.registerLazySingleton(() => PayrollBloc());
    locator.registerFactory(
      () => PayrollController(
        sessionBloc: resolve(),
        getPayrollUseCase: resolve(),
        listPayrollUseCase: resolve(),
        payrollBloc: resolve(),
      ),
    );

    locator.registerFactory<PayrollEntryApi>(() => PayrollEntryApi.create(
          resolve(),
        ));
    locator.registerFactory<PayrollEntryRemoteDataSource>(
        () => PayrollEntryRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<PayrollEntryRepository>(
        () => PayrollEntryRepositoryImpl(
              remoteDataSource: resolve(),
            ));
    locator.registerFactory<ListPayrollEntry>(() => ListPayrollEntryImpl(
          repository: resolve(),
        ));

    locator.registerLazySingleton(() => PayrollEntryBloc());
    locator.registerFactory(
      () => PayrollEntryController(
        sessionBloc: resolve(),
        listPayrollEntryUseCase: resolve(),
        payrollEntryBloc: resolve(),
      ),
    );

    //vox (advertências, multas, comunicados)
    locator.registerFactory<VoxApi>(() => VoxApi.create(resolve()));
    locator.registerFactory<VoxRemoteDataSource>(
        () => VoxRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<VoxRepository>(
        () => VoxRepositoryImpl(remoteDataSource: resolve()));
    locator.registerFactory<RequestDocument>(
        () => RequestDocumentImpl(repository: resolve()));
    locator.registerFactory<CreateDocument>(
        () => CreateDocumentImpl(repository: resolve()));
    locator.registerFactory<ListDocumentReasons>(
        () => ListDocumentReasonsImpl(repository: resolve()));
    locator.registerFactory<ListDocumentTemplates>(
        () => ListDocumentTemplatesImpl(repository: resolve()));
    locator.registerFactory<ListDocuments>(
        () => ListDocumentsImpl(repository: resolve()));
    locator.registerFactory<GetDocument>(
        () => GetDocumentImpl(repository: resolve()));
    locator.registerFactory<UploadDocumentImage>(
        () => UploadDocumentImageImpl(repository: resolve()));
    locator.registerLazySingleton<VoxHistoryCache>(() => VoxHistoryCache());
    locator.registerLazySingleton<VoxReasonsCache>(() => VoxReasonsCache());
    locator
        .registerLazySingleton<VoxTemplatesCache>(() => VoxTemplatesCache());

    //Documents (feature compartilhada)
    locator.registerFactory<DocumentsApi>(
      () => DocumentsApi.create(resolve()),
    );
    locator.registerLazySingleton<CachedDocumentsStore>(
      () => CachedDocumentsStore(),
    );
    locator.registerFactory<DocumentsRemoteDataSource>(
      () => DocumentsRemoteDataSourceImpl(api: resolve()),
    );
    locator.registerFactory<DocumentsRepository>(
      () => DocumentsRepositoryImpl(
        remoteDataSource: resolve(),
        cacheStore: resolve(),
        environment: resolve(),
        authenticationStore: resolve(),
      ),
    );
    locator.registerFactory<DownloadDocument>(
      () => DownloadDocumentImpl(repository: resolve()),
    );
    locator.registerFactory<GetExtractedText>(
      () => GetExtractedTextImpl(repository: resolve()),
    );
    locator.registerLazySingleton<DocumentsBloc>(
      () => DocumentsBloc(),
    );
    locator.registerLazySingleton<DocumentsController>(
      () => DocumentsController(
        bloc: resolve(),
        repository: resolve(),
        downloadDocument: resolve(),
        getExtractedText: resolve(),
        session: SindicoSharedSession(resolve<SessionBloc>()),
        analytics: SindicoDocumentsAnalytics(resolve<SessionBloc>()),
      ),
    );
    // advertências/multas/comunicados unificados em feature/vox (ver bloco //vox)

    //space calendar
    locator.registerLazySingleton<ReservationSummaryDao>(
        () => database.reservationSummaryDao);
    locator.registerFactory<ReservationSummaryApi>(
        () => ReservationSummaryApi.create(
              resolve(),
            ));
    locator.registerFactory<ReservationSummaryRemoteDataSource>(
        () => ReservationSummaryRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<ReservationSummaryLocalDataSource>(
        () => ReservationSummaryLocalDataSourceImpl(
              dao: resolve(),
            ));
    locator.registerFactory<ReservationSummaryRepository>(
        () => ReservationSummaryRepositoryImpl(
              localDataSource: resolve(),
              remoteDataSource: resolve(),
            ));
    locator.registerFactory<ListReservationSummary>(
        () => ListReservationSummaryImpl(
              repository: resolve(),
            ));
    locator.registerFactory<DeleteReservation>(() => DeleteReservationImpl(
          repository: resolve(),
        ));
    locator.registerLazySingleton<ReservationCalendarBloc>(
        () => ReservationCalendarBlocImpl(
              sessionBloc: resolve(),
              listAllReservation: resolve(),
              registerReservation: resolve(),
              listReservationSummary: resolve(),
              listReservation: resolve(),
              delete: resolve(),
            ));
    locator.registerFactory<ReservationApi>(() => ReservationApi.create(
          resolve(),
        ));
    locator.registerFactory<ReservationRemoteDataSource>(
        () => ReservationRemoteDataSourceImpl(
              api: resolve(),
              spaceApi: resolve(),
            ));
    locator
        .registerFactory<ReservationRepository>(() => ReservationRepositoryImpl(
              remoteDataSource: resolve(),
            ));
    locator.registerFactory<ListReservation>(() => ListReservationImpl(
          repository: resolve(),
        ));

    locator.registerFactory<ListAllReservation>(() => ListAllReservationsImpl(
          repository: resolve(),
        ));
    locator.registerFactory<ReservationListBloc>(() => ReservationListBlocImpl(
          sessionBloc: resolve(),
          listReservation: resolve(),
        ));

    locator.registerFactory<CancelReservation>(() => CancelReservationImpl(
          repository: resolve(),
        ));
    locator.registerFactory<ReservationCancellationBloc>(
        () => ReservationCancellationBlocImpl(
              sessionBloc: resolve(),
              cancelReservation: resolve(),
            ));

    locator.registerLazySingleton<SpaceDao>(() => database.spaceDao);
    locator.registerFactory<SpaceApi>(() => SpaceApi.create(
          resolve(),
        ));
    locator
        .registerFactory<SpaceLocalDataSource>(() => SpaceLocalDataSourceImpl(
              dao: resolve(),
            ));
    locator
        .registerFactory<SpaceRemoteDataSource>(() => SpaceRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<SpaceRepository>(() => SpaceRepositoryImpl(
          remoteDataSource: resolve(),
          localDataSource: resolve(),
        ));
    locator.registerFactory<ListSpace>(() => ListSpaceImpl(
          repository: resolve(),
        ));
    locator.registerFactory<SpaceBloc>(() => SpaceBlocImpl(
          sessionBloc: resolve(),
          listSpace: resolve(),
          listUnits: resolve(),
        ));
    locator
        .registerFactory<ReservationFilterBloc>(() => ReservationFilterBlocImpl(
              sessionBloc: resolve(),
              listSpace: resolve(),
              listUnits: resolve(),
            ));
    locator.registerFactory<ListReservationTime>(() => ListReservationTimeImpl(
          repository: resolve(),
        ));
    locator.registerFactory<ReservationRegistrationTimeBloc>(
        () => ReservationRegistrationTimeBlocImpl(
              sessionBloc: resolve(),
              listReservationTime: resolve(),
            ));
    locator.registerFactory<ReservationRegistrationBloc>(
        () => ReservationRegistrationBlocImpl(
              sessionBloc: resolve(),
            ));
    locator.registerFactory<RegisterMaintenance>(() => RegisterMaintenanceImpl(
          repository: resolve(),
        ));
    locator.registerFactory<ReservationTimeApi>(() => ReservationTimeApi.create(
          resolve(),
        ));
    locator.registerFactory<ReservationTimeRemoteDataSource>(
        () => ReservationTimeRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<ReservationTimeRepository>(
        () => ReservationTimeRepositoryImpl(
              dataSource: resolve(),
            ));
    locator.registerFactory<ReservationRegistrationMaintenanceBloc>(
        () => ReservationRegistrationMaintenanceBlocImpl(
              sessionBloc: resolve(),
              registerMaintenance: resolve(),
            ));
    locator.registerFactory<ReservationRegistrationReservationBloc>(
        () => ReservationRegistrationReservationBlocImpl(
              sessionBloc: resolve(),
              registerReservation: resolve(),
              getReservationRule: resolve(),
              listUnits: resolve(),
            ));
    locator.registerFactory<ReservationRuleApi>(() => ReservationRuleApi.create(
          resolve(),
        ));
    locator.registerFactory<ReservationRuleRemoteDataSource>(
        () => ReservationRuleRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<ReservationRuleRepository>(
        () => ReservationRuleRepositoryImpl(
              dataSource: resolve(),
            ));
    locator.registerFactory<GetReservationRule>(() => GetReservationRuleImpl(
          repository: resolve(),
        ));
    locator.registerFactory<RegisterReservation>(() => RegisterReservationImpl(
          repository: resolve(),
        ));
    locator.registerFactory<RegisterRaffle>(() => RegisterRaffleImpl(
          repository: resolve(),
        ));
    locator.registerFactory<ReservationRegistrationRaffleBloc>(
        () => ReservationRegistrationRaffleBlocImpl(
              sessionBloc: resolve(),
              listUnits: resolve(),
              listResidents: resolve(),
              registerRaffle: resolve(),
            ));
    locator.registerFactory<GetRaffle>(() => GetRaffleImpl(
          repository: resolve(),
        ));
    locator.registerFactory<DrawRaffle>(() => DrawRaffleImpl(
          repository: resolve(),
        ));
    locator.registerFactory<ReservationRaffleDrawBloc>(
        () => ReservationRaffleDrawBlocImpl(
              sessionBloc: resolve(),
              drawRaffle: resolve(),
              getRaffle: resolve(),
            ));

    //space registration
    locator.registerFactory<SpaceRegistrationRequestApi>(
        () => SpaceRegistrationRequestApi.create(
              resolve(),
            ));
    locator.registerFactory<SpaceRegistrationRequestRemoteDataSource>(
        () => SpaceRegistrationRequestRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<SpaceRegistrationRequestRepository>(
        () => SpaceRegistrationRequestRepositoryImpl(
              dataSource: resolve(),
            ));
    locator.registerFactory<RequestSpaceRegistration>(
        () => RequestSpaceRegistrationImpl(
              repository: resolve(),
            ));
    locator.registerFactory<SpaceRegistrationLelloBloc>(
        () => SpaceRegistrationLelloBlocImpl(
              sessionBloc: resolve(),
              requestSpaceRegistration: resolve(),
            ));
    locator.registerFactory<RegisterSpace>(() => RegisterSpaceImpl(
          repository: resolve(),
        ));
    locator.registerFactory<SpaceFileRepository>(() => SpaceFileRepositoryImpl(
          uploader: resolve(),
        ));
    locator.registerFactory<UploadSpaceFile>(() => UploadSpaceFileImpl(
          repository: resolve(),
        ));
    locator.registerFactory<UpdateSpace>(() => UpdateSpaceImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<SpaceRegistrationBloc>(() => SpaceRegistrationBlocImpl(
              sessionBloc: resolve(),
              uploadSpaceFile: resolve(),
              registerSpace: resolve(),
              listAccounts: resolve(),
              listSpaces: resolve(),
              listSpaceType: resolve(),
              updateSpace: resolve(),
            ));

    locator.registerFactory<PostReservationChangeRules>(
        () => PostReservationChangeRulesImpl(
              repository: resolve(),
            ));
    locator.registerFactory<GetReservationChangeRules>(
        () => GetReservationChangeRulesImpl(
              repository: resolve(),
            ));
    locator.registerFactory<ReservationChangeRulesBloc>(
        () => ReservationChangesRulesBlocImpl(
              post: resolve(),
              getChangeRules: resolve(),
              sessionBloc: resolve(),
            ));

    locator.registerFactory<ReservationChangeCalendarBloc>(
        () => ReservationChangeCalendarBlocImpl(
              listUnits: resolve(),
              sessionBloc: resolve(),
            ));

    //space type
    locator.registerFactory<SpaceTypeRemoteDataSource>(
        () => SpaceTypeRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<SpaceTypeRepository>(() => SpaceTypeRepositoryImpl(
          dataSource: resolve(),
        ));
    locator.registerFactory<ListSpaceType>(() => ListSpaceTypeImpl(
          repository: resolve(),
        ));
    //Reports Book
    locator.registerFactory<ReportsBookApi>(() => ReportsBookApi.create(
          resolve(),
        ));
    locator.registerFactory<ReportsBookRemoteDataSource>(
        () => ReportsBookRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<ReportsBloc>(() => ReportsBloc());
    locator.registerLazySingleton(() => ReportController(
          reportsBloc: resolve(),
          sessionBloc: resolve(),
          listUnitSimpleUsecase: resolve(),
          getReportsUseCase: resolve(),
          getReportUseCase: resolve(),
          putReportAttachmentUseCase: resolve(),
          putReportContentUseCase: resolve(),
          closeReportUseCase: resolve(),
        ));
    locator
        .registerFactory<ReportsBookRepository>(() => ReportsBookRepositoryImpl(
              dataSource: resolve(),
              uploader: resolve(),
              baseUrl: environment.apiUrl,
            ));
    locator.registerFactory<GetReportsUseCase>(() => GetReportsUseCaseImpl(
          repository: resolve(),
        ));
    locator.registerFactory<GetReportUseCase>(() => GetReportUseCaseImpl(
          repository: resolve(),
        ));
    locator.registerFactory<PutReportAttachmentUseCase>(
        () => PutReportAttachmentUseCaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<PutReportContentUseCase>(
        () => PutReportContentUseCaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<CloseReportUseCase>(() => CloseReportUseCaseImpl(
          repository: resolve(),
        ));
    //Agreements

    locator.registerFactory(
      () => AgreementsBloc(),
    );
    locator.registerFactory<AgreementsApi>(
      () => AgreementsApi.create(
        resolve(),
      ),
    );
    locator.registerLazySingleton(() => AgreementsController(
          agreementsBloc: resolve(),
          sessionBloc: resolve(),
          getAnalysisUseCase: resolve(),
          getAllAgreementsInfoUseCase: resolve(),
          getRulesUseCase: resolve(),
          changeRulesUseCase: resolve(),
          agreementUpdateStatusUseCase: resolve(),
        ));
    locator.registerFactory<AgreementsRemoteDataSource>(
        () => AgreementsRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<AgreementsLocalDataSource>(
        () => AgreementsLocalDataSourceImpl(
              agreementsDao: resolve(),
              agreementsInstallmentsDao: resolve(),
              agreementsQuoteDao: resolve(),
              agreementsRulesDaysDao: resolve(),
              agreementsRulesInstallmentsDao: resolve(),
            ));
    locator.registerLazySingleton<AgreementsDao>(() => database.agreementsDao);
    locator.registerLazySingleton<AgreementsInstallmentsDao>(
        () => database.agreementsInstallmentsDao);
    locator.registerLazySingleton<AgreementsQuoteDao>(
        () => database.agreementsQuoteDao);
    locator.registerLazySingleton<AgreementsRulesDaysDao>(
        () => database.agreementsRulesDaysDao);
    locator.registerLazySingleton<AgreementsRulesInstallmentsDao>(
        () => database.agreementsRulesInstallmentsDao);
    locator
        .registerFactory<AgreementsRepository>(() => AgreementsRepositoryImpl(
              remoteDataSource: resolve(),
              localDataSource: resolve(),
            ));
    locator.registerFactory<GetAnalysisUseCase>(() => GetAnalysisUseCaseImpl(
          repository: resolve(),
        ));
    locator.registerFactory<GetAllAgreementsInfoUseCase>(
        () => GetAllAgreementsInfoUseCaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<GetRulesUseCase>(() => GetRulesUseCaseImpl(
          repository: resolve(),
        ));
    locator.registerFactory<ChangeRulesUseCase>(() => ChangeRulesUseCaseImpl(
          repository: resolve(),
        ));
    locator.registerFactory<AgreementUpdateStatusUseCase>(
        () => AgreementUpdateStatusUseCaseImpl(
              repository: resolve(),
            ));

    //dasboardNotificatiosPreferences
    locator.registerFactory<GetNotificationsPreferencesUseCase>(
        () => GetNotificationsPreferencesUseCaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<UpdateNotificationsPreferences>(
        () => UpdateNotificationsPreferencesImpl(
              repository: resolve(),
            ));

    locator.registerFactory<NotificationsPreferencesBloc>(
        () => NotificationsPreferencesBloc());
    locator.registerLazySingleton(() => NotificationsPreferencesController(
          sessionBloc: resolve(),
          notificationsPreferencesBloc: resolve(),
          getNotificationsPreferencesUseCase: resolve(),
          updateNotificationsPreferencesUseCase: resolve(),
        ));

    locator.registerFactory<NotificationsPreferencesRepository>(
        () => NotificationsPreferencesRepositoryImpl(
              remoteDataSource: resolve(),
              //localDataSource: resolve(),
            ));
    locator.registerFactory<NotificationsPreferencesRemoteDataSource>(
        () => NotificationsPreferencesRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<NotificationsPreferencesApi>(
        () => NotificationsPreferencesApi.create(
              resolve(),
            ));

    //Resin
    locator.registerFactory<ResinApi>(() => ResinApi.create(resolve()));
    locator.registerFactory<ResinBankApi>(() => ResinBankApi.create(resolve()));
    locator.registerFactory<ResinRemoteDataSource>(
        () => ResinRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<ResinBankRemoteDataSource>(
        () => ResinBankRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<ResinLocalDataSource>(
      () => ResinLocalDataSourceImpl(
        resinBankAccountsDao: resolve(),
        resinBanksDao: resolve(),
        resinPeopleDao: resolve(),
        resinRefundsDao: resolve(),
      ),
    );
    locator.registerLazySingleton<ResinBankAccountsDao>(
        () => database.resinBankAccountsDao);
    locator.registerLazySingleton<ResinBanksDao>(() => database.resinBanksDao);
    locator
        .registerLazySingleton<ResinPeopleDao>(() => database.resinPeopleDao);
    locator
        .registerLazySingleton<ResinRefundsDao>(() => database.resinRefundsDao);
    locator.registerFactory<ResinBankRepository>(() => ResinBankRepositoryImpl(
          remoteDataSource: resolve(),
          localDataSource: resolve(),
        ));
    locator.registerFactory<ResinRepository>(() => ResinRepositoryImpl(
          remoteDataSource: resolve(),
          localDataSource: resolve(),
        ));
    locator.registerFactory<CreateResinBankAccount>(
        () => CreateResinBankAccountImpl(repository: resolve()));
    locator.registerFactory<CreateResinRefund>(
        () => CreateResinRefundImpl(repository: resolve()));
    locator.registerFactory<DeleteResinBankAccount>(
        () => DeleteResinBankAccountImpl(repository: resolve()));
    locator.registerFactory<DeleteResinRefund>(
        () => DeleteResinRefundImpl(repository: resolve()));
    locator.registerFactory<EditResinRefund>(
        () => EditResinRefundImpl(repository: resolve()));
    locator.registerFactory<GetResinBankAccounts>(
        () => GetResinBankAccountsImpl(repository: resolve()));
    locator.registerFactory<GetResinBanks>(
        () => GetResinBanksImpl(repository: resolve()));
    locator.registerFactory<GetResinParams>(
        () => GetResinParamsImpl(repository: resolve()));
    locator.registerFactory<GetResinPeople>(
        () => GetResinPeopleImpl(repository: resolve()));
    locator.registerFactory<GetResinRefundDetails>(
        () => GetResinRefundDetailsImpl(repository: resolve()));
    locator.registerFactory<GetResinRefunds>(
        () => GetResinRefundsImpl(repository: resolve()));
    locator.registerFactory<UploadNewReceipt>(
        () => UploadNewReceiptImpl(repository: resolve()));
    locator.registerFactory<ResinMenuBloc>(() => ResinMenuBloc());
    locator.registerLazySingleton(
      () => ResinMenuController(
        sessionBloc: resolve(),
        getResinParams: resolve(),
        bloc: resolve(),
      ),
    );
    locator.registerFactory<GetResinCheckMaxValueUsecase>(
        () => GetResinCheckMaxValueUsecaseImpl(repository: resolve()));
    locator.registerFactory<ResinNewAdvanceBloc>(
      () => ResinNewAdvanceBloc(),
    );
    locator.registerLazySingleton(
      () => ResinNewAdvanceController(
        sessionBloc: resolve(),
        getResinBankAccountsUseCase: resolve(),
        deleteResinBankAccountUseCase: resolve(),
        createResinRefundUseCase: resolve(),
        editResinRefund: resolve(),
        checkMaxValueUsecase: resolve(),
        bloc: resolve(),
      ),
    );

    locator.registerFactory<ResinNewRefundBloc>(
      () => ResinNewRefundBloc(),
    );
    locator.registerLazySingleton(
      () => ResinNewRefundController(
        sessionBloc: resolve(),
        getResinBankAccountsUseCase: resolve(),
        deleteResinBankAccountUseCase: resolve(),
        createResinRefundUseCase: resolve(),
        editResinRefund: resolve(),
        checkMaxValueUsecase: resolve(),
        bloc: resolve(),
      ),
    );
    locator.registerFactory<ResinNewBankAccountBloc>(
      () => ResinNewBankAccountBloc(),
    );
    locator.registerLazySingleton(
      () => ResinNewBankAccountController(
        bloc: resolve(),
        sessionBloc: resolve(),
        getResinBanksUseCase: resolve(),
        getResinPeopleUseCase: resolve(),
        createResinBankAccountUseCase: resolve(),
      ),
    );
    locator.registerFactory<ResinHistoryAdvanceBloc>(
        () => ResinHistoryAdvanceBloc());
    locator.registerLazySingleton(
      () => ResinHistoryAdvanceController(
        bloc: resolve(),
        sessionBloc: resolve(),
        getResinRefunds: resolve(),
        getResinRefundDetails: resolve(),
        deleteResinRefund: resolve(),
      ),
    );
    locator.registerFactory<ResinHistoryRefundBloc>(
        () => ResinHistoryRefundBloc());
    locator.registerLazySingleton(
      () => ResinHistoryRefundController(
        bloc: resolve(),
        sessionBloc: resolve(),
        getResinRefunds: resolve(),
        getResinRefundDetails: resolve(),
        deleteResinRefund: resolve(),
      ),
    );
    locator.registerFactory<ResinReceiptDetailsBloc>(
        () => ResinReceiptDetailsBloc());

    locator.registerLazySingleton(
      () => ResinReceiptDetailsController(
        bloc: resolve(),
        sessionBloc: resolve(),
        getResinRefundDetails: resolve(),
        uploadNewReceipt: resolve(),
      ),
    );

    locator.registerFactory<ResinSendReceiptBloc>(() => ResinSendReceiptBloc());

    locator.registerLazySingleton(
      () => ResinSendReceiptController(
        bloc: resolve(),
        getResinRefunds: resolve(),
        sessionBloc: resolve(),
      ),
    );

    //Ghost Notification
    locator.registerLazySingleton<GhostNotificationApi>(
        () => GhostNotificationApi.create(resolve()));
    locator.registerLazySingleton<GhostNotificationDatasource>(
        () => GhostNotificationDataSourceImpl(api: resolve()));
    locator.registerLazySingleton<GhostNotificationRepository>(
        () => GhostNotificationRepositoryImpl(datasource: resolve()));
    locator.registerLazySingleton<GhostNotificationUsecase>(
      () => GhostNotificationUsecaseImpl(
        repository: resolve(),
        sessionBloc: resolve(),
        authenticationStore: resolve(),
        getMe: resolve(),
        switchRoles: resolve(),
      ),
    );

    // StaffAccessManagement
    locator.registerFactory<StaffAccessManagementApi>(
        () => StaffAccessManagementApi.create(resolve()));
    locator.registerFactory<StaffAccessManagementRemoteDataSource>(
        () => StaffAccessManagementRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<StaffAccessManagementRepository>(
        () => StaffAccessManagementRepositoryImpl(remoteDataSource: resolve()));

    locator.registerFactory<BuildingManagerUsersCase>(
        () => BuildingManagerUsersCaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<DeactivateNonManagerUserCase>(
        () => DeactivateNonManagerUserCaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<PostNonUserCase>(() => PostNonUserCaseImpl(
          repository: resolve(),
        ));
    locator.registerFactory<PutBuildingManagerUserCase>(
        () => PutBuildingManagerUserCaseImpl(
              repository: resolve(),
            ));

    locator.registerLazySingleton(() => StaffAccessManagementBloc());
    locator.registerLazySingleton(() => StaffAccessManagementController(
          bloc: resolve<StaffAccessManagementBloc>(),
          sessionBloc: resolve<SessionBloc>(),
          getBuildingManagerUsersCase: resolve(),
          deactivateNonManagerUserCase: resolve(),
          post: resolve(),
          putBuildingManagerUserCase: resolve(),
        ));

    locator.registerLazySingleton<CircuitBreakerController>(
      () => CircuitBreakerController(
        database: FirebaseFirestore.instance,
        sessionBloc: resolve<SessionBloc>(),
        environment: environment,
      ),
    );

    //expired session
    locator.registerFactory<ExpiredSessionLocalDataSource>(
      () => ExpiredSessionLocalDataSourceImpl(resetDb: database.resetDb),
    );
    locator.registerFactory<ExpiredSessionRepository>(
      () => ExpiredSessionRepositoryImpl(localDataSource: resolve()),
    );
    locator.registerFactory<ClearData>(
      () => ClearDataImpl(),
    );
    locator.registerFactory<ExpiredSessionBloc>(
      () => ExpiredSessionBlocImpl(
        emptySessionState: resolve<SessionBloc>().emptyState,
        clearDataUseCase: resolve(),
        logOutUseCase: resolve(),
      ),
    );

    //region Maintenance Management
    locator.registerFactory<MaintenanceManagementApi>(
      () => MaintenanceManagementApi.create(
        resolve(),
      ),
    );
    locator.registerFactory<MaintenanceManagementRemoteDataSource>(
      () => MaintenanceManagementRemoteDataSourceImpl(
        resolve(),
      ),
    );
    locator.registerFactory<MaintenanceManagementRepository>(
      () => MaintenanceManagementRepositoryImpl(
        resolve(),
        resolve(),
      ),
    );
    locator.registerFactory<GetCondominiumInfoUseCase>(
      () => GetCondominiumInfoUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetMaintenanceTaskEventsUseCase>(
      () => GetMaintenanceTaskEventsUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetScheduleEventsUseCase>(
      () => GetScheduleEventsUseCaseImpl(
        resolve(),
      ),
    );

    locator.registerFactory<GetCalendarDaysUseCase>(
      () => GetCalendarDaysUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetMaintenanceTasksFilterOptionsUseCase>(
      () => GetMaintenanceTasksFilterOptionsUseCase(
        resolve(),
      ),
    );
    locator.registerFactory<GetLegalObligationsUseCase>(
      () => GetLegalObligationsUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<DownloadLegalObligationFileUseCase>(
      () => DownloadLegalObligationFileUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<UploadLegalObligationFileUseCase>(
      () => UploadLegalObligationFileUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<SendTechnicalInspectionEmailUseCase>(
      () => SendTechnicalInspectionEmailUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<RequestLegalObligationRenewalUseCase>(
      () => RequestLegalObligationRenewalUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<LegalObligationBloc>(
      () => LegalObligationBlocImpl(
        resolve(),
        resolve(),
        resolve(),
        resolve(),
        resolve(),
        resolve(),
        resolve(),
      ),
    );
    locator.registerFactory<AgendaTasksBloc>(
      () => AgendaTasksBloc(
        getMaintenanceTaskEventsUseCase: resolve(),
      ),
    );
    locator.registerFactory<ScheduleEventsBloc>(
      () => ScheduleEventsBloc(
        getScheduleEventsUseCase: resolve(),
        resetScheduleEventUseCase: resolve(),
      ),
    );
    locator.registerFactory<CalendarIndicatorsBloc>(
      () => CalendarIndicatorsBloc(
        getCalendarDaysUseCase: resolve(),
      ),
    );
    locator.registerFactory<GetProcedureOptionsUseCase>(
      () => GetProcedureOptionsUseCase(
        resolve(),
      ),
    );
    locator.registerFactory<CreateTaskUseCase>(
      () => CreateTaskUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetFormularyByMonthUseCase>(
      () => GetFormularyByMonthUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<VisualizeReportsBloc>(
      () => VisualizeReportsBlocImpl(
        resolve(),
        resolve(),
        resolve(),
        resolve(),
      ),
    );
    locator.registerFactory<GetLocalsLookupUseCase>(
      () => GetLocalsLookupUseCase(
        resolve(),
      ),
    );
    locator.registerFactory<GetAssetsLookupUseCase>(
      () => GetAssetsLookupUseCase(
        resolve(),
      ),
    );
    locator.registerFactory<GetTaskBySectorUseCase>(
      () => GetTaskBySectorUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetTaskByMonthUseCase>(
      () => GetTaskByMonthUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetTaskByLocalUseCase>(
      () => GetTaskByLocalUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetTaskByAssetUseCase>(
      () => GetTaskByAssetUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetTaskSummaryUseCase>(
      () => GetTaskSummaryUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetTaskDetailsUseCase>(
      () => GetTaskDetailsUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetTaskFormulariesUseCase>(
      () => GetTaskFormulariesUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetTaskFilesUseCase>(
      () => GetTaskFilesUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<CreateTaskFromScheduleUseCase>(
      () => CreateTaskFromScheduleUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<EditScheduleEventUseCase>(
      () => EditScheduleEventUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<DeleteScheduleEventUseCase>(
      () => DeleteScheduleEventUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetEventDetailsUseCase>(
      () => GetEventDetailsUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<SubmitFormUseCase>(
      () => SubmitFormUseCase(
        resolve<MaintenanceManagementRepository>(),
      ),
    );
    locator.registerFactory<ResetScheduleEventUseCase>(
      () => ResetScheduleEventUseCaseImpl(
        resolve<MaintenanceManagementRepository>(),
      ),
    );
    locator.registerFactory<GetScheduleEventHistoryUseCase>(
      () => GetScheduleEventHistoryUseCase(
        resolve<MaintenanceManagementRepository>(),
      ),
    );
    locator.registerFactory<TaskHistoryBloc>(
      () => TaskHistoryBloc(
        resolve<GetScheduleEventHistoryUseCase>(),
      ),
    );
    locator.registerLazySingleton<TaskSummaryBloc>(
      () => TaskSummaryBloc(
        getTaskSummaryUseCase: resolve(),
      ),
    );
    locator.registerFactory<CreateRoutineBloc>(
      () => CreateRoutineBloc(
        getProcedureOptionsUseCase: resolve(),
        getFilterOptionsUseCase: resolve(),
        getLocalsLookupUseCase: resolve(),
        createTaskUseCase: resolve(),
        getAssetsLookupUseCase: resolve(),
        createTaskFromScheduleUseCase: resolve(),
      ),
    );
    locator.registerFactory<TaskDetailsBloc>(
      () => TaskDetailsBlocImpl(
        resolve(),
        resolve(),
        resolve(),
        resolve(),
      ),
    );
    locator.registerFactory<TaskEditBloc>(
      () => TaskEditBloc(
        resolve(),
      ),
    );
    locator.registerFactory<TaskInitStepBloc>(
      () => TaskInitStepBloc(
        resolve(),
        resolve(),
        resolve(),
      ),
    );

    // Task Report dependencies
    locator.registerFactory<GetTaskReportUseCase>(
      () => GetTaskReportUseCaseImpl(
        repository: resolve(),
      ),
    );
    locator.registerFactory<TaskReportBloc>(
      () => TaskReportBloc(
        getTaskReportUseCase: resolve(),
      ),
    );

    // Chat dependencies
    locator.registerSingleton<WebSocketService>(
      WebSocketService(),
    );

    locator.registerFactory<ChatRepository>(
      () => ChatRepositoryImpl(
        resolve(), // MaintenanceManagementRemoteDataSource
        resolve(), // WebSocketService
      ),
    );
    locator.registerFactory<GetChatChannelsUseCase>(
      () => GetChatChannelsUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetChatMessagesUseCase>(
      () => GetChatMessagesUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<SendChatMessageUseCase>(
      () => SendChatMessageUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<CreateChatChannelUseCase>(
      () => CreateChatChannelUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<SubscribeToChannelUseCase>(
      () => SubscribeToChannelUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<UnsubscribeFromChannelUseCase>(
      () => UnsubscribeFromChannelUseCaseImpl(
        resolve(),
      ),
    );

    // Chat Conversations BLoC
    locator.registerFactory<ChatConversationsBloc>(
      () => ChatConversationsBloc(
        resolve(), // GetChatChannelsUseCase
        resolve(), // SubscribeToChannelUseCase
        resolve(), // UnsubscribeFromChannelUseCase
        resolve(), // GetMaintenanceTasksFilterOptionsUseCase
        resolve(), // ChatRepository
      ),
    );

    // Chat Messages BLoC
    locator.registerFactory<ChatMessagesBloc>(
      () => ChatMessagesBloc(
        resolve(),
        resolve(),
        resolve(),
      ),
    );

    //LelloHub
    locator.registerFactory<ConsultantApi>(
      () => ConsultantApi.create(
        resolve(),
      ),
    );

    locator.registerFactory<ConsultantRemoteDataSource>(
      () => ConsultantRemoteDataSourceImpl(
        api: resolve(),
      ),
    );

    locator.registerFactory<ConsultantRepository>(
      () => ConsultantRepositoryImpl(
        remoteDataSource: resolve(),
      ),
    );

    locator.registerFactory<ConsultantUseCase>(
      () => ConsultantUseCaseImpl(
        repository: resolve(),
      ),
    );

    locator.registerLazySingleton(
      () => ConsultantController(
        sessionBloc: resolve(),
        getConsultantUseCase: resolve(),
        authenticationStore: resolve(),
      ),
    );
  }

  Future<void> afterSetup() async {
    final AuthenticationStore loginStore = resolve();
    loginStore.load();
  }

  @override
  T resolve<T extends Object>() => locator<T>();

  @override
  FutureOr resetLazySingleton<T extends Object>() =>
      locator.resetLazySingleton<T>();

  @override
  String getBaseUrl() {
    return resolve<Environment>().apiUrl;
  }
}
