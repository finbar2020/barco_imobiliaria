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

import '../../feature/my_preferences/data/data_source/my_preferences_data_source.dart';
import '../../feature/my_preferences/data/data_source/my_preferences_data_source_impl.dart';
import '../../feature/my_preferences/data/repository/my_preferences_repository_impl.dart';
import '../../feature/my_preferences/domain/repositories/my_preferences_repository.dart';
import '../../feature/my_preferences/domain/use_cases/get_street_types/get_street_types_use_case_impl.dart';
import '../../feature/my_preferences/domain/use_cases/get_unit_personal_data/get_unit_personal_data_use_case.dart';
import '../../feature/my_preferences/domain/use_cases/get_unit_personal_data/get_unit_personal_data_use_case_impl.dart';
import '../../feature/my_preferences/domain/use_cases/update_unit_personal_data/update_unit_personal_data_use_case.dart';
import '../../feature/my_preferences/domain/use_cases/update_unit_personal_data/update_unit_personal_data_use_case_impl.dart';
import '../../feature/my_preferences/presentation/pages/receiving_documents/presentation/bloc/receiving_documents_bloc.dart';
import '../../feature/sub_user/domain/use_cases/delete_sub_user/delete_sub_user_impl.dart';
import '../../feature/sub_user/domain/use_cases/pending_requests/get_pending_requests_impl_use_case.dart';
import '../../feature/sub_user/domain/use_cases/update_access_request_status/update_access_request_status_use_case_impl.dart';
import '../../feature/sub_user/presentation/bloc/sub_user_add_bloc.dart';
import '../../feature/sub_user/presentation/controllers/sub_user_add_controller.dart';
import '../../feature/sub_user/presentation/stores/sub_user_store.dart';

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

    final datadogTrackingClient = DatadogClient(
      datadogSdk: DatadogSdk.instance,
    );

    locator.registerSingleton(environment);

    locator.registerLazySingleton<ApiPerformaceMonitor>(
        () => ApiPerformaceMonitor());

    locator.registerLazySingleton(() => ChopperClient(
            client: datadogTrackingClient,
            baseUrl: Uri.tryParse(environment.apiUrl),
            converter: JsonConverter(),
            errorConverter: ApiFailureConverter(),
            authenticator: RefreshAuthenticatorInterceptor(
              dataSource: resolve(),
              refreshToken: resolve(),
            ),
            interceptors: [
              CurlInterceptor(),
              PrettyChopperLogger(
                level: !environment.isProduction
                    ? chopper.Level.body
                    : chopper.Level.none,
              ),
              AuthorizationHeaderInterceptor(
                dataSource: resolve(),
                monitor: resolve(),
              ),
            ]));

    locator.registerFactory<Validator>(() => ValidatorImpl());
    locator.registerLazySingleton(() => RemoteConfigStore());

    //ME
    locator.registerFactory<MeApi>(() => MeApi.create(resolve()));
    locator.registerLazySingleton<MeDao>(() => database.meDao);
    locator
        .registerLazySingleton<CondominiumDao>(() => database.condominiumDao);
    locator.registerLazySingleton<BlockDao>(() => database.blockDao);
    locator.registerLazySingleton<UnitDao>(() => database.unitDao);
    locator.registerLazySingleton<LayoutDao>(() => database.layoutDao);

    locator.registerFactory<MeRepository>(() => MeRepositoryImpl(
        localDataSource: resolve(),
        remoteDataSource: resolve(),
        baseUrl: environment.apiUrl));
    locator.registerFactory<GetMe>(() => GetMeImpl(repository: resolve()));
    locator.registerFactory<SaveMe>(() => SaveMeImpl(repository: resolve()));
    locator.registerFactory<UpdatePasswordMe>(
        () => UpdatePasswordMeImpl(repository: resolve()));
    locator.registerFactory<MeLocalDataSource>(() => MeLocalDataSourceImpl(
          meDao: resolve(),
          blockDao: resolve(),
          condoDao: resolve(),
          unitDao: resolve(),
          layoutDao: resolve(),
        ));
    locator.registerFactory<MeRemoteDataSource>(
        () => MeRemoteDataSourceImpl(
              api: resolve(),
              idEmpresa: FlavorConfig.config.idEmpresa,
            ));
    locator.registerFactory<LogMeOut>(() => LogMeOutImpl(
          accessTokenRepository: resolve(),
          db: database,
          sessionRepository: resolve(),
          meRepository: resolve(),
        ));
    locator.registerFactory<MeBloc>(() => MeBloc());
    locator.registerLazySingleton(() => MeController(
        bloc: resolve(),
        getMe: resolve(),
        sessionBloc: resolve(),
        getDados2faUseCase: resolve(),
        request2faUseCase: resolve(),
        saveMe: resolve(),
        authenticationBloc: resolve(),
        authStore: resolve(),
        uploadProfilePicture: resolve(),
        updatePasswordMe: resolve(),
        logMeOut: resolve(),
        deleteAccountUser: resolve(),
        disableFcm: resolve(),
        baseUrl: environment.apiUrl));

    // HOME
    locator.registerFactory<HomeApi>(() => HomeApi.create(resolve()));
    locator.registerFactory<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<HomeRepository>(
        () => HomeRepositoryImpl(dataSource: resolve()));

    locator
        .registerFactory<GetBanner>(() => GetBannerImpl(repository: resolve()));
    locator
        .registerFactory<HomeToGo>(() => HomeToGoImpl(repository: resolve()));
    locator
        .registerFactory<PostTerms>(() => PostTermsImpl(repository: resolve()));
    locator.registerFactory<RegisterFcm>(
        () => RegisterFcmImpl(repository: resolve()));
    locator.registerFactory<DisableFcm>(() => DisableFcmImpl(
          repository: resolve(),
          accessTokenRepository: resolve(),
        ));
    locator.registerLazySingleton<HomeBloc>(
      () => HomeBloc(
        registerFcm: resolve(),
        sessionBloc: resolve(),
        getBanner: resolve(),
        clubLello: resolve(),
        postLello: resolve(),
        subUserUseCase: resolve(),
        sendAccessRenewRequestUseCase: resolve(),
        deviceIdentifierService: resolve(),
      ),
    );
    locator.registerFactory<HomeDialogBloc>(() => HomeDialogBloc(
          sessionBloc: resolve(),
        ));
    locator.registerLazySingleton(() => DeviceIdentifierService());

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
          appOriginEnum: AppOriginEnum.owner,
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

    //splash
    locator.registerFactory<BootDataSource>(() => BootDataSourceImpl());
    locator.registerLazySingleton<BootDataRepository>(
        () => BootDataRepositoryImpl(dataSource: resolve()));
    locator.registerLazySingleton<GetBootData>(
        () => GetBootDataImpl(repository: resolve()));
    locator.registerLazySingleton<SetBootData>(
        () => SetBootDataImpl(repository: resolve()));

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
    locator.registerFactory<DeleteAccount>(() => DeleteAccountImpl(
          repository: resolve(),
        ));
    locator.registerLazySingleton(() => AuthenticationBloc());
    locator.registerLazySingleton(() => AuthenticationStore(
          bloc: resolve(),
          authenticateUsecase: resolve(),
          logoutUsecase: resolve(),
          getToken: resolve(),
          switchRoles: resolve(),
          connectionController: resolve(),
          appOrigin: AppOriginEnum.owner,
        ));

    locator.registerLazySingleton(() => IaBellaApi.create(resolve()));
    locator.registerFactory<IaBellaRemoteDataSource>(
        () => IaBellaRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<IaBellaRepository>(
        () => IaBellaRepositoryImpl(remoteDataSource: resolve()));
    locator.registerFactory<IaBellaBloc>(() => IaBellaBloc());
    locator.registerLazySingleton(() => IaBellaController(
        bloc: resolve(),
        sendMessageUseCase: resolve(),
        downloadPdfUseCase: resolve(),
        rateResponseUseCase: resolve(),
        finalEvaluationUseCase: resolve(),
        sessionBloc: resolve(),
        startSessionUseCase: resolve()));
    locator.registerFactory<IaBellaStartSessionUseCase>(
        () => IaBellaStartSessionUseCaseImpl(repository: resolve()));
    locator.registerFactory<IaBellaSendMessageUseCase>(
        () => IaBellaSendMessageUseCaseImpl(repository: resolve()));
    locator.registerFactory<IaBellaPdfUseCase>(
        () => IaBellaPdfUseCaseImpl(repository: resolve()));
    locator.registerFactory<IaBellaRateResponseUseCase>(
        () => IaBellaRateResponseUseCaseImpl(repository: resolve()));
    locator.registerFactory<IaBellaFinalEvaluationUseCase>(
        () => IaBellaFinalEvaluationUseCaseImpl(repository: resolve()));

    //connection
    locator.registerFactory<ConnectionRemoteDataSource>(
        () => ConnectionRemoteDataSourceImpl(
              baseUrl: getBaseUrl(),
            ));
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

    //session
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
        remoteConfigStore: resolve(),
        authenticationStore: resolve(),
        loadSession: resolve(),
        saveSesion: resolve(),
        switchRoles: resolve(),
        baseUrl: environment.apiUrl,
      ),
    );

    //registration
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
        UploadProfilePictureImpl(uploader: resolve(), sessionBloc: resolve()));
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
    locator.registerLazySingleton<Uploader>(() => UploaderImpl(
          environment: resolve(),
          getToken: resolve(),
          session: resolve(),
        ));

    //reset password
    locator.registerFactory<PasswordResetApi>(
        () => PasswordResetApi.create(resolve()));
    locator.registerFactory<PasswordResetRemoteDataSource>(
        () => PasswordResetRemoteDataSourceImpl(
              api: resolve(),
            ));
    locator.registerFactory<PasswordResetRepository>(
        () => PasswordResetRepositoryImpl(dataSource: resolve()));
    locator.registerFactory<ResetPassword>(
        () => ResetPasswordImpl(repository: resolve()));
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

    //code validation
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
          emptySessionState: resolve<SessionBloc>().emptyState,
          clearDataUseCase: resolve(),
          logOutUseCase: resolve()),
    );

    //Face Detector
    locator.registerFactory<GetImageFromCameraViewPickerUsecase>(
        () => GetImageFromCameraViewPickerUsecase());

    //subUser
    locator.registerFactory<SubUserApi>(() => SubUserApi.create(resolve()));
    locator.registerFactory<SubUsersBloc>(() => SubUsersBloc());
    locator.registerLazySingleton(() => SubUserEditBloc());
    locator.registerLazySingleton(() => SubUserAddBloc());
    locator.registerFactory<SubUserRemoteDataSource>(
        () => SubUserRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<SubUserRepository>(
        () => SubUserRepositoryImpl(dataSource: resolve()));
    locator.registerFactory<SubUserUseCase>(
        () => SubUserUseCaseImpl(repository: resolve()));
    locator.registerFactory<GetPendingRequestsUseCase>(
        () => GetPendingRequestsUseCaseImpl(resolve()));
    locator.registerFactory<UpdateSubUser>(
        () => UpdateSubUserImpl(repository: resolve()));
    locator.registerFactory<DeleteSubUser>(
        () => DeleteSubUserImpl(repository: resolve()));
    locator.registerFactory<InsertSubUser>(
        () => InsertSubUserImpl(repository: resolve()));
    locator.registerFactory<SubUserRoleCase>(
        () => SubUserRoleCaseImpl(repository: resolve()));
    locator.registerFactory<SubUserCheckServiceCase>(
        () => SubUserCheckServiceImpl(repository: resolve()));
    locator.registerFactory<SendInviteUsecase>(
        () => SendInviteUsecaseImpl(repository: resolve()));
    locator.registerFactory<UpdateAccessRequestUseCase>(
        () => UpdateAccessRequestStatusUseCaseImpl(resolve()));
    locator.registerFactory<SendAccessRenewRequestUseCase>(
        () => SendAccessRenewRequestUseCaseImpl(repository: resolve()));
    locator.registerLazySingleton(
      () => SubUserStore(
        bloc: resolve(),
        addBloc: resolve(),
        editBloc: resolve(),
        subUserRoleCase: resolve(),
        subUserUseCase: resolve(),
        sessionBloc: resolve(),
        updateSubUser: resolve(),
        insertSubUser: resolve(),
        checkServiceCase: resolve(),
        facialBiometricUsecase: resolve(),
        sendInviteUsecase: resolve(),
        getImageFromCameraViewPickerUsecase: resolve(),
        meController: resolve(),
        sendAccessRenewRequestUseCase: resolve(),
        getPendingRequestsUseCase: resolve(),
        updateAccessRequestUseCase: resolve(),
        deleteSubUser: resolve(),
      ),
    );
    locator.registerLazySingleton(
      () => SubUserEditController(
        store: resolve(),
      ),
    );
    locator.registerLazySingleton(
      () => SubUserController(
        store: resolve(),
      ),
    );
    locator.registerLazySingleton(
      () => SubUserAddController(
        resolve(),
      ),
    );

    //vehicle
    locator.registerFactory<VehicleApi>(() => VehicleApi.create(resolve()));
    locator.registerFactory<VehiclesBloc>(() => VehiclesBloc());
    locator.registerFactory<VehicleRemoteDataSource>(
        () => VehicleRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<VehicleRepository>(
        () => VehicleRepositoryImpl(remoteDataSource: resolve()));
    locator.registerFactory<SaveVehicle>(
        () => SaveVehicleImpl(repository: resolve()));
    locator.registerFactory<GetVehicle>(
        () => GetVehicleImpl(repository: resolve()));
    locator.registerFactory<UpDateVehicle>(
        () => UpDateVehicleImpl(repository: resolve()));
    locator.registerFactory<DeleteVehicle>(
        () => DeleteVehiceleImpl(repository: resolve()));
    locator.registerLazySingleton(
      () => VehicleController(
        vehicleBloc: resolve(),
        sessionBloc: resolve(),
        saveVehicle: resolve(),
        getVehiacle: resolve(),
        upDateVehicle: resolve(),
        deleteVehicle: resolve(),
      ),
    );

    //Mailing
    locator.registerFactory<MailingApi>(() => MailingApi.create(resolve()));
    locator.registerFactory<MailingBloc>(() => MailingBloc());

    locator.registerFactory<MailingRemoteDataSource>(
        () => MailingRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<MailingRepository>(
        () => MailingRepositoryImpl(dataSource: resolve()));
    locator.registerFactory<MailingUseCase>(
        () => MailingUseCaseImpl(repository: resolve()));
    locator
        .registerFactory(() => GetMailingPictureUseCase(repository: resolve()));
    locator.registerLazySingleton(
      () => MailingController(
        mailingUseCase: resolve(),
        sessionBloc: resolve(),
        getMailingPictureUseCase: resolve(),
        bloc: resolve(),
      ),
    );

    //billets
    locator.registerFactory<BilletsApi>(() => BilletsApi.create(resolve()));
    locator.registerFactory<BilletsBloc>(() => BilletsBloc());
    locator.registerFactory<BilletsRemoteDataSource>(
        () => BilletsRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<BilletsRepository>(
        () => BilletsRepositoryImpl(dataSource: resolve()));
    locator.registerFactory<BilletsUseCase>(
        () => BilletsUseCaseImpl(repository: resolve()));
    locator.registerFactory<BilletsPdfUseCase>(
        () => BilletsPdfUseCaseImpl(repository: resolve()));
    locator.registerLazySingleton(() => BilletsController(
          bloc: resolve(),
          billetsUseCase: resolve(),
          billetsPdf: resolve(),
          sessionBloc: resolve(),
        ));

    //accountability
    locator.registerFactory<AccountabilityApi>(
        () => AccountabilityApi.create(resolve()));
    locator.registerFactory<AccountabilityBloc>(() => AccountabilityBloc());
    locator.registerLazySingleton(() => AccountabilityController(
          bloc: resolve(),
          getAccountability: resolve(),
          getAccountabilityPeriod: resolve(),
          sessionBloc: resolve(),
        ));
    locator.registerFactory<AccountabilityRemoteDataSource>(
        () => AccountabilityRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<AccountabilityRepository>(
        () => AccountabilityRepositoryImpl(dataSource: resolve()));
    locator.registerFactory<GetAccountability>(
        () => GetAccountabilityImpl(repository: resolve()));
    locator.registerFactory<GetAccountabilityPeriod>(
        () => GetAccountabilityPeriodImpl(repository: resolve()));

    //documents
    locator.registerLazySingleton<CachedDocumentsStore>(
        () => CachedDocumentsStore());
    locator.registerFactory<DocumentsApi>(() => DocumentsApi.create(resolve()));
    locator.registerFactory<DocumentsBloc>(() => DocumentsBloc());
    locator.registerFactory<DocumentsRemoteDataSource>(
        () => DocumentsRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<DocumentsRepository>(() => DocumentsRepositoryImpl(
          remoteDataSource: resolve(),
          cacheStore: resolve(),
          environment: environment,
          authenticationStore: resolve(),
        ));
    locator.registerFactory<DownloadDocument>(
        () => DownloadDocumentImpl(repository: resolve()));
    locator.registerFactory<GetExtractedText>(
        () => GetExtractedTextImpl(repository: resolve()));
    locator.registerLazySingleton(() => DocumentsController(
          bloc: resolve(),
          repository: resolve(),
          downloadDocument: resolve(),
          getExtractedText: resolve(),
          session: MorarSharedSession(resolve()),
          analytics: MorarDocumentsAnalytics(resolve()),
        ));

    //meetings
    locator.registerFactory<DigitalMeetingApi>(
        () => DigitalMeetingApi.create(resolve()));
    locator.registerLazySingleton(() => DigitalMeetingBloc());
    locator.registerLazySingleton(() => DigitalMeetingController(
          bloc: resolve(),
          getMeetingDataUsecase: resolve(),
          getMeetingsUsecase: resolve(),
          sessionBloc: resolve(),
        ));
    locator.registerFactory<DigitalMeetingRemoteDataSource>(
        () => DigitalMeetingRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<DigitalMeetingRepository>(
        () => DigitalMeetingRepositoryImpl(dataSource: resolve()));
    locator.registerFactory<GetMeetings>(
        () => GetMeetingsImpl(repository: resolve()));
    locator.registerFactory<GetMeetingDataUseCase>(
        () => GetMeetingDataImpl(repository: resolve()));

    //reservations
    locator.registerFactory<ReservationApi>(
        () => ReservationApi.create(resolve()));
    locator.registerLazySingleton(() => ReservationController());
    locator.registerFactory<ReservationBloc>(() => ReservationBloc(
          getSpace: resolve(),
          getReservations: resolve(),
          calendar: resolve(),
          hours: resolve(),
          insertReservation: resolve(),
          delete: resolve(),
          sessionBloc: resolve(),
          billetsPdf: resolve(),
        ));
    locator.registerFactory<ReservationRemoteDataSource>(
        () => ReservationRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<ReservationRepository>(
        () => ReservationRepositoryImpl(dataSource: resolve()));
    locator
        .registerFactory<GetSpace>(() => GetSpaceImpl(repository: resolve()));
    locator.registerFactory<GetAllReservation>(
        () => GetAllReservationImpl(repository: resolve()));
    locator.registerFactory<GetCalendar>(
        () => GetCalendarImpl(repository: resolve()));

    locator
        .registerFactory<GetHours>(() => GetHoursImpl(repository: resolve()));
    locator.registerFactory<PostReservation>(
        () => PostReservationImpl(repository: resolve()));
    locator.registerFactory<DeleteReservation>(
        () => DeleteReservationImpl(repository: resolve()));

    //AWS
    locator.registerFactory<AwsUploadFileUsecase>(
        () => AwsUploadFileUsecaseImpl());

    //accessControl
    locator.registerFactory<AccessControlApi>(
        () => AccessControlApi.create(resolve()));
    locator.registerFactory<AccessControlBloc>(() => AccessControlBloc());
    locator.registerLazySingleton(
      () => AccessControlStore(
        getVisitantsUseCase: resolve(),
        save: resolve(),
        edit: resolve(),
        deleteVisitantUsecase: resolve(),
        addVisit: resolve(),
        deleteScheduled: resolve(),
        editScheduled: resolve(),
        sessionBloc: resolve(),
        sendInvite: resolve(),
        bloc: resolve(),
      ),
    );
    locator.registerLazySingleton(
        () => AccessControlVisitantController(store: resolve()));
    locator.registerLazySingleton(
        () => AccessControlProviderController(store: resolve()));
    locator.registerFactory<AccessControlRemoteDataSource>(
        () => AccessControlRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<AccessControlRepository>(() =>
        AccessControlRepositoryImpl(
            remoteDataSource: resolve(), uploader: resolve()));
    locator.registerFactory<GetVisitants>(
        () => GetVisitantsImpl(repository: resolve()));
    locator.registerFactory<SaveVisitant>(
        () => SaveVisitantImpl(repository: resolve()));
    locator.registerFactory<EditVisitant>(
        () => EditVisitantImpl(repository: resolve()));
    locator.registerFactory<DeleteVisitant>(
        () => DeleteVisitantImpl(repository: resolve()));
    locator
        .registerFactory<AddVisit>(() => AddVisitImpl(repository: resolve()));
    locator.registerFactory<DeleteVisit>(
        () => DeleteVisitImpl(repository: resolve()));
    locator
        .registerFactory<EditVisit>(() => EditVisitImpl(repository: resolve()));
    locator.registerFactory<FacialBiometricUsecase>(() =>
        FacialBiometricUsecaseImpl(
            repository: resolve(), awsUploadFileUsecase: resolve()));

    //Reports Book
    locator.registerFactory<ReportsBookApi>(
        () => ReportsBookApi.create(resolve()));
    locator.registerFactory<ReportsBookRemoteDataSource>(
        () => ReportsBookRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<ReportsBookRepository>(() =>
        ReportsBookRepositoryImpl(
            dataSource: resolve(),
            uploader: resolve(),
            baseUrl: environment.apiUrl));
    locator.registerFactory<GetAllReportsUseCase>(
        () => GetAllReportsUseCaseImpl(repository: resolve()));
    locator.registerFactory<PostNewReportUseCase>(
        () => PostNewReportUseCaseImpl(repository: resolve()));
    locator.registerFactory<GetReportUseCase>(() => GetReportUseCaseImpl(
          repository: resolve(),
        ));
    locator.registerFactory<PutReportContentUseCase>(
        () => PutReportContentUseCaseImpl(repository: resolve()));
    locator.registerFactory<PutReportAttachmentUseCase>(
        () => PutReportAttachmentUseCaseImpl(repository: resolve()));
    locator.registerFactory<ReportsBloc>(() => ReportsBloc());
    locator.registerLazySingleton(
      () => ReportsController(
          sessionBloc: resolve(),
          reportsBloc: resolve(),
          getAllReportsUseCase: resolve(),
          getReportUseCase: resolve(),
          postNewReportUseCase: resolve(),
          putReportContentUseCase: resolve(),
          putReportAttachmentUseCase: resolve()),
    );

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
          appOriginEnum: AppOriginEnum.owner),
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
          appOriginEnum: AppOriginEnum.owner,
          sessionBloc: resolve<SessionBloc>(),
        ));
    locator.registerFactory<ComfortPartnerReviewsBloc>(
        () => ComfortPartnerReviewsBloc());
    locator.registerLazySingleton(
      () => ComfortPartnerReviewsController(
          getAllPartnerReviewsUseCase: resolve(),
          sessionBloc: resolve<SessionBloc>(),
          appOriginEnum: AppOriginEnum.owner,
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

    //INSURANCE
    locator.registerFactory<InsuranceApi>(() => InsuranceApi.create(resolve()));
    locator.registerFactory<InsuranceBloc>(() => InsuranceBloc());
    locator.registerLazySingleton(() => InsuranceController(
          bloc: resolve(),
          insuranceUseCase: resolve(),
          postUseCase: resolve(),
          sessionBloc: resolve(),
        ));
    locator.registerFactory<InsuranceRemoteDataSource>(
        () => InsuranceRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<InsuranceRepository>(() => InsuranceRepositoryImpl(
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<GetInsurance>(
        () => GetInsurancempl(repository: resolve()));
    locator.registerFactory<PostInsurance>(
        () => PostInsurancempl(repository: resolve()));

    //AGREEMENTS
    locator
        .registerFactory<AgreementsApi>(() => AgreementsApi.create(resolve()));
    locator.registerLazySingleton<AgreementsBloc>(() => AgreementsBloc(
          sessionBloc: resolve(),
          getAvailableUseCase: resolve(),
          getRecommendationUseCase: resolve(),
          getPaydayUseCase: resolve(),
          getInstallmentCreditUseCase: resolve(),
          postAgreementUseCase: resolve(),
          getAgreementDetailUseCase: resolve(),
          baseUrl: environment.apiUrl,
        ));
    locator.registerFactory<AgreementsRemoteDataSource>(
        () => AgreementsRemoteDataSourceImpl(api: resolve()));

    locator.registerFactory<AgreementsRepository>(
        () => AgreementsRepositoryImpl(remoteDataSource: resolve()));
    locator.registerFactory<GetAvailableUseCase>(
        () => GetAvailableUseCaseImpl(repository: resolve()));
    locator.registerFactory<GetRecommendationUseCase>(
        () => GetRecommendationUseCaseImpl(repository: resolve()));
    locator.registerFactory<GetPaydayUseCase>(
        () => GetPaydayUseCaseImpl(repository: resolve()));
    locator.registerFactory<GetInstallmentCreditUseCase>(
        () => GetInstallmentCreditUseCaseImpl(repository: resolve()));
    locator.registerFactory<PostAgreementUseCase>(
        () => PostAgreementImplUseCase(repository: resolve()));
    locator.registerFactory<GetAgreementDetailUseCase>(
        () => GetAgreementDetailImplUseCase(repository: resolve()));

    //BANNERS
    locator.registerFactory<BannersApi>(() => BannersApi.create(resolve()));
    locator.registerFactory<BannersBloc>(() => BannersBloc());
    locator.registerLazySingleton(() => BannersController(
        appOriginEnum: AppOriginEnum.owner,
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
    locator.registerFactory<BannersRemoteDataSource>(
        () => BannersRemoteDataSourceImpl(api: resolve()));
    locator.registerLazySingleton<BannersDao>(() => BannersDao());
    locator.registerLazySingleton<BannersArgsDao>(() => BannersArgsDao());
    locator.registerFactory<BannersRepository>(() => BannersRepositoryImpl(
          remoteDataSource: resolve(),
          localDataSource: resolve(),
        ));
    locator.registerFactory<GetBannersUseCase>(
        () => GetBannersUseCaseImpl(repository: resolve()));

    //TDB
    locator.registerFactory<TDBApi>(() => TDBApi.create(resolve()));
    locator.registerFactory<TDBBloc>(() => TDBBloc());
    locator.registerLazySingleton(() => TDBController(
          bloc: resolve(),
          getTDBInfoUseCase: resolve(),
          sessionBloc: resolve(),
        ));
    locator.registerFactory<TDBRemoteDataSource>(
        () => TDBRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<TDBRepository>(() => TDBRepositoryImpl(
          remoteDataSource: resolve(),
        ));
    locator.registerFactory<GetTDBInfoUseCase>(() => GetTDBInfoUseCaseImpl(
          repository: resolve(),
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
        getMe: resolve(),
        switchRoles: resolve(),
        homeBloc: resolve(),
      ),
    );

    // Preferences
    locator.registerFactory<PreferencesApi>(
        () => PreferencesApi.create(resolve()));
    locator.registerFactory<PreferencesDataSource>(
        () => PreferencesDataSourceImpl(api: resolve()));
    locator.registerFactory<PreferencesRepository>(
        () => PreferencesRepositoryImpl(dataSource: resolve()));

    locator.registerFactory<GetZeroPaperUseCase>(
        () => GetZeroPaperUseCaseImpl(repository: resolve()));
    locator.registerFactory<PutZeroPaperUseCase>(
        () => PutZeroPaperUseCaseImpl(repository: resolve()));
    locator.registerFactory<PreferencesZeroPaperBloc>(
        () => PreferencesZeroPaperBloc());
    locator.registerLazySingleton(() => PreferencesZeroPaperController(
        bloc: resolve(),
        getZeroPaperUseCase: resolve(),
        putZeroPaperUseCase: resolve(),
        sessionBloc: resolve()));

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

    locator.registerFactory<PreferencesHomeCardsBloc>(
        () => PreferencesHomeCardsBloc());
    locator.registerLazySingleton(() => PreferencesHomeCardsController(
          sessionBloc: resolve<SessionBloc>(),
          bloc: resolve(),
        ));

    locator.registerLazySingleton(
      () => ChangeAddressController(
        bloc: resolve(),
        sessionBloc: resolve(),
        getCitiesUsecase: resolve(),
        getEasyFixUnitUsecase: resolve(),
        updateAddressUsecase: resolve(),
      ),
    );
    locator.registerLazySingleton(() => EasyFixApi.create(resolve()));
    locator.registerLazySingleton(() => ChangeAddressBloc());
    locator.registerLazySingleton<EasyFixRemoteDataSource>(
        () => EasyFixRemoteDataSourceImpl(api: resolve()));
    locator.registerLazySingleton<EasyFixRepository>(
        () => EasyFixRepositoryImpl(datasource: resolve()));
    locator.registerLazySingleton(
        () => GetEasyFixUnitUsecase(repository: resolve()));
    locator.registerLazySingleton(
        () => UpdateAddressUsecase(repository: resolve()));
    locator
        .registerLazySingleton(() => GetCitiesUsecase(repository: resolve()));

    //Receiving Documents
    locator.registerFactory<MyPreferencesApi>(
      () => MyPreferencesApi.create(
        resolve(),
      ),
    );
    locator.registerFactory<MyPreferencesDataSource>(
      () => MyPreferencesDataSourceImpl(
        resolve(),
      ),
    );
    locator.registerFactory<MyPreferencesRepository>(
      () => MyPreferencesRepositoryImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetUnitPersonalDataUseCase>(
      () => GetUnitPersonalDataUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<UpdateUnitPersonalDataUseCase>(
      () => UpdateUnitPersonalDataUseCaseImpl(
        resolve(),
      ),
    );
    locator.registerFactory<GetStreetTypesUseCase>(
      () => GetStreetTypesUseCaseImpl(
        resolve(),
      ),
    );

    //Certificate No Outstanding Debt
    locator.registerFactory<CndApi>(() => CndApi.create(resolve()));
    locator.registerFactory<CndRemoteDataSource>(
        () => CndRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<CndRepository>(
        () => CndRepositoryImpl(dataSource: resolve()));
    locator.registerFactory<CndPdfUseCase>(
        () => CndPdfUseCaseImpl(repository: resolve()));

    locator.registerFactory<CertificateNoOutstandingDebtBloc>(
        () => CertificateNoOutstandingDebtBloc());
    locator.registerLazySingleton(
      () => CertificateNoOutstandingDebtController(
          sessionBloc: resolve(),
          bloc: resolve(),
          cndPdfUseCase: resolve(),
          getEasyFixUnitUsecase: resolve()),
    );

    locator.registerFactory<ChangeOwnershipApi>(
        () => ChangeOwnershipApi.create(resolve()));
    locator.registerFactory<ChangeOwnershipRemoteDataSource>(
        () => ChangeOwnershipRemoteDataSourceImpl(api: resolve()));
    locator.registerFactory<ChangeOwnershipRepository>(() =>
        ChangeOwnershipRepositoryImpl(
            dataSource: resolve(), uploader: resolve()));
    locator.registerFactory<PostChangeUseCase>(() => PostChangeUseCaseImpl(
        repository: resolve(), awsUploadFileUsecase: resolve()));
    locator.registerFactory<CanChangeUseCase>(
        () => CanChangeUseCaseImpl(repository: resolve()));
    locator.registerFactory<ChangeOwnershipBloc>(() => ChangeOwnershipBloc());
    locator.registerLazySingleton(() => OwnershipController(
          bloc: resolve(),
          postChangeUsecase: resolve(),
          canChange: resolve(),
          sessionBloc: resolve(),
        ));

    locator.registerLazySingleton<CircuitBreakerController>(
        () => CircuitBreakerController(
              database: FirebaseFirestore.instance,
              sessionBloc: resolve<SessionBloc>(),
              environment: environment,
            ));

    locator.registerFactory(
      () => ReceivingDocumentsBloc(
        resolve(),
        resolve(),
        resolve(),
        resolve(),
        resolve(),
      ),
    );

    locator.registerFactory(
      () => InCareBloc(
        resolve(),
        resolve(),
        resolve(),
      ),
    );
  }

  Future<void> afterSetup() async {
    print("finalizou");
    final AuthenticationStore loginStore = resolve();
    loginStore.load();
  }

  T resolve<T extends Object>() => locator<T>();

  @override
  FutureOr resetLazySingleton<T extends Object>() =>
      locator.resetLazySingleton<T>();

  @override
  String getBaseUrl() {
    return resolve<Environment>().apiUrl;
  }
}
