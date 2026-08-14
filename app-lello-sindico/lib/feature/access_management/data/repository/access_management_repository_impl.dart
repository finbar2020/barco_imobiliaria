import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/core/uploader/uploader.dart';
import 'package:lello/feature/access_management/data/data_source/access_management_remote_data_source.dart';
import 'package:lello/feature/access_management/data/model/access_management_send_invite_model.dart';
import 'package:lello/feature/access_management/domain/entity/access_control_register_facial_response.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_send_invite.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_service_seventh.dart';
import 'package:lello/feature/access_management/domain/repository/access_management_repository.dart';
import 'package:shared_features/shared_features.dart';

class AccessManagementRepositoryImpl extends AccessManagementRepository {
  final AccessManagementRemoteDataSource dataSource;
  final Uploader uploader;

  AccessManagementRepositoryImpl({
    required this.dataSource,
    required this.uploader,
  });

  @override
  Future<Try<AccessManagementServiceSeventh>> checkSeventhService(
      String reference) async {
    try {
      final data = await dataSource.checkSeventhService(reference);
      return Success(data.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<UrlUploadS3>> getUrlAws() async {
    try {
      final data = await dataSource.getUrlAws();
      UrlUploadS3 entity = data.toEntity();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> uploadImageToAws(File file, String url) async {
    try {
      final completer = Completer<Try<String>>();
      await uploader.uploadS3(
        url,
        file,
        onComplete: (url) {
          return completer.complete(Success(url));
        },
        onError: (e) {
          return completer.complete(Rejection(UnknownFailure(e)));
        },
      );
      return completer.future;
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<AccessControlRegisterFacialResponse>> registerFacialBiometric(
      String hash) async {
    try {
      final result = await dataSource.registerFacialBiometric(hash);
      return Success(result.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> sendInvite(AccessManagementSendInviteEntity model) async {
    try {
      AccessManagementSendInviteModel parse =
          AccessManagementSendInviteModel.fromEntity(model)!;
      final result = await dataSource.sendInvite(parse);
      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
