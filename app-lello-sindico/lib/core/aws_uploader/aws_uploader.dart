import 'dart:async';
import 'dart:io';

abstract class AwsUploader {
  Future<String> uploadS3(String url, File file,
      {required Function(String) onComplete,
      required Function(Exception) onError});
  Future<String> uploadS3WithProgress(
      String url, File file, StreamController<double>? progress,
      {required Function(String) onComplete,
      required Function(Exception) onError});
}
