import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/core/widgets/hex_color.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/modal/theme_color_dialog.dart';
import 'package:shared_features/core/widgets/color_palette_widget.dart';
import 'package:shared_features/core/widgets/half_color_icon.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

class MeProfileInfoWidget extends StatefulWidget {
  final Me me;
  final bool isGeneric;
  final Function(ThemeData changeTheme)? changeTheme;
  MeProfileInfoWidget(
      {Key? key, required this.me, this.isGeneric = false, this.changeTheme})
      : super(key: key);

  @override
  State<MeProfileInfoWidget> createState() => _MeProfileInfoWidgetState();
}

class _MeProfileInfoWidgetState extends State<MeProfileInfoWidget> {
  final SessionBloc sessionBloc = ApplicationContainer.instance().resolve();
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        if (widget.me.cpf != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
                widget.me.cpf!.length > 14
                    ? getString(context, "cnpj")
                    : getString(context, "me_cpf_title"),
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: _buildValue(context, "${widget.me.cpf?.formatCpfCnpj()}"),
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(getString(context, "profile_update_email"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: _buildValue(context, widget.me.email ?? ""),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(getString(context, "phone"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: _buildValue(context, widget.me.phone ?? ""),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(getString(context, "password"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: Text("******", style: LelloTextStyles.subBody(theme)),
        ),
        if (!env.isProduction)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Token Firebase A/B",
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copiar codigo',
                  onPressed: () async {
                    Clipboard.setData(ClipboardData(
                        text: await FirebaseInstallations.instance.getToken()));
                  },
                ),
              ],
            ),
          ),
        if (!env.isProduction)
          ListTile(
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
        if (!env.isProduction)
          ListTile(
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
        if (!env.isProduction &&
            authenticationStore.bloc.state is AuthenticatedState)
          ListTile(
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
        if (!env.isProduction && widget.isGeneric)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title:
                Text("Cores do Tema", style: LelloTextStyles.bodyBold(theme)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: HalfColorIcon(
                      color1: theme.colorScheme.primary,
                      color2: theme.colorScheme.secondary),
                  onPressed: () {
                    _openSelectTheme(theme);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ColorPaletteWidget(
                          colorPalette: LelloTheme.palleteOf(theme),
                        ),
                      ),
                    );
                  },
                  child: const Text('Show Color Palette'),
                ),
              ],
            ),
          ),
        if (!env.isProduction)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Drop Sessao", style: LelloTextStyles.bodyBold(theme)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.error),
                  tooltip: 'Copiar codigo',
                  onPressed: () async {
                    sessionBloc.logout(restartApp: true);
                  },
                ),
              ],
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

  void _openSelectTheme(ThemeData theme) {
    showDialog<ThemeColorValue?>(
      context: context,
      builder: (context) => ThemeColorDialog(
        initialPrimaryColor: theme.colorScheme.primary,
        initialSecondaryColor: theme.colorScheme.secondary,
        initialIsDark: theme.brightness == Brightness.dark,
      ),
    ).then(
      (value) {
        if (value != null) {
          Color? primary;
          Color? secondary;
          bool? isDark;
          if (value.primaryColor == null || value.secondaryColor == null) {
            //retornar para padrao condominio
            sessionBloc.updateThemeColor(null);
            var layout = sessionBloc.state.session?.condominium!.layout;
            primary = layout?.primary.isNotEmpty == true
                ? HexColor(layout!.primary)
                : null;
            secondary = layout?.secondary.isNotEmpty == true
                ? HexColor(layout!.secondary)
                : null;
            isDark = false;
          } else {
            primary = value.primaryColor;
            secondary = value.secondaryColor;
            isDark = value.isDark;
            sessionBloc.updateThemeColor(value);
          }
          ColorPallete initialTheme = isDark ?? false
              ? DarkPallete(primary: primary, secondary: secondary)
              : LightPallete(primary: primary, secondary: secondary);
          var newTheme = LelloTheme.themeWithPallete(
              isDark ?? false ? Brightness.dark : Brightness.light,
              initialTheme);
          widget.changeTheme!.call(newTheme);
        }
      },
    );
  }
}
