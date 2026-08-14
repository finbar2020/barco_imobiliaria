import '../domain/entity/task_report_entity.dart';

extension TaskReportQuestionTypeExtension on TaskReportQuestionType {
  String get displayName {
    switch (this) {
      case TaskReportQuestionType.textarea:
        return 'Texto longo';
      case TaskReportQuestionType.radio:
        return 'Múltipla escolha';
      case TaskReportQuestionType.select:
        return 'Seleção única';
      case TaskReportQuestionType.file:
        return 'Arquivo';
    }
  }

  String get description {
    switch (this) {
      case TaskReportQuestionType.textarea:
        return 'Campo de texto para respostas descritivas';
      case TaskReportQuestionType.radio:
        return 'Opções de escolha única com botões de rádio';
      case TaskReportQuestionType.select:
        return 'Lista suspensa para seleção de uma opção';
      case TaskReportQuestionType.file:
        return 'Anexo de arquivos e imagens';
    }
  }
}

extension TaskReportAnswerTypeExtension on TaskReportAnswerType {
  String get displayName {
    switch (this) {
      case TaskReportAnswerType.text:
        return 'Texto';
      case TaskReportAnswerType.singleChoice:
        return 'Escolha única';
      case TaskReportAnswerType.multipleChoice:
        return 'Múltipla escolha';
      case TaskReportAnswerType.file:
        return 'Arquivo';
    }
  }
}

extension TaskReportFileEntityExtension on TaskReportFileEntity {
  String get formattedSize {
    final kb = sizeInBytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    }
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  bool get isImage {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension.toLowerCase());
  }

  bool get isPdf {
    return extension.toLowerCase() == 'pdf';
  }

  bool get isDocument {
    final docExtensions = ['doc', 'docx', 'txt', 'rtf'];
    return docExtensions.contains(extension.toLowerCase());
  }

  bool get isSpreadsheet {
    final sheetExtensions = ['xls', 'xlsx', 'csv'];
    return sheetExtensions.contains(extension.toLowerCase());
  }
}
