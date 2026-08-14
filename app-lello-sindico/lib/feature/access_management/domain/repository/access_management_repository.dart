import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/domain/entity/access_control_register_facial_response.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_send_invite.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_service_seventh.dart';
import 'package:shared_features/shared_features.dart';

abstract class AccessManagementRepository {
  Future<Try<AccessManagementServiceSeventh>> checkSeventhService(
      String reference);
  Future<Try<UrlUploadS3>> getUrlAws();
  Future<Try<String>> uploadImageToAws(File file, String url);
  Future<Try<AccessControlRegisterFacialResponse>> registerFacialBiometric(
      String hash);
  Future<Try<String>> sendInvite(AccessManagementSendInviteEntity model);
}
