import 'dart:convert';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/vox/domain/entity/document_detail.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/presentation/detail/bloc/vox_detail_bloc.dart';
import 'package:lello/feature/vox/presentation/detail/bloc/vox_detail_event.dart';
import 'package:lello/feature/vox/presentation/detail/bloc/vox_detail_state.dart';
import 'package:lello/feature/vox/presentation/widget/vox_error_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

/// Detalhe unificado de um documento. O [VoxDetailBloc] é provido pelo chamador
/// e re-busca o conteúdo por id (Q7). Decodifica o Base64 do conteúdo (mesmo
/// comportamento dos detalhes antigos: Latin1 + base64).
class VoxDetailPage extends StatelessWidget {
  const VoxDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<VoxDetailBloc, VoxDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: PrimaryAppBar(
            title: _title(state.type),
            theme: theme,
            iconColor: theme.primaryColor,
          ),
          body: _body(context, state),
        );
      },
    );
  }

  Widget _body(BuildContext context, VoxDetailState state) {
    switch (state.status) {
      case VoxDetailStatus.loading:
        return const Center(child: LoadingWidget());
      case VoxDetailStatus.failure:
        return VoxErrorWidget(
          error: state.error,
          onRetry: () =>
              context.read<VoxDetailBloc>().add(VoxDetailStarted()),
          onBack: () => Navigator.of(context).pop(),
        );
      case VoxDetailStatus.loaded:
        return _content(context, state.detail);
    }
  }

  Widget _content(BuildContext context, DocumentDetail? detail) {
    final html = _decode(detail?.content);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: HtmlWidget(html),
      ),
    );
  }

  String _decode(String? base64Content) {
    if (base64Content == null || base64Content.isEmpty) return "";
    try {
      return const Latin1Codec().decode(base64.decode(base64Content));
    } catch (_) {
      return base64Content;
    }
  }

  String _title(DocumentType type) {
    switch (type) {
      case DocumentType.warning:
        return "Advertência";
      case DocumentType.fine:
        return "Multa";
      case DocumentType.announcement:
        return "Comunicado";
    }
  }
}
