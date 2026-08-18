import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/vox/domain/entity/attachment_kind.dart';
import 'package:lello/feature/vox/presentation/request/bloc/vox_request_bloc.dart';
import 'package:lello/feature/vox/presentation/request/bloc/vox_request_event.dart';
import 'package:lello/feature/vox/presentation/request/bloc/vox_request_state.dart';

/// Componente de anexos da solicitação: seleção por galeria, câmera ou arquivo
/// (PDF). Espelha o padrão de upload usado em outros pontos do app (ex.:
/// accountability). Os arquivos escolhidos viram eventos do [VoxRequestBloc]
/// (que já converte para Base64 no submit). Só faz sentido no modo solicitação.
class VoxAttachmentsWidget extends StatelessWidget {
  const VoxAttachmentsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<VoxRequestBloc>();
    return BlocBuilder<VoxRequestBloc, VoxRequestState>(
      buildWhen: (p, c) => p.images != c.images || p.files != c.files,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Anexos", style: LelloTextStyles.bodyBold(theme)),
            _attachmentList(theme, state, bloc),
            SizedBox(height: Dimens.spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _action(theme, "assets/ic_photo_bold.svg", "Galeria",
                    () => _pickGallery(bloc)),
                _action(theme, "assets/ic_camera_bold.svg", "Câmera",
                    () => _pickCamera(bloc)),
                _action(theme, "assets/ic_attachment_bold.svg", "Arquivo",
                    () => _pickFiles(bloc)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _attachmentList(
      ThemeData theme, VoxRequestState state, VoxRequestBloc bloc) {
    final tiles = <Widget>[];
    for (var i = 0; i < state.images.length; i++) {
      final index = i;
      tiles.add(_attachmentTile(theme, basename(state.images[index].path),
          () => bloc.add(VoxAttachmentRemoved(AttachmentKind.image, index))));
    }
    for (var i = 0; i < state.files.length; i++) {
      final index = i;
      tiles.add(_attachmentTile(theme, basename(state.files[index].path),
          () => bloc.add(VoxAttachmentRemoved(AttachmentKind.file, index))));
    }
    if (tiles.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: Dimens.spacingSmall),
      child: Column(children: tiles),
    );
  }

  Widget _attachmentTile(ThemeData theme, String name, VoidCallback onRemove) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingXSmall),
      child: Row(
        children: [
          SvgPicture.asset("assets/ic_clips.svg"),
          SizedBox(width: Dimens.spacingXSmall),
          Expanded(
            child: Text(name,
                style: LelloTextStyles.body(theme),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          IconButton(
            icon: Icon(Icons.close, color: LelloTheme.palleteOf(theme).grey()),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }

  Widget _action(
      ThemeData theme, String asset, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(asset, height: 32),
          SizedBox(height: Dimens.spacingSmall),
          Text(label, style: LelloTextStyles.bodyBold(theme)),
        ],
      ),
    );
  }

  Future<void> _pickGallery(VoxRequestBloc bloc) async {
    final images = await ImagePicker().pickMultiImage();
    for (final image in images) {
      if (image.path.isNotEmpty) bloc.add(VoxImageAttached(File(image.path)));
    }
  }

  Future<void> _pickCamera(VoxRequestBloc bloc) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) bloc.add(VoxImageAttached(File(image.path)));
  }

  Future<void> _pickFiles(VoxRequestBloc bloc) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      allowMultiple: true,
    );
    if (result == null) return;
    final files = result.files
        .where((f) => f.path != null)
        .map((f) => File(f.path!))
        .toList();
    if (files.isNotEmpty) bloc.add(VoxFilesAttached(files));
  }
}
