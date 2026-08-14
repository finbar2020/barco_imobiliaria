import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/core/uploader/uploader.dart';
import 'package:lello/feature/space/domain/repository/space_file_repository.dart';

class SpaceFileRepositoryImpl extends SpaceFileRepository {
  final Uploader uploader;

  SpaceFileRepositoryImpl({required this.uploader});
  @override
  Future<Try<String>> upload(String condominiumId, String spaceId, File file,
      StreamController<double> progress) {
    final completer = Completer<Try<String>>();
    uploader.uploadWithProgress(
        "condominiums/$condominiumId/space-files/$spaceId", file, progress,
        onComplete: (data) {
      final j = json.decode(data);
      return completer.complete(Success(j["path"]));
    }, onError: (err) {
      return completer.complete(Rejection(UnknownFailure(err)));
    });
    return completer.future;
  }
}
