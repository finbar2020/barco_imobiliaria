import 'package:essentials/essentials.dart';

/// Sobe uma imagem do conteúdo HTML e retorna a URL pública (para inserir como
/// tag `<img>` no editor).
abstract class UploadDocumentImage
    extends UseCase<String, UploadDocumentImageParam> {}

class UploadDocumentImageParam {
  final Uint8List bytes;
  final String fileName;

  UploadDocumentImageParam({required this.bytes, required this.fileName});
}
