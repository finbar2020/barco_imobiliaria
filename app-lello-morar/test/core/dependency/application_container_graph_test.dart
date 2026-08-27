// Gerado a partir dos registros explícitos de `ApplicationContainer`:
// resolve cada tipo para garantir que o grafo de dependências está completo.
// O `CircuitBreakerController` fica de fora porque abre um stream real do
// Firestore ao ser construído.
import 'dart:async';
import 'package:chopper/chopper.dart' as chopper;
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:pretty_chopper_logger/pretty_chopper_logger.dart';
import 'package:get_it/get_it.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
import 'package:morar/core/database/block/block_dao.dart';
import 'package:morar/core/database/condominium/condominium_dao.dart';
import 'package:morar/core/database/layout/layout_dao.dart';
import 'package:morar/core/database/lello_database.dart';
import 'package:morar/core/database/me/me_dao.dart';
import 'package:morar/core/database/unit/unit_dao.dart';
import 'package:morar/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:morar/core/messaging/use_case/ghost_notification_usecase_impl.dart';
import 'package:morar/core/network/authorization_header_interceptor.dart';
import 'package:morar/core/stores/remote_config_store.dart';
import 'package:morar/core/uploader/uploader.dart';
import 'package:morar/core/uploader/uploader_impl.dart';
import 'package:morar/core/widgets/expire_cache.dart';
import 'package:morar/feature/access_control/data/data_source/access_control_api.dart';
import 'package:morar/feature/access_control/data/data_source/access_control_remote_data_source.dart';
import 'package:morar/feature/access_control/data/data_source/access_control_remote_data_source_impl.dart';
import 'package:morar/feature/access_control/data/repository/access_control_repository_impl.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:morar/feature/access_control/domain/use_case/facial_biometric/facial_biometric_usecase.dart';
import 'package:morar/feature/access_control/domain/use_case/facial_biometric/facial_biometric_usecase_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/add_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/add_visit_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/delete_visit._impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/delete_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/edit_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/edit_visit_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/delete_visitant.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/delete_visitant_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/edit_visitant.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/edit_visitant_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/get_visitants.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/get_visitants_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/save_visitant.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/save_visitant_impl.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_bloc.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_provider_controller.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_visitant_controller.dart';
import 'package:morar/feature/accountability/data/data_source/accountability_api.dart';
import 'package:morar/feature/accountability/data/data_source/accountability_remote_data_source.dart';
import 'package:morar/feature/accountability/data/data_source/accountability_remote_data_source_impl.dart';
import 'package:morar/feature/accountability/data/repository/accountability_repository_impl.dart';
import 'package:morar/feature/accountability/domain/repository/accountability_repository.dart';
import 'package:morar/feature/accountability/domain/use_case/get_accountability/get_accountability.dart';
import 'package:morar/feature/accountability/domain/use_case/get_accountability/get_accountability_impl.dart';
import 'package:morar/feature/accountability/domain/use_case/get_periods/get_accountability_period.dart';
import 'package:morar/feature/accountability/domain/use_case/get_periods/get_accountability_periods_impl.dart';
import 'package:morar/feature/accountability/presentation/bloc/accountabiity_bloc.dart';
import 'package:morar/feature/accountability/presentation/controllers/accountability_controller.dart';
import 'package:morar/feature/agreements/data/data_source/agreements_api.dart';
import 'package:morar/feature/agreements/data/data_source/agreements_remote_data_source.dart';
import 'package:morar/feature/agreements/data/data_source/agreements_remote_data_sourece_impl.dart';
import 'package:morar/feature/agreements/data/repository/agreements_repository_impl.dart';
import 'package:morar/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:morar/feature/agreements/domain/use_case/get_all_info/get_all_info.dart';
import 'package:morar/feature/agreements/domain/use_case/get_all_info/get_all_info_impl.dart';
import 'package:morar/feature/agreements/domain/use_case/get_detail/get_detail.dart';
import 'package:morar/feature/agreements/domain/use_case/get_detail/get_detail_impl.dart';
import 'package:morar/feature/agreements/domain/use_case/get_installment_credit/get_installment_credit.dart';
import 'package:morar/feature/agreements/domain/use_case/get_installment_credit/get_installment_credit_impl.dart';
import 'package:morar/feature/agreements/domain/use_case/get_payday/get_payday.dart';
import 'package:morar/feature/agreements/domain/use_case/get_payday/get_payday_impl.dart';
import 'package:morar/feature/agreements/domain/use_case/get_recommendation/get_recommendation.dart';
import 'package:morar/feature/agreements/domain/use_case/get_recommendation/get_recommendation_impl.dart';
import 'package:morar/feature/agreements/domain/use_case/post_agreement/post_agreement.dart';
import 'package:morar/feature/agreements/domain/use_case/post_agreement/post_agreement_impl.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/billets/data/data_source/billets_api.dart';
import 'package:morar/feature/billets/data/data_source/billets_remote_data_source.dart';
import 'package:morar/feature/billets/data/data_source/billets_remote_data_source_impl.dart';
import 'package:morar/feature/billets/data/repository/billets_repository_impl.dart';
import 'package:morar/feature/billets/domain/repository/billets_repository.dart';
import 'package:morar/feature/billets/domain/use_case/billets_pdf_use_case.dart';
import 'package:morar/feature/billets/domain/use_case/billets_pdf_use_case_impl.dart';
import 'package:morar/feature/billets/domain/use_case/billets_use_case.dart';
import 'package:morar/feature/billets/domain/use_case/billets_use_case_impl.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_bloc.dart';
import 'package:morar/feature/billets/presentation/controllers/billets_controller.dart';
import 'package:morar/feature/change_ownership/data/data_source/change_ownership_api.dart';
import 'package:morar/feature/change_ownership/data/data_source/change_ownership_data_source.dart';
import 'package:morar/feature/change_ownership/data/data_source/change_ownership_data_source_impl.dart';
import 'package:morar/feature/change_ownership/data/repository/change_ownership_repository_impl.dart';
import 'package:morar/feature/change_ownership/domain/repository/change_ownership_repository.dart';
import 'package:morar/feature/change_ownership/domain/use_case/can_change/can_change.dart';
import 'package:morar/feature/change_ownership/domain/use_case/can_change/can_change_impl.dart';
import 'package:morar/feature/change_ownership/domain/use_case/post_change/post_change.dart';
import 'package:morar/feature/change_ownership/domain/use_case/post_change/post_change_impl.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_bloc.dart';
import 'package:morar/feature/change_ownership/presentation/controller/ownership_controller.dart';
import 'package:morar/feature/digital_meeting/data/data_source/digital_meeting_api.dart';
import 'package:morar/feature/digital_meeting/data/data_source/digital_meeting_remote_data_source.dart';
import 'package:morar/feature/digital_meeting/data/data_source/digital_meeting_remote_data_source_impl.dart';
import 'package:morar/feature/digital_meeting/data/repository/digital_meeting_repository_impl.dart';
import 'package:morar/feature/digital_meeting/domain/repository/digital_meeting_repository.dart';
import 'package:morar/feature/digital_meeting/domain/use_case/get_assemblies/get_assemblies.dart';
import 'package:morar/feature/digital_meeting/domain/use_case/get_assemblies/get_assemblies_impl.dart';
import 'package:morar/feature/digital_meeting/domain/use_case/get_assembly/get_assembly.dart';
import 'package:morar/feature/digital_meeting/domain/use_case/get_assembly/get_assembly_impl.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_bloc.dart';
import 'package:morar/feature/digital_meeting/presentation/controller/digital_meeting_controller.dart';
import 'package:shared_features/core/database/documents/cached_documents_store.dart';
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
import 'package:morar/feature/documents/integration/morar_documents_analytics.dart';
import 'package:morar/feature/documents/integration/morar_shared_session.dart';
import 'package:morar/feature/easy_fix/cnd/data/data_source/cnd_api.dart';
import 'package:morar/feature/easy_fix/cnd/data/data_source/cnd_remote_data_source.dart';
import 'package:morar/feature/easy_fix/cnd/data/data_source/cnd_remote_data_source_impl.dart';
import 'package:morar/feature/easy_fix/cnd/data/repository/cdn_repository_impl.dart';
import 'package:morar/feature/easy_fix/cnd/domain/repository/cnd_repository.dart';
import 'package:morar/feature/easy_fix/cnd/domain/use_case/cnd_pdf_use_case.dart';
import 'package:morar/feature/easy_fix/cnd/domain/use_case/cnd_pdf_use_case_impl.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/bloc/cnd_bloc.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/controller/cnd_controller.dart';
import 'package:morar/feature/easy_fix/data/data_source/easy_fix_api.dart';
import 'package:morar/feature/easy_fix/data/data_source/easy_fix_remote_data_source.dart';
import 'package:morar/feature/easy_fix/data/data_source/easy_fix_remote_data_source_impl.dart';
import 'package:morar/feature/easy_fix/data/repository/easy_fix_repository_impl.dart';
import 'package:morar/feature/easy_fix/domain/repository/easy_fix_repository.dart';
import 'package:morar/feature/easy_fix/domain/use_case/get_cities_usecase.dart';
import 'package:morar/feature/easy_fix/domain/use_case/get_easy_fix_unit_usecase.dart';
import 'package:morar/feature/easy_fix/domain/use_case/update_address_usecase.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_bloc.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/controllers/change_address_controller.dart';
import 'package:morar/feature/home/data/data_source/home_api.dart';
import 'package:morar/feature/home/data/data_source/home_remote_data_source.dart';
import 'package:morar/feature/home/data/data_source/home_remote_data_source_impl.dart';
import 'package:morar/feature/home/data/repository/home_repository_impl.dart';
import 'package:morar/feature/home/domain/repository/home_repository.dart';
import 'package:morar/feature/home/domain/use_cases/get_banner/get_banner.dart';
import 'package:morar/feature/home/domain/use_cases/get_banner/get_banner_impl.dart';
import 'package:morar/feature/home/domain/use_cases/home_to_go/home_to_go.dart';
import 'package:morar/feature/home/domain/use_cases/home_to_go/home_to_go_impl.dart';
import 'package:morar/feature/home/domain/use_cases/post_terms/post_terms.dart';
import 'package:morar/feature/home/domain/use_cases/post_terms/post_terms_impl.dart';
import 'package:morar/feature/home/presentation/bloc/home_bloc.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc.dart';
import 'package:morar/feature/ia_bella/data/data_source/ia_bella_api.dart';
import 'package:morar/feature/ia_bella/data/data_source/ia_bella_remote_data_source.dart';
import 'package:morar/feature/ia_bella/data/data_source/ia_bella_remote_data_source_impl.dart';
import 'package:morar/feature/ia_bella/data/repository/ia_bella_repository_impl.dart';
import 'package:morar/feature/ia_bella/domain/repository/ia_bella_repository.dart';
import 'package:morar/feature/ia_bella/domain/use_case/download_pdf/ia_bella_pdf_use_case_impl.dart';
import 'package:morar/feature/ia_bella/domain/use_case/download_pdf/ia_bella_pdf_user_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/final_evaluation/ia_bella_final_evaluation_use_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/final_evaluation/ia_bella_final_evaluation_use_case_impl.dart';
import 'package:morar/feature/ia_bella/domain/use_case/rate_response/ia_bella_rate_response_use_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/rate_response/ia_bella_rate_response_use_case_impl.dart';
import 'package:morar/feature/ia_bella/domain/use_case/send_message/ia_bella_send_message_use_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/send_message/ia_bella_send_message_use_case_impl.dart';
import 'package:morar/feature/ia_bella/domain/use_case/start_session/ia_bella_start_session_use_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/start_session/ia_bella_start_session_use_case_impl.dart';
import 'package:morar/feature/ia_bella/presentation/bloc/ia_bella_bloc.dart';
import 'package:morar/feature/ia_bella/presentation/controllers/ia_bella_controller.dart';
import 'package:morar/feature/insurance/data/data_source/insurance_api.dart';
import 'package:morar/feature/insurance/data/data_source/insurance_remote_data_source.dart';
import 'package:morar/feature/insurance/data/data_source/insurance_remote_data_source_impl.dart';
import 'package:morar/feature/insurance/data/repository/insurance_repository_impl.dart';
import 'package:morar/feature/insurance/domain/repository/insurance_repository.dart';
import 'package:morar/feature/insurance/domain/use_case/get_insurance/get_insurance.dart';
import 'package:morar/feature/insurance/domain/use_case/get_insurance/get_insurance_impl.dart';
import 'package:morar/feature/insurance/domain/use_case/post_insurance/post_insurance.dart';
import 'package:morar/feature/insurance/domain/use_case/post_insurance/post_insurance_impl.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_bloc.dart';
import 'package:morar/feature/insurance/presentation/controller/insurance_controller.dart';
import 'package:morar/feature/mailing/data/data_source/mailing_api.dart';
import 'package:morar/feature/mailing/data/data_source/mailing_remote_data_source.dart';
import 'package:morar/feature/mailing/data/data_source/mailing_remote_data_source_impl.dart';
import 'package:morar/feature/mailing/data/repository/mailing_repository_impl.dart';
import 'package:morar/feature/mailing/domain/repository/mailing_repository.dart';
import 'package:morar/feature/mailing/domain/use_case/get_mailing_picture_impl.dart';
import 'package:morar/feature/mailing/domain/use_case/mailings.dart';
import 'package:morar/feature/mailing/domain/use_case/mailings_impl.dart';
import 'package:morar/feature/mailing/presentation/bloc/mailing_bloc.dart';
import 'package:morar/feature/mailing/presentation/controllers/mailing_controller.dart';
import 'package:morar/feature/me/data/data_source/local/me_local_data_source.dart';
import 'package:morar/feature/me/data/data_source/local/me_local_data_source_impl.dart';
import 'package:morar/feature/me/data/data_source/remote/me_api.dart';
import 'package:morar/feature/me/data/data_source/remote/me_remote_data_source.dart';
import 'package:morar/feature/me/data/data_source/remote/me_remote_data_source_impl.dart';
import 'package:morar/feature/me/data/repository/me_repository_impl.dart';
import 'package:morar/feature/me/data/repository/profile_picture_repository_impl.dart';
import 'package:morar/feature/me/domain/repository/me_repository.dart';
import 'package:morar/feature/me/domain/repository/profile_picture_repository.dart';
import 'package:morar/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:morar/feature/me/domain/use_case/get_me/get_me_impl.dart';
import 'package:morar/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:morar/feature/me/domain/use_case/log_me_out/log_me_out_impl.dart';
import 'package:morar/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:morar/feature/me/domain/use_case/save_me/save_me_impl.dart';
import 'package:morar/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:morar/feature/me/domain/use_case/update_password_me/update_password_me_impl.dart';
import 'package:morar/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture.dart';
import 'package:morar/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture_impl.dart';
import 'package:morar/feature/me/presentation/bloc/me_bloc.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:morar/feature/my_preferences/data/data_source/my_preferences_api.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/get_street_types/get_street_types_use_case.dart';
import 'package:morar/feature/my_preferences/presentation/pages/in_care/bloc/in_care_bloc.dart';
import 'package:morar/feature/preferences/data/data_source/preferences_api.dart';
import 'package:morar/feature/preferences/data/data_source/preferences_data_source.dart';
import 'package:morar/feature/preferences/data/data_source/preferences_data_source_impl.dart';
import 'package:morar/feature/preferences/data/repository/preferences_repository_impl.dart';
import 'package:morar/feature/preferences/domain/repository/preferences_repository.dart';
import 'package:morar/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification.dart';
import 'package:morar/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification_impl.dart';
import 'package:morar/feature/preferences/domain/use_case/get_preferences_zero_paper/get_preferences_zero_paper.dart';
import 'package:morar/feature/preferences/domain/use_case/get_preferences_zero_paper/get_preferences_zero_paper_impl.dart';
import 'package:morar/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification.dart';
import 'package:morar/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification_impl.dart';
import 'package:morar/feature/preferences/domain/use_case/put_preferences_zero_paper/put_preferences_zero_paper.dart';
import 'package:morar/feature/preferences/domain/use_case/put_preferences_zero_paper/put_preferences_zero_paper_impl.dart';
import 'package:morar/feature/preferences/presentation/pages/home_cards/bloc/preferences_home_cards_bloc.dart';
import 'package:morar/feature/preferences/presentation/pages/home_cards/controller/preferences_home_cards_controller.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/bloc/preferences_notification_bloc.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/controller/preferences_notification_controller.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/bloc/preferences_zero_paper_bloc.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/controllers/preferences_zero_paper_controller.dart';
import 'package:morar/feature/reports_book/data/data_source/reports_book_api.dart';
import 'package:morar/feature/reports_book/data/data_source/reports_book_remote_data_source.dart';
import 'package:morar/feature/reports_book/data/data_source/reports_book_remote_data_source_impl.dart';
import 'package:morar/feature/reports_book/data/repository/reports_book_repository_impl.dart';
import 'package:morar/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_all_reports.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_all_reports_impl.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_report.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_report_impl.dart';
import 'package:morar/feature/reports_book/domain/use_case/post_new_report.dart';
import 'package:morar/feature/reports_book/domain/use_case/post_new_report_impl.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_attachment.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_attachment_impl.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_content.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_content_impl.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_bloc.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reservation/data/data_source/reservation_api.dart';
import 'package:morar/feature/reservation/data/data_source/reservation_data_source.dart';
import 'package:morar/feature/reservation/data/data_source/reservation_data_source_impl.dart';
import 'package:morar/feature/reservation/data/repository/reserve_repository_impl.dart';
import 'package:morar/feature/reservation/domain/repository/reserve_repository.dart';
import 'package:morar/feature/reservation/domain/use_case/delete_reservation/delete_reservation.dart';
import 'package:morar/feature/reservation/domain/use_case/delete_reservation/delete_reservation_impl.dart';
import 'package:morar/feature/reservation/domain/use_case/get_all_reservation/get_all_reservation.dart';
import 'package:morar/feature/reservation/domain/use_case/get_all_reservation/get_all_reservation_impl.dart';
import 'package:morar/feature/reservation/domain/use_case/get_calendar/get_calendar.dart';
import 'package:morar/feature/reservation/domain/use_case/get_calendar/get_calendar_impl.dart';
import 'package:morar/feature/reservation/domain/use_case/get_hours/get_hours.dart';
import 'package:morar/feature/reservation/domain/use_case/get_hours/get_hours_impl.dart';
import 'package:morar/feature/reservation/domain/use_case/get_spaces/get_spaces.dart';
import 'package:morar/feature/reservation/domain/use_case/get_spaces/get_spaces_impl.dart';
import 'package:morar/feature/reservation/domain/use_case/post_reservations/post_reservation.dart';
import 'package:morar/feature/reservation/domain/use_case/post_reservations/post_reservation_impl.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';
import 'package:morar/feature/reservation/presentation/controller/reservation_controller.dart';
import 'package:morar/feature/session/data/data_source/session_local_data_source.dart';
import 'package:morar/feature/session/data/data_source/session_local_data_source_impl.dart';
import 'package:morar/feature/session/data/repository/session_repository_impl.dart';
import 'package:morar/feature/session/domain/repository/session_repository.dart';
import 'package:morar/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:morar/feature/session/domain/use_case/load_session/load_session_impl.dart';
import 'package:morar/feature/session/domain/use_case/save_session/save_session.dart';
import 'package:morar/feature/session/domain/use_case/save_session/save_session_impl.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/splash/data/data_source/boot_data_source.dart';
import 'package:morar/feature/splash/data/data_source/boot_data_source_impl.dart';
import 'package:morar/feature/splash/data/repository/boot_data_repository_impl.dart';
import 'package:morar/feature/splash/domain/repository/boot_data_repository.dart';
import 'package:morar/feature/splash/domain/use_case/get_boot_data/get_boot_data.dart';
import 'package:morar/feature/splash/domain/use_case/get_boot_data/get_boot_data_impl.dart';
import 'package:morar/feature/splash/domain/use_case/set_boot_data/set_boot_data.dart';
import 'package:morar/feature/splash/domain/use_case/set_boot_data/set_boot_data_impl.dart';
import 'package:morar/feature/sub_user/data/data_source/sub_user_remote_data_source.dart';
import 'package:morar/feature/sub_user/data/data_source/sub_user_remote_data_source_impl.dart';
import 'package:morar/feature/sub_user/data/data_source/subuser_api.dart';
import 'package:morar/feature/sub_user/data/repository/sub_user_repository_impl.dart';
import 'package:morar/feature/sub_user/domain/repository/sub_user_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/check_seventh_service/sub_user_check_service.dart';
import 'package:morar/feature/sub_user/domain/use_cases/check_seventh_service/sub_user_check_service_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/delete_sub_user/delete_sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_roles/sub_user_roles.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_roles/sub_user_roles_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_sub_user/sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_sub_user/sub_user_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/insert_sub_user/insert_sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/insert_sub_user/insert_sub_user_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/pending_requests/get_pending_requests_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_access_renew_reques_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_invite/send_invite_usecase.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_invite/send_invite_usecase_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_access_request_status/update_access_request_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_sub_user/update_sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_sub_user/update_sub_user_impl.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_user_edit_bloc.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_edit_controller.dart';
import 'package:morar/feature/tdb/data/data_source/tdb_api.dart';
import 'package:morar/feature/tdb/data/data_source/tdb_remote_data_source.dart';
import 'package:morar/feature/tdb/data/data_source/tdb_remote_data_source_impl.dart';
import 'package:morar/feature/tdb/data/repository/tdb_repository_impl.dart';
import 'package:morar/feature/tdb/domain/repository/tdb_repository.dart';
import 'package:morar/feature/tdb/domain/use_case/get_tdb_info/get_tdb_info.dart';
import 'package:morar/feature/tdb/domain/use_case/get_tdb_info/get_tdb_info_impl.dart';
import 'package:morar/feature/tdb/presentation/bloc/tdb_bloc.dart';
import 'package:morar/feature/tdb/presentation/controllers/tdb_controller.dart';
import 'package:morar/feature/vehicles/data/data_source/vehicles_api.dart';
import 'package:morar/feature/vehicles/data/data_source/vehicles_remote_data_source.dart';
import 'package:morar/feature/vehicles/data/data_source/vehicles_remote_data_sourece_impl.dart';
import 'package:morar/feature/vehicles/data/repository/vehicles_repository_impl.dart';
import 'package:morar/feature/vehicles/domain/repository/vehicles_repository.dart';
import 'package:morar/feature/vehicles/domain/use_cases/delete_vehicles/delete_vehicle.dart';
import 'package:morar/feature/vehicles/domain/use_cases/delete_vehicles/delete_vehicle_impl.dart';
import 'package:morar/feature/vehicles/domain/use_cases/get_vehicles/get_vehicles.dart';
import 'package:morar/feature/vehicles/domain/use_cases/get_vehicles/get_vehicles_impl.dart';
import 'package:morar/feature/vehicles/domain/use_cases/save_vehicles/save_vehicles.dart';
import 'package:morar/feature/vehicles/domain/use_cases/save_vehicles/save_vehicles_impl.dart';
import 'package:morar/feature/vehicles/domain/use_cases/update_vehicles/update_vehicles.dart';
import 'package:morar/feature/vehicles/domain/use_cases/update_vehicles/update_vehicles_impl.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_bloc.dart';
import 'package:morar/feature/vehicles/presentation/controllers/vehicle_controller.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/database/banners/banners_args_dao.dart';
import 'package:shared_features/core/database/banners/banners_dao.dart';
import 'package:shared_features/core/network/refresh_authenticator_interceptor.dart';
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
import 'package:morar/feature/my_preferences/data/data_source/my_preferences_data_source.dart';
import 'package:morar/feature/my_preferences/data/data_source/my_preferences_data_source_impl.dart';
import 'package:morar/feature/my_preferences/data/repository/my_preferences_repository_impl.dart';
import 'package:morar/feature/my_preferences/domain/repositories/my_preferences_repository.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/get_street_types/get_street_types_use_case_impl.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/get_unit_personal_data/get_unit_personal_data_use_case.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/get_unit_personal_data/get_unit_personal_data_use_case_impl.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/update_unit_personal_data/update_unit_personal_data_use_case.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/update_unit_personal_data/update_unit_personal_data_use_case_impl.dart';
import 'package:morar/feature/my_preferences/presentation/pages/receiving_documents/presentation/bloc/receiving_documents_bloc.dart';
import 'package:morar/feature/sub_user/domain/use_cases/delete_sub_user/delete_sub_user_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/pending_requests/get_pending_requests_impl_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_access_request_status/update_access_request_status_use_case_impl.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_user_add_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_add_controller.dart';
import 'package:morar/feature/sub_user/presentation/stores/sub_user_store.dart';
import 'dart:io';

import 'package:flutter/services.dart' show MethodChannel;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_subcategories/get_subcategories.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/firebase_mocks.dart';
import '../../helpers/init_sqflite_ffi.dart';
import '../../helpers/test_application_container.dart' show TestEnvironment;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  initSqfliteForTests();

  setUp(() async {
    FlavorConfig.init();
    // O HomeDialogBloc consulta o permission_handler ao ser construído.
    setFakePermissionHandler(FakePermissionHandler());
    await setUpFakeFirebase();
    // O RegistrationStore consulta a assinatura do app via sms_autofill.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('sms_autofill'),
            (call) async => call.method == 'getAppSignature' ? 'sig' : null);
    SharedPreferences.setMockInitialValues({});
    Hive.init(Directory.systemTemp.createTempSync('morar_di').path);
    await ApplicationContainer.instance().locator.reset(dispose: true);
    await ApplicationContainer.instance().setUp(TestEnvironment());
  });

  tearDown(() => ApplicationContainer.instance().locator.reset(dispose: true));

  test('todos os tipos registrados podem ser resolvidos', () async {
    final c = ApplicationContainer.instance();
    final resolvers = <Object Function()>[
      () => c.resolve<ApiPerformaceMonitor>(),
      () => c.resolve<Validator>(),
      () => c.resolve<MeApi>(),
      () => c.resolve<MeDao>(),
      () => c.resolve<CondominiumDao>(),
      () => c.resolve<BlockDao>(),
      () => c.resolve<UnitDao>(),
      () => c.resolve<LayoutDao>(),
      () => c.resolve<MeRepository>(),
      () => c.resolve<GetMe>(),
      () => c.resolve<SaveMe>(),
      () => c.resolve<UpdatePasswordMe>(),
      () => c.resolve<MeLocalDataSource>(),
      () => c.resolve<MeRemoteDataSource>(),
      () => c.resolve<LogMeOut>(),
      () => c.resolve<MeBloc>(),
      () => c.resolve<HomeApi>(),
      () => c.resolve<HomeRemoteDataSource>(),
      () => c.resolve<HomeRepository>(),
      () => c.resolve<GetBanner>(),
      () => c.resolve<HomeToGo>(),
      () => c.resolve<PostTerms>(),
      () => c.resolve<RegisterFcm>(),
      () => c.resolve<DisableFcm>(),
      () => c.resolve<HomeBloc>(),
      () => c.resolve<HomeDialogBloc>(),
      () => c.resolve<NotificationsApi>(),
      () => c.resolve<NotificationsRemoteDataSource>(),
      () => c.resolve<NotificationsRepository>(),
      () => c.resolve<GetNotifications>(),
      () => c.resolve<ReadNotification>(),
      () => c.resolve<MarkAllReadNotification>(),
      () => c.resolve<DeleteAllReadNotification>(),
      () => c.resolve<DeleteNotification>(),
      () => c.resolve<NotificationResume>(),
      () => c.resolve<SendPushCallback>(),
      () => c.resolve<BootDataSource>(),
      () => c.resolve<BootDataRepository>(),
      () => c.resolve<GetBootData>(),
      () => c.resolve<SetBootData>(),
      () => c.resolve<AuthenticationApi>(),
      () => c.resolve<GetToken>(),
      () => c.resolve<AuthenticateFirebase>(),
      () => c.resolve<AccessTokenLocalDataSource>(),
      () => c.resolve<AccessTokenRemoteDataSource>(),
      () => c.resolve<RefreshTokenRemoteDataSource>(),
      () => c.resolve<AccessTokenRepository>(),
      () => c.resolve<RefreshTokenRepository>(),
      () => c.resolve<Logout>(),
      () => c.resolve<Authenticate>(),
      () => c.resolve<SwitchRoles>(),
      () => c.resolve<RefreshToken>(),
      () => c.resolve<DeleteAccount>(),
      () => c.resolve<IaBellaRemoteDataSource>(),
      () => c.resolve<IaBellaRepository>(),
      () => c.resolve<IaBellaBloc>(),
      () => c.resolve<IaBellaStartSessionUseCase>(),
      () => c.resolve<IaBellaSendMessageUseCase>(),
      () => c.resolve<IaBellaPdfUseCase>(),
      () => c.resolve<IaBellaRateResponseUseCase>(),
      () => c.resolve<IaBellaFinalEvaluationUseCase>(),
      () => c.resolve<ConnectionRemoteDataSource>(),
      () => c.resolve<ConnectionRepository>(),
      () => c.resolve<ConnectionUseCase>(),
      () => c.resolve<SessionLocalDataSource>(),
      () => c.resolve<SessionRepository>(),
      () => c.resolve<LoadSession>(),
      () => c.resolve<SaveSession>(),
      () => c.resolve<SessionBloc>(),
      () => c.resolve<RegistrationApi>(),
      () => c.resolve<ProfilePictureRepository>(),
      () => c.resolve<RegistrationRemoteDataSource>(),
      () => c.resolve<RegistrationRepository>(),
      () => c.resolve<Register>(),
      () => c.resolve<GetMyUser>(),
      () => c.resolve<UploadProfilePicture>(),
      () => c.resolve<Uploader>(),
      () => c.resolve<PasswordResetApi>(),
      () => c.resolve<PasswordResetRemoteDataSource>(),
      () => c.resolve<PasswordResetRepository>(),
      () => c.resolve<ResetPassword>(),
      () => c.resolve<ResetPassword2fa>(),
      () => c.resolve<ResetPasswordBloc>(),
      () => c.resolve<CodeValidationApi>(),
      () => c.resolve<CodeValidationRemoteDataSource>(),
      () => c.resolve<CodeValidationRepository>(),
      () => c.resolve<RequestValidationCode>(),
      () => c.resolve<ValidateCode>(),
      () => c.resolve<GetDados2fa>(),
      () => c.resolve<Request2fa>(),
      () => c.resolve<Validate2fa>(),
      () => c.resolve<ExpiredSessionLocalDataSource>(),
      () => c.resolve<ExpiredSessionRepository>(),
      () => c.resolve<ClearData>(),
      () => c.resolve<ExpiredSessionBloc>(),
      () => c.resolve<GetImageFromCameraViewPickerUsecase>(),
      () => c.resolve<SubUserApi>(),
      () => c.resolve<SubUsersBloc>(),
      () => c.resolve<SubUserRemoteDataSource>(),
      () => c.resolve<SubUserRepository>(),
      () => c.resolve<SubUserUseCase>(),
      () => c.resolve<GetPendingRequestsUseCase>(),
      () => c.resolve<UpdateSubUser>(),
      () => c.resolve<DeleteSubUser>(),
      () => c.resolve<InsertSubUser>(),
      () => c.resolve<SubUserRoleCase>(),
      () => c.resolve<SubUserCheckServiceCase>(),
      () => c.resolve<SendInviteUsecase>(),
      () => c.resolve<UpdateAccessRequestUseCase>(),
      () => c.resolve<SendAccessRenewRequestUseCase>(),
      () => c.resolve<VehicleApi>(),
      () => c.resolve<VehiclesBloc>(),
      () => c.resolve<VehicleRemoteDataSource>(),
      () => c.resolve<VehicleRepository>(),
      () => c.resolve<SaveVehicle>(),
      () => c.resolve<GetVehicle>(),
      () => c.resolve<UpDateVehicle>(),
      () => c.resolve<DeleteVehicle>(),
      () => c.resolve<MailingApi>(),
      () => c.resolve<MailingBloc>(),
      () => c.resolve<MailingRemoteDataSource>(),
      () => c.resolve<MailingRepository>(),
      () => c.resolve<MailingUseCase>(),
      () => c.resolve<BilletsApi>(),
      () => c.resolve<BilletsBloc>(),
      () => c.resolve<BilletsRemoteDataSource>(),
      () => c.resolve<BilletsRepository>(),
      () => c.resolve<BilletsUseCase>(),
      () => c.resolve<BilletsPdfUseCase>(),
      () => c.resolve<AccountabilityApi>(),
      () => c.resolve<AccountabilityBloc>(),
      () => c.resolve<AccountabilityRemoteDataSource>(),
      () => c.resolve<AccountabilityRepository>(),
      () => c.resolve<GetAccountability>(),
      () => c.resolve<GetAccountabilityPeriod>(),
      () => c.resolve<CachedDocumentsStore>(),
      () => c.resolve<DocumentsApi>(),
      () => c.resolve<DocumentsBloc>(),
      () => c.resolve<DocumentsRemoteDataSource>(),
      () => c.resolve<DocumentsRepository>(),
      () => c.resolve<DownloadDocument>(),
      () => c.resolve<GetExtractedText>(),
      () => c.resolve<DigitalMeetingApi>(),
      () => c.resolve<DigitalMeetingRemoteDataSource>(),
      () => c.resolve<DigitalMeetingRepository>(),
      () => c.resolve<GetMeetings>(),
      () => c.resolve<GetMeetingDataUseCase>(),
      () => c.resolve<ReservationApi>(),
      () => c.resolve<ReservationBloc>(),
      () => c.resolve<ReservationRemoteDataSource>(),
      () => c.resolve<ReservationRepository>(),
      () => c.resolve<GetSpace>(),
      () => c.resolve<GetAllReservation>(),
      () => c.resolve<GetCalendar>(),
      () => c.resolve<GetHours>(),
      () => c.resolve<PostReservation>(),
      () => c.resolve<DeleteReservation>(),
      () => c.resolve<AwsUploadFileUsecase>(),
      () => c.resolve<AccessControlApi>(),
      () => c.resolve<AccessControlBloc>(),
      () => c.resolve<AccessControlRemoteDataSource>(),
      () => c.resolve<AccessControlRepository>(),
      () => c.resolve<GetVisitants>(),
      () => c.resolve<SaveVisitant>(),
      () => c.resolve<EditVisitant>(),
      () => c.resolve<DeleteVisitant>(),
      () => c.resolve<AddVisit>(),
      () => c.resolve<DeleteVisit>(),
      () => c.resolve<EditVisit>(),
      () => c.resolve<FacialBiometricUsecase>(),
      () => c.resolve<ReportsBookApi>(),
      () => c.resolve<ReportsBookRemoteDataSource>(),
      () => c.resolve<ReportsBookRepository>(),
      () => c.resolve<GetAllReportsUseCase>(),
      () => c.resolve<PostNewReportUseCase>(),
      () => c.resolve<GetReportUseCase>(),
      () => c.resolve<PutReportContentUseCase>(),
      () => c.resolve<PutReportAttachmentUseCase>(),
      () => c.resolve<ReportsBloc>(),
      () => c.resolve<ComfortApi>(),
      () => c.resolve<ComfortMyRequestsBloc>(),
      () => c.resolve<ComfortPartnersBloc>(),
      () => c.resolve<ComfortPartnerCouponsBloc>(),
      () => c.resolve<ComfortPartnerReviewsBloc>(),
      () => c.resolve<ComfortRemoteDataSource>(),
      () => c.resolve<ComfortRepository>(),
      () => c.resolve<GetPartnerCouponsUseCase>(),
      () => c.resolve<GetAllPartnersUseCase>(),
      () => c.resolve<GetPartnerIsFavoriteUseCase>(),
      () => c.resolve<GetMyRequestsUseCase>(),
      () => c.resolve<ChangePartnerFavoriteStatusUseCase>(),
      () => c.resolve<CreateCouponRequestUseCase>(),
      () => c.resolve<SendReviewRequestUseCase>(),
      () => c.resolve<FindRequestPurchaseUseCase>(),
      () => c.resolve<GetAllPartnerReviewsUseCase>(),
      () => c.resolve<ResendRequestUseCase>(),
      () => c.resolve<CancelRequestUseCase>(),
      () => c.resolve<UpdateRequestUseCase>(),
      () => c.resolve<ComfortMyRequestItemActionsBloc>(),
      () => c.resolve<ComfortMyRequestItemActionsController>(),
      () => c.resolve<InsuranceApi>(),
      () => c.resolve<InsuranceBloc>(),
      () => c.resolve<InsuranceRemoteDataSource>(),
      () => c.resolve<InsuranceRepository>(),
      () => c.resolve<GetInsurance>(),
      () => c.resolve<PostInsurance>(),
      () => c.resolve<AgreementsApi>(),
      () => c.resolve<AgreementsBloc>(),
      () => c.resolve<AgreementsRemoteDataSource>(),
      () => c.resolve<AgreementsRepository>(),
      () => c.resolve<GetAvailableUseCase>(),
      () => c.resolve<GetRecommendationUseCase>(),
      () => c.resolve<GetPaydayUseCase>(),
      () => c.resolve<GetInstallmentCreditUseCase>(),
      () => c.resolve<PostAgreementUseCase>(),
      () => c.resolve<GetAgreementDetailUseCase>(),
      () => c.resolve<BannersApi>(),
      () => c.resolve<BannersBloc>(),
      () => c.resolve<BannersLocalDataSource>(),
      () => c.resolve<BannersRemoteDataSource>(),
      () => c.resolve<BannersDao>(),
      () => c.resolve<BannersArgsDao>(),
      () => c.resolve<BannersRepository>(),
      () => c.resolve<GetBannersUseCase>(),
      () => c.resolve<TDBApi>(),
      () => c.resolve<TDBBloc>(),
      () => c.resolve<TDBRemoteDataSource>(),
      () => c.resolve<TDBRepository>(),
      () => c.resolve<GetTDBInfoUseCase>(),
      () => c.resolve<GhostNotificationApi>(),
      () => c.resolve<GhostNotificationDatasource>(),
      () => c.resolve<GhostNotificationRepository>(),
      () => c.resolve<GhostNotificationUsecase>(),
      () => c.resolve<PreferencesApi>(),
      () => c.resolve<PreferencesDataSource>(),
      () => c.resolve<PreferencesRepository>(),
      () => c.resolve<GetZeroPaperUseCase>(),
      () => c.resolve<PutZeroPaperUseCase>(),
      () => c.resolve<PreferencesZeroPaperBloc>(),
      () => c.resolve<GetNotificationUseCase>(),
      () => c.resolve<PutNotificationUseCase>(),
      () => c.resolve<PreferencesNotificationBloc>(),
      () => c.resolve<PreferencesHomeCardsBloc>(),
      () => c.resolve<EasyFixRemoteDataSource>(),
      () => c.resolve<EasyFixRepository>(),
      () => c.resolve<MyPreferencesApi>(),
      () => c.resolve<MyPreferencesDataSource>(),
      () => c.resolve<MyPreferencesRepository>(),
      () => c.resolve<GetUnitPersonalDataUseCase>(),
      () => c.resolve<UpdateUnitPersonalDataUseCase>(),
      () => c.resolve<GetStreetTypesUseCase>(),
      () => c.resolve<CndApi>(),
      () => c.resolve<CndRemoteDataSource>(),
      () => c.resolve<CndRepository>(),
      () => c.resolve<CndPdfUseCase>(),
      () => c.resolve<CertificateNoOutstandingDebtBloc>(),
      () => c.resolve<ChangeOwnershipApi>(),
      () => c.resolve<ChangeOwnershipRemoteDataSource>(),
      () => c.resolve<ChangeOwnershipRepository>(),
      () => c.resolve<PostChangeUseCase>(),
      () => c.resolve<CanChangeUseCase>(),
      () => c.resolve<ChangeOwnershipBloc>(),
      () => c.resolve<ChopperClient>(),
      () => c.resolve<RemoteConfigStore>(),
      () => c.resolve<MeController>(),
      () => c.resolve<DeviceIdentifierService>(),
      () => c.resolve<NotificationListBloc>(),
      () => c.resolve<NotificationController>(),
      () => c.resolve<AuthenticationBloc>(),
      () => c.resolve<AuthenticationStore>(),
      () => c.resolve<IaBellaApi>(),
      () => c.resolve<IaBellaController>(),
      () => c.resolve<ConnectionController>(),
      () => c.resolve<RegistrationBloc>(),
      () => c.resolve<RegistrationStore>(),
      () => c.resolve<ResetPasswordController>(),
      () => c.resolve<CodeValidationBloc>(),
      () => c.resolve<CodeValidationStore>(),
      () => c.resolve<SubUserEditBloc>(),
      () => c.resolve<SubUserAddBloc>(),
      () => c.resolve<SubUserStore>(),
      () => c.resolve<SubUserEditController>(),
      () => c.resolve<SubUserController>(),
      () => c.resolve<SubUserAddController>(),
      () => c.resolve<VehicleController>(),
      () => c.resolve<GetMailingPictureUseCase>(),
      () => c.resolve<MailingController>(),
      () => c.resolve<BilletsController>(),
      () => c.resolve<AccountabilityController>(),
      () => c.resolve<DocumentsController>(),
      () => c.resolve<DigitalMeetingBloc>(),
      () => c.resolve<DigitalMeetingController>(),
      () => c.resolve<ReservationController>(),
      () => c.resolve<AccessControlStore>(),
      () => c.resolve<AccessControlVisitantController>(),
      () => c.resolve<AccessControlProviderController>(),
      () => c.resolve<ReportsController>(),
      () => c.resolve<ComfortPartnersController>(),
      () => c.resolve<ComfortPartnerReviewsController>(),
      () => c.resolve<InsuranceController>(),
      () => c.resolve<BannersController>(),
      () => c.resolve<TDBController>(),
      () => c.resolve<PreferencesZeroPaperController>(),
      () => c.resolve<PreferencesNotificationController>(),
      () => c.resolve<PreferencesHomeCardsController>(),
      () => c.resolve<ChangeAddressController>(),
      () => c.resolve<EasyFixApi>(),
      () => c.resolve<ChangeAddressBloc>(),
      () => c.resolve<GetEasyFixUnitUsecase>(),
      () => c.resolve<UpdateAddressUsecase>(),
      () => c.resolve<GetCitiesUsecase>(),
      () => c.resolve<CertificateNoOutstandingDebtController>(),
      () => c.resolve<OwnershipController>(),
      () => c.resolve<ReceivingDocumentsBloc>(),
      () => c.resolve<InCareBloc>(),
    ];

    final failures = <String>[];
    for (final resolve in resolvers) {
      try {
        if (resolve() == null) failures.add('null');
      } catch (e) {
        failures.add(e.toString().split('\n').first);
      }
    }
    expect(failures, isEmpty);
    // Dá tempo para erros assíncronos dos construtores aparecerem ainda
    // dentro do teste.
    await Future.delayed(const Duration(milliseconds: 100));
  });

  /// Corrigido: `ComfortMyRequestsController` depende de
  /// `GetSubcategoriesUseCase`, que agora é registrado no container. A tela de
  /// "meus pedidos" das comodidades resolve o controller com sucesso.
  test('ComfortMyRequestsController resolve com o GetSubcategoriesUseCase', () {
    final c = ApplicationContainer.instance();
    expect(c.locator.isRegistered<GetSubcategoriesUseCase>(), isTrue);
    expect(c.resolve<GetSubcategoriesUseCase>(), isA<GetSubcategoriesUseCase>());
    expect(
      c.resolve<ComfortMyRequestsController>(),
      isA<ComfortMyRequestsController>(),
    );
  });
}
