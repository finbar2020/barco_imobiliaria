// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:io';

import 'package:essentials/ui/widget/image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lello/feature/accountability/domain/use_case/send_new_question/send_new_question_impl.dart';
import 'package:lello/feature/accountability/presentation/question_create/bloc/question_create_bloc.dart';
import 'package:lello/feature/accountability/presentation/question_create/bloc/question_create_event.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../session/presentation/bloc/session_bloc.dart';
import '../../../domain/entity/accountability_doubt.dart';
import '../../../domain/use_case/get_question_types/get_question_type_usecase.dart';

class QuestionCreateController {
  final QuestionCreateBloc bloc;
  final SessionBloc sessionBloc;
  final GetAccountabilityQuestionUsecase _getAccountabilityQuestionUsecase;
  final SendAccountabilityQuestionUsecase _sendAccountabilityQuestionUsecase;
  QuestionCreateController({
    required GetAccountabilityQuestionUsecase getAccountabilityQuestionUsecase,
    required SendAccountabilityQuestionUsecase
        sendAccountabilityQuestionUsecase,
    required this.bloc,
    required this.sessionBloc,
  })  : _getAccountabilityQuestionUsecase = getAccountabilityQuestionUsecase,
        _sendAccountabilityQuestionUsecase = sendAccountabilityQuestionUsecase;

  AccountabilityDoubt? doubtSelected;

  Future<void> getQuestions() async {
    bloc.add(QuestionCreateLoadingEvent());
    final condominiumId = sessionBloc.state.session!.selectedCondominium!.id;

    final result = await _getAccountabilityQuestionUsecase(
      GetAccountabilityQuestionParam(condominiumId: condominiumId),
    );
    result.fold(
      (failure) => bloc.add(
        QuestionCreateFailedEvent(
          failure: failure,
        ),
      ),
      (data) => bloc.add(
        QuestionCreateLoadedEvent(data: data),
      ),
    );
  }

  Future<void> chooseImage(
    BuildContext context, {
    required ImageSource source,
  }) async {
    ImagePicker imagePicker = ImagePicker();

    List<File> files = [];
    if (source == ImageSource.camera) {
      var image = await imagePicker.pickImage(source: ImageSource.camera);
      if (image == null) return;
      files.add(File(image.path));
      var oldName = basename(files.first.path).split(".").first;
      var newName = "duvida_foto";
      files.first =
          files.first.renameSync(files.first.path.replaceAll(oldName, newName));
    } else {
      var images = await imagePicker.pickMultiImage();
      if (images.isEmpty || images.first.path.isEmpty) {
        return;
      }
      files = images.map((e) => File(e.path)).toList();
    }
    for (File file in files) {
      CroppedFile? croppedFile = await showReceiptCropper(file.path);
      if (croppedFile == null) continue;
      var oldName = basename(croppedFile.path).split(".").first;
      var newName = basename(file.path).split(".").first;

      doubtSelected?.attachmentsFiles.add(
        File(croppedFile.path).renameSync(
          croppedFile.path.replaceAll(oldName, newName),
        ),
      );
    }
  }

  Future<void> chooseFile() async {
    FilePickerResult? file = await getFile(
        type: FileType.custom, allowedExtensions: ["pdf"], allowMultiple: true);
    if (file != null) {
      for (int i = 0; i < file.files.length; i++) {
        var element = file.files[i];
        var f = File(element.path!);
        var clonedFile = await viewFile(f);
        doubtSelected?.attachmentsFiles.add(clonedFile);
      }
    }
  }

  Future<FilePickerResult?> getFile(
      {FileType? type,
      List<String>? allowedExtensions,
      bool? allowMultiple}) async {
    var perms = await CheckPermissions.storage();
    if (perms == false) {
      Fluttertoast.showToast(msg: "Permissão para ler arquivos negada.");
    }
    var file = await FilePicker.platform.pickFiles(
      type: type ?? FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple ?? false,
    );
    return file;
  }

  Future<File> viewFile(File originalFile) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/${basename(originalFile.path)}");
    await file.writeAsBytes(originalFile.readAsBytesSync());
    return file;
  }

  void removeFile({required int index}) =>
      doubtSelected?.attachmentsFiles.removeAt(index);

  Future<void> sendDoubt() async {
    final condominiumId = sessionBloc.state.session!.selectedCondominium!.id;
    bloc.add(QuestionCreateSendingEvent());

    final result = await _sendAccountabilityQuestionUsecase(
      SendAccountabilityQuestionParam(
        doubt: doubtSelected!,
        condominiumId: condominiumId,
      ),
    );

    result.fold(
      (failure) => bloc.add(
        QuestionCreateSendFailedEvent(failure: failure),
      ),
      (data) => bloc.add(QuestionCreateSendedEvent()),
    );
  }

  void dispose() {
    doubtSelected = null;
    bloc.add(QuestionCreateLoadingEvent());
  }
}
