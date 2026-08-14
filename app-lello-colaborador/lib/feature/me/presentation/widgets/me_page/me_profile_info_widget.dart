import 'package:colaborador/core/dependency/application_container.dart';

import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class MeProfileInfoWidget extends StatelessWidget {
  final Me me;
  const MeProfileInfoWidget({super.key, required this.me});

  @override
  Widget build(BuildContext context) {
    Environment env = ApplicationContainer.instance().resolve<Environment>();
    AuthenticationStore authenticationStore =
        ApplicationContainer.instance().resolve();
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
              me.cpf.length > 14
                  ? getString(context, "cnpj")
                  : getString(context, "me_cpf_title"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: _buildValue(
            context,
            me.cpf.formatCpfCnpj(),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            getString(context, "profile_update_email"),
            style: LelloTextStyles.bodyBold(theme),
          ),
          subtitle: _buildValue(context, me.email),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            getString(context, "phone"),
            style: LelloTextStyles.bodyBold(theme),
          ),
          subtitle: _buildValue(context, me.phone),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(getString(context, "password"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: Text(
            "******",
            style: LelloTextStyles.subBody(theme),
          ),
        ),
        Offstage(
          offstage: env.isProduction,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Token Firebase",
              style: LelloTextStyles.bodyBold(theme),
            ),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copiar codigo',
                  onPressed: () async {
                    Clipboard.setData(
                      ClipboardData(
                        text: await FirebaseInstallations.instance.getToken(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: env.isProduction,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Token Firebase Push",
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copiar codigo',
                  onPressed: () async {
                    var token = await FirebaseMessaging.instance.getToken();
                    if (token != null) {
                      Clipboard.setData(ClipboardData(text: token));
                    } else {
                      Fluttertoast.showToast(msg: "Token não encontrado");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: env.isProduction,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Firebase Installation ID",
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copiar ID',
                  onPressed: () async {
                    String id = await FirebaseInstallations.instance.getId();
                    Clipboard.setData(ClipboardData(text: id));
                  },
                ),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: env.isProduction,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title:
                Text("Refresh Token", style: LelloTextStyles.bodyBold(theme)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authenticationStore.getRefreshToken(),
                  style: LelloTextStyles.subBody(theme),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                Text(
                  authenticationStore.getExpirationDate(),
                  style: LelloTextStyles.subBody(theme),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copiar codigo',
                  onPressed: () async {
                    var token = authenticationStore.getRefreshToken();
                    Clipboard.setData(ClipboardData(text: token));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValue(BuildContext context, String value) {
    ThemeData theme = Theme.of(context);
    if (value.isNotEmpty) {
      return Text(value, style: LelloTextStyles.subBody(theme));
    } else {
      return Text(getString(context, "not_informed"),
          style: LelloTextStyles.caption(theme));
    }
  }
}
