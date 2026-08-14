import 'dart:async';
import 'dart:io';

import 'package:colaborador/feature/me/domain/repository/profile_picture_repository.dart';
import 'package:colaborador/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';

class UploadProfilePictureImpl extends UploadProfilePicture {
  final ProfilePictureRepository uploader;
  final SessionBloc sessionBloc;

  UploadProfilePictureImpl({required this.uploader, required this.sessionBloc});
  @override
  Future<Try<String>> call(File params) async {
    final completer = Completer<Try<String>>();
    await uploader.upload(
      params,
      onComplete: (url) {
        sessionBloc.beginLoadSession();
        return completer.complete(Success(url));
      },
      onError: (e) {
        return completer.complete(Rejection(UnknownFailure(e)));
      },
    );
    return completer.future;
  }
}
