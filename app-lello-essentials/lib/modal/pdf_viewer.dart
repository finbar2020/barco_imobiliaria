import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

class PDFScreen extends StatefulWidget {
  final String title;
  final String? extractedText;
  final File? pdfFile;
  final String? url;
  final String? fileName;
  final bool canDownload;
  final Map<String, String>? headers;
  final bool useTerms;

  PDFScreen({
    this.pdfFile,
    this.title = '',
    this.url,
    this.fileName,
    this.canDownload = false,
    this.headers,
    this.useTerms = false,
    this.extractedText = '',
  });

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  File? fileAfterSnapshotData;
  bool _isLoading = false;
  bool isAccessibilityEnabled = false;
  bool isForcePdf = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isAccessibilityEnabled = MediaQuery.of(context).accessibleNavigation;
  }

  Future<bool> _checkAndRequestPermissions(BuildContext context) async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        Flushbar(
          message: getString(context, "permission_required_download"),
          duration: Duration(seconds: 3),
        ).show(context);
        return false;
      }
    }

    final mediaStatus = await Permission.mediaLibrary.request();
    if (!mediaStatus.isGranted) {
      Flushbar(
        message: getString(context, "permission_required_download"),
        duration: Duration(seconds: 3),
      ).show(context);
      return false;
    }
    return true;
  }

  Future<void> _handleDownload(File file, BuildContext context) async {
    //if (!await _checkAndRequestPermissions(context)) return;

    setState(() => _isLoading = true);
    try {
      final saved = await _saveFile(file, context);
      if (saved) {
        Flushbar(
          message: getString(context, "download_success"),
          duration: Duration(seconds: 2),
        ).show(context);
      }
    } catch (e) {
      debugPrint('[PDFScreen] Download error: $e');
      Flushbar(
        message: getString(context, "download_error"),
        duration: Duration(seconds: 3),
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleShare(
      File file, BuildContext context, Rect? sharePositionOrigin) async {
    setState(() => _isLoading = true);
    try {
      File? customFile;
      if (widget.fileName != null) {
        var newDirectory =
            "${(await getApplicationDocumentsDirectory()).path}/${widget.fileName}";
        if (newDirectory != file.path) {
          customFile = file.copySync(newDirectory);
        }
      }
      var filePath = customFile?.path ?? file.path;

      final xFile = XFile(filePath);
      await Share.shareXFiles([xFile],
          sharePositionOrigin: sharePositionOrigin);
    } catch (e) {
      debugPrint('[PDFScreen] Share error: $e');
      Flushbar(
        message: getString(context, "share_error"),
        duration: Duration(seconds: 3),
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildActionButtons(File? file, ThemeData theme) {
    if (file == null) return Container();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.canDownload)
          Semantics(
            button: true,
            enabled: !_isLoading,
            label: getString(context, 'download_pdf_button'),
            hint: getString(context, 'double_tap_to_download_pdf'),
            child: ExcludeSemantics(
              child: IconButton(
                icon: _isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: LelloTheme.palleteOf(theme).customColor(),
                          semanticsLabel: getString(context, 'loading'),
                        ),
                      )
                    : Icon(Icons.download,
                        color: LelloTheme.palleteOf(theme).customColor()),
                onPressed:
                    _isLoading ? null : () => _handleDownload(file, context),
              ),
            ),
          ),
        Semantics(
          button: true,
          enabled: !_isLoading,
          label: getString(context, 'share_pdf_button'),
          hint: getString(context, 'double_tap_to_share_pdf'),
          child: ExcludeSemantics(
            child: Builder(
              builder: (shareContext) => IconButton(
                icon: Icon(Icons.share,
                    color: LelloTheme.palleteOf(theme).customColor()),
                onPressed: _isLoading
                    ? null
                    : () {
                        final box = shareContext.findRenderObject() as RenderBox;
                        final rect =
                            box.localToGlobal(Offset.zero) & box.size;
                        _handleShare(file, context, rect);
                      },
              ),
            ),
          ),
        ),
        if (isAccessibilityEnabled)
          Semantics(
            button: true,
            enabled: !_isLoading,
            label: isForcePdf
                ? "Clique para voltar ao modo de leitura"
                : "Clique para voltar ao modo PDF",
            child: ExcludeSemantics(
              child: IconButton(
                icon: Icon(
                    isForcePdf ? Icons.picture_as_pdf : Icons.text_fields,
                    color: LelloTheme.palleteOf(theme).customColor()),
                onPressed: _isLoading
                    ? null
                    : () => {
                          setState(() {
                            isForcePdf = !isForcePdf;
                          })
                        },
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTextAvailable =
        widget.extractedText != null && widget.extractedText!.trim().isNotEmpty;

    return Semantics(
      label: getString(context, 'pdf_viewer_screen'),
      explicitChildNodes: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: LelloTheme.palleteOf(theme).primary(),
          leading: Semantics(
            button: true,
            label: getString(context, 'back_button'),
            hint: getString(context, 'double_tap_to_go_back'),
            child: ExcludeSemantics(
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: getString(context, 'back_button_tooltip'),
              ),
            ),
          ),
          iconTheme: IconThemeData(
            color: LelloTheme.palleteOf(theme).customColor(),
          ),
          title: Semantics(
            header: true,
            label: "${getString(context, 'pdf_document')}: ${widget.title}",
            child: ExcludeSemantics(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: LelloTheme.palleteOf(theme).customColor(),
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
          actions: [
            _buildActionButtons(widget.pdfFile ?? fileAfterSnapshotData, theme),
          ],
        ),
        body: Builder(
          builder: (context) {
            if (isAccessibilityEnabled && isTextAvailable && !isForcePdf) {
              final paragraphs = splitIntoParagraphs(widget.extractedText!);

              return Semantics(
                container: true,
                label: getString(context, 'pdf_content'),
                hint: getString(context, 'swipe_to_navigate_paragraphs'),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: paragraphs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final paragraph = paragraphs[index].trim();
                    return Semantics(
                      label: index == 0
                          ? "${getString(context, 'paragraph')} ${index + 1} ${getString(context, 'of')} ${paragraphs.length}"
                          : "${getString(context, 'paragraph')} ${index + 1}",
                      child: Text(
                        paragraph,
                        style: LelloTextStyles.body(theme),
                        textAlign: TextAlign.start,
                        semanticsLabel: paragraph,
                      ),
                    );
                  },
                ),
              );
            }

            if (widget.pdfFile != null) {
              return Semantics(
                label: getString(context, 'pdf_document'),
                readOnly: true,
                child: _pdfFile(widget.pdfFile!.path, theme),
              );
            } else if (fileAfterSnapshotData != null) {
              return Semantics(
                label: getString(context, 'pdf_document'),
                readOnly: true,
                child: _pdfFile(fileAfterSnapshotData!.path, theme),
              );
            }

            return FutureBuilder<File>(
              future: DefaultCacheManager()
                  .getSingleFile(widget.url!, headers: widget.headers),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Semantics(
                      label: getString(context, 'loading_pdf'),
                      value: getString(context, 'please_wait'),
                      child: ExcludeSemantics(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Semantics(
                      label: getString(context, 'error_loading_pdf'),
                      value: snapshot.error.toString(),
                      child: Text(
                        getString(context, 'pdf_load_error'),
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() => fileAfterSnapshotData = snapshot.data!);
                  });
                  return Semantics(
                    label: getString(context, 'pdf_document'),
                    readOnly: true,
                    child: _pdfFile(snapshot.data!.path, theme),
                  );
                } else {
                  return Center(
                    child: Semantics(
                      label: getString(context, 'pdf_not_available'),
                      child: Text(
                        getString(context, 'pdf_not_available'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  /// Devolve `true` quando o arquivo foi salvo (e aberto). Sem diretório de
  /// destino avisa "canot_download_file" e devolve `false`; falha na cópia é
  /// propagada para quem chamou tratar.
  Future<bool> _saveFile(File file, BuildContext context) async {
    Directory? appDocDir;
    try {
      appDocDir = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getExternalStorageDirectory();
    } catch (e) {
      debugPrint('[PDFScreen] Storage directory error: $e');
      appDocDir = null;
    }
    if (appDocDir == null) {
      Flushbar(
        duration: Duration(seconds: 5),
        message: getString(context, "canot_download_file"),
      ).show(context);
      return false;
    }
    String appDocPath = appDocDir.path;
    var path = '$appDocPath/${widget.fileName ?? Path.basename(file.path)}';
    if (path != file.path) {
      await file.copy(path);
    }
    OpenFile.open(path);
    return true;
  }

  Widget _pdfFile(String path, ThemeData theme) {
    return Semantics(
      label: getString(context, 'pdf_document_view'),
      readOnly: true,
      child: PdfViewer.file(
        path,
        params: PdfViewerParams(
          textSelectionParams: const PdfTextSelectionParams(enabled: true),
          errorBannerBuilder: (context, error, stackTrace, documentRef) {
            return Center(
              child: Semantics(
                label: getString(context, 'pdf_error'),
                value: error.toString(),
                child: Text(
                  getString(context, 'unable_to_load'),
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
