import 'dart:async';

import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/core/background/sync_digital_points_worker.dart';
import 'package:colaborador/core/database/authentication_tablet_database/authentication_tablet_database.dart';
import 'package:colaborador/core/database/authentication_tablet_database/condominium_info/condominium_info_dao.dart';
import 'package:colaborador/core/database/authentication_tablet_database/employee_info/employee_info_dao.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point/digital_point_dao.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point_log/digital_point_log_dao.dart';
import 'package:colaborador/core/database/lello_database/condominium/condominium_dao.dart';
import 'package:colaborador/core/database/lello_database/condominium_employee_schedule/condominium_employee_schedule_dao.dart';
import 'package:colaborador/core/database/lello_database/lello_database.dart';
import 'package:colaborador/core/database/lello_database/me/me_dao.dart';
import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase_impl.dart';
import 'package:colaborador/core/network/authorization_header_interceptor.dart';
import 'package:colaborador/core/uploader/uploader.dart';
import 'package:colaborador/core/uploader/uploader_impl.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/local/authentication_tablet_local_data_source.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/local/authentication_tablet_local_data_source_impl.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/remote/authentication_tablet_api.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/remote/authentication_tablet_remote_data_source.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/remote/authentication_tablet_remote_data_source_impl.dart';
import 'package:colaborador/feature/authentication_tablet/data/repository/authentication_tablet_repository_impl.dart';
import 'package:colaborador/feature/authentication_tablet/domain/repository/authentication_tablet_repository.dart';
import 'package:colaborador/feature/authentication_tablet/domain/use_case/get_info_by_condo_code/get_info_by_condo_code.dart';
import 'package:colaborador/feature/authentication_tablet/domain/use_case/get_info_by_condo_code/get_info_by_condo_code_impl.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_bloc.dart';
import 'package:colaborador/feature/digital_point/controllers/digital_point_controller.dart';
import 'package:colaborador/feature/digital_point/data/data_source/local/digital_point_local_data_source.dart';
import 'package:colaborador/feature/digital_point/data/data_source/local/digital_point_local_data_source_impl.dart';
import 'package:colaborador/feature/digital_point/data/data_source/remote/digital_point_api.dart';
import 'package:colaborador/feature/digital_point/data/data_source/remote/digital_point_remote_data_source.dart';
import 'package:colaborador/feature/digital_point/data/data_source/remote/digital_point_remote_data_source_impl.dart';
import 'package:colaborador/feature/digital_point/data/repository/digital_point_repository_impl.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/check_digital_point/check_digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/check_digital_point/check_digital_point_impl.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_pending_points_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_by_status_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_no_auth.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/register_point/register_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/register_point/register_point_impl.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/request_digital_point/request_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/request_digital_point/request_usecase_impl.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/save_point/save_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/save_point/save_point_impl.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_point_without_login/sync_point_without_login.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_point_without_login/sync_point_without_login_impl.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_points/sync_points.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_points/sync_points_impl.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/upload_digital_point_to_aws/upload_digital_point_to_aws.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/upload_digital_point_to_aws/upload_digital_point_to_aws_impl.dart';
import 'package:colaborador/feature/digital_point/presentation/bloc/digital_point_bloc.dart';
import 'package:colaborador/feature/documents/data/data_source/documents_api.dart';
import 'package:colaborador/feature/documents/data/data_source/documents_remote_data_source.dart';
import 'package:colaborador/feature/documents/data/data_source/documents_remote_data_source_impl.dart';
import 'package:colaborador/feature/documents/data/repository/documents_repository_impl.dart';
import 'package:colaborador/feature/documents/domain/repository/documents_repository.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_document_file/get_document_file.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_document_file/get_document_file_impl.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_documents_info_list/get_documents_info_list.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_documents_info_list/get_documents_info_list_impl.dart';
import 'package:colaborador/feature/documents/presentation/benefits/bloc/benefits_bloc.dart';
import 'package:colaborador/feature/documents/presentation/document_file/bloc/document_file_bloc.dart';
import 'package:colaborador/feature/documents/presentation/income_report/bloc/income_report_bloc.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/bloc/pay_stub_bloc.dart';
import 'package:colaborador/feature/documents/presentation/vacation/bloc/vacation_bloc.dart';
import 'package:colaborador/feature/employee_referral/data/data_source/employee_referral_api.dart';
import 'package:colaborador/feature/employee_referral/data/data_source/employee_referral_remote_data_source.dart';
import 'package:colaborador/feature/employee_referral/data/data_source/employee_referral_remote_data_source_impl.dart';
import 'package:colaborador/feature/employee_referral/data/repository/employee_referral_repository_impl.dart';
import 'package:colaborador/feature/employee_referral/domain/repository/employee_referral_repository.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/get_cities/get_cities_impl.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/get_cities/get_cities_units.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/register_employee_referral/employee_referral.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/register_employee_referral/employee_referral_impl.dart';
import 'package:colaborador/feature/employee_referral/presentation/bloc/employee_referral_bloc.dart';
import 'package:colaborador/feature/home/data/data_source/home_api.dart';
import 'package:colaborador/feature/home/data/data_source/home_remote_data_source.dart';
import 'package:colaborador/feature/home/data/data_source/home_remote_data_source_impl.dart';
import 'package:colaborador/feature/home/data/repository/home_repository_impl.dart';
import 'package:colaborador/feature/home/domain/repository/home_repository.dart';
import 'package:colaborador/feature/home/presentation/bloc/home_bloc.dart';
import 'package:colaborador/feature/home/presentation/bloc/register_point_bloc.dart';
import 'package:colaborador/feature/home/presentation/controllers/home_controller.dart';
import 'package:colaborador/feature/home/presentation/controllers/register_point_controller.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_bloc.dart';
import 'package:colaborador/feature/home_cards_preferences/controller/preferences_home_cards_controller.dart';
import 'package:colaborador/feature/manual_timesheet/data/data_source/remote/manual_timesheet_api.dart';
import 'package:colaborador/feature/manual_timesheet/data/data_source/remote/manual_timesheet_remote_data_source.dart';
import 'package:colaborador/feature/manual_timesheet/data/data_source/remote/manual_timesheet_remote_data_source_impl.dart';
import 'package:colaborador/feature/manual_timesheet/data/repository/manual_timesheet_repository_impl.dart';
import 'package:colaborador/feature/manual_timesheet/domain/repository/manual_timesheet_repository.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/register_manual_timesheet/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/register_manual_timesheet/manual_timesheet_impl.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/upload_sick_note_to_aws/upload_manual_timesheet_to_aws.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/upload_sick_note_to_aws/upload_manual_timesheet_to_aws_impl.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/bloc/manual_timesheet_bloc.dart';
import 'package:colaborador/feature/me/data/data_source/local/me_local_data_source.dart';
import 'package:colaborador/feature/me/data/data_source/local/me_local_data_source_impl.dart';
import 'package:colaborador/feature/me/data/data_source/remote/me_api.dart';
import 'package:colaborador/feature/me/data/data_source/remote/me_remote_data_source.dart';
import 'package:colaborador/feature/me/data/data_source/remote/me_remote_data_source_impl.dart';
import 'package:colaborador/feature/me/data/repository/me_repository_impl.dart';
import 'package:colaborador/feature/me/data/repository/profile_picture_repository_impl.dart';
import 'package:colaborador/feature/me/domain/repository/me_repository.dart';
import 'package:colaborador/feature/me/domain/repository/profile_picture_repository.dart';
import 'package:colaborador/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:colaborador/feature/me/domain/use_case/get_me/get_me_impl.dart';
import 'package:colaborador/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:colaborador/feature/me/domain/use_case/log_me_out/log_me_out_impl.dart';
import 'package:colaborador/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:colaborador/feature/me/domain/use_case/save_me/save_me_impl.dart';
import 'package:colaborador/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:colaborador/feature/me/domain/use_case/update_password_me/update_password_me_impl.dart';
import 'package:colaborador/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture.dart';
import 'package:colaborador/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture_impl.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/preferences/data/data_source/preferences_api.dart';
import 'package:colaborador/feature/preferences/data/data_source/preferences_data_source.dart';
import 'package:colaborador/feature/preferences/data/data_source/preferences_data_source_impl.dart';
import 'package:colaborador/feature/preferences/data/repository/preferences_repository_impl.dart';
import 'package:colaborador/feature/preferences/domain/repository/preferences_repository.dart';
import 'package:colaborador/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification.dart';
import 'package:colaborador/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification_impl.dart';
import 'package:colaborador/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification.dart';
import 'package:colaborador/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification_impl.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_bloc.dart';
import 'package:colaborador/feature/preferences/presentation/controller/preferences_notification_controller.dart';
import 'package:colaborador/feature/proof/data/data_source/remote/proof_api.dart';
import 'package:colaborador/feature/proof/data/data_source/remote/proof_remote_data_source.dart';
import 'package:colaborador/feature/proof/data/data_source/remote/proof_remote_data_source_impl.dart';
import 'package:colaborador/feature/proof/data/repository/proof_repository_impl.dart';
import 'package:colaborador/feature/proof/domain/repository/proof_repository.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof/get_proof.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof/get_proof_impl.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof_file/get_proof_file.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof_file/get_proof_file_impl.dart';
import 'package:colaborador/feature/proof/presentation/bloc/proof_bloc.dart';
import 'package:colaborador/feature/session/data/data_source/session_local_data_source.dart';
import 'package:colaborador/feature/session/data/data_source/session_local_data_source_impl.dart';
import 'package:colaborador/feature/session/data/repository/session_repository_impl.dart';
import 'package:colaborador/feature/session/domain/repository/session_repository.dart';
import 'package:colaborador/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:colaborador/feature/session/domain/use_case/load_session/load_session_impl.dart';
import 'package:colaborador/feature/session/domain/use_case/save_session/save_session.dart';
import 'package:colaborador/feature/session/domain/use_case/save_session/save_session_impl.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/sick_note/data/data_source/remote/sick_note_api.dart';
import 'package:colaborador/feature/sick_note/data/data_source/remote/sick_note_remote_data_source.dart';
import 'package:colaborador/feature/sick_note/data/data_source/remote/sick_note_remote_data_source_impl.dart';
import 'package:colaborador/feature/sick_note/data/repository/sick_note_repository_impl.dart';
import 'package:colaborador/feature/sick_note/domain/repository/sick_note_repository.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/register_sick_note/sick_note.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/register_sick_note/sick_note_impl.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/upload_sick_note_to_aws/upload_sick_note_to_aws.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/upload_sick_note_to_aws/upload_sick_note_to_aws_impl.dart';
import 'package:colaborador/feature/sick_note/presentation/bloc/sick_note_bloc.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_bloc.dart';
import 'package:colaborador/feature/timesheet/data/data_source/remote/timesheet_api.dart';
import 'package:colaborador/feature/timesheet/data/data_source/remote/timesheet_remote_data_source.dart';
import 'package:colaborador/feature/timesheet/data/data_source/remote/timesheet_remote_data_source_impl.dart';
import 'package:colaborador/feature/timesheet/data/repository/timesheet_repository_impl.dart';
import 'package:colaborador/feature/timesheet/domain/repository/timesheet_repository.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet/get_timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet/get_timesheet_impl.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_detail/get_timesheet_detail.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_detail/get_timesheet_detail_impl.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods_impl.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/send_email/send_email.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/send_email/send_email_impl.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/sign_timesheet/sign_timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/sign_timesheet/sign_timesheet_impl.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/bloc/timesheet_sign_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/bloc/timesheet_detail_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/bloc/timesheet_email_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_bloc.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:get_it/get_it.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/network/refresh_authenticator_interceptor.dart';
import 'package:shared_features/feature/attach_files/bloc/attach_files_bloc.dart';
import 'package:shared_features/feature/attach_files/store/attach_files_store.dart';
import 'package:shared_features/feature/authentication/data/data_source/remote/authentication_api.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
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
import 'package:shared_features/feature/gdp/data/data_source/remote/employee_api.dart';
import 'package:shared_features/feature/gdp/data/data_source/remote/employee_remote_data_source.dart';
import 'package:shared_features/feature/gdp/data/data_source/remote/employee_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/data/repository/employee_repository_impl.dart';
import 'package:shared_features/feature/gdp/domain/entity/condominium.dart';
import 'package:shared_features/feature/gdp/domain/repository/employee_repository.dart';
import 'package:shared_features/feature/gdp/domain/use_case/get_employee/get_employee.dart';
import 'package:shared_features/feature/gdp/domain/use_case/get_employee/get_employee_impl.dart';
import 'package:shared_features/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:shared_features/feature/gdp/domain/use_case/list_employee/list_employee_impl.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/employee/employee_bloc.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/list/employee_list_bloc.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll/payroll_api.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll/payroll_remote_data_source.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll/payroll_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll_entry/payroll_entry_api.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll_entry/payroll_entry_remote_data_source.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll_entry/payroll_entry_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/payroll/data/repository/payroll_entry_repository_impl.dart';
import 'package:shared_features/feature/gdp/payroll/data/repository/payroll_repository_impl.dart';
import 'package:shared_features/feature/gdp/payroll/domain/repository/payroll_entry_repository.dart';
import 'package:shared_features/feature/gdp/payroll/domain/repository/payroll_repository.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/get_payroll/get_payroll.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/get_payroll/get_payroll_impl.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/list_payroll/list_payroll.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/list_payroll/list_payroll_impl.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/list_payroll_entry/list_payroll_entry.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/list_payroll_entry/list_payroll_entry_impl.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll/payroll_bloc.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll_entry/payroll_entry_bloc.dart';
import 'package:shared_features/feature/gdp/payslip/data/data_source/payslip_api.dart';
import 'package:shared_features/feature/gdp/payslip/data/data_source/payslip_remote_data_source.dart';
import 'package:shared_features/feature/gdp/payslip/data/data_source/payslip_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/payslip/data/repository/payslip_repository_impl.dart';
import 'package:shared_features/feature/gdp/payslip/domain/repository/payslip_repository.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip_impl.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file_impl.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_bloc.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_bloc.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/data_source/remote/employee_report_api.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/data_source/remote/employee_report_remote_data_source.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/data_source/remote/employee_report_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/repository/employee_report_repository_impl.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/repository/employee_report_repository.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report_impl.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_bloc.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/data/data_source/timesheet_api.dart';
import 'package:shared_features/feature/gdp/timesheet/data/data_source/timesheet_remote_data_source.dart';
import 'package:shared_features/feature/gdp/timesheet/data/data_source/timesheet_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/data/repository/timesheet_repository_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/get_report_day/get_report_day.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/get_report_day/get_report_day_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/insert_timesheet_event/insert_timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/insert_timesheet_event/insert_timesheet_event_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_signature/list_signature.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_signature/list_signature_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet/list_timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet/list_timesheet_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet_employee/list_timesheet_employee.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet_employee/list_timesheet_employee_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/request_timesheet/request_timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/request_timesheet/request_timesheet_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/sign_timesheet/sign_timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/sign_timesheet/sign_timesheet_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_signatures/timesheet_signatures_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/data/data_source/vacation_api.dart';
import 'package:shared_features/feature/gdp/vacation/data/data_source/vacation_remote_data_source.dart';
import 'package:shared_features/feature/gdp/vacation/data/data_source/vacation_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/vacation/data/repository/vacation_repository_impl.dart';
import 'package:shared_features/feature/gdp/vacation/domain/repository/vacation_repository.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation_impl.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days_impl.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period_impl.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation_impl.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/details/vacation_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:shared_features/feature/ghost_notification/data/data_source/ghost_notification_api.dart';
import 'package:shared_features/feature/notifications/data/data_source/notifications_api.dart';
import 'package:shared_features/feature/registration/data/data_source/registration_api.dart';
import 'package:shared_features/feature/registration/presentation/store/registration_store.dart';
import 'package:shared_features/feature/reset_password/data/data_source/password_reset_api.dart';
import 'package:shared_features/shared_features.dart';

import '../bloc/inactivity/inactivity_cubit.dart';
import '../database/lello_database/employee/employee_dao.dart';
import '../stores/session_store.dart';

class ApplicationContainer extends SharedApplicationContainer {
  static final ApplicationContainer _instance =
      ApplicationContainer._internal();

  ApplicationContainer._internal();

  factory ApplicationContainer.instance() {
    return _instance;
  }

  final GetIt locator = GetIt.asNewInstance();

  Future<void> setUp(Environment environment) async {
    _setupDependencies(environment);
    await afterSetup();
  }

  void _setupDependencies(Environment environment) {
    final database = LelloDatabase();
    final digitalPointDatabase = DigitalPointDatabase();
    final authenticationTabletDatabase = AuthenticationTabletDatabase();

    locator.registerSingleton(environment);

    locator.registerLazySingleton(() => Connectivity());

    locator
        .registerLazySingleton(() => AppConnectivity(connectivity: resolve()));

    locator.registerLazySingleton(() => ChopperClient(
        baseUrl: Uri.tryParse(environment.apiUrl),
        converter: const JsonConverter(),
        errorConverter: ApiFailureConverter(),
        authenticator: RefreshAuthenticatorInterceptor(
          dataSource: resolve(),
          refreshToken: resolve(),
        ),
        interceptors: [AuthorizationHeaderInterceptor(dataSource: resolve())]));

    locator.registerFactory<Validator>(() => ValidatorImpl());

    locator.registerLazySingleton(
      () => SyncDigitalPointsWorker(
        getPendingPointsUsecase: resolve(),
        syncPointWithoutLoginUsecase: resolve(),
      ),
    );

    locator.registerFactory(() => AttachFilesBloc());

    locator.registerLazySingleton(() => AttachFilesStore(bloc: resolve()));

    //AuthenticationTabletDatabase Dao
    locator.registerLazySingleton<CondominiumInfoDao>(
        () => authenticationTabletDatabase.condominiumInfoDao);
    locator.registerLazySingleton<EmployeeInfoDao>(
        () => authenticationTabletDatabase.employeeInfoDao);

    //DigitalPointDatabase Dao
    locator.registerLazySingleton<DigitalPointDao>(
        () => digitalPointDatabase.digitalPointDao);
    locator.registerLazySingleton<DigitalPointLogDao>(
        () => digitalPointDatabase.digitalPointLogDao);

    //Splash
    locator.registerFactory<AuthenticationApi>(
        () => AuthenticationApi.create(resolve()));
    locator
        .registerFactory<GetToken>(() => GetTokenImpl(repository: resolve()));
    locator.registerFactory<AuthenticateFirebase>(
        () => AuthenticateFirebaseImpl());
    locator.registerFactory<AccessTokenLocalDataSource>(
        () => AccessTokenLocalDataSourceImpl());
    locator.registerFactory<AccessTokenRemoteDataSource>(
        () => AccessTokenRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<RefreshTokenRemoteDataSource>(() =>
        RefreshTokenRemoteDataSourceImpl(
            baseUrl: Uri.tryParse(environment.apiUrl)));
    locator.registerFactory<AccessTokenRepository>(() =>
        AccessTokenRepositoryImpl(
            remoteDataSource: resolve(), dataSource: resolve()));
    locator.registerFactory<RefreshTokenRepository>(() =>
        RefreshTokenRepositoryImpl(
            remoteDataSource: resolve(), dataSource: resolve()));

    locator.registerFactory<Logout>(() => LogoutImpl(
        repository: resolve(),
        pendencyRepository: resolve<NotificationsRepository>(),
        sessionRepository: resolve<SessionRepository>()));
    locator.registerFactory<Authenticate>(() => AuthenticateImpl(
        repository: resolve(), authenticateFirebase: resolve()));
    locator.registerFactory<SwitchRoles>(() => SwitchRolesImpl(
        repository: resolve(), authenticateFirebase: resolve()));
    locator.registerFactory<RefreshToken>(() =>
        RefreshTokenImpl(repository: resolve(), authenticationBloc: resolve()));
    locator.registerFactory<DeleteAccount>(
        () => DeleteAccountImpl(repository: resolve()));
    locator.registerLazySingleton<AuthenticationBloc>(
      () => AuthenticationBloc(),
    );
    locator.registerLazySingleton(
      () => AuthenticationStore(
        bloc: resolve(),
        authenticateUsecase: resolve(),
        logoutUsecase: resolve(),
        getToken: resolve(),
        switchRoles: resolve(),
        appOrigin: AppOriginEnum.employee,
      ),
    );
    locator.registerFactory<NotificationsApi>(
      () => NotificationsApi.create(resolve()),
    );

    locator.registerFactory<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl(api: resolve()),
    );

    locator.registerFactory<NotificationsRepository>(
      () => NotificationsRepositoryImpl(
        remoteDataSource: resolve(),
      ),
    );

    locator.registerFactory<SendPushCallback>(
        () => SendPushCallbackImpl(repository: resolve()));

    locator.registerLazySingleton<GetNotifications>(
      () => GetNotificationsImpl(repository: resolve()),
    );

    locator.registerLazySingleton<ReadNotification>(
      () => ReadNotificationsImpl(repository: resolve()),
    );

    locator.registerLazySingleton<DeleteAllReadNotification>(
      () => DeleteAllReadNotificationImpl(repository: resolve()),
    );

    locator.registerLazySingleton<DeleteNotification>(
      () => DeleteNotificationImpl(repository: resolve()),
    );

    locator.registerLazySingleton<MarkAllReadNotification>(
      () => MarkAllReadNotificationImpl(repository: resolve()),
    );

    locator.registerLazySingleton<NotificationResume>(
      () => NotificationResumeImpl(repository: resolve()),
    );
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
          appOriginEnum: AppOriginEnum.employee,
        ));

    locator.registerFactory<PreferencesApi>(
        () => PreferencesApi.create(resolve()));
    locator.registerFactory<PreferencesDataSource>(
        () => PreferencesDataSourceImpl(api: resolve()));
    locator.registerFactory<PreferencesRepository>(
        () => PreferencesRepositoryImpl(dataSource: resolve()));

    locator.registerFactory<GetNotificationUseCase>(
        () => GetNotificationUseCaseImpl(repository: resolve()));
    locator.registerFactory<PutNotificationUseCase>(
        () => PutNotificationUseCaseImpl(repository: resolve()));
    locator.registerFactory<PreferencesNotificationBloc>(
        () => PreferencesNotificationBloc());
    locator.registerLazySingleton(() => PreferencesNotificationController(
        bloc: resolve(),
        getNotificationUseCase: resolve(),
        putNotificationUseCase: resolve(),
        sessionBloc: resolve()));

    //Code validation
    locator.registerFactory<CodeValidationApi>(
        () => CodeValidationApi.create(resolve()));
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
        () => CodeValidationRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<CodeValidationRepository>(
        () => CodeValidationRepositoryImpl(dataSource: resolve()));
    locator.registerFactory<RequestValidationCode>(
        () => RequestValidationCodeImpl(repository: resolve()));
    locator.registerFactory<ValidateCode>(
        () => ValidateCodeImpl(repository: resolve()));

    locator.registerFactory<GetDados2fa>(
        () => GetDados2faImpl(repository: resolve()));
    locator.registerFactory<Request2fa>(
        () => Request2faImpl(repository: resolve()));
    locator.registerFactory<Validate2fa>(
        () => Validate2faImpl(repository: resolve()));

    //Registration
    locator.registerFactory<RegistrationApi>(
        () => RegistrationApi.create(resolve()));

    locator.registerFactory<ProfilePictureRepository>(
        () => ProfilePictureRepositoryImpl(uploader: resolve()));
    locator.registerFactory<RegistrationRemoteDataSource>(
        () => RegistrationRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<RegistrationRepository>(
        () => RegistrationRepositoryImpl(dataSource: resolve()));
    locator.registerFactory<Register>(() => RegisterImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<GetMyUser>(() => GetMyUserImpl(repository: resolve()));
    locator.registerFactory<UploadProfilePicture>(() =>
        UploadProfilePictureImpl(sessionBloc: resolve(), uploader: resolve()));
    locator.registerLazySingleton(() => RegistrationBloc());
    locator.registerLazySingleton(() => RegistrationStore(
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
        ));
    locator.registerLazySingleton<Uploader>(() => UploaderImpl(
          environment: resolve(),
          getToken: resolve(),
          session: resolve(),
        ));

    //Session
    locator.registerLazySingleton(() => SessionStore());
    locator.registerFactory<SessionLocalDataSource>(
        () => SessionLocalDataSourceImpl());
    locator.registerFactory<SessionRepository>(
        () => SessionRepositoryImpl(sessionDataSource: resolve()));
    locator.registerFactory<LoadSession>(
        () => LoadSessionImpl(getMe: resolve(), repository: resolve()));
    locator.registerFactory<SaveSession>(
        () => SaveSessionImpl(repository: resolve()));
    locator.registerLazySingleton<SessionBloc>(
      () => SessionBloc(
        store: resolve(),
        authenticationStore: resolve(),
        saveSession: resolve(),
        loadSession: resolve(),
        baseUrl: environment.apiUrl,
        switchRoles: resolve(),
        logMeOut: resolve(),
      ),
    );

    locator.registerLazySingleton(
      () => InactivityCubit(
        sessionBloc: resolve<SessionBloc>(),
      ),
    );

    locator.registerFactory<HomeDialogBloc>(() => HomeDialogBloc(
          sessionBloc: resolve(),
        ));

    //Me
    locator.registerFactory<MeApi>(() => MeApi.create(resolve()));
    locator.registerLazySingleton<MeDao>(() => database.meDao);
    locator
        .registerLazySingleton<CondominiumDao>(() => database.condominiumDao);
    locator.registerLazySingleton<CondominiumEmployeeScheduleDao>(
        () => database.condominiumEmployeeScheduleDao);

    locator.registerFactory<MeRepository>(
      () => MeRepositoryImpl(
        localDataSource: resolve(),
        remoteDataSource: resolve(),
      ),
    );
    locator.registerFactory<GetMe>(() => GetMeImpl(repository: resolve()));
    locator.registerFactory<SaveMe>(() => SaveMeImpl(repository: resolve()));
    locator.registerFactory<UpdatePasswordMe>(
        () => UpdatePasswordMeImpl(repository: resolve()));
    locator.registerFactory<MeLocalDataSource>(() => MeLocalDataSourceImpl(
          meDao: resolve(),
          condominiumDao: resolve(),
          condominiumEmployeeScheduleDao: resolve(),
        ));
    locator.registerFactory<MeRemoteDataSource>(() => MeRemoteDataSourceImpl(
          api: resolve(),
          idEmpresa: FlavorConfig.config.idEmpresa,
        ));
    locator.registerFactory<LogMeOut>(() => LogMeOutImpl(
          accessTokenRepository: resolve(),
          db: database,
          sessionRepository: resolve(),
          meRepository: resolve(),
        ));
    locator.registerFactory<MeBloc>(() => MeBloc(
        getMe: resolve(),
        sessionBloc: resolve(),
        getDados2faUseCase: resolve(),
        request2faUseCase: resolve(),
        saveMe: resolve(),
        authenticationBloc: resolve(),
        authenticationStore: resolve(),
        uploadProfilePicture: resolve(),
        updatePasswordMe: resolve(),
        logMeOut: resolve(),
        deleteUser: resolve(),
        disableFcm: resolve(),
        baseUrl: environment.apiUrl));

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
      () => ExpiredSessionBloc(
          clearDataUseCase: resolve(),
          logOutUseCase: resolve(),
          // `VoidCallback` não é um tipo registrado no container: o estado
          // vazio da sessão é o próprio logout do `SessionBloc`.
          emptySessionState: resolve<SessionBloc>().logout),
    );

    // HOME
    locator.registerFactory<HomeApi>(() => HomeApi.create(resolve()));
    locator.registerLazySingleton(
      () => HomeController(
          getPointsUsecase: resolve(),
          getPointsByStatusUsecase: resolve(),
          sessionBloc: resolve(),
          connectivity: resolve(),
          homeBloc: resolve(),
          authenticationStore: resolve(),
          getToken: resolve()),
    );
    locator.registerLazySingleton(() => RegisterPointBloc());
    locator.registerLazySingleton(
      () => RegisterPointController(
        appConnectivity: resolve(),
        sessionBloc: resolve(),
        registerPointBloc: resolve(),
        digitalPointController: resolve(),
      ),
    );
    locator.registerFactory<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<HomeRepository>(
        () => HomeRepositoryImpl(dataSource: resolve()));

    locator.registerFactory<RegisterFcm>(
        () => RegisterFcmImpl(repository: resolve()));

    locator.registerLazySingleton<HomeBloc>(
      () => HomeBloc(
        registerFcm: resolve(),
        sessionBloc: resolve(),
        deviceIdentifierService: resolve(),
      ),
    );
    locator.registerLazySingleton(() => DeviceIdentifierService());

    locator.registerFactory<DisableFcm>(() => DisableFcmImpl(
          repository: resolve(),
          accessTokenRepository: resolve(),
        ));

    //DigitalPoint
    locator.registerLazySingleton(
      () => DigitalPointController(
        sessionBloc: resolve(),
        appConnectivity: resolve(),
      ),
    );
    locator.registerFactory<DigitalPointApi>(
        () => DigitalPointApi.create(resolve()));
    locator.registerFactory<DigitalPointLocalDataSource>(() =>
        DigitalPointLocalDataSourceImpl(
            digitalPointDao: resolve(), digitalPointLogDao: resolve()));
    locator.registerFactory<DigitalPointRemoteDataSource>(
        () => DigitalPointRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<DigitalPointRepository>(() =>
        DigitalPointRepositoryImpl(
            localDataSource: resolve(),
            remoteDataSource: resolve(),
            uploader: resolve()));
    locator
        .registerFactory<RequestDigitalUsecase>(() => RequestDigitalUsecaseImpl(
              repository: resolve(),
              awsUploadFileUsecase: resolve(),
            ));
    locator
        .registerFactory<RegisterPointUsecase>(() => RegisterPointUsecaseImpl(
              repository: resolve(),
              awsUploadFileUsecase: resolve(),
            ));
    locator.registerFactory(() => GetPointsUsecase(repository: resolve()));

    locator
        .registerFactory(() => GetPendingPointsUsecase(repository: resolve()));

    locator.registerFactory<SyncPointWithoutLoginUsecase>(() =>
        SyncPointWithoutLoginUsecaseImpl(
            repository: resolve(), uploadDigitalPointToAwsUsecase: resolve()));
    locator
        .registerFactory(() => GetPointsByStatusUsecase(repository: resolve()));
    locator
        .registerFactory(() => GetPointsNoAuthUsecase(repository: resolve()));
    locator.registerFactory<SavePointUsecase>(
        () => SavePointUsecaseImpl(repository: resolve()));
    locator.registerFactory<UploadDigitalPointToAwsUsecase>(
        () => UploadDigitalPointToAwsUsecaseImpl(
              repository: resolve(),
              awsUploadFileUsecase: resolve(),
            ));
    locator.registerFactory<SyncPointsUsecase>(() => SyncPointsUsecaseImpl(
          repository: resolve(),
          uploadDigitalPointToAwsUsecase: resolve(),
        ));
    locator.registerFactory<DigitalPointBloc>(
      () => DigitalPointBloc(
        appConnectivity: resolve(),
        getImageFromCameraViewPickerUsecase: resolve(),
        requestDigitalUsecase: resolve(),
        registerPointUsecase: resolve(),
        savePointUsecase: resolve(),
        sessionBloc: resolve(),
      ),
    );
    locator.registerFactory<CheckDigitalPointUsecase>(
        () => CheckDigitalPointUsecaseImpl(
              repository: resolve(),
            ));

    locator.registerFactory<GetImageFromCameraViewPickerUsecase>(
        () => GetImageFromCameraViewPickerUsecase());

    //AWS
    locator.registerFactory<AwsUploadFileUsecase>(
        () => AwsUploadFileUsecaseImpl());

    //SyncDigitalPoint
    locator
        .registerFactory<SyncDigitalPointsBloc>(() => SyncDigitalPointsBloc(
              syncPointsUsecase: resolve(),
              sessionBloc: resolve(),
            ));

    //Timesheet
    locator.registerFactory<TimesheetApi>(() => TimesheetApi.create(resolve()));
    locator.registerFactory<TimesheetRemoteDataSource>(
        () => TimesheetRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<TimesheetRepository>(
      () => TimesheetRepositoryImpl(remoteDataSource: resolve()),
    );
    locator.registerFactory<GetTimesheetUsecase>(() => GetTimesheetUsecaseImpl(
          repository: resolve(),
        ));
    locator.registerFactory<TimesheetSendEmailUsecase>(
        () => TimesheetSendEmailUsecaseImpl(
              repository: resolve(),
            ));
    locator
        .registerFactory<SignTimesheetUsecase>(() => SignTimesheetUsecaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<GetTimesheetDetailUsecase>(
        () => GetTimesheetDetailUsecaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<GetTimesheetPeriodsUsecase>(
        () => GetTimesheetPeriodsUsecaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<TimesheetBloc>(
      () => TimesheetBloc(
        sessionBloc: resolve(),
        getTimesheetUsecase: resolve(),
        getTimesheetPeriodsUsecase: resolve(),
        store: resolve(),
      ),
    );
    locator.registerFactory<TimesheetEmailBloc>(() => TimesheetEmailBloc(
          sendEmailUsecase: resolve(),
          sessionBloc: resolve(),
        ));
    locator.registerFactory<TimesheetSignBloc>(() => TimesheetSignBloc(
          timesheetSignUsecase: resolve(),
          sessionBloc: resolve(),
        ));
    locator.registerFactory<TimesheetDetailBloc>(() => TimesheetDetailBloc(
          getTimesheetDetailUsecase: resolve(),
          sessionBloc: resolve(),
        ));

    //SickNote
    locator.registerFactory<SickNoteApi>(() => SickNoteApi.create(resolve()));
    locator.registerFactory<SickNoteRemoteDataSource>(
        () => SickNoteRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<SickNoteRepository>(() => SickNoteRepositoryImpl(
        remoteDataSource: resolve(), uploader: resolve()));
    locator.registerFactory<RegisterSickNoteUsecase>(
        () => RegisterSickNoteUsecaseImpl(
              repository: resolve(),
              awsUploadFileUsecase: resolve(),
            ));
    locator.registerFactory<UploadSickNoteToAwsUsecase>(
        () => UploadSickNoteToAwsUsecaseImpl(
              repository: resolve(),
              awsUploadFileUsecase: resolve(),
            ));
    locator.registerFactory<SickNoteBloc>(() => SickNoteBloc(
          registerSickNoteUsecase: resolve(),
          sessionBloc: resolve(),
        ));

    //Employee Referral
    locator.registerFactory<EmployeeReferralApi>(
        () => EmployeeReferralApi.create(resolve()));
    locator.registerFactory<EmployeeReferralRemoteDataSource>(
        () => EmployeeReferralRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<EmployeeReferralRepository>(() =>
        EmployeeReferralRepositoryImpl(
            remoteDataSource: resolve(), uploader: resolve()));
    locator.registerFactory<RegisterEmployeeReferralUsecase>(
        () => RegisterEmployeeReferralUsecaseImpl(
              repository: resolve(),
              awsUploadFileUsecase: resolve(),
            ));
    locator.registerFactory<GetCitiesUsecase>(() => GetCitiesUsecaseImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<EmployeeReferralBloc>(() => EmployeeReferralBloc(
              sessionBloc: resolve(),
              getCitiesUsecase: resolve(),
              registerEmployeeReferralcase: resolve(),
            ));

    //proof
    locator.registerFactory<ProofApi>(() => ProofApi.create(resolve()));
    locator.registerFactory<ProofRemoteDataSource>(
        () => ProofRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<ProofRepository>(
      () => ProofRepositoryImpl(remoteDataSource: resolve()),
    );
    locator.registerFactory<GetProofUseCase>(() => GetProofUseCaseImpl(
          repository: resolve(),
        ));
    locator.registerFactory<GetProofFileUseCase>(() => GetProofFileUseCaseImpl(
          repository: resolve(),
        ));

    locator.registerFactory<ProofBloc>(() => ProofBloc(
          getProofUseCase: resolve(),
          getProofFileUseCase: resolve(),
          sessionBloc: resolve(),
        ));

    //Login Tablet
    locator.registerFactory<AuthenticationTabletApi>(
        () => AuthenticationTabletApi.create(resolve()));
    locator.registerFactory<AuthenticationTabletRemoteDataSource>(
        () => AuthenticationTabletRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<AuthenticationTabletLocalDataSource>(() =>
        AuthenticationTabletLocalDataSourceImpl(
            condominiumInfoDao: resolve(), employeeInfoDao: resolve()));
    locator.registerFactory<AuthenticationTabletRepository>(
      () => AuthenticationTabletRepositoryImpl(
          localDataSource: resolve(), remoteDataSource: resolve()),
    );
    locator.registerFactory<GetInfoByCondoCodeUseCase>(
        () => GetInfoByCondoCodeUseCaseImpl(repository: resolve()));
    locator.registerFactory<AuthenticationTabletBloc>(
      () => AuthenticationTabletBloc(
        getInfoByCondoCodeUseCase: resolve(),
        getPendingPointsUsecase: resolve(),
        syncPoints: resolve(),
      ),
    );

    //Documents
    locator.registerFactory<DocumentsApi>(() => DocumentsApi.create(resolve()));
    locator.registerFactory<DocumentsRemoteDataSource>(
        () => DocumentsRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<DocumentsRepository>(
      () => DocumentsRepositoryImpl(remoteDataSource: resolve()),
    );
    locator.registerFactory<GetDocumentsInfoListUseCase>(
        () => GetDocumentsInfoListUsecaseImpl(
              repository: resolve(),
            ));
    locator.registerFactory<GetDocumentFileUseCase>(
        () => GetDocumentFileUsecaseImpl(repository: resolve()));

    locator.registerFactory<IncomeReportBloc>(() => IncomeReportBloc(
          sessionBloc: resolve(),
          getDocumentsInfoListUseCase: resolve(),
        ));
    locator.registerFactory<PayStubBloc>(() => PayStubBloc(
          sessionBloc: resolve(),
          getDocumentsInfoListUseCase: resolve(),
        ));
    locator.registerFactory<BenefitsBloc>(() => BenefitsBloc(
          sessionBloc: resolve(),
          getDocumentsInfoListUseCase: resolve(),
        ));
    locator.registerFactory<VacationBloc>(() => VacationBloc(
          sessionBloc: resolve(),
          getDocumentsInfoListUseCase: resolve(),
        ));
    locator.registerFactory<DocumentFileBloc>(() => DocumentFileBloc(
          sessionBloc: resolve(),
          getDocumentFileUseCase: resolve(),
        ));

    //manual Timesheet
    locator.registerFactory<ManualTimeSheetApi>(
        () => ManualTimeSheetApi.create(resolve()));
    locator.registerFactory<ManualTimeSheetRemoteDataSource>(
        () => ManualTimeSheetRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<ManualTimeSheetRepository>(() =>
        ManualTimeSheetRepositoryImpl(
            remoteDataSource: resolve(), uploader: resolve()));
    locator.registerFactory<RegisterManualTimeSheetUsecase>(
        () => RegisterManualTimeSheetUsecaseImpl(
              repository: resolve(),
              awsUploadFileUsecase: resolve(),
            ));
    locator.registerFactory<UploadManualTimeSheetToAwsUsecase>(
        () => UploadManualTimeSheetToAwsUsecaseImpl(
              repository: resolve(),
              awsUploadFileUsecase: resolve(),
            ));
    locator.registerFactory<ManualTimeSheetBloc>(() => ManualTimeSheetBloc(
          registerManualTimeSheetUsecase: resolve(),
          sessionBloc: resolve(),
        ));

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
          appOriginEnum: AppOriginEnum.employee),
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
          getToken: resolve(),
          appOriginEnum: AppOriginEnum.employee,
          sessionBloc: resolve<SessionBloc>(),
        ));
    locator.registerFactory<ComfortPartnerReviewsBloc>(
        () => ComfortPartnerReviewsBloc());
    locator.registerLazySingleton(
      () => ComfortPartnerReviewsController(
          getAllPartnerReviewsUseCase: resolve(),
          sessionBloc: resolve<SessionBloc>(),
          appOriginEnum: AppOriginEnum.employee,
          comfortPartnerReviewsBloc: resolve()),
    );
    locator.registerFactory<ComfortRemoteDataSource>(
        () => ComfortRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<ComfortRepository>(() => ComfortRepositoryImpl(
          remoteDataSource: resolve(),
        ));
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

    //GDP
    //employee
    locator.registerFactory<EmployeeApi>(() => EmployeeApi.create(
          resolve(),
        ));
    locator.registerFactory<ListEmployee>(() => ListEmployeeImpl(
          repository: resolve(),
        ));
    // locator.registerFactory<EmployeeLocalDataSource>(
    //     () => EmployeeLocalDataSourceImpl(
    //           dao: resolve(),
    //         ));
    locator.registerFactory<EmployeeRemoteDataSource>(
        () => EmployeeRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<EmployeeRepository>(() => EmployeeRepositoryImpl(
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<EmployeeListBloc>(() => EmployeeListBloc(
          sessionBloc: resolve<SessionBloc>().getSession,
          listEmployee: resolve(),
          appOriginEnum: AppOriginEnum.employee,
        ));
    locator.registerFactory<GetEmployee>(() => GetEmployeeImpl(
          repository: resolve(),
        ));
    locator.registerFactory<EmployeeBloc>(() => EmployeeBloc(
          sessionBloc: resolve<SessionBloc>().getSession,
          getEmployee: resolve(),
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
    locator.registerFactory<QuickFixBloc>(() => QuickFixBloc(
          sessionBloc: resolve<SessionBloc>().getSession,
          listEmployee: resolve(),
          appOriginEnum: AppOriginEnum.employee,
        ));
    locator.registerFactory<QuickFixReportBloc>(() => QuickFixReportBloc(
          condominiumId: CondominiumGDP.fromMe(
              resolve<SessionBloc>().getSession?.condominium),
          getEmployeeReport: resolve(),
          appOriginEnum: AppOriginEnum.employee,
          sessionBloc: resolve<SessionBloc>().getSession,
        ));

    //gdp - timesheet
    locator.registerFactory<TimesheetGDPApi>(() => TimesheetGDPApi.create(
          resolve(),
        ));
    locator.registerFactory<TimesheetGDPRemoteDataSource>(
        () => TimesheetGDPRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<TimesheetGDPRepository>(
        () => TimesheetGDPRepositoryImpl(
              remoteDataSource: resolve(),
            ));
    locator.registerFactory<ListTimesheet>(() => ListTimesheetImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<ListTimesheetEmployee>(() => ListTimesheetEmployeeImpl(
              repository: resolve(),
            ));
    locator.registerFactory<SignTimesheet>(() => SignTimesheetImpl(
          repository: resolve(),
        ));
    locator.registerFactory<ListSignature>(() => ListSignatureImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<InsertTimesheetEvent>(() => InsertTimesheetEventImpl(
              repository: resolve(),
            ));
    locator.registerFactory<GetReportDay>(() => GetReportDayImpl(
          repository: resolve(),
        ));
    locator.registerFactory<RequestTimesheet>(() => RequestTimesheetImpl(
          repository: resolve(),
        ));
    locator.registerFactory<TimesheetMenuBloc>(() => TimesheetMenuBloc(
          sessionBloc: resolve<SessionBloc>().getSession,
          getReportDay: resolve(),
          listTimesheetEmployee: resolve(),
          requestTimesheet: resolve(),
        ));
    locator.registerFactory<TimesheetListBloc>(() => TimesheetListBloc(
          sessionBloc: resolve<SessionBloc>().getSession,
          listTimesheet: resolve(),
          insertTimesheetEvent: resolve(),
          appOriginEnum: AppOriginEnum.employee,
        ));
    locator.registerFactory<TimesheetSignaturesBloc>(
        () => TimesheetSignaturesBloc(
              sessionBloc: resolve<SessionBloc>().getSession,
              listSignature: resolve(),
              signTimesheet: resolve(),
              appOriginEnum: AppOriginEnum.employee,
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
        .registerFactory<ScheduleVacationBloc>(() => ScheduleVacationBloc(
              sessionBloc: resolve<SessionBloc>().getSession,
              scheduleVacation: resolve(),
              appOriginEnum: AppOriginEnum.employee,
            ));
    locator.registerFactory<ScheduleVacation>(() => ScheduleVacationImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<VacationEmployeesBloc>(() => VacationEmployeesBloc(
              sessionBloc: resolve<SessionBloc>().getSession,
              listEmployee: resolve(),
            ));
    locator.registerFactory<GetVacation>(() => GetVacationImpl(
          repository: resolve(),
        ));
    locator.registerFactory<VacationGDPBloc>(() => VacationGDPBloc(
          sessionBloc: resolve<SessionBloc>().getSession,
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
        .registerFactory<PayslipEmployeesBloc>(() => PayslipEmployeesBloc(
              sessionBloc: resolve<SessionBloc>().getSession,
              listEmployee: resolve(),
            ));
    locator.registerFactory<GetPayslip>(() => GetPayslipImpl(
          repository: resolve(),
        ));
    locator.registerFactory<GetPayslipFile>(() => GetPayslipFileImpl(
          repository: resolve(),
        ));
    locator
        .registerFactory<PayslipSelectionBloc>(() => PayslipSelectionBloc(
              sessionBloc: resolve<SessionBloc>().getSession,
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
    locator.registerFactory<PayrollBloc>(() => PayrollBloc(
          sessionBloc: resolve<SessionBloc>().getSession,
          getPayroll: resolve(),
          listPayroll: resolve(),
        ));

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
    locator.registerFactory<PayrollEntryBloc>(() => PayrollEntryBloc(
          sessionBloc: resolve<SessionBloc>().getSession,
          listPayrollEntry: resolve(),
        ));

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
              getPointsUsecase: resolve(),
            ));

    locator.registerFactory<PreferencesHomeCardsBloc>(
        () => PreferencesHomeCardsBloc());
    locator.registerLazySingleton(() => PreferencesHomeCardsController(
          sessionBloc: resolve<SessionBloc>(),
          bloc: resolve(),
        ));

    locator.registerLazySingleton<CircuitBreakerController>(
        () => CircuitBreakerController(
              database: FirebaseFirestore.instance,
              sessionBloc: resolve<SessionBloc>(),
              environment: environment,
            ));
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
