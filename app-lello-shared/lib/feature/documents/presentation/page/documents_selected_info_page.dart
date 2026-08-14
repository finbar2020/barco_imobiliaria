import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/documents/domain/entity/documents.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_state.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_controller.dart';
import 'package:shared_features/shared_features.dart';

/// Detalhe de um documento: ações de compartilhar e abrir o PDF (com texto
/// extraído via acessibilidade quando o leitor de tela está ativo).
class DocumentsSelectedInfoPage extends StatelessWidget {
  final DocumentsController controller;
  final Documents document;

  /// Chave de localização do tipo (também usada nos eventos de analytics).
  final String appBarTitle;

  const DocumentsSelectedInfoPage({
    Key? key,
    required this.controller,
    required this.document,
    required this.appBarTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: BlocBuilder(
        bloc: controller.bloc,
        buildWhen: (previous, current) =>
            isFileAffectingState(current as DocumentsState),
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: appBarTitle),
            body: _buildScaffoldBody(
                document, theme, context, controller.bloc.state, appBarTitle),
          );
        },
      ),
    );
  }

  Widget _buildScaffoldBody(Documents document, ThemeData theme,
      BuildContext context, DocumentsState state, String documentType) {
    if (state is DocumentsFileLoadingState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    if (state is DocumentsFileFailureState) {
      return _buildError(document: document, documentType: documentType);
    }
    if (state is DocumentsFileLoadedState) {
      final localFile = state.file.localFile;
      if (localFile == null) {
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 86.0,
                width: 70.0,
                child: SvgPicture.asset(
                  "assets/ic_documents_detail.svg",
                  package: 'shared_features',
                ),
              ),
            ),
            SizedBox(height: Dimens.homeMenuIconSize),
            Text(
              document.name!,
              textAlign: TextAlign.center,
              style: LelloTextStyles.body(theme),
            ),
            SizedBox(height: Dimens.homeAppBarHeight),
            _buildButton(
              context,
              theme,
              "registration_use_terms_share",
              () {
                final box = context.findRenderObject() as RenderBox;
                final rect = box.localToGlobal(Offset.zero) & box.size;
                _shareDocument(
                  localFile,
                  state.file.name ?? document.name ?? 'documento.pdf',
                  documentType,
                  sharePositionOrigin: rect,
                );
              },
            ),
            SizedBox(height: Dimens.spacingMedium),
            _buildButton(
              context,
              theme,
              "payment_list_show_document",
              () async {
                String? extractedText;
                if (MediaQuery.of(context).accessibleNavigation) {
                  extractedText =
                      await state.file.loadExtractedText?.call();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFScreen(
                        pdfFile: localFile,
                        extractedText: extractedText,
                        title: 'PDF Documento',
                        canDownload: true),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildButton(BuildContext context, ThemeData theme, String title,
      VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.only(right: 5.0),
      height: 54.0,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: LelloTheme.palleteOf(theme).customColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: LelloTheme.palleteOf(theme).textLightest(),
            ),
          ),
        ),
        child: Text(
          getString(context, title),
          style: LelloTextStyles.button(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).text(),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _shareDocument(File pdfFile, String fileName, String documentType,
      {Rect? sharePositionOrigin}) async {
    if (await CheckPermissions.storage()) {
      controller.analytics.logShare(documentType);
      try {
        final xFile = XFile(pdfFile.path, name: fileName);
        Share.shareXFiles([xFile], sharePositionOrigin: sharePositionOrigin);
      } catch (e) {
        throw Exception("Error sharing file");
      }
    }
  }

  Column _buildError(
      {required Documents document, required String documentType}) {
    return Column(
      children: [
        Expanded(
          child: Builder(
            builder: (context) => Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: ErrorHandlingWidget(
                reTryFunction: () {
                  controller.getFile(document, documentType);
                },
                backFunction: () => Navigator.pop(context, true),
                isProduction: kReleaseMode,
                error: "",
                errorCode: "",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
