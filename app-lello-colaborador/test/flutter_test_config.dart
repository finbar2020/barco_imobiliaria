import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

/// Comparador de goldens tolerante à rasterização de texto.
///
/// As imagens de referência do repositório foram geradas em outra máquina e
/// outra versão do Flutter. O layout continua idêntico — todas as imagens têm
/// exatamente as mesmas dimensões — mas os glifos são rasterizados com
/// pequenas diferenças de antialiasing e posicionamento subpixel.
///
/// Duas medidas separam esse ruído de uma mudança real de tela:
///
/// * ruído de antialiasing produz muitos pixels com diferença pequena;
/// * conteúdo novo ou removido produz pixels com diferença grande (fundo
///   virando traço de letra, por exemplo).
///
/// Os limites abaixo vieram da medição das 90 imagens do projeto contra a
/// referência (pior caso: 1,81% acima de 48 e 0,28% acima de 128) comparada
/// com uma alteração real de texto (2,99% e 1,53%).
const _toleranciaAntialias = 48;
const _maxProporcaoAntialias = 0.025;

const _toleranciaForte = 128;
const _maxProporcaoForte = 0.006;

/// Defina `--dart-define=GOLDEN_STRICT=true` para voltar à comparação pixel a
/// pixel, na máquina e versão de Flutter em que as referências foram geradas.
const _modoEstrito = bool.fromEnvironment('GOLDEN_STRICT');

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final padrao = goldenFileComparator;
  if (!_modoEstrito && padrao is LocalFileComparator) {
    goldenFileComparator = _ComparadorTolerante(padrao.basedir);
  }
  await testMain();
}

class _ComparadorTolerante extends LocalFileComparator {
  _ComparadorTolerante(Uri basedir)
      : super(basedir.resolve('flutter_test_config.dart'));

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final referencia = await getGoldenBytes(golden);
    if (await _dentroDaTolerancia(imageBytes, Uint8List.fromList(referencia))) {
      return true;
    }
    // Fora da tolerância: o comparador padrão grava os arquivos de diferença e
    // lança a mensagem de erro habitual.
    return super.compare(imageBytes, golden);
  }
}

Future<bool> _dentroDaTolerancia(Uint8List atual, Uint8List referencia) async {
  final a = await _decodificar(atual);
  final b = await _decodificar(referencia);

  // Tamanho diferente é mudança de layout, não de rasterização.
  if (a.largura != b.largura || a.altura != b.altura) return false;

  final total = a.largura * a.altura;
  final limiteAntialias = (total * _maxProporcaoAntialias).floor();
  final limiteForte = (total * _maxProporcaoForte).floor();

  var antialias = 0;
  var fortes = 0;

  for (var i = 0; i < a.pixels.length; i += 4) {
    var delta = 0;
    for (var canal = 0; canal < 4; canal++) {
      final d = (a.pixels[i + canal] - b.pixels[i + canal]).abs();
      if (d > delta) delta = d;
    }
    if (delta > _toleranciaAntialias) {
      antialias++;
      if (delta > _toleranciaForte) fortes++;
      if (antialias > limiteAntialias || fortes > limiteForte) return false;
    }
  }
  return true;
}

class _Imagem {
  const _Imagem(this.largura, this.altura, this.pixels);

  final int largura;
  final int altura;
  final Uint8List pixels;
}

Future<_Imagem> _decodificar(Uint8List bytes) async {
  final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
  final descritor = await ui.ImageDescriptor.encoded(buffer);
  final codec = await descritor.instantiateCodec();
  final frame = await codec.getNextFrame();
  final imagem = frame.image;
  try {
    final dados =
        await imagem.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
    return _Imagem(imagem.width, imagem.height, dados!.buffer.asUint8List());
  } finally {
    imagem.dispose();
    codec.dispose();
    descritor.dispose();
  }
}
