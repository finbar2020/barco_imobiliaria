import 'dart:async';
import 'dart:io';

import 'package:colaborador/core/uploader/uploader.dart';
import 'package:colaborador/feature/sick_note/data/data_source/remote/sick_note_remote_data_source.dart';
import 'package:colaborador/feature/sick_note/data/model/sick_note_model.dart';
import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/sick_note/domain/repository/sick_note_repository.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

class SickNoteRepositoryImpl extends SickNoteRepository {
  final SickNoteRemoteDataSource remoteDataSource;
  final Uploader uploader;

  SickNoteRepositoryImpl({
    required this.remoteDataSource,
    required this.uploader,
  });

  @override
  Future<Try<SickNoteEntity>> registerSickNote(
      SickNoteEntity entity, String condoId, String meId) async {
    SickNoteModel modelUpdated = SickNoteModel.fromEntity(entity);
    try {
      modelUpdated =
          await remoteDataSource.registerSickNote(modelUpdated, condoId);
      return Success(modelUpdated.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<UrlUploadS3>> getUrlAws(String condoId) async {
    try {
      final data = await remoteDataSource.getUrlAws(condoId);
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
          debugPrint("DEBUG PRINT: onComplete uploadImageToAws: $url");
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
}
