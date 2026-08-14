import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import '../../../domain/entity/task_report_entity.dart';

class TaskReportFilePreviewPage extends StatefulWidget {
  final TaskReportFileEntity file;
  final List<TaskReportFileEntity> allFiles;
  final int initialIndex;

  const TaskReportFilePreviewPage({
    super.key,
    required this.file,
    required this.allFiles,
    this.initialIndex = 0,
  });

  @override
  State<TaskReportFilePreviewPage> createState() =>
      _TaskReportFilePreviewPageState();
}

class _TaskReportFilePreviewPageState extends State<TaskReportFilePreviewPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(theme, palette),
      body: _buildBody(theme, palette),
      bottomNavigationBar: _buildBottomBar(theme, palette),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, ColorPallete palette) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        widget.allFiles[_currentIndex].filename,
        style: LelloTextStyles.title(theme)?.copyWith(
          color: Colors.white,
          fontSize: 16,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      actions: [
        if (widget.allFiles.length > 1)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentIndex + 1}/${widget.allFiles.length}',
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(ThemeData theme, ColorPallete palette) {
    if (widget.allFiles.length == 1) {
      return _buildSingleFileView(widget.file, theme, palette);
    }

    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: widget.allFiles.length,
      itemBuilder: (context, index) {
        return _buildSingleFileView(widget.allFiles[index], theme, palette);
      },
    );
  }

  Widget _buildSingleFileView(
    TaskReportFileEntity file,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final isImage = _isImageFile(file.extension);

    if (isImage) {
      return Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            file.url,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorWidget(file, theme, palette);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      );
    }

    return _buildFileInfoView(file, theme, palette);
  }

  Widget _buildFileInfoView(
    TaskReportFileEntity file,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFileIcon(file.extension, 64),
            const SizedBox(height: 16),
            Text(
              file.filename,
              style: LelloTextStyles.title(theme)?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${file.extension.toUpperCase()} • ${_formatFileSize(file.sizeInBytes)}',
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.grey(),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enviado em ${file.uploadedAt}',
              style: LelloTextStyles.caption(theme)?.copyWith(
                color: palette.grey(),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _downloadFile(file),
              icon: const Icon(Icons.download),
              label: const Text('Baixar arquivo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary(),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
    TaskReportFileEntity file,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar imagem',
              style: LelloTextStyles.title(theme)?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              file.filename,
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.grey(),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme, ColorPallete palette) {
    if (widget.allFiles.length <= 1) return const SizedBox();

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _currentIndex > 0
                ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: Icon(
              Icons.chevron_left,
              color: _currentIndex > 0 ? Colors.white : Colors.white30,
              size: 32,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1} de ${widget.allFiles.length}',
              style: LelloTextStyles.body(theme)?.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: _currentIndex < widget.allFiles.length - 1
                ? () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: Icon(
              Icons.chevron_right,
              color: _currentIndex < widget.allFiles.length - 1
                  ? Colors.white
                  : Colors.white30,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileIcon(String extension, double size) {
    IconData icon;
    Color color;

    switch (extension.toLowerCase()) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'doc':
      case 'docx':
        icon = Icons.description;
        color = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        icon = Icons.table_chart;
        color = Colors.green;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = Colors.grey;
    }

    return Icon(icon, size: size, color: color);
  }

  bool _isImageFile(String extension) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension.toLowerCase());
  }

  String _formatFileSize(int sizeInBytes) {
    final kb = sizeInBytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    }
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  void _downloadFile(TaskReportFileEntity file) {
    // Implementar download do arquivo
    // Em produção, usar url_launcher ou similar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Baixando ${file.filename}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
