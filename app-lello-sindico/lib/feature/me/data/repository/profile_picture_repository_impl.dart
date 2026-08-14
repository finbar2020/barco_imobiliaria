import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/core/uploader/uploader.dart';
import 'package:lello/feature/me/domain/repository/profile_picture_repository.dart';

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
    } catch (err) {
      return new Rejection(UnknownFailure(err));
    }
  }
}
