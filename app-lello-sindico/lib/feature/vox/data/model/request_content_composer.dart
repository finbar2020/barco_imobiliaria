/// Composição do conteúdo das **solicitações** (POST /requests/service) no
/// momento do envio ao backend.
///
/// Quando o documento tem título (hoje só o comunicado — ver `DocumentType.hasTitle`),
/// o título é embutido no próprio `content`, já que o fio da solicitação não tem
/// campo de título separado. Sem título, o conteúdo trafega inalterado.
String? composeRequestContent(String? content, String? title) {
  if (title == null || title.trim().isEmpty) return content;
  return "$title\nConteúdo: ${content ?? ''}";
}
