import 'dart:io';

import 'package:colaborador/core/uploader/uploader.dart';
import 'package:colaborador/feature/me/domain/repository/profile_picture_repository.dart';
import 'package:essentials/essentials.dart';

class ProfilePictureRepositoryImpl extends ProfilePictureRepository {
  final Uploader uploader;

  ProfilePictureRepositoryImpl({required this.uploader});
  @override
  Future<Try<String>> upload(File file,
      {required Function(String) onComplete,
      required Function(Exception) onError}) async {
    try {
      final taskId = await uploader.upload("me/pictures", file,
          onComplete: onComplete, onError: onError);
      return Success(taskId);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(e, stacktrace);
      return Rejection(UnknownFailure(e));
    }
  }
}
