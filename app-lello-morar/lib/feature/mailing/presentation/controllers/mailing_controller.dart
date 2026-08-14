import 'dart:typed_data';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:morar/feature/mailing/domain/use_case/get_mailing_picture_impl.dart';
import 'package:morar/feature/mailing/presentation/bloc/mailing_bloc.dart';
import 'package:morar/feature/session/domain/entity/session.dart';

import '../../../../core/analytics/analytics_log_events.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../data/model/mailing_model.dart';
import '../../domain/entity/mailing.dart';
import '../../domain/use_case/mailings.dart';
import '../bloc/mailing_event.dart';

class MailingController {
  final MailingUseCase mailingUseCase;
  final SessionBloc sessionBloc;
  final GetMailingPictureUseCase getMailingPictureUseCase;
  final MailingBloc bloc;

  MailingController({
    required this.mailingUseCase,
    required this.sessionBloc,
    required this.getMailingPictureUseCase,
    required this.bloc,
  });

  int totalItems = 0;
  List<Mailing> mailings = [];
  Uint8List? picture;

  Future<Uint8List?> getPicture({required String hash}) async {
    final result =
        await getMailingPictureUseCase(GetMailingPictureParams(hash: hash));
    return result.fold(
      (l) => null,
      (file) {
        if (file != null) {
          picture = file;
          return file;
        }
        return null;
      },
    );
  }

  Future<void> getMailings({bool showAll = false}) async {
    bloc.add(MailingLoadingEvent());

    if (sessionBloc.state.session?.condominium?.id == null) {
      bloc.add(MailingFailureEvent());
      return;
    }

    final response = await mailingUseCase.call(
      MailingParams(
        unityId: sessionBloc.state.session!.unity!.id!,
        showAll: showAll,
      ),
    );

    response.fold((error) => bloc.add(MailingFailureEvent()), (res) {
      try {
        List<Mailing> mailings = [];
        if (res.data.length != null || res.data.isNotEmpty) {
          List.generate(res.data.length, (i) {
            Map<String, dynamic> map = res.data[i];
            MailingModel model = MailingModel.fromJson(map);
            mailings.add(model.toEntity());
          });
        }

        if (mailings.length == 0) {
          return bloc.add(MailingEmptyEvent());
        } else {
          totalItems = res.meta!.totalItems!;
          this.mailings = mailings;
          bloc.add(MailingSuccessEvent(mailings: mailings));
        }
      } catch (e) {
        return bloc.add(MailingFailureEvent());
      }
    });
    OwnerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsOwner.correspondenciaAcessar(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
      referenceValue:
          sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
    );
  }

  Session get session => sessionBloc.state.session!;
}
