import 'package:essentials/methods/strings/split_paragraphs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('separa parágrafos por linha em branco', () {
    expect(splitIntoParagraphs('a\n\nb\n \n c '), ['a', 'b', 'c']);
  });

  test('normaliza quebras de linha do Windows e Mac antigo', () {
    expect(splitIntoParagraphs('a\r\n\r\nb\r\rc'), ['a', 'b', 'c']);
  });

  test('mantém quebras simples dentro do parágrafo', () {
    expect(splitIntoParagraphs('linha1\nlinha2'), ['linha1\nlinha2']);
  });

  test('texto vazio devolve lista vazia', () {
    expect(splitIntoParagraphs('   \n\n  '), isEmpty);
  });
}
