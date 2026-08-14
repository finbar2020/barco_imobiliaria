import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:essentials/essentials.dart';
import 'package:lello/core/aws_uploader/aws_uploader.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class AwsUploaderImpl extends AwsUploader {
  final GetToken getToken;
  final SessionBloc session;

  AwsUploaderImpl({
    required this.getToken,
    required this.session,
  });

  @override
  Future<String> uploadS3(
    String url,
    File file, {
    required Function(String) onComplete,
    required Function(Exception) onError,
  }) async {
    return uploadS3WithProgress(url, file, null,
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
      Uint8List fileBytes = File(file.path).readAsBytesSync();
      dio.Dio().put(
        url,
        data: file.openRead(),
        options: dio.Options(
          contentType: lookupMimeType(file.path) ?? "application/octet-stream",
          headers: {
            'Accept': "*/*",
            'Content-Length': fileBytes.length,
            'Connection': 'keep-alive',
            'User-Agent': 'YourAppName'
          },
        ),
        onReceiveProgress: (count, total) {
          progress?.add((total / count) * 100);
        },
      ).then(
        (value) {
          if (value.statusCode == null || value.statusCode! ~/ 100 != 2) {
            onError.call(Exception(
                "Upload failed with status code: ${value.statusCode}"));
          } else {
            onComplete.call(url);
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
