import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';
import 'package:colaborador/feature/documents/presentation/document_file/bloc/document_file_bloc.dart';
import 'package:colaborador/feature/documents/presentation/document_file/bloc/document_file_state.dart';
import 'package:colaborador/feature/documents/presentation/document_file/widget/document_file_failed_body.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class DocumentFilePageArgs {
  final String documentName;
  DocumentFilePageArgs(this.documentName);
}

class DocumentFilePage extends StatefulWidget {
  const DocumentFilePage({Key? key}) : super(key: key);

  @override
  State<DocumentFilePage> createState() => _DocumentFilePageState();
}

class _DocumentFilePageState extends State<DocumentFilePage> {
  DocumentFileBloc documentFileBloc = ApplicationContainer.instance().resolve();

  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      _setUpPage(context);
    }
    return Scaffold(
      body: BlocProvider(
        create: (context) => documentFileBloc,
        child: BlocBuilder(
            bloc: documentFileBloc,
            builder: (context, state) {
              if (state is DocumentFileLoadingState) {
                return Column(
                  children: [
                    Expanded(
                        child: LoadingWidget(
                            message: getString(
                                context, "document_file_page_loading"))),
                  ],
                );
              }
              if (state is DocumentFileFailedState) {
                return const DocumentFileFailedBody();
              }
              if (state is DocumentFileLoadedState) {
                if (state.documentFile.file != null) {
                  return PDFScreen(
                    pdfFile: state.documentFile.file,
                    canDownload: true,
                  );
                }
                return const DocumentFileFailedBody();
              }
              return Container();
            }),
      ),
    );
  }

  void _setUpPage(BuildContext context) {
    firstBuild = false;
    DocumentFilePageArgs args =
        ModalRoute.of(context)?.settings.arguments as DocumentFilePageArgs;
    documentFileBloc.getDocumentFile(documentName: args.documentName);
  }
}
