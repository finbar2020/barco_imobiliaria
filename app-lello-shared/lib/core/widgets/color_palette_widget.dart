import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ColorPaletteWidget extends StatelessWidget {
  final ColorPallete colorPalette;

  const ColorPaletteWidget({Key? key, required this.colorPalette})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Uma função auxiliar para obter o código hexadecimal da cor
    String getColorHex(Color color) =>
        '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

    // Mapeando as cores com seus nomes e valores
    final colors = {
      'Primary': colorPalette.primary(),
      'Secondary': colorPalette.secondary(),
      'Accent': colorPalette.accent(),
      'Background': colorPalette.background(),
      'Background Dark': colorPalette.backgroundDark(),
      'Contrast Background': colorPalette.contrastBackground(),
      'Warning': colorPalette.warning(),
      'Raffle': colorPalette.raffle(),
      'Success': colorPalette.success(),
      'Error': colorPalette.error(),
      'Second Gradient': colorPalette.secondGradient(),
      'Custom Color': colorPalette.customColor(),
      'Text Lightest': colorPalette.textLightest(),
      'Overlay': colorPalette.overlay(),
      'Separator': colorPalette.separator(),
      'Grey': colorPalette.grey(),
      'Grey Card': colorPalette.greyCard(),
      'Button': colorPalette.button(),
      'Button Text': colorPalette.buttonText(),
      'Button Link': colorPalette.buttonLink(),
      'Secondary Button Border': colorPalette.secondaryButtonBorder(),
      'Text': colorPalette.text(),
      'Text Light': colorPalette.textLight(),
      'Hub Text': colorPalette.hubText(),
      'Text Accent': colorPalette.textAccent(),
      'Text Opaque': colorPalette.textOpaque(),
      'Purple Text': colorPalette.purpleText(),
      'AppBar': colorPalette.appBar(),
    };
    var theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: 'Color Palette',
          theme: theme,
        ),
        body: ListView(
          children: colors.entries.map((entry) {
            final color = entry.value;
            return ListTile(
              leading: Icon(Icons.circle, color: color, size: 24),
              title: Text(entry.key),
              subtitle: Text(getColorHex(color)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
