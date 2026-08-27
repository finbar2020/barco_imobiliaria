import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../configs/custom_firebase_remote_config.dart';

enum FileError {
  none,
  size,
  protected,
  unsupportedFormat,
}

class CheckFile {
  static Future<FileError> checkAll({
    required File file,
    int? optionalFileSizeValuePermitted,
  }) async {
    if (isFileExceedMaxSizePermitted(
        file: file,
        optionalFileSizeValuePermitted: optionalFileSizeValuePermitted)) {
      return FileError.size;
    }
    if (await isFileEncrypted(
      file: file,
    )) {
      return FileError.protected;
    }
    if (await isFileDifferentFromSupportedFormats(
      file: file,
    )) {
      return FileError.unsupportedFormat;
    }
    return FileError.none;
  }

  static bool isFileExceedMaxSizePermitted(
      {required File file, int? optionalFileSizeValuePermitted}) {
    if (optionalFileSizeValuePermitted != null) {
      if (file.lengthSync() > optionalFileSizeValuePermitted) {
        return true;
      } else {
        return false;
      }
    } else {
      int fileSizeValuePermitted = _getFileMaxSizePermitted();
      if (file.lengthSync() > fileSizeValuePermitted) {
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<bool> isFileEncrypted({required File file}) async {
    try {
      if (file.path.contains(".pdf")) {
        await PdfDocument.openFile(file.path);
      }
      return false;
    } catch (e) {
      // Só senha conta como "protegido": PdfPasswordException do pdfrx (ou o
      // ArgumentError das versões antigas). Outros erros (arquivo corrompido,
      // sem lib nativa) não são proteção por senha.
      return e is PdfPasswordException || e is ArgumentError;
    }
  }

  static Future<bool> isFileDifferentFromSupportedFormats(
      {required File file}) async {
    try {
      final fileExtension = file.path.split('.').last.toLowerCase();
      if (fileExtension != 'pdf' &&
          fileExtension != 'jpeg' &&
          fileExtension != 'jpg' &&
          fileExtension != 'png') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return true;
    }
  }

  static int _getFileMaxSizePermitted() {
    int defaultValue = 10485760;
    try {
      final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 30),
          minimumFetchInterval: Duration(days: 1)));
      remoteConfig.fetch();
      var fileMaxSizePermitted = jsonDecode(remoteConfig
          .getString(CustomFirebaseRemoteConfig.fileMaxSizePermitted));
      return fileMaxSizePermitted != null ? fileMaxSizePermitted : defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }
}
