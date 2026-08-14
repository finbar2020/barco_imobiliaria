import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_register_facial_response.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_visitant.dart';
import 'package:shared_features/shared_features.dart';

abstract class AccessControlRepository {
  Future<Try<List<AccessControl>>> listVisitants(String unitId);
  Future<Try<AccessControl>> saveVisitant(AccessControlVisitant visitant);
  Future<Try<String>> editVisitant(AccessControlVisitant visitant);
  Future<Try<String>> deleteVisitant(String gestId);
  Future<Try<String>> addVisit(
    String gestId,
    String unitId,
    AccessControlAuthorizations model,
  );
  Future<Try<String>> deleteVisit(String recurrenceId);
  Future<Try<String>> editVisit(
    AccessControlAuthorizations model,
    String recurrenceId,
  );
  Future<Try<UrlUploadS3>> getUrlAws();
  Future<Try<String>> uploadImageToAws(File file, String url);
  Future<Try<AccessControlRegisterFacialResponse>> registerFacialBiometric(
      String hash);
  Future<Try<String>> sendInvite(AccessControlSendInviteEntity cpf);
}
