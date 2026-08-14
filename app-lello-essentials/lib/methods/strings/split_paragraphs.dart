List<String> splitIntoParagraphs(String raw) {
  // Normaliza quebras de linha para \n
  var s = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  // Divide parágrafos usando dois \n consecutivos (com ou sem espaços entre eles)
  // O regex \n\s*\n captura: \n + zero ou mais espaços + \n
  var paragraphs = s.split(RegExp(r'\n\s*\n'));

  // Limpa cada parágrafo: remove espaços extras no início/fim e mantém \n simples como quebras de linha
  return paragraphs.map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
}
