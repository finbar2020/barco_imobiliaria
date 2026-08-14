library shared_features;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide Image;
import 'package:essentials/paginator/paginator.dart';
import 'package:essentials/paginator/paginator_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/access_settings_permission_denied/entity/access_settings_permissions_denied_item.dart';
import 'package:shared_features/feature/access_settings_permission_denied/presentation/page/access_settings_permission_denied_page.dart';
import 'package:shared_features/feature/access_settings_permission_denied/presentation/page/access_settings_permission_denied_page.dart';
import 'package:shared_features/feature/attach_files/widgets/attach_files_error_toasts.dart';
import 'package:shared_features/feature/authentication/data/data_source/remote/authentication_api.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_model.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_request_model.dart';
import 'package:shared_features/feature/authentication/data/model/refresh_token_request_model.dart';
import 'package:shared_features/feature/authentication/data/model/role_model.dart';
import 'package:shared_features/feature/code_validation/data/data_source/code_validation_api.dart';
import 'package:shared_features/feature/code_validation/data/model/code_data_model.dart';
import 'package:shared_features/feature/code_validation/data/model/code_request_model.dart';
import 'package:shared_features/feature/code_validation/data/model/code_valid_token_model.dart';
import 'package:shared_features/feature/code_validation/data/model/code_validation_model.dart';
import 'package:shared_features/feature/ghost_notification/data/data_source/ghost_notification_api.dart';
import 'package:shared_features/feature/ghost_notification/data/model/ghost_notification_model.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';
import 'package:shared_features/feature/notifications/data/models/notification_model.dart';
import 'package:shared_features/feature/notifications/data/models/notification_resume_model.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_list_tile.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_list_widget.dart';
import 'package:shared_features/feature/registration/data/data_source/registration_api.dart';
import 'package:shared_features/feature/registration/data/model/registation_model.dart';
import 'package:shared_features/feature/registration/data/model/register_fcm_token_model.dart';
import 'package:shared_features/feature/registration/data/model/registration_lello_user_model.dart';
import 'package:shared_features/feature/reset_password/data/data_source/password_reset_api.dart';
import 'package:shared_features/feature/reset_password/data/model/password_reset_model.dart';

import 'feature/attach_files/bloc/attach_files_bloc.dart';
import 'feature/attach_files/store/attach_files_store.dart';
import 'feature/authentication/presentation/store/authentication_store.dart';
import 'feature/code_validation/presentation/store/code_validation_store.dart';
import 'feature/notifications/data/data_source/notifications_api.dart';
import 'feature/registration/presentation/store/registration_store.dart';

part 'core/check_permissions/check_permissions.dart';
part 'core/failure_message.dart';

///?core
///
part 'core/shared_application_container.dart';
part 'core/shared_application_redirect_rote.dart';
part 'core/shared_application_rote.dart';
part 'core/shared_preferences_keys.dart';
//? Tablet Session
part 'core/tablet_session/tablet_session_utils.dart';
//Attach Files

part 'feature/attach_files/widgets/attach_files_bottom_sheet.dart';
part 'feature/attach_files/widgets/attach_files_widget.dart';
//? Data sources
part 'feature/authentication/data/data_source/local/access_token_local_data_source.dart';
part 'feature/authentication/data/data_source/local/access_token_local_data_source_impl.dart';
part 'feature/authentication/data/data_source/remote/access_token_remote_data_source.dart';
part 'feature/authentication/data/data_source/remote/access_token_remote_data_source_impl.dart';
part 'feature/authentication/data/data_source/remote/refresh_token_remote_data_source.dart';
part 'feature/authentication/data/data_source/remote/refresh_token_remote_data_source_impl.dart';
//? repository - impl
part 'feature/authentication/data/repository/access_token_repository_impl.dart';
part 'feature/authentication/data/repository/refresh_token_repository_impl.dart';
//?entity
part 'feature/authentication/domain/entity/access_token.dart';
part 'feature/authentication/domain/entity/auth_arguments.dart';
part 'feature/authentication/domain/entity/credentials.dart';
part 'feature/authentication/domain/entity/role.dart';
//? repository - domain

part 'feature/authentication/domain/repository/access_token_repository.dart';
part 'feature/authentication/domain/repository/refresh_token_repository.dart';
//? Use case

part 'feature/authentication/domain/use_case/authenticate/authenticate.dart';
part 'feature/authentication/domain/use_case/authenticate/authenticate_failures.dart';
part 'feature/authentication/domain/use_case/authenticate/authenticate_impl.dart';
part 'feature/authentication/domain/use_case/authenticate_convite/authenticate_convite.dart';
part 'feature/authentication/domain/use_case/authenticate_convite/authenticate_convite_failures.dart';
part 'feature/authentication/domain/use_case/authenticate_convite/authenticate_convite_impl.dart';
part 'feature/authentication/domain/use_case/authenticate_firebase/authenticate_firebase.dart';
part 'feature/authentication/domain/use_case/authenticate_firebase/authenticate_firebase_impl.dart';
part 'feature/authentication/domain/use_case/delete/delete_account.dart';
part 'feature/authentication/domain/use_case/delete/delete_account_impl.dart';
part 'feature/authentication/domain/use_case/get_token/get_token.dart';
part 'feature/authentication/domain/use_case/get_token/get_token_impl.dart';
//TODO verificar como sera feita a implementacao do logout, por conta das diversas features atreladas
part 'feature/authentication/domain/use_case/logout/logout.dart';
part 'feature/authentication/domain/use_case/logout/logout_impl.dart';
part 'feature/authentication/domain/use_case/switch_roles/switch_roles.dart';
part 'feature/authentication/domain/use_case/switch_roles/switch_roles_impl.dart';
part 'feature/authentication/domain/use_case/refresh_token/refresh_token.dart';
part 'feature/authentication/domain/use_case/refresh_token/refresh_token_impl.dart';
//? Presentation

part 'feature/authentication/presentation/bloc/authentication_bloc.dart';
part 'feature/authentication/presentation/bloc/authentication_event.dart';
part 'feature/authentication/presentation/bloc/authentication_state.dart';
part 'feature/authentication/presentation/page/login_page.dart';
part 'feature/authentication/presentation/widget/login_form.dart';
//Aws
part 'feature/aws/domain/entity/url_upload_s3.dart';
part 'feature/aws/domain/use_case/aws_upload_file/aws_upload_file.dart';
part 'feature/aws/domain/use_case/aws_upload_file/aws_upload_file_impl.dart';
//presentation
part 'feature/billets/presentation/widgets/billet_founds_list_widget.dart';
//? Data sources
part 'feature/code_validation/data/data_source/code_validation_remote_data_source.dart';
part 'feature/code_validation/data/data_source/code_validation_remote_data_source_impl.dart';
//? repository - impl
part 'feature/code_validation/data/repository/code_validation_repository_impl.dart';
part 'feature/code_validation/domain/entity/code_data.dart';
part 'feature/code_validation/domain/entity/code_data_contact.dart';
//?entity
part 'feature/code_validation/domain/entity/code_request.dart';
part 'feature/code_validation/domain/entity/code_valid_token.dart';
part 'feature/code_validation/domain/entity/code_validation.dart';
//? repository - domain
part 'feature/code_validation/domain/repository/code_validation_repository.dart';
part 'feature/code_validation/domain/use_case/get_dados_2fa/get_dados_2fa.dart';
part 'feature/code_validation/domain/use_case/get_dados_2fa/get_dados_2fa_failures.dart';
part 'feature/code_validation/domain/use_case/get_dados_2fa/get_dados_2fa_impl.dart';
part 'feature/code_validation/domain/use_case/request_2fa/request_2fa.dart';
part 'feature/code_validation/domain/use_case/request_2fa/request_2fa_failures.dart';
part 'feature/code_validation/domain/use_case/request_2fa/request_2fa_impl.dart';
//? Use case

part 'feature/code_validation/domain/use_case/request_validation_code/request_validation_code.dart';
part 'feature/code_validation/domain/use_case/request_validation_code/request_validation_code_failures.dart';
part 'feature/code_validation/domain/use_case/request_validation_code/request_validation_code_impl.dart';
part 'feature/code_validation/domain/use_case/validate_2fa/validate_2fa.dart';
part 'feature/code_validation/domain/use_case/validate_2fa/validate_2fa_failures.dart';
part 'feature/code_validation/domain/use_case/validate_2fa/validate_2fa_impl.dart';
part 'feature/code_validation/domain/use_case/validate_code/validate_code.dart';
part 'feature/code_validation/domain/use_case/validate_code/validate_code_failures.dart';
part 'feature/code_validation/domain/use_case/validate_code/validate_code_impl.dart';
//? Presentation

part 'feature/code_validation/presentation/bloc/code_validation_bloc.dart';
part 'feature/code_validation/presentation/bloc/code_validation_event.dart';
part 'feature/code_validation/presentation/bloc/code_validation_state.dart';
//? pages
part 'feature/code_validation/presentation/page/code_validation_page.dart';
//? Widget
part 'feature/code_validation/presentation/widget/code_validation_input.dart';
part 'feature/code_validation/presentation/widget/request_validation_code_loading.dart';
part 'feature/connection/data/data_source/connection_remote_data_source.dart';
part 'feature/connection/data/data_source/connection_remote_data_source_impl.dart';
part 'feature/connection/data/repository/connection_repository_impl.dart';
part 'feature/connection/domain/repository/connection_repository.dart';
part 'feature/connection/domain/use_case/connection_use_case.dart';
part 'feature/connection/domain/use_case/connection_use_case_impl.dart';
part 'feature/connection/presentation/connection_controller.dart';
part 'feature/expired_session/data/data_source/local/expired_session_local_data_source.dart';
part 'feature/expired_session/data/data_source/local/expired_session_local_data_source_impl.dart';
part 'feature/expired_session/data/repository/expired_session_repository_impl.dart';
part 'feature/expired_session/domain/repository/expired_session_repository.dart';
part 'feature/expired_session/domain/use_case/clear_data/clear_data.dart';
part 'feature/expired_session/domain/use_case/clear_data/clear_data_impl.dart';
part 'feature/expired_session/presentation/bloc/expired_session_bloc.dart';
part 'feature/expired_session/presentation/bloc/expired_session_event.dart';
part 'feature/expired_session/presentation/bloc/expired_session_state.dart';
part 'feature/expired_session/presentation/page/expired_session_page.dart';
//Data source
part 'feature/ghost_notification/data/data_source/ghost_notification_data_source.dart';
part 'feature/ghost_notification/data/data_source/ghost_notification_data_source_impl.dart';
part 'feature/ghost_notification/data/repository/ghost_notification_repository_impl.dart';
part 'feature/ghost_notification/domain/entity/ghost_notification_entity.dart';
//Entity
part 'feature/ghost_notification/domain/entity/ghost_notification_type_enum.dart';
//repository
part 'feature/ghost_notification/domain/repository/ghost_notification_repository.dart';
part 'feature/notifications/data/data_source/notification_remote_data_source.dart';
part 'feature/notifications/data/data_source/notifications_remote_data_source_impl.dart';
part 'feature/notifications/data/repositories/notifications_repository.dart';
part 'feature/notifications/domain/entities/notification.dart';
part 'feature/notifications/domain/entities/notification_callback_type.dart';
part 'feature/notifications/domain/entities/notification_resume.dart';
part 'feature/notifications/domain/repositories/notifications_repository.dart';
part 'feature/notifications/domain/use_cases/delete_all_read_notification.dart';
part 'feature/notifications/domain/use_cases/delete_all_read_notification_impl.dart';
part 'feature/notifications/domain/use_cases/delete_notification.dart';
part 'feature/notifications/domain/use_cases/delete_notification_impl.dart';
part 'feature/notifications/domain/use_cases/get_notification_impl.dart';
part 'feature/notifications/domain/use_cases/get_notifications.dart';
part 'feature/notifications/domain/use_cases/mark_all_read_notification.dart';
part 'feature/notifications/domain/use_cases/mark_all_read_notification_impl.dart';
part 'feature/notifications/domain/use_cases/notification_resume.dart';
//use case
part 'feature/notifications/domain/use_cases/notification_resume_impl.dart';
part 'feature/notifications/domain/use_cases/read_notification.dart';
part 'feature/notifications/domain/use_cases/read_notification_impl.dart';
part 'feature/notifications/domain/use_cases/send_push_callback.dart';
part 'feature/notifications/domain/use_cases/send_push_callback_impl.dart';
part 'feature/notifications/presentation/bloc/notification_list_bloc.dart';
//presentation
part 'feature/notifications/presentation/bloc/notification_list_event.dart';
part 'feature/notifications/presentation/bloc/notification_list_state.dart';
part 'feature/notifications/presentation/pages/notifications_page.dart';
//? Data sources
part 'feature/registration/data/data_source/registration_remote_data_source.dart';
part 'feature/registration/data/data_source/registration_remote_data_source_impl.dart';
//? repository - impl
part 'feature/registration/data/repository/registration_repository_impl.dart';
//?entity
part 'feature/registration/domain/entity/register_fcm_token.dart';
part 'feature/registration/domain/entity/registration.dart';
part 'feature/registration/domain/entity/registration_lello_user.dart';
part 'feature/registration/domain/entity/registration_step.dart';
//? repository - domain

part 'feature/registration/domain/repository/registration_repository.dart';
part 'feature/registration/domain/use_case/disable_fcm_token/disable_fcm.dart';
part 'feature/registration/domain/use_case/disable_fcm_token/disable_fcm_impl.dart';
//? Use case

part 'feature/registration/domain/use_case/get_my_user/get_my_user.dart';
part 'feature/registration/domain/use_case/get_my_user/get_my_user_impl.dart';
part 'feature/registration/domain/use_case/register/register.dart';
part 'feature/registration/domain/use_case/register/register_failure.dart';
part 'feature/registration/domain/use_case/register/register_impl.dart';
part 'feature/registration/domain/use_case/register_fcm_token/register_fcm.dart';
part 'feature/registration/domain/use_case/register_fcm_token/register_fcm_impl.dart';
//? Presentation

part 'feature/registration/presentation/bloc/registration_bloc.dart';
part 'feature/registration/presentation/bloc/registration_event.dart';
part 'feature/registration/presentation/bloc/registration_state.dart';
//? pages
part 'feature/registration/presentation/page/registration_failure_page.dart';
part 'feature/registration/presentation/page/registration_lello_user_warning_page.dart';
part 'feature/registration/presentation/page/registration_no_data_page.dart';
part 'feature/registration/presentation/page/registration_page.dart';
part 'feature/registration/presentation/page/registration_succeeded_page.dart';
//? Widget

part 'feature/registration/presentation/widget/registration_cpf.dart';
part 'feature/registration/presentation/widget/registration_me.dart';
part 'feature/registration/presentation/widget/registration_password.dart';
part 'feature/registration/presentation/widget/registration_phone.dart';
part 'feature/registration/presentation/widget/registration_phone_email_empty_dialog.dart';
part 'feature/registration/presentation/widget/registration_picture.dart';
part 'feature/registration/presentation/widget/registration_use_terms.dart';
part 'feature/registration/presentation/widget/registration_use_terms_dialog.dart';
//? Data sources
part 'feature/reset_password/data/data_source/password_reset_remote_data_source.dart';
part 'feature/reset_password/data/data_source/password_reset_remote_data_source_impl.dart';
//? repository - impl
part 'feature/reset_password/data/repository/password_reset_repository_impl.dart';
//?entity
part 'feature/reset_password/domain/entity/password_reset.dart';
part 'feature/reset_password/domain/entity/password_reset_step.dart';
//? repository - domain
part 'feature/reset_password/domain/repository/password_reset_repository.dart';
//? Use case

part 'feature/reset_password/domain/use_case/reset_password/reset_password.dart';
part 'feature/reset_password/domain/use_case/reset_password/reset_password_failures.dart';
part 'feature/reset_password/domain/use_case/reset_password/reset_password_impl.dart';
part 'feature/reset_password/domain/use_case/reset_password_2fa/reset_password_2fa.dart';
part 'feature/reset_password/domain/use_case/reset_password_2fa/reset_password_2fa_failures.dart';
part 'feature/reset_password/domain/use_case/reset_password_2fa/reset_password_2fa_impl.dart';
//? Presentation

part 'feature/reset_password/presentation/bloc/reset_password_bloc.dart';
part 'feature/reset_password/presentation/bloc/reset_password_event.dart';
part 'feature/reset_password/presentation/bloc/reset_password_state.dart';
part 'feature/reset_password/presentation/controller/reset_password_controller.dart';
//? pages
part 'feature/reset_password/presentation/page/reset_password_page.dart';
part 'feature/reset_password/presentation/page/reset_password_success_page.dart';
//? Widget
part 'feature/reset_password/presentation/widget/reset_password_cpf.dart';
part 'feature/reset_password/presentation/widget/reset_password_me.dart';
part 'feature/reset_password/presentation/widget/reset_password_new_password.dart';
part 'feature/reset_password/presentation/widget/reset_password_phone_form.dart';
part 'feature/reset_password/presentation/widget/reset_password_warning_page.dart';
part 'feature/session/shared_session.dart';
//? Session
part 'feature/session/shared_session_state.dart';
part 'package:shared_features/feature/notifications/presentation/controller/notification_controller.dart';
