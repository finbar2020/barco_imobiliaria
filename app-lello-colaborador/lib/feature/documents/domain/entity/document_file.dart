import 'dart:io';

class DocumentFile {
  final String id;
  final String name;
  final String type;
  final String data;
  File? file;

  DocumentFile({
    required this.id,
    required this.name,
    required this.type,
    required this.data,
    this.file,
  });
}
