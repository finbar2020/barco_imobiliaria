import 'dart:io';
import 'package:essentials/essentials.dart' hide Image, Path;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:lello/core/services/tt_storage_service.dart';
import '../../../../../../domain/entity/event_details_entity.dart';
import '../../../file_preview_page.dart';
import 'base_question_widget.dart';

/// Widget para upload de arquivos (FILE)
class FileQuestionWidget extends BaseQuestionWidget {
  final List<String>? currentAnswer;
  final Function(List<String>) onAnswerChanged;

  const FileQuestionWidget({
    super.key,
    required super.question,
    this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget buildField(
      BuildContext context, ThemeData theme, ColorPallete palette) {
    return _FileQuestionContent(
      question: question,
      currentAnswer: currentAnswer,
      onAnswerChanged: onAnswerChanged,
    );
  }
}

/// Widget stateful interno para gerenciar o estado do upload
class _FileQuestionContent extends StatefulWidget {
  final QuestionEntity question;
  final List<String>? currentAnswer;
  final Function(List<String>) onAnswerChanged;

  const _FileQuestionContent({
    required this.question,
    this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  State<_FileQuestionContent> createState() => _FileQuestionContentState();
}

class _FileQuestionContentState extends State<_FileQuestionContent> {
  final _storageService = TTStorageService();
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadingFileName = '';

  // Mapa para manter referência local dos arquivos (para preview de PDF)
  // Key: URL do Firebase, Value: Path local do arquivo
  final Map<String, String> _localFilePaths = {};

  @override
  void dispose() {
    // Limpa o mapa de paths locais
    _localFilePaths.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    return _buildContent(context, theme, palette);
  }

  Widget _buildContent(
      BuildContext context, ThemeData theme, ColorPallete palette) {
    final photos = widget.currentAnswer ?? [];

    // Mostra indicador de upload
    if (_isUploading) {
      return _buildUploadingIndicator(palette);
    }

    if (photos.isEmpty) {
      return GestureDetector(
        onTap: () => _showImageSourceOptions(context, palette),
        child: CustomPaint(
          painter: DashedBorderPainter(
            color: palette.grey().withValues(alpha: 0.5),
            strokeWidth: 1.3,
            dashWidth: 5,
            dashSpace: 3,
            borderRadius: 6,
          ),
          child: Container(
            height: 157,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: palette.background(), // Design System
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 64,
                  color: palette.grey(), // Design System
                ),
                const SizedBox(height: 16),
                Text(
                  'Clique para adicionar anexos',
                  style: TextStyle(
                    fontFamily: 'Anek Latin',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: palette.grey(), // Design System
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 146.73 / 156.95,
      ),
      itemCount: photos.length + 1, // +1 para o botão adicionar
      itemBuilder: (context, index) {
        // Botão adicionar sempre na primeira posição
        if (index == 0) {
          return _buildAddPhotoButton(context, palette);
        }
        // Fotos começam do índice 1
        return _buildPhotoThumbnail(photos[index - 1], palette);
      },
    );
  }

  Widget _buildPhotoThumbnail(String photoPathOrUrl, ColorPallete palette) {
    final isUrl = photoPathOrUrl.startsWith('http://') ||
        photoPathOrUrl.startsWith('https://');

    // Se for URL e tiver path local salvo, usa o path local para preview
    final String displayPath =
        isUrl && _localFilePaths.containsKey(photoPathOrUrl)
            ? _localFilePaths[photoPathOrUrl]!
            : photoPathOrUrl;

    // Recalcula isUrl baseado no displayPath (não no photoPathOrUrl)
    final bool isDisplayPathUrl =
        displayPath.startsWith('http://') || displayPath.startsWith('https://');

    final extension = path.extension(displayPath).toLowerCase();
    final isPdf = extension == '.pdf';

    return Stack(
      clipBehavior: Clip
          .none, // Permite que o botão remover fique visível fora dos limites
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (isUrl) {
              // Para URLs remotas (após upload), usa FilePreviewPage
              // Remove query parameters da URL para extrair nome e extensão
              final uri = Uri.parse(photoPathOrUrl);
              final pathWithoutQuery = uri.path;

              // Extrai o nome do arquivo do path (após o último /)
              final fileName = pathWithoutQuery.split('/').last;

              // Extrai a extensão (após o último .)
              final extension =
                  fileName.contains('.') ? fileName.split('.').last : '';

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilePreviewPage(
                    url: photoPathOrUrl,
                    filename: fileName,
                    extension: extension,
                  ),
                ),
              );
            } else if (_localFilePaths.containsKey(photoPathOrUrl)) {
              // Se tiver path local salvo, usa ele
              FileMethods.viewFile(
                  context, File(_localFilePaths[photoPathOrUrl]!));
            } else {
              // Path local direto
              FileMethods.viewFile(context, File(photoPathOrUrl));
            }
          },
          child: Container(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _buildFileThumbnail(
                  context, displayPath, isDisplayPathUrl, isPdf),
            ),
          ),
        ),
        // Badge indicador de PDF
        if (isPdf)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              height: 15,
              width: 40,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'PDF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Positioned(
          top: -7, // ✅ Posição conforme Figma
          right: -7,
          child: GestureDetector(
            onTap: () {
              // Remove do mapa de paths locais
              _localFilePaths.remove(photoPathOrUrl);

              final updatedPhotos =
                  List<String>.from(widget.currentAnswer ?? [])
                    ..remove(photoPathOrUrl);
              widget.onAnswerChanged(updatedPhotos);
            },
            child: Container(
              width: 27, // ✅ 27px conforme Figma
              height: 27,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: palette.error(), // Design System
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 11, // ✅ 11px conforme Figma
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileThumbnail(
      BuildContext context, String pathOrUrl, bool isUrl, bool isPdf) {
    final extension = path.extension(pathOrUrl).toLowerCase();
    final fileName = path.basename(pathOrUrl);

    // Verifica se é imagem
    final isImage =
        ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'].contains(extension);

    if (isUrl) {
      // Para URLs do Firebase Storage
      if (isImage) {
        // Tenta carregar como imagem
        return CachedNetworkImage(
          imageUrl: pathOrUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              color: LelloTheme.palleteOf(Theme.of(context)).primary(),
            ),
          ),
          errorWidget: (context, url, error) => _buildDocumentPlaceholder(
            fileName: fileName,
            extension: extension,
            palette: LelloTheme.palleteOf(Theme.of(context)),
          ),
        );
      } else {
        // Para documentos e PDFs, mostra placeholder com nome
        return _buildDocumentPlaceholder(
          fileName: fileName,
          extension: extension,
          palette: LelloTheme.palleteOf(Theme.of(context)),
        );
      }
    }

    // Para arquivos locais
    final file = File(pathOrUrl);

    if (isPdf) {
      // Usa FileMethods do essentials que já tem preview de PDF
      return FileMethods.imageBody(
        context,
        file,
        imageIconSize: double.infinity,
      );
    }

    if (isImage) {
      // Para imagens locais, usa Image.file
      return Image.file(
        file,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, _) => _buildDocumentPlaceholder(
          fileName: fileName,
          extension: extension,
          palette: LelloTheme.palleteOf(Theme.of(context)),
        ),
      );
    }

    // Para outros tipos de arquivo (DOCX, XLS, etc), mostra placeholder
    return _buildDocumentPlaceholder(
      fileName: fileName,
      extension: extension,
      palette: LelloTheme.palleteOf(Theme.of(context)),
    );
  }

  /// Widget placeholder para documentos (DOCX, PDF, XLS, etc)
  Widget _buildDocumentPlaceholder({
    required String fileName,
    required String extension,
    required ColorPallete palette,
  }) {
    // Ícone baseado no tipo de arquivo
    IconData icon;
    Color iconColor;

    switch (extension) {
      case '.pdf':
        icon = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case '.doc':
      case '.docx':
        icon = Icons.description;
        iconColor = Colors.blue;
        break;
      case '.xls':
      case '.xlsx':
        icon = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case '.ppt':
      case '.pptx':
        icon = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      case '.txt':
        icon = Icons.text_snippet;
        iconColor = Colors.grey;
        break;
      default:
        icon = Icons.insert_drive_file;
        iconColor = palette.grey();
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[100],
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: iconColor,
          ),
          const SizedBox(height: 12),
          Text(
            fileName,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: palette.text(),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            extension.toUpperCase().replaceAll('.', ''),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoButton(BuildContext context, ColorPallete palette) {
    return GestureDetector(
      onTap: () => _showImageSourceOptions(context, palette),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: palette.grey().withValues(alpha: 0.42),
          strokeWidth: 1.3,
          dashWidth: 5,
          dashSpace: 3,
          borderRadius: 6,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.cloud_upload_outlined,
                size: 50,
                color: palette.grey(),
              ),
            ),
            Text(
              'Clique para adicionar anexos',
              style: TextStyle(
                fontFamily: 'Anek Latin',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: palette.grey(), // Design System
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceOptions(BuildContext context, ColorPallete palette) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Opção Câmera
            _buildImageSourceOption(
              context: context,
              palette: palette,
              icon: Icons.camera_alt_outlined,
              label: 'Câmera',
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.camera);
              },
            ),
            const SizedBox(width: 61),
            // Opção Galeria
            _buildImageSourceOption(
              context: context,
              palette: palette,
              icon: Icons.photo_outlined,
              label: 'Foto',
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.gallery);
              },
            ),
            const SizedBox(width: 61),
            // Opção Arquivo
            _buildImageSourceOption(
              context: context,
              palette: palette,
              icon: Icons.attach_file,
              label: 'Arquivo',
              onTap: () {
                Navigator.pop(context);
                _pickFile(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required BuildContext context,
    required ColorPallete palette,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícone
          Container(
            width: 49,
            height: 38,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 50,
            ),
          ),
          const SizedBox(height: 20),
          // Label
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: source);
      if (image != null) {
        await _uploadFile(File(image.path));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar imagem: $e')),
        );
      }
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (file.path != null) {
          await _uploadFile(File(file.path!));
        } else if (file.bytes != null) {
          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/${file.name}');
          await tempFile.writeAsBytes(file.bytes!);
          await _uploadFile(tempFile);
        } else {
          throw Exception('Não foi possível acessar o arquivo');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar arquivo: $e')),
        );
      }
    }
  }

  /// Faz upload do arquivo para Firebase Storage
  Future<void> _uploadFile(File file) async {
    if (!mounted) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _uploadingFileName = path.basename(file.path);
    });

    try {
      // Gera um ID único para o arquivo baseado no timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${timestamp}_${path.basename(file.path)}';

      // Faz upload para Firebase Storage
      final downloadUrl = await _storageService.uploadFile(
        file: file,
        folderPath: 'maintenance/forms/${widget.question.id}',
        fileName: fileName,
      );

      if (!mounted) return;

      // Salva path local para preview
      _localFilePaths[downloadUrl] = file.path;

      // Adiciona URL à lista de arquivos
      final updatedFiles = List<String>.from(widget.currentAnswer ?? [])
        ..add(downloadUrl);
      widget.onAnswerChanged(updatedFiles);
    } catch (e) {
      print("ADD FILE: Erro ao adicionar arquivo");
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
          _uploadingFileName = '';
        });
      }
    }
  }

  /// Widget de indicador de upload
  Widget _buildUploadingIndicator(ColorPallete palette) {
    return Container(
      height: 157,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.background(),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: palette.grey().withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: palette.primary(),
          ),
          const SizedBox(height: 16),
          Text(
            'Enviando arquivo...',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: palette.text(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _uploadingFileName,
            style: TextStyle(
              fontFamily: 'Anek Latin',
              fontSize: 12,
              color: palette.grey(),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Painter para desenhar borda pontilhada
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final dashPath = Path();
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < metric.length) {
        final length = draw ? dashWidth : dashSpace;
        final end = distance + length;

        if (draw) {
          dashPath.addPath(
            metric.extractPath(distance, end.clamp(0.0, metric.length)),
            Offset.zero,
          );
        }

        distance = end;
        draw = !draw;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}
