import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/vox/domain/entity/document_mode.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/presentation/vox_navigator.dart';

/// Escolha entre criar e enviar direto ou abrir uma solicitação. Só aparece para
/// tipos que suportam os dois modos (advertência e comunicado).
class VoxMethodSelectorPage extends StatelessWidget {
  final DocumentType type;

  const VoxMethodSelectorPage({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PrimaryAppBar(
        theme: theme,
        iconColor: theme.primaryColor,
        title: _title(),
      ),
      body: ListView(
        children: [
          _option(
            context,
            theme,
            icon: Icons.send_outlined,
            title: "Criar e enviar",
            subtitle: "O documento é gerado e enviado diretamente.",
            mode: DocumentMode.create,
          ),
          Divider(color: theme.dividerColor),
          _option(
            context,
            theme,
            icon: Icons.assignment_outlined,
            title: "Solicitar",
            subtitle: "Gera uma solicitação de serviço para a equipe de atendimento.",
            mode: DocumentMode.request,
          ),
        ],
      ),
    );
  }

  Widget _option(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required DocumentMode mode,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: Dimens.spacingLarge,
        right: Dimens.spacingLarge,
        top: Dimens.spacingSmall,
        bottom: Dimens.spacingSmall,
      ),
      // Mesma cor dos ícones SVG do menu anterior (#606062).
      leading: Icon(icon, color: LelloTheme.palleteOf(theme).grey()),
      title: Text(title, style: LelloTextStyles.bodyBold(theme)),
      subtitle: Text(subtitle, style: LelloTextStyles.body(theme)),
      onTap: () => VoxNavigator.openWizard(context, type, mode),
    );
  }

  String _title() {
    switch (type) {
      case DocumentType.warning:
        return "Nova advertência";
      case DocumentType.fine:
        return "Nova multa";
      case DocumentType.announcement:
        return "Novo comunicado";
    }
  }
}
