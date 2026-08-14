import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/hex_color.dart';
import 'package:lello/environment/environment.prod.dart';
import 'package:lello/environment/environment.staging.dart';
import 'package:shared_features/core/widgets/color_palette_widget.dart';
import 'package:shared_features/core/widgets/half_color_icon.dart';
import 'package:lello/feature/me/presentation/bloc/me_state.dart';
import 'package:lello/feature/me/presentation/controller/me_controller.dart';
import 'package:lello/feature/me/presentation/page/me_delete_account_error.dart';
import 'package:lello/feature/me/presentation/page/me_delete_account_success.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/core/modal/theme_color_dialog.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';
import 'package:http/http.dart' as http;

class MePage extends StatefulWidget {
  final Function(ThemeData changeTheme)? changeTheme;
  final bool isGeneric;
  const MePage({super.key, this.isGeneric = false, this.changeTheme});

  @override
  MePageState createState() => MePageState();
}

class MePageState extends State<MePage> {
  final SessionBloc sessionBloc = ApplicationContainer.instance().resolve();
  final AccessTokenLocalDataSource authStore =
      ApplicationContainer.instance().resolve();
  final MeController controller =
      ApplicationContainer.instance().resolve<MeController>();
  late final Future<void> pipeline;
  late final TextEditingController envUrlController;
  late final AuthenticationStore authenticationStore;
  late final Environment env;
  final TextEditingController _hostnameController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pipeline = controller.pipeline();
    env = ApplicationContainer.instance().resolve<Environment>();
    authenticationStore = ApplicationContainer.instance().resolve();
    _lastClickTime = DateTime.now();
    if (env.isProduction == false &&
        env.apiUrl != StagingEnvironment().apiUrl) {
      var url = Uri.parse(env.apiUrl);
      _hostnameController.text = url.host;
      _portController.text = url.port.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    const editBulletSize = 32.0;
    Map<String, String>? customHeader =
        controller.authenticationStore.getCustomHeader();
    final theme = Theme.of(context);
    final me = controller.me;
    return FutureBuilder(
      future: pipeline,
      builder: (context, snapshot) {
        return BlocListener(
          bloc: controller.authenticationStore.bloc,
          listener: (context, state) {
            if (state is UnauthenticatedState) {
              if (widget.isGeneric) {
                widget.changeTheme?.call(LelloTheme.viverDefaultTheme);
              }
              Navigator.pushNamedAndRemoveUntil(
                  context, SharedApplicationRoute.login, (route) => false,
                  arguments: AuthArguments(goToRegister: false));
            }
          },
          child: WillPopScope(
            onWillPop: () async {
              if (controller.meBloc.state is MeEditState) {
                //controller.revertEdit();
                return false;
              }
              if (controller.meBloc.state is MeEditPasswordState) {
                controller.beginEdit();
                return false;
              }
              return true;
            },
            child: Theme(
              data: theme,
              child: Scaffold(
                appBar: PrimaryAppBar(
                  title: getString(context, "profile_title"),
                  theme: theme,
                  actions: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: Dimens.spacing),
                        child: Text(
                          "${controller.lastGetMeUpdateDifference}${controller.lastSwitchRolesUpdateDifference}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: LelloTheme.palleteOf(theme).grey(),
                              fontSize: 10),
                        ),
                      ),
                    )
                  ],
                ),
                body: BlocConsumer(
                  bloc: controller.meBloc,
                  listener: (context, state) {
                    if (state is MeUploadProfileFailedState) {
                      Navigator.pushNamed(context, ApplicationRoute.meFailure);
                    }
                    if (state is MeDeleteAccountSuccessState) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeDeleteAccountSuccessPage(),
                        ),
                      );
                    }
                    if (state is MeDeleteAccountFailedState) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MeDeleteAccountErrorPage(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is MeLoadingState ||
                        state is MeDeleteLoadingState) {
                      return const Column(
                        children: [
                          Expanded(
                            child: LoadingWidget(),
                          ),
                        ],
                      );
                    }
                    if (state is MeLoadFailedState) {
                      return Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(Dimens.spacingMedium),
                              child: ErrorHandlingWidget(
                                reTryFunction: () {
                                  controller.pipeline();
                                },
                                backFunction: () =>
                                    Navigator.pop(context, true),
                                isProduction: env.isProduction,
                                error: state.failure.error.toString(),
                                errorCode: state.failure.code.toString(),
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 30),
                            child: TertiaryButton(
                              text: getString(context, "logout"),
                              onPressed: controller.logout,
                            ),
                          )
                        ],
                      );
                    }
                    if (state is MeLoadedState) {
                      return ListView(
                        children: [
                          GestureDetector(
                            onTap: _onTextTapped,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: Dimens.spacingSmall),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            getString(context, "version"),
                                            style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold)
                                                .copyWith(
                                                    color: LelloTheme.palleteOf(
                                              theme,
                                            ).text()),
                                          ),
                                          Text(
                                            controller.version!,
                                            style: const TextStyle(fontSize: 10)
                                                .copyWith(
                                                    color: LelloTheme.palleteOf(
                                              theme,
                                            ).text()),
                                          ),
                                          SizedBox(
                                              height: Dimens.spacingXSmall),
                                          if (!env.isProduction)
                                            Text(
                                              env.name,
                                              style:
                                                  const TextStyle(fontSize: 10)
                                                      .copyWith(
                                                color:
                                                    LelloTheme.palleteOf(theme)
                                                        .purpleText(),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(Dimens.spacing),
                            child: Column(
                              children: [
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      Modal.showBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Wrap(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(
                                                    Dimens.spacingMedium),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        await controller
                                                            .choosePhoto(
                                                                imageSource:
                                                                    ImageSource
                                                                        .camera);
                                                      },
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/ic_camera.svg",
                                                            width: 45,
                                                            height: 45,
                                                          ),
                                                          SizedBox(
                                                              height: Dimens
                                                                  .spacingLarge),
                                                          Text(
                                                            getString(context,
                                                                "camera"),
                                                            style:
                                                                LelloTextStyles
                                                                    .bodyBold(
                                                              theme,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: Dimens
                                                            .spacingLarge),
                                                    TextButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        await controller
                                                            .choosePhoto(
                                                                imageSource:
                                                                    ImageSource
                                                                        .gallery);
                                                      },
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/ic_gallery.svg",
                                                            width: 45,
                                                            height: 45,
                                                          ),
                                                          SizedBox(
                                                              height: Dimens
                                                                  .spacingLarge),
                                                          Text(
                                                            getString(context,
                                                                "gallery"),
                                                            style:
                                                                LelloTextStyles
                                                                    .bodyBold(
                                                              theme,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Center(
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: (state.me?.pictureLink
                                                              .isNotEmpty ==
                                                          true &&
                                                      customHeader != null)
                                                  ? Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10000.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          httpHeaders:
                                                              customHeader,
                                                          imageUrl:
                                                              "${env.apiUrl}/${state.me!.pictureLink}",
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: const Center(
                                                                child:
                                                                    LoadingWidget()),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              SvgPicture.asset(
                                                                  "assets/user_placeholder.svg",
                                                                  width: 32),
                                                        ),
                                                      ),
                                                    )
                                                  : SvgPicture.asset(
                                                      "assets/user_placeholder.svg",
                                                      width: 32)),
                                          Positioned(
                                            right: 0 - (editBulletSize / 2),
                                            bottom: 0,
                                            top: 0,
                                            child: Container(
                                              width: editBulletSize,
                                              height: editBulletSize,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .background(),
                                                    width: 3),
                                                color: theme.primaryColor,
                                              ),
                                              child: SvgPicture.asset(
                                                "assets/ic_edit.svg",
                                                width: 3,
                                                height: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Dimens.spacing),
                                Text(state.me!.name ?? "",
                                    style: LelloTextStyles.headline(theme),
                                    textAlign: TextAlign.center),
                                TertiaryButton(
                                  style: TextStyle(color: theme.primaryColor),
                                  text: getString(context, "logout"),
                                  onPressed: controller.logout,
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(getString(context, "cpf"),
                                      style: LelloTextStyles.bodyBold(theme)),
                                  subtitle: Text(
                                    state.me!.cpf!,
                                    style: LelloTextStyles.subBody(theme),
                                    //
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                      getString(
                                          context, "profile_update_email"),
                                      style: LelloTextStyles.bodyBold(theme)),
                                  subtitle: Text(
                                    state.me!.email!,
                                    style: LelloTextStyles.subBody(theme),
                                    //
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(getString(context, "phone"),
                                      style: LelloTextStyles.bodyBold(theme)),
                                  subtitle: Text(
                                    state.me?.phone ??
                                        getString(context, 'not_informed'),
                                    style: me?.phone != null
                                        ? LelloTextStyles.subBody(theme)
                                        : LelloTextStyles.caption(theme),
                                    //
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(getString(context, "password"),
                                      style: LelloTextStyles.bodyBold(theme)),
                                  subtitle: Text("******",
                                      style: LelloTextStyles.subBody(theme)),
                                ),
                                if (!env.isProduction)
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text("Token Firebase A/B",
                                        style: LelloTextStyles.bodyBold(theme)),
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.copy),
                                          tooltip: 'Copiar codigo',
                                          onPressed: () async {
                                            Clipboard.setData(ClipboardData(
                                                text:
                                                    await FirebaseInstallations
                                                        .instance
                                                        .getToken()));
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.copy),
                                          tooltip: 'Copiar codigo',
                                          onPressed: () async {
                                            var token = await FirebaseMessaging
                                                .instance
                                                .getToken();
                                            if (token != null) {
                                              Clipboard.setData(
                                                  ClipboardData(text: token));
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Token não encontrado");
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.copy),
                                          tooltip: 'Copiar ID',
                                          onPressed: () async {
                                            String id =
                                                await FirebaseInstallations
                                                    .instance
                                                    .getId();
                                            Clipboard.setData(
                                                ClipboardData(text: id));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                if (!env.isProduction &&
                                    authenticationStore.bloc.state
                                        is AuthenticatedState)
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text("Refresh Token",
                                        style: LelloTextStyles.bodyBold(theme)),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          authenticationStore.getRefreshToken(),
                                          style: LelloTextStyles.subBody(theme),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          authenticationStore
                                              .getExpirationDate(),
                                          style: LelloTextStyles.subBody(theme),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.copy),
                                          tooltip: 'Copiar codigo',
                                          onPressed: () async {
                                            var token = authenticationStore
                                                .getRefreshToken();
                                            Clipboard.setData(
                                                ClipboardData(text: token));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                if (!env.isProduction &&
                                    authenticationStore.bloc.state
                                        is AuthenticatedState)
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text("Drop Sessao",
                                        style: LelloTextStyles.bodyBold(theme)),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.error),
                                          tooltip: 'Copiar codigo',
                                          onPressed: () async {
                                            sessionBloc.logout(
                                                restartApp: true);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                if (!env.isProduction && widget.isGeneric)
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text("Cores do Tema",
                                        style: LelloTextStyles.bodyBold(theme)),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: HalfColorIcon(
                                              color1: theme.colorScheme.primary,
                                              color2:
                                                  theme.colorScheme.secondary),
                                          onPressed: () {
                                            _openSelectTheme(theme);
                                          },
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ColorPaletteWidget(
                                                  colorPalette:
                                                      LelloTheme.palleteOf(
                                                          theme),
                                                ),
                                              ),
                                            );
                                          },
                                          child:
                                              const Text('Show Color Palette'),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (!env.isProduction && _showEnvConfig)
                                  ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text("Url do Ambiente",
                                          style:
                                              LelloTextStyles.bodyBold(theme)),
                                      subtitle: Row(
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: TextField(
                                              controller: _hostnameController,
                                              decoration: const InputDecoration(
                                                hintText: 'Hostname',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: Dimens.spacingXSmall),
                                          Flexible(
                                            flex: 1,
                                            child: TextField(
                                              controller: _portController,
                                              decoration: const InputDecoration(
                                                hintText: 'Porta',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: Dimens.spacingXSmall),
                                          ElevatedButton(
                                            onPressed: () {
                                              String url =
                                                  'http://${_hostnameController.text}:${_portController.text}';
                                              final uri =
                                                  Uri.parse('$url/_health');
                                              if (uri.host ==
                                                  Uri.parse(
                                                          ProductionEnvironment()
                                                              .apiUrl)
                                                      .host) {
                                                Fluttertoast.showToast(
                                                    msg: 'URL inválida');
                                                return;
                                              }

                                              http.get(uri).then((response) {
                                                if (response.statusCode ==
                                                    200) {
                                                  SharedPreferences
                                                          .getInstance()
                                                      .then((prefs) {
                                                    prefs.setString(
                                                        SharedPreferencesKeys
                                                            .customURL,
                                                        "$url/api/v4");
                                                  });
                                                  Fluttertoast.showToast(
                                                      msg: 'URL válida');
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: 'URL inválida');
                                                }
                                              }).timeout(
                                                const Duration(seconds: 5),
                                                onTimeout: () {
                                                  Fluttertoast.showToast(
                                                      msg: 'URL inválida');
                                                },
                                              ).catchError((error) {
                                                Fluttertoast.showToast(
                                                    msg: 'URL inválida');
                                              });
                                              SharedPreferences.getInstance()
                                                  .then((prefs) {
                                                prefs.setString(
                                                    SharedPreferencesKeys
                                                        .customURL,
                                                    envUrlController.text);
                                              });
                                            },
                                            child: const Text('Aplicar'),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _hostnameController.text = "";
                                              _portController.text = "";
                                              SharedPreferences.getInstance()
                                                  .then((prefs) {
                                                prefs.setString(
                                                    SharedPreferencesKeys
                                                        .customURL,
                                                    StagingEnvironment()
                                                        .apiUrl);
                                              });
                                            },
                                            icon: const Icon(Icons.delete),
                                          )
                                        ],
                                      )),
                                Column(
                                  children: [
                                    SecondaryButton(
                                      text: getString(context, "edit"),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, ApplicationRoute.meEdit);
                                      },
                                    ),
                                    SizedBox(height: Dimens.spacingMedium),
                                  ],
                                ),
                                SecondaryButton(
                                  text: getString(context, "delete_account"),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => LogoutButton(
                                        onTap: () {
                                          controller.deleteUserAccount(
                                            me: state.me!,
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
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
            var layout = sessionBloc.state.session?.selectedCondominium!.layout;
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

  int _clickCount = 0;
  late DateTime _lastClickTime;
  final int _requiredClicks = 5;
  final Duration _clickTimeout = const Duration(seconds: 2);
  bool _showEnvConfig = false;
  void _onTextTapped() {
    final now = DateTime.now();
    if (now.difference(_lastClickTime) > _clickTimeout) {
      // Reset the counter if the timeout has passed
      _clickCount = 0;
    }

    _lastClickTime = now;
    _clickCount++;

    if (_clickCount == _requiredClicks) {
      setState(() {
        _showEnvConfig = true;
      });
      _clickCount = 0; // Reset the counter after activation
    }
  }
}

class LogoutButton extends StatelessWidget {
  final Function() onTap;
  const LogoutButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 50.0,
              color: Colors.black,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "delete_account_dialog_title"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.titleSmall(theme)!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "delete_account_dialog_subtitle"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "delete_account_dialog_subtitle_complement"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme),
            ),
            SizedBox(height: Dimens.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    getString(context, "cancel").toUpperCase(),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onTap,
                  child: Text(
                    getString(context, "resin_receipts_exclude").toUpperCase(),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
