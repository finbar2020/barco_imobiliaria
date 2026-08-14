import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/vox/domain/entity/document_mode.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/presentation/menu/vox_method_selector_page.dart';
import 'package:lello/feature/vox/presentation/vox_navigator.dart';

/// Menu de Advertências e Multas (substitui WarningsAndFinesMenu).
class VoxWarningsFinesMenu extends StatelessWidget {
  const VoxWarningsFinesMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PrimaryAppBar(
        theme: theme,
        iconColor: theme.primaryColor,
        title: getString(context, "warnings_and_fines_menu_title"),
      ),
      body: ListView(
        children: [
          voxMenuTitle(getString(context, "warnings_title")),
          voxMenuItem(
            context,
            theme,
            getString(context, "warnings_history"),
            "assets/ic_warnings_and_fines_menu_history.svg",
            () => VoxNavigator.openHistory(context, DocumentType.warning),
          ),
          Divider(color: theme.dividerColor),
          voxMenuItem(
            context,
            theme,
            getString(context, "new_warning"),
            "assets/ic_new_warning.svg",
            () => _openNew(context, DocumentType.warning),
          ),
          voxMenuTitle(getString(context, "fines_title")),
          voxMenuItem(
            context,
            theme,
            getString(context, "fines_notification_history"),
            "assets/ic_fine_notification_request_history.svg",
            () => VoxNavigator.openHistory(context, DocumentType.fine),
          ),
          Divider(color: theme.dividerColor),
          voxMenuItem(
            context,
            theme,
            getString(context, "request_fine_notification"),
            "assets/ic_new_fine_request.svg",
            // Multa só pode ser solicitada (sem seletor de método).
            () => VoxNavigator.openWizard(
                context, DocumentType.fine, DocumentMode.request),
          ),
          Divider(color: theme.dividerColor),
        ],
      ),
    );
  }
}

/// Menu de Comunicados (substitui AnnouncementsMenu).
class VoxAnnouncementsMenu extends StatelessWidget {
  const VoxAnnouncementsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PrimaryAppBar(
        theme: theme,
        iconColor: theme.primaryColor,
        title: getString(context, "announcements_title"),
      ),
      body: ListView(
        children: [
          voxMenuTitle(getString(context, "announcements_title")),
          voxMenuItem(
            context,
            theme,
            getString(context, "announcements_menu_history"),
            "assets/ic_announcements_menu_history.svg",
            () => VoxNavigator.openHistory(context, DocumentType.announcement),
          ),
          Divider(color: theme.dividerColor),
          voxMenuItem(
            context,
            theme,
            getString(context, "announcements_menu_new"),
            "assets/ic_announcements_menu_new.svg",
            () => _openNew(context, DocumentType.announcement),
          ),
        ],
      ),
    );
  }
}

void _openNew(BuildContext context, DocumentType type) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => VoxMethodSelectorPage(type: type),
  ));
}

Widget voxMenuItem(BuildContext context, ThemeData theme, String title,
    String asset, VoidCallback onTap) {
  return ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.only(
      left: Dimens.spacingLarge,
      right: Dimens.spacingLarge,
      top: Dimens.spacingSmall,
      bottom: Dimens.spacingSmall,
    ),
    leading: SvgPicture.asset(asset, width: 24),
    title: Text(title, style: LelloTextStyles.bodyBold(theme)),
  );
}

Widget voxMenuTitle(String title) {
  return Container(
    color: Colors.grey[200],
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    ),
  );
}
