/// Modo de envio de um documento.
///
/// - [create]: o síndico cria e envia o documento direto (endpoint próprio de
///   criação). Disponível para advertência e comunicado.
/// - [request]: gera uma solicitação de serviço que passa por aprovação
///   (POST /requests/service). Disponível para os três tipos.
enum DocumentMode { create, request }
