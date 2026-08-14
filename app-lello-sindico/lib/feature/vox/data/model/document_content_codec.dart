import 'dart:convert';

/// Conversão do conteúdo HTML para o formato de transporte (Base64).
///
/// Centraliza, na camada data, o que antes vazava para a presentation (item B5).
/// A codificação de escrita usa UTF-8 (mesmo comportamento do `CustomHtmlPage`
/// antigo: `base64.encode(utf8.encode(html))`).
String? encodeHtmlToBase64(String? html) =>
    html == null ? null : base64.encode(utf8.encode(html));

/// Decodifica conteúdo Base64 de volta para HTML.
String? decodeBase64ToHtml(String? base64Content) =>
    base64Content == null ? null : utf8.decode(base64.decode(base64Content));
