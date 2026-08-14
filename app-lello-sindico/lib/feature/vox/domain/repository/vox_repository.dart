import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/entity/document_detail.dart';
import 'package:lello/feature/vox/domain/entity/document_reason.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_template.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

/// Repositório unificado dos documentos Vox (advertência/multa/comunicado).
///
/// O dispatch por [DocumentType] na implementação é a "estratégia de submit"
/// do eixo REQUEST (Q3): cada tipo constrói seu model e bate em
/// POST /requests/service com o `serviceId` correto.
abstract class VoxRepository {
  /// Solicita um documento (POST /requests/service). Retorna o id/resposta.
  Future<Try<String>> requestDocument(
      DocumentType type, DocumentRequest request);

  /// Cria e envia um documento direto (endpoint próprio de criação).
  /// Suportado por advertência e comunicado (multa só pode ser solicitada).
  Future<Try<String>> createDocument(
      DocumentType type, DocumentRequest request);

  /// Motivos do documento (advertência/multa). Comunicado retorna lista vazia.
  Future<Try<List<DocumentReason>>> listReasons(
      DocumentType type, String condominiumId);

  /// Templates do documento (advertência/multa). Comunicado retorna lista vazia.
  Future<Try<List<DocumentTemplate>>> listTemplates(
      DocumentType type, String condominiumId);

  /// Histórico de documentos do tipo no condomínio.
  Future<Try<List<Document>>> listDocuments(
      DocumentType type, String condominiumId);

  /// Detalhe de um documento por id (Q7: sempre re-busca).
  Future<Try<DocumentDetail>> getDocument(DocumentType type, String id);

  /// Sobe uma imagem (comprimida) para o conteúdo HTML e retorna a URL pública.
  Future<Try<String>> uploadImage(Uint8List bytes, String fileName);
}
