import 'dart:convert';

import 'package:essentials/configs/environment.dart';
import 'package:essentials/ui/colors/carimbeira_pallete.dart';
import 'package:essentials/ui/colors/color_pallete.dart';
import 'package:essentials/ui/colors/dark_pallete.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Cores padrão de cada paleta (o singleton de cada paleta pode ser
/// customizado por `customize`/`LelloTheme.viverDefaultTheme`, então os testes
/// o restauram ao final).
const lightPrimaryDefault = Color(0xFFC20332);
const lightSecondaryDefault = Color(0xFF5C0521);
const darkPrimaryDefault = Color(0xFFCB2640);
const darkSecondaryDefault = Color(0xFFCB2640);
const carimbeiraPrimaryDefault = Color(0xFFFFAB66);
const carimbeiraSecondaryDefault = Color(0xFFEE4713);

/// Restaura as três paletas para as cores originais.
void resetPalletes() {
  LightPallete.restoreDefaults();
  DarkPallete.restoreDefaults();
  CarimbeiraPallete.restoreDefaults();
}

/// Todas as cores expostas por [ColorPallete], indexadas pelo nome do método.
Map<String, Color> palleteEntries(ColorPallete p) => {
      'primary': p.primary(),
      'secondary': p.secondary(),
      'accent': p.accent(),
      'background': p.background(),
      'backgroundDark': p.backgroundDark(),
      'contrastBackground': p.contrastBackground(),
      'warning': p.warning(),
      'raffle': p.raffle(),
      'routineBlue': p.routineBlue(),
      'success': p.success(),
      'error': p.error(),
      'negative': p.negative(),
      'secondGradient': p.secondGradient(),
      'customColor': p.customColor(),
      'textLightest': p.textLightest(),
      'crimsonRed': p.crimsonRed(),
      'hubertSindico': p.hubertSindico(),
      'hubertMorador': p.hubertMorador(),
      'overlay': p.overlay(),
      'separator': p.separator(),
      'grey': p.grey(),
      'greyDarker': p.greyDarker(),
      'greyCard': p.greyCard(),
      'button': p.button(),
      'buttonText': p.buttonText(),
      'buttonLink': p.buttonLink(),
      'buttonSystem': p.buttonSystem(),
      'secondaryButtonBorder': p.secondaryButtonBorder(),
      'whatsappButton': p.whatsappButton(),
      'text': p.text(),
      'textLight': p.textLight(),
      'hubText': p.hubText(),
      'textAccent': p.textAccent(),
      'textOpaque': p.textOpaque(),
      'purpleText': p.purpleText(),
      'appBar': p.appBar(),
      'appBarHome': p.appBarHome(),
      'statusBarColor': p.statusBarColor(),
    };

/// Grade de amostras de cor para goldens da paleta.
Widget palleteSwatches(ColorPallete pallete) {
  final entries = palleteEntries(pallete).entries.toList();
  return Wrap(
    spacing: 4,
    runSpacing: 4,
    children: [
      for (final e in entries)
        SizedBox(
          width: 88,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 28,
                decoration: BoxDecoration(
                  color: e.value,
                  border: Border.all(color: const Color(0xFF9E9E9E)),
                ),
              ),
              Text(
                e.key,
                style: const TextStyle(fontSize: 8, color: Color(0xFF000000)),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
    ],
  );
}

/// Ambiente concreto para widgets que recebem [Environment].
class FakeEnvironment extends Environment {
  FakeEnvironment({
    required bool isProduction,
    String name = 'HML',
    String apiUrl = 'https://api.test',
  }) : super(isProduction: isProduction, apiUrl: apiUrl, name: name);
}

/// AssetBundle em memória: devolve o conteúdo de [assets] pela chave e
/// registra em [requested] cada chave pedida.
class FakeAssetBundle extends CachingAssetBundle {
  FakeAssetBundle(this.assets);

  final Map<String, String> assets;
  final requested = <String>[];

  @override
  Future<ByteData> load(String key) async {
    requested.add(key);
    final content = assets[key];
    if (content == null) {
      throw FlutterError('Asset de teste não encontrado: $key');
    }
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(content)));
  }
}

/// Animação Lottie mínima (um círculo vermelho) para testes do ScrollIndicator.
const minimalLottieJson = '{"v":"5.5.7","fr":30,"ip":0,"op":30,"w":100,"h":100,'
    '"nm":"teste","ddd":0,"assets":[],"layers":[{"ddd":0,"ind":1,"ty":4,'
    '"nm":"circulo","sr":1,"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},'
    '"p":{"a":0,"k":[50,50,0]},"a":{"a":0,"k":[0,0,0]},"s":{"a":0,"k":[100,100,100]}},'
    '"ao":0,"shapes":[{"ty":"el","p":{"a":0,"k":[0,0]},"s":{"a":0,"k":[40,40]},"d":1},'
    '{"ty":"fl","c":{"a":0,"k":[1,0,0,1]},"o":{"a":0,"k":100},"r":1}],'
    '"ip":0,"op":30,"st":0,"bm":0}]}';
