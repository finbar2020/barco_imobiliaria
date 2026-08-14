// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:essentials/methods/files/file_check_result.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/attach_files/bloc/attach_files_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:essentials/essentials.dart';

class AttachFilesStore {
  final AttachFilesBloc bloc;

  AttachFilesStore({
    required this.bloc,
  });

  Future<void> chooseImage({
    required BuildContext context,
    required ImageSource imageSource,
    required int? maxHeight,
    required int? maxWidth,
    required int? maxFileSizePermitted,
    required List<CropAspectRatioPreset> aspectRatioPresets,
    required CropStyle cropStyle,
  }) async {
    // Verifica permissão de câmera antes de tentar usar (se for câmera)
    if (imageSource == ImageSource.camera) {
      bool hasPermission = await _checkCameraPermission();
      if (!hasPermission) {
        // Se não tem permissão, não tenta usar o ImagePicker
        return;
      }
    }

    List<File> files = [];
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(source: imageSource);
    if (image != null) {
      CroppedFile? croppedFile = await showGeneralImageCropper(
        image.path,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        aspectRatioPresets: aspectRatioPresets,
        cropStyle: cropStyle,
        context: context,
      );

      if (croppedFile != null) {
        Directory directory = await getApplicationDocumentsDirectory();
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        String newFileName = 'image_$timestamp${path.extension(image.path)}';
        String newPath = path.join(directory.path, newFileName);
        File newFile = await File(croppedFile.path).copy(newPath);
        files.add(newFile);
      }
    }

    List<FileCheckResult> checkResults =
        await _checkFiles(files, maxFileSizePermitted: maxFileSizePermitted);

    bool hasError = false;
    for (var result in checkResults) {
      if (result.error != FileError.none) {
        hasError = true;
        String fileName = path.basenameWithoutExtension(result.file.path);
        String fileExtension = path.extension(result.file.path);
        switch (result.error) {
          case FileError.size:
            bloc.add(AttachFilesEmptyEvent(
              errorType: FileError.size,
              fileName: fileName,
              fileExtension: fileExtension,
            ));
            break;
          case FileError.protected:
            bloc.add(AttachFilesEmptyEvent(
              errorType: FileError.protected,
              fileName: fileName,
              fileExtension: fileExtension,
            ));
            break;
          case FileError.unsupportedFormat:
            bloc.add(AttachFilesEmptyEvent(
              errorType: FileError.unsupportedFormat,
              fileName: fileName,
              fileExtension: fileExtension,
            ));
            break;
          case FileError.none:
            break;
        }
      }
    }

    if (!hasError) {
      bloc.add(AttachFilesSuccessEvent(files: files));
    }
  }

  Future<void> chooseFile({
    int? maxFileSizePermitted,
    bool allowMultiple = false,
  }) async {
    List<File> files = [];

    var filesPicked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      allowMultiple: allowMultiple,
    );

    List<File?> listOfFiles = filesPicked?.files
            .map((e) => e.path != null ? File(e.path!) : null)
            .toList() ??
        [];

    files = listOfFiles.whereType<File>().toList();

    List<FileCheckResult> checkResults =
        await _checkFiles(files, maxFileSizePermitted: maxFileSizePermitted);

    bool hasError = false;
    for (var result in checkResults) {
      if (result.error != FileError.none) {
        hasError = true;
        String fileName = path.basenameWithoutExtension(result.file.path);
        String fileExtension = path.extension(result.file.path);
        switch (result.error) {
          case FileError.size:
            bloc.add(AttachFilesEmptyEvent(
              errorType: FileError.size,
              fileName: fileName,
              fileExtension: fileExtension,
            ));
            break;
          case FileError.protected:
            bloc.add(AttachFilesEmptyEvent(
              errorType: FileError.protected,
              fileName: fileName,
              fileExtension: fileExtension,
            ));
            break;
          case FileError.unsupportedFormat:
            bloc.add(AttachFilesEmptyEvent(
              errorType: FileError.unsupportedFormat,
              fileName: fileName,
              fileExtension: fileExtension,
            ));
            break;
          case FileError.none:
            break;
        }
      }
    }

    if (!hasError) {
      bloc.add(AttachFilesSuccessEvent(files: files));
    }
  }

  Future<bool> _checkCameraPermission() async {
    if (kIsWeb) {
      return true;
    } else {
      var status = await Permission.camera.status;
      if (status.isGranted) {
        return true;
      }
      await Permission.camera.request();
      status = await Permission.camera.status;
      if (!status.isGranted) {
        return false;
      } else {
        return true;
      }
    }
  }
}

Future<List<FileCheckResult>> _checkFiles(
  List<File> files, {
  int? maxFileSizePermitted,
}) async {
  List<FileCheckResult> results = [];
  await Future.forEach(files, (element) async {
    FileError error = await CheckFile.checkAll(
        file: element, optionalFileSizeValuePermitted: maxFileSizePermitted);
    results.add(FileCheckResult(file: element, error: error));
  });
  return results;
}
