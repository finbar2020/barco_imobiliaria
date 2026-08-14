import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:morar/core/uploader/uploader.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class UploaderImpl extends Uploader {
  final Environment environment;
  final GetToken getToken;
  final SessionBloc session;

  UploaderImpl({
    required this.environment,
    required this.getToken,
    required this.session,
  });

  @override
  Future<String> upload(String path, File file,
      {StreamController<double>? progress,
      required Function(String) onComplete,
      required Function(Exception) onError}) async {
    return uploadWithProgress(path, file, progress,
        onComplete: onComplete, onError: onError);
  }

  @override
  Future<String> uploadWithProgress(
      String path, File file, StreamController<double>? progress,
      {required Function(String) onComplete,
      required Function(Exception) onError}) async {
    //TODO: Verificar role do Uploader
    try {
      final token = await getToken.call(GetTokenParams(role: null));
      final accessToken = token.getOrElse(() => null);
      final headers = <String, String>{};
      if (accessToken != null) {
        headers["Authorization"] = "Bearer ${accessToken.accessToken}";
      }

      dio.Dio().post(
        "${environment.apiUrl}/$path",
        data: dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(file.path,
              contentType:
                  MediaType.parse(lookupMimeType(file.path) ?? "image/jpeg")),
        }),
        options: dio.Options(headers: {
          "Authorization":
              "Bearer ${accessToken!.accessToken}", // set content-length
        }),
        onReceiveProgress: (count, total) {
          progress?.add((total / count) * 100);
        },
      ).then(
        (value) {
          if (value.statusCode == null || value.statusCode! ~/ 100 != 2) {
            onError.call(value.data);
          } else {
            onComplete.call("Sended");
          }
        },
      );
      return "Sending";
    } on Exception catch (e) {
      onError.call(e);
      throw e;
    }
  }

  @override
  Future<String> uploadS3(String url, File file,
      {required Function(String) onComplete,
      required Function(Exception) onError}) async {
    return await uploadS3WithProgress(url, file, null,
        onComplete: onComplete, onError: onError);
  }

  @override
  Future<String> uploadS3WithProgress(
    String url,
    File file,
    StreamController<double>? progress, {
    required Function(String) onComplete,
    required Function(Exception) onError,
  }) async {
    try {
      Uint8List image = File(file.path).readAsBytesSync();
      dio.Dio().put(
        url,
        data: file.openRead(),
        options: dio.Options(
            contentType: lookupMimeType(file.path) ?? "image/jpeg",
            headers: {
              'Accept': "*/*",
              'Content-Length': image.length,
              'Connection': 'keep-alive',
              'User-Agent': 'ClinicPlush'
            }),
        onReceiveProgress: (count, total) {
          progress?.add((total / count) * 100);
        },
      ).then(
        (value) {
          if (value.statusCode == null || value.statusCode! ~/ 100 != 2) {
            onError.call(value.data);
          } else {
            onComplete.call("Sended");
          }
        },
      );
      return "Sending";
    } on Exception catch (e) {
      onError.call(e);
      throw e;
    }
  }
}
