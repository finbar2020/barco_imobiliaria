import 'package:essentials/essentials.dart' hide Image, BlendMode;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BellaHeaderWidget extends StatelessWidget {
  final double width;
  final double height;

  const BellaHeaderWidget({
    Key? key,
    this.width = 225,
    this.height = 130,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final iaAssetPrefix = FlavorConfig.config.iaName.toLowerCase();

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Bolha Bege (fundo)
          SvgPicture.asset('assets/bella_fundo_bege.svg'),

          // 2. Bolha Cinza
          SvgPicture.asset('assets/bella_fundo_cinza.svg'),

          // 3. Balão Principal — cor dinâmica via primaryColor
          SvgPicture.asset(
            'assets/bella_balao_principal.svg',
            theme: SvgTheme(
              currentColor: primaryColor,
            ),
          ),

          // 4. Texto/logo "Bella" — centralizado no balão principal (x≈89.6, y≈60.2)
          Align(
            alignment: const Alignment(-0.44, -0.12),
            child: SvgPicture.asset(
              'assets/${iaAssetPrefix}_balao_texto.svg',
            ),
          ),
        ],
      ),
    );
  }
}
