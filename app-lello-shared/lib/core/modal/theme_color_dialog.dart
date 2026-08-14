import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ThemeColorValue {
  final Color? primaryColor;
  final Color? secondaryColor;
  final bool? isDark;

  ThemeColorValue(this.primaryColor, this.secondaryColor, this.isDark);
}

class ThemeColorDialog extends StatefulWidget {
  final Color initialPrimaryColor;
  final Color initialSecondaryColor;
  final bool? initialIsDark;

  const ThemeColorDialog({
    super.key,
    required this.initialPrimaryColor,
    required this.initialSecondaryColor,
    required this.initialIsDark,
  });

  @override
  _ThemeColorDialogState createState() => _ThemeColorDialogState();
}

class _ThemeColorDialogState extends State<ThemeColorDialog> {
  late TextEditingController primaryController;
  late TextEditingController secondaryController;
  late Color primaryColor;
  late Color secondaryColor;
  late bool isDark = false;

  @override
  void initState() {
    super.initState();
    primaryColor = widget.initialPrimaryColor;
    secondaryColor = widget.initialSecondaryColor;
    isDark = widget.initialIsDark ?? false;
    primaryController = TextEditingController(text: _colorToHex(primaryColor));
    primaryController.addListener(() {
      final color = _hexToColor(primaryController.text);
      if (color != null) {
        setState(() => primaryColor = color);
      }
    });
    secondaryController =
        TextEditingController(text: _colorToHex(secondaryColor));
    secondaryController.addListener(() {
      final color = _hexToColor(secondaryController.text);
      if (color != null) {
        setState(() => secondaryColor = color);
      }
    });
  }

  String _colorToHex(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  Color? _hexToColor(String hex) {
    try {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cores do Tema'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: const Text('Primária: ')),
              Icon(Icons.circle, color: primaryColor),
              Expanded(
                child: TextField(
                  controller: primaryController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () => _colorPicker(primaryController),
                  icon: Icon(Icons.palette))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: const Text('Secundária: ')),
              Icon(Icons.circle, color: secondaryColor),
              Expanded(
                child: TextField(
                  controller: secondaryController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () => _colorPicker(secondaryController),
                  icon: Icon(Icons.palette))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Tema escuro: '),
              Expanded(
                child: Checkbox(
                  value: isDark,
                  onChanged: (value) {
                    setState(() {
                      isDark = value ?? false;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(ThemeColorValue(null, null, null)),
          child: const Text('REINICIAR'),
        ),
        TextButton(
          onPressed: () {
            final primary = _hexToColor(primaryController.text);
            final secondary = _hexToColor(secondaryController.text);

            if (primary != null && secondary != null) {
              Navigator.of(context)
                  .pop(ThemeColorValue(primary, secondary, isDark));
            } else {
              // Mostra um alerta se as cores forem inválidas
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Erro'),
                  content:
                      const Text('Insira um valor de cor hexadecimal válido!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          child: const Text('SALVAR'),
        ),
      ],
    );
  }

  _colorPicker(TextEditingController cc) {
    var color = _hexToColor(cc.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecione uma cor'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color ?? Colors.white,
            onColorChanged: (color) {
              setState(() {
                cc.text = _colorToHex(color);
              });
            },
            colorPickerWidth: 300.0,
            pickerAreaHeightPercent: 0.7,
            enableAlpha: false,
            displayThumbColor: true,
            paletteType: PaletteType.hsv,
            pickerAreaBorderRadius: const BorderRadius.only(
              topLeft: Radius.circular(2.0),
              topRight: Radius.circular(2.0),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
