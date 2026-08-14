import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:morar/feature/change_ownership/domain/entity/ownership_entity.dart';
import 'package:morar/feature/change_ownership/domain/use_case/can_change/can_change.dart';
import 'package:morar/feature/change_ownership/domain/use_case/post_change/post_change.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_bloc.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_event.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class OwnershipController {
  final ChangeOwnershipBloc bloc;
  final SessionBloc sessionBloc;
  final PostChangeUseCase postChangeUsecase;
  final CanChangeUseCase canChange;
  OwnershipController({
    required this.bloc,
    required this.sessionBloc,
    required this.postChangeUsecase,
    required this.canChange,
  });

  OwnershipEntity entity = OwnershipEntity();

  Future<void> postChange() async {
    bloc.add(ChangeOwnershipLoadingEvent());

    String condoId = sessionBloc.state.session?.condominium?.id ?? "";

    var result = await postChangeUsecase
        .call(PostChangeParams(condoId: condoId, entity: entity));

    var response = result.fold(
        (l) => bloc.add(ChangeOwnershipFailureEvent(error: "")),
        (r) => bloc.add(ChangeOwnershipSuccessEvent()));
    return response;
  }

  Future<bool> beginTakePhoto({required ImageSource source}) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
        source: source, maxHeight: 1000.00, maxWidth: 1000.00);
    if (image != null) {
      CroppedFile? croppedFile = await showImageCropper(image.path);

      if (croppedFile != null) {
        entity.attachment = File(croppedFile.path);
        entity.attachmentType = "image";
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> beginTakeFile() async {
    var file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf"],
        allowMultiple: false);

    if (file != null && file.count > 0) {
      if (CheckFile.isFileExceedMaxSizePermitted(
          file: File(file.files.first.path!))) {
        entity.attachment = null;
        entity.attachmentType = null;
        return false;
      }
      if (await CheckFile.isFileEncrypted(file: File(file.files.first.path!))) {
        entity.attachment = null;
        entity.attachmentType = null;
        return false;
      }
      entity.attachment = File(file.files.first.path!);
      entity.attachmentType = "application/pdf";
      return true;
    }
    return false;
  }

  Future<void> getCanChange() async {
    bloc.add(ChangeOwnershipLoadingEvent());

    String condoId = sessionBloc.state.session?.condominium?.id ?? "";

    var result = await canChange.call(CanChangeParams(condoId: condoId));

    var response = result.fold(
        (l) => bloc.add(ChangeOwnershipFailureEvent(error: "")),
        (r) => bloc.add(ChangeOwnershipLoadedEvent(
            canChange: r.canChange ?? false,
            cantChangeMessage: r.message ?? "")));
    return response;
  }
}
