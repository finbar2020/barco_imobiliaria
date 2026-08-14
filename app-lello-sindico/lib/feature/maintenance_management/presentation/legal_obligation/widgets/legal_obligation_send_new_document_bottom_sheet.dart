import 'dart:io';

import 'package:essentials/essentials.dart' hide Image, Path;
import 'package:essentials/modal/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:shared_features/shared_features.dart';

class LegalObligationSendNewDocumentResult {
  final File file;
  final DateTime expirationDate;

  const LegalObligationSendNewDocumentResult({
    required this.file,
    required this.expirationDate,
  });
}

class LegalObligationSendNewDocumentBottomSheet extends StatefulWidget {
  final DateTime? initialExpirationDate;

  const LegalObligationSendNewDocumentBottomSheet({
    super.key,
    this.initialExpirationDate,
  });

  static Future<LegalObligationSendNewDocumentResult?> show(
    BuildContext context, {
    DateTime? initialExpirationDate,
  }) {
    return showModalBottomSheet<LegalObligationSendNewDocumentResult?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => LegalObligationSendNewDocumentBottomSheet(
        initialExpirationDate: initialExpirationDate,
      ),
    );
  }

  @override
  State<LegalObligationSendNewDocumentBottomSheet> createState() =>
      _LegalObligationSendNewDocumentBottomSheetState();
}

class _LegalObligationSendNewDocumentBottomSheetState
    extends State<LegalObligationSendNewDocumentBottomSheet> {
  static const _maxFileSize = 10 * 1024 * 1024;
  static const _emptyUploadBoxHeight = 120.0;

  File? _selectedFile;
  late DateTime? _selectedExpirationDate;
  final _expirationDateController = TextEditingController();
  final _expirationDateFocusNode = FocusNode();
  final TextInputFormatter _expirationDateFormatter = fullDateFormatter();
  String? _expirationDateError;

  @override
  void initState() {
    super.initState();
    _expirationDateFocusNode.addListener(_onExpirationDateFocusChanged);

    final initialDate = widget.initialExpirationDate;
    if (initialDate != null && !_isRetroactiveDate(initialDate)) {
      _selectedExpirationDate = DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
      );
      _expirationDateController.text = _formatDate(_selectedExpirationDate!);
    } else {
      _selectedExpirationDate = null;
    }
  }

  @override
  void dispose() {
    _expirationDateController.dispose();
    _expirationDateFocusNode.removeListener(_onExpirationDateFocusChanged);
    _expirationDateFocusNode.dispose();
    super.dispose();
  }

  bool get _canConfirm =>
      _selectedFile != null && _selectedExpirationDate != null;

  void _onExpirationDateFocusChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _pickFile() async {
    _dismissKeyboard();

    final files = await AttachFilesBottomSheet.show(
      appContainer: ApplicationContainer.instance(),
      context: context,
      allowMultiple: false,
      maxFileSizePermitted: _maxFileSize,
      aspectRatioPresets: [CropAspectRatioPreset.original],
    );

    if (!mounted || files.isEmpty) return;

    setState(() {
      _selectedFile = files.first;
    });
  }

  void _onExpirationDateChanged(String value) {
    if (value.isEmpty) {
      _updateExpirationDateState(date: null, error: null);
      return;
    }

    if (value.length < 10) {
      _updateExpirationDateState(date: null, error: null);
      return;
    }

    final parsedDate = _parseTypedDate(value);
    if (parsedDate == null) {
      _updateExpirationDateState(
        date: null,
        error: _dueDateErrorMessage(),
      );
      return;
    }

    if (_isRetroactiveDate(parsedDate)) {
      _updateExpirationDateState(
        date: null,
        error: _dueDateErrorMessage(),
      );
      return;
    }

    _updateExpirationDateState(date: parsedDate, error: null);
  }

  void _updateExpirationDateState({DateTime? date, String? error}) {
    if (_selectedExpirationDate == date && _expirationDateError == error) {
      return;
    }

    setState(() {
      _selectedExpirationDate = date;
      _expirationDateError = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final insets = MediaQuery.of(context).viewInsets;
    final keyboardVisible = insets.bottom > 0;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Dimens.spacing,
            Dimens.spacingMedium,
            Dimens.spacing,
            Dimens.spacingLarge + insets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 58,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Text(
                getString(context, 'legal_obligation_send_new_document_title'),
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: palette.text()),
              ),
              SizedBox(height: Dimens.spacingMedium),
              _buildFilePicker(theme, keyboardVisible),
              SizedBox(height: Dimens.spacingMedium),
              _buildExpirationDateField(theme),
              SizedBox(height: Dimens.spacingLarge),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      onPressed: () {
                        _dismissKeyboard();
                        Navigator.of(context).pop();
                      },
                      text: getString(context, 'legal_obligation_cancel'),
                    ),
                  ),
                  SizedBox(width: Dimens.spacing),
                  Expanded(
                    child: PrimaryButton(
                      theme: theme,
                      buttonColor: palette.primary(),
                      onPressed: _canConfirm
                          ? () {
                              _dismissKeyboard();
                              Navigator.of(context).pop(
                                LegalObligationSendNewDocumentResult(
                                  file: _selectedFile!,
                                  expirationDate: _selectedExpirationDate!,
                                ),
                              );
                            }
                          : null,
                      text: getString(context, 'legal_obligation_confirm'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePicker(ThemeData theme, bool keyboardVisible) {
    final hasFile = _selectedFile != null;
    final isImage = hasFile && _isImageFile(_selectedFile!);
    final isPdf = hasFile && _isPdfFile(_selectedFile!);
    final palette = LelloTheme.palleteOf(theme);

    if (!hasFile) {
      return InkWell(
        onTap: _pickFile,
        borderRadius: BorderRadius.circular(8),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: Colors.grey.shade400,
            strokeWidth: 1.2,
            dashWidth: 5,
            dashSpace: 3,
            borderRadius: 8,
          ),
          child: Container(
            width: double.infinity,
            height: _emptyUploadBoxHeight,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/ic_upload_image.svg',
                  width: 44,
                  height: 44,
                ),
                SizedBox(height: Dimens.spacingXSmall),
                Text(
                  getString(
                    context,
                    'legal_obligation_send_new_document_upload_hint',
                  ),
                  style: LelloTextStyles.caption(theme)?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (isImage || isPdf) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              if (keyboardVisible || _expirationDateFocusNode.hasFocus) {
                _dismissKeyboard();
                return;
              }

              _openSelectedFilePreview();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey.shade100,
                child: isImage
                    ? Image.file(
                        _selectedFile!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) {
                          return _buildSelectedFileFallback(theme);
                        },
                      )
                    : FileMethods.imageBody(
                        context,
                        _selectedFile!,
                        imageIconSize: double.infinity,
                      ),
              ),
            ),
          ),
          Positioned(
            top: -7,
            right: -7,
            child: _buildRemoveButton(palette),
          ),
        ],
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: _pickFile,
          borderRadius: BorderRadius.circular(8),
          child: _buildSelectedFileFallback(theme),
        ),
        Positioned(
          top: -7,
          right: -7,
          child: _buildRemoveButton(palette),
        ),
      ],
    );
  }

  Widget _buildSelectedFileFallback(ThemeData theme) {
    final fileName = _fileName(_selectedFile!);

    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            size: 28,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: LelloTextStyles.bodyBold(theme)
                      ?.copyWith(color: Colors.grey.shade700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  getString(
                    context,
                    'legal_obligation_send_new_document_upload_hint',
                  ),
                  style: LelloTextStyles.caption(theme)
                      ?.copyWith(color: Colors.grey.shade500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveButton(ColorPallete palette) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFile = null;
        });
      },
      child: Container(
        width: 27,
        height: 27,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: palette.error(),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          size: 11,
          color: Colors.white,
        ),
      ),
    );
  }

  bool _isImageFile(File file) {
    final lowerPath = file.path.toLowerCase();
    return lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png') ||
        lowerPath.endsWith('.webp') ||
        lowerPath.endsWith('.gif') ||
        lowerPath.endsWith('.bmp');
  }

  bool _isPdfFile(File file) {
    return file.path.toLowerCase().endsWith('.pdf');
  }

  Future<void> _openSelectedFilePreview() async {
    final selectedFile = _selectedFile;
    if (selectedFile == null) return;

    if (_isPdfFile(selectedFile)) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(pdfFile: selectedFile, title: 'PDF'),
        ),
      );
      return;
    }

    if (_isImageFile(selectedFile)) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              IMGScreen(imageFile: selectedFile, title: 'Imagem'),
        ),
      );
      return;
    }

    FileMethods.viewFile(context, selectedFile);
  }

  Widget _buildExpirationDateField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getString(
            context,
            'legal_obligation_send_new_document_due_date_label',
          ),
          style: LelloTextStyles.bodyBold(theme)
              ?.copyWith(color: Colors.grey.shade700),
        ),
        SizedBox(height: Dimens.spacingXSmall),
        TextField(
          controller: _expirationDateController,
          focusNode: _expirationDateFocusNode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [_expirationDateFormatter],
          onChanged: _onExpirationDateChanged,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            hintText: getString(
              context,
              'legal_obligation_send_new_document_due_date_hint',
            ),
            errorText: _expirationDateError,
            suffixIcon: _expirationDateFocusNode.hasFocus
                ? IconButton(
                    onPressed: _dismissKeyboard,
                    icon: const Icon(Icons.keyboard_hide_rounded),
                    tooltip: getString(
                      context,
                      'legal_obligation_close_keyboard',
                      defaultText: 'Fechar teclado',
                    ),
                  )
                : null,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SvgPicture.asset(
                'assets/ic_calendar.svg',
                width: 18,
                height: 18,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacingSmall),
        _buildResponsibilityBanner(theme),
      ],
    );
  }

  Widget _buildResponsibilityBanner(ThemeData theme) {
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: palette.routineBlue().withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.routineBlue().withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: palette.routineBlue(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              getString(
                context,
                'legal_obligation_send_new_document_responsibility_banner',
              ),
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.text(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _parseTypedDate(String value) {
    final match = RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value);
    if (!match) return null;

    final parts = value.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return null;

    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }

    return date;
  }

  bool _isRetroactiveDate(DateTime date) {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return normalizedDate.isBefore(normalizedToday);
  }

  String _dueDateErrorMessage() {
    return getString(
      context,
      'legal_obligation_send_new_document_due_date_error',
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  String _fileName(File file) {
    final parts = file.path.split(RegExp(r'[\\/]'));
    return parts.isEmpty ? file.path : parts.last;
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  _DashedBorderPainter({
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
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final dashPath = Path();
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      var draw = true;

      while (distance < metric.length) {
        final segmentLength = draw ? dashWidth : dashSpace;
        final end = distance + segmentLength;

        if (draw) {
          dashPath.addPath(
            metric.extractPath(distance, end.clamp(0, metric.length)),
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
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}
