import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class FilePreviewPage extends StatelessWidget {
  final String url;
  final String filename;
  final String extension;

  const FilePreviewPage({
    super.key,
    required this.url,
    required this.filename,
    required this.extension,
  });

  bool get _isImage {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension.toLowerCase());
  }

  bool get _isPdf {
    return extension.toLowerCase() == 'pdf';
  }

  bool get _isDocument {
    final docExtensions = ['doc', 'docx', 'xls', 'xlsx'];
    return docExtensions.contains(extension.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    
    // Decodifica o nome do arquivo (remove %20, %2F, etc)
    String decodedFilename = Uri.decodeComponent(filename);
    
    // Se contém /, pega apenas o último segmento (nome do arquivo)
    if (decodedFilename.contains('/')) {
      decodedFilename = decodedFilename.split('/').last;
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.primary(),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          decodedFilename,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _buildBody(context, palette),
    );
  }

  Widget _buildBody(BuildContext context, ColorPallete palette) {
    if (_isImage) {
      return PhotoView(
        imageProvider: NetworkImage(url),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        loadingBuilder: (context, event) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'Erro ao carregar imagem',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      );
    }

    // Visualizador de PDF
    if (_isPdf) {
      return PdfViewer.uri(
        Uri.parse(url),
        params: PdfViewerParams(
          backgroundColor: Colors.black,
          loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          },
          errorBannerBuilder: (context, error, stackTrace, documentRef) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Erro ao carregar PDF',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    // Para documentos (DOC, DOCX, XLS, XLSX), usar Google Drive Viewer
    if (_isDocument) {
      final encodedUrl = Uri.encodeComponent(url);
      final viewerUrl = 'https://docs.google.com/viewer?url=$encodedUrl&embedded=true';
      
      return WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..loadRequest(Uri.parse(viewerUrl))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                // Página começou a carregar
              },
              onPageFinished: (String url) {
                // Página terminou de carregar
              },
              onWebResourceError: (WebResourceError error) {
                debugPrint('Erro ao carregar documento: ${error.description}');
              },
            ),
          ),
      );
    }

    // Para outros arquivos, exibir mensagem
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getFileIcon(),
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            filename,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tipo: ${extension.toUpperCase()}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon() {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }
}
