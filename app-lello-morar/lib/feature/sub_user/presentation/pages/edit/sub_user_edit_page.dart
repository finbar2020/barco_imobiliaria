import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:flutter/painting.dart' as painting;
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/me/presentation/pages/me_page.dart';
import 'package:morar/feature/me/presentation/widgets/me_edit_phone.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_edit_blocked_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_edit_conclude_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_edit_registered_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_edit_unregistered_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_remove_success.dart';
import 'package:morar/feature/sub_user/presentation/pages/sub_user_success.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../../core/widgets/loading_widget.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../generated/l10n.dart';
import '../../../../access_control/domain/entity/access_control_invite_forward_type.dart';
import '../../../../access_control/domain/entity/access_control_send_invite.dart';
import '../../../../access_control/domain/entity/access_invite_user_type_enum.dart';
import '../../../../session/domain/entity/session.dart';
import '../../bloc/sub_user_edit_bloc.dart';
import '../../bloc/sub_users_bloc.dart';
import '../../controllers/sub_user_edit_controller.dart';
import '../send_invite/sub_user_send_invite_error.dart';
import '../send_invite/sub_user_send_invite_success.dart.dart';
import '../service/sub_user_service_on_page.dart';

class SubUserEditPage extends StatefulWidget {
  const SubUserEditPage({Key? key}) : super(key: key);

  @override
  _SubUserEditPageState createState() => _SubUserEditPageState();
}

class _SubUserEditPageState extends State<SubUserEditPage> {
  final _controller =
      ApplicationContainer.instance().resolve<SubUserEditController>();

  bool _isLoading = false;
  late StreamSubscription _meSubscription;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller.pipeline();
    _meSubscription = _controller.blocMe.stream.listen(_onMeStateChanged);
  }

  @override
  void dispose() {
    _controller.activeEditMainUser = false;
    _meSubscription.cancel();
    super.dispose();
  }

  void _onMeStateChanged(dynamic state) {
    if (state is MeEditState) {
      _controller.editBloc.add(SubUserEditLoadingEvent());
    }
  }

  bool _isSecondNameMasked(String fullName) {
    final names = fullName.split(' ');
    if (names.length < 2) return false;
    final first = names[0];
    final second = names[1];
    final hasVisibleFirst =
        first.runes.any((c) => String.fromCharCode(c) != '*');
    final allMaskedSecond =
        second.runes.every((c) => String.fromCharCode(c) == '*');
    return hasVisibleFirst && allMaskedSecond;
  }

  bool get _canShowMoreOptions {
    final main = _controller.mainUser;
    final selected = _controller.userSelected;
    if (main.id == selected?.id) return false;
    if (main.role == 'morar.proprietario') return true;
    if (main.role == 'morar.inquilino' && selected != null) {
      return !_isSecondNameMasked(selected.name ?? '');
    }
    return false;
  }

  List<PopupMenuEntry> _buildMoreOptions(
      BuildContext context, ThemeData theme) {
    final blocked = _controller.userSelected?.blocked ?? false;
    return [
      if (!blocked)
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.block),
              SizedBox(width: Dimens.spacingSmall),
              Text(getString(context, 'block'))
            ],
          ),
          onTap: () => _showDialogBlockUser(context),
        ),
      PopupMenuItem(
        child: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: Dimens.spacingSmall),
            Text(getString(context, 'exclude'),
                style: TextStyle(color: Colors.red))
          ],
        ),
        onTap: () => _showRemoveUserDialog(context, theme),
      ),
    ];
  }

  bool get _shouldShowSaveButton {
    final selected = _controller.userSelected;
    return selected?.blocked == false &&
            _controller.mainUser.role == 'morar.proprietario' ||
        _controller.mainUser.role == 'morar.inquilino' &&
            !_isSecondNameMasked(
              selected?.name ?? '',
            );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final env = ApplicationContainer.instance().resolve<Environment>();

    return Scaffold(
      appBar: CustomAppBar(
        title: getString(context, 'edit'),
        useGetString: false,
        onPressed: () {
          _controller.getSubUsers();
          Navigator.pop(context);
        },
        actions: _canShowMoreOptions
            ? [
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () => showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(100, 100, 0, 0),
                    items: _buildMoreOptions(context, theme),
                  ),
                )
              ]
            : [],
      ),
      body: MultiBlocListener(
        listeners: [_meListener(context), _editListener(context)],
        child: BlocConsumer(
          bloc: _controller.editBloc,
          listener: (_, __) {},
          builder: (context, state) {
            if (state is SubUserEditLoadingState ||
                state is SubUserDeleteLoadingState) {
              return _buildLoading();
            }
            if (state is SubUserEditErrorState ||
                state is SubUserDeleteErrorState) {
              return _buildError(state, env);
            }
            if (state is SubUserEditSendTokenState) {
              return _buildSendToken(state);
            }
            if (state is SubUserEditLoadedState ||
                state is SubUserEditSuccessState) {
              return _buildMainContent(theme);
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: LoadingWidget(),
    );
  }

  Widget _buildError(dynamic state, Environment env) {
    final error = (state is SubUserEditErrorState)
        ? state.error
        : (state as SubUserDeleteErrorState).error;
    return Center(
      child: ErrorHandlingWidget(
        reTryFunction: () => _controller.pipeline(),
        backFunction: () => Navigator.pop(context, true),
        isProduction: env.isProduction,
        error: error?.error.toString() ?? '',
        errorCode: error?.code.toString() ?? '',
      ),
    );
  }

  Widget _buildSendToken(SubUserEditSendTokenState state) {
    return BlocProvider(
      create: (_) =>
          ApplicationContainer.instance().resolve<CodeValidationBloc>(),
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: CodeValidationPage(
          appContainer: ApplicationContainer.instance(),
          codeRequest: state.codeRequest,
          digits: 4,
          onSuccess: (validation) =>
              _controller.meController.mapSave(codeValidation: validation),
          onRestart: () => _controller.meController.resendToken(),
        ),
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme) {
    final session = _controller.session;
    return Column(
      children: [
        _buildHeader(theme, session),
        SizedBox(height: Dimens.spacingMedium),
        Expanded(child: _buildFormContent()),
        if (_shouldShowSaveButton) _buildSaveButton(theme),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, Session session) {
    final name = session.condominium?.name ?? '';
    final unit = session.unity?.title ?? '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: LelloTheme.palleteOf(theme).backgroundDark(),
      width: double.infinity,
      height: Dimens.spacingLarge,
      child: Center(
        child: Text(
          '$name - $unit',
          overflow: TextOverflow.ellipsis,
          style: LelloTextStyles.body(theme),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    final selected = _controller.userSelected!;
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 80),
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selected.blocked == true)
              SubUserEditBlockedPage()
            else if (selected.registered == true ||
                _isSecondNameMasked(selected.name ?? ''))
              SubUserEditRegisteredPage(
                formkey: _formKey,
              )
            else
              SubUserEditUnregisteredPage(formkey: _formKey),
            if (selected.blocked == false) ...[
              SizedBox(height: Dimens.spacingLarge),
              AppAccessWidget(model: selected, controller: _controller),
              SizedBox(height: Dimens.spacing),
              if (_controller.useFacialBiometric) UseFacialBiometricsWidget(),
            ],
            SizedBox(height: Dimens.spacing),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: PrimaryButton(
        child: _isLoading
            ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
            : null,
        text: _controller.editMainUser
            ? getString(context, 'edit')
            : getString(context, 'save'),
        onPressed: _onSavePressed,
      ),
    );
  }

  void _onSavePressed() async {
    if (_controller.editMainUser) {
      Navigator.of(context).pop();
      await Navigator.of(context).pushNamed(
        ApplicationRoute.me,
        arguments: MePageArgs(autoEditMode: true),
      );
      return;
    }
    if (_formKey.currentState?.validate() == false) return;
    if (_isLoading) return;

    final selected = _controller.userSelected!;
    if (selected.mainUser && _controller.activeEditMainUser) {
      if (_formKey.currentState!.validate()) {
        setState(() => _controller.activeEditMainUser = true);
        await _controller.updateMainUser();
      }
      return;
    }
    if (selected.role != null && selected.role != 'morar.proprietario') {
      setState(() => _isLoading = true);
      await _controller.subUserUpdate(isBlock: false, isUseApp: false);
      setState(() => _isLoading = false);
      Navigator.pop(context);
      Flushbar(
          duration: Duration(seconds: 3),
          message: getString(context, 'resident_save_profile'))
        ..show(context);
      await _controller.getSubUsers();
    } else {
      Flushbar(
          duration: Duration(seconds: 3),
          message: getString(context, 'resident_need_profile'))
        ..show(context);
    }
  }

  BlocListener _meListener(BuildContext context) {
    return BlocListener(
      bloc: _controller.blocMe,
      listener: (context, state) async {
        if (state is MeEditPhoneChangedState &&
            state is! MeEditRequestingCodeState &&
            state is! MeEditRequestCodeFailedState) {
          await showModalBottomSheet(
            context: context,
            isDismissible: false,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
            builder: (_) => SingleChildScrollView(
              child: MeEditPhoneInfo(
                cancelOnPressed: () {
                  Navigator.pop(context);
                  _controller.activeEditMainUser = true;
                  _controller.editBloc.add(SubUserEditLoadedEvent());
                },
                controller: _controller.meController,
              ),
            ),
          );
        }
        if (state is MeEditValidateCodeState) {
          Navigator.of(context).pop();
          _controller.editBloc
              .add(SubUserEditSendTokenEvent(codeRequest: state.codeRequest!));
        }
        if (state is MeEditSucceededState) {
          Navigator.pop(context);
          TextInput.finishAutofillContext(shouldSave: true);
          _controller.meController.meLoad(forceUpdate: true);
          _controller.activeEditMainUser = false;
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SubUserSuccessPage()));
        } else if (state is MeEditFailedState ||
            state is MeEditRequestCodeFailedState) {
          _controller.editBloc.add(SubUserEditErrorEvent());
        }
      },
    );
  }

  BlocListener _editListener(BuildContext context) {
    return BlocListener(
      bloc: _controller.editBloc,
      listener: (context, state) async {
        if (state is SubUserEditSuccessState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SubUserSuccessPage()));
        } else if (state is SubUserEditConcludeState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SubUserEditConcludePage(
                      blocked: state.subUser.blocked!,
                      session: _controller.session)));
        } else if (state is SubUserDeleteSuccessState) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SubUserRemoveSuccessPage(
                      name: _controller.userSelected?.name ?? '')));
          _controller.getSubUsers();
        } else if (state is CheckServiceOnlineState) {
          Navigator.pushReplacementNamed(
              context, ApplicationRoute.subUserServiceOn,
              arguments:
                  SubUserServiceOnPageArgs(subUser: _controller.userSelected!));
        } else if (state is CheckServiceOfflineState) {
          Navigator.pushNamed(context, ApplicationRoute.subUserServiceOff);
        } else if (state is SubUserEditSendInviteSuccessState) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => SendInviteSuccessPage()));
        } else if (state is SubUserEditSendInviteErrorState) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => SendInviteErrorPage()));
        }
      },
    );
  }

  void _showDialogBlockUser(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Você optou por bloquear esse usuário.',
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.body(theme)),
              SizedBox(height: 8),
              Text('Deseja continuar?',
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.bodyBold(theme)),
              SizedBox(height: 16),
              PrimaryButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _controller.subUserUpdate(isBlock: true, isUseApp: false);
                  },
                  text: 'Sim, bloquear'),
              SizedBox(height: 8),
              SecondaryButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: 'Não, quero voltar',
                  buttonBorderColor: LelloTheme.palleteOf(theme).primary()),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemoveUserDialog(BuildContext context, ThemeData theme) {
    final selected = _controller.userSelected;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(getString(context, "attention"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.titleSmall(theme)!
                      .copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Você tem certeza que deseja excluir',
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.bodyBold(theme)),
              SizedBox(height: 8),
              Text(selected?.name ?? '',
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.bodyBold(theme)
                      ?.copyWith(color: LelloTheme.palleteOf(theme).primary())),
              SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text('Como ', style: LelloTextStyles.bodyBold(theme)),
                  Text(selected?.roleDescription ?? '',
                      style: LelloTextStyles.bodyBold(theme)?.copyWith(
                          color: LelloTheme.palleteOf(theme).primary())),
                  Text(' da sua unidade?',
                      style: LelloTextStyles.bodyBold(theme)),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Ao excluir, este usuário não terá acesso a nada relacionado a unidade e não aparecerá entre os usuários.',
                textAlign: TextAlign.center,
                style: LelloTextStyles.bodyBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).grey()),
              ),
              SizedBox(height: 16),
              PrimaryButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _controller.deleteSubUser();
                  },
                  text: 'Sim, excluir'),
              SizedBox(height: 8),
              SecondaryButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: 'Não, quero voltar',
                  buttonBorderColor: LelloTheme.palleteOf(theme).primary()),
            ],
          ),
        ),
      ),
    );
  }
}

class AppAccessWidget extends StatelessWidget {
  final SubUserEditController controller;
  final SubUser model;

  const AppAccessWidget({
    Key? key,
    required this.controller,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(left: Dimens.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getString(context, 'residents_register_sub_user_app_access'),
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: Dimens.spacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) {
                      if (!(model.useApp ?? false)) {
                        return Row(
                          children: [
                            SvgPicture.asset('assets/bi_phone_blocked.svg'),
                            SizedBox(width: Dimens.spacingSmall),
                            Text(
                              getString(context, "resident_blocked_access_app"),
                              style: TextStyle(
                                color: LightPallete().grey(),
                              ),
                            ),
                          ],
                        );
                      }
                      if (model.useApp! && model.registered!) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/bi_phone.svg'),
                                SizedBox(width: Dimens.spacingSmall),
                                Text(
                                  getString(
                                      context, "resident_installed_access_app"),
                                  style: TextStyle(
                                    color: LightPallete().success(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          SvgPicture.asset(
                            'assets/bi_phone.svg',
                            colorFilter: ColorFilter.mode(
                              LelloTheme.palleteOf(theme).textAccent(),
                              painting.BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: Dimens.spacingSmall),
                          Text(
                            getString(context, "resident_liberated_access_app"),
                            style: TextStyle(
                              color: LightPallete().textAccent(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              if (!model.mainUser)
                SecondaryButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Container(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/ic_exclamation.svg',
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(height: Dimens.spacing),
                              Text(
                                getString(context, "attention"),
                                textAlign: TextAlign.center,
                                style: LelloTextStyles.titleSmall(theme)!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: Dimens.spacingLarge),
                              Text(
                                (!(model.useApp ?? false))
                                    ? getString(context,
                                        "resident_sure_unlock_app_access")
                                    : getString(context,
                                        "resident_sure_lock_app_access"),
                                textAlign: TextAlign.center,
                                style: LelloTextStyles.subtitle(theme),
                              ),
                              SizedBox(height: Dimens.spacingXLarge),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      getString(context, "no").toUpperCase(),
                                      style: LelloTextStyles.subtitle(theme)!
                                          .copyWith(
                                        color:
                                            LelloTheme.palleteOf(theme).text(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Dimens.spacing),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      controller.subUserUpdate(
                                        isUseApp: true,
                                        isBlock: false,
                                      );
                                    },
                                    child: Text(
                                      getString(context, "yes").toUpperCase(),
                                      style: LelloTextStyles.subtitle(theme)!
                                          .copyWith(
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  height: 40,
                  buttonBorderColor: LightPallete().grey(),
                  child: Text(
                    !(model.useApp ?? false)
                        ? getString(context, 'resident_liberate_access_app')
                        : getString(context, 'resident_remove_access_app'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: LightPallete().grey(),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class UseFacialBiometricsWidget extends StatelessWidget {
  UseFacialBiometricsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<SubUserEditController>();
    final theme = Theme.of(context);
    final SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();
    final CircuitBreakerController circuitBreakController =
        ApplicationContainer.instance().resolve<CircuitBreakerController>();

    return Padding(
      padding: EdgeInsets.only(left: Dimens.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: 0.2,
            child: Divider(
              color: LightPallete().textLight(),
              height: 1,
              thickness: 1,
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getString(context, 'residents_register_sub_user_facial_biometrics'),
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: Dimens.spacing),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) {
                      return controller.userSelected!.useFacialBiometric!
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/biometric_registered_icon.svg'),
                                    SizedBox(width: Dimens.spacingSmall),
                                    Text(
                                      getString(context,
                                          "residents_register_sub_user_biometric_registered"),
                                      style: TextStyle(
                                        color: LightPallete().success(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () async {
                                if (controller.userSelected!.mainUser) {
                                  await controller.checkService();
                                  controller.getSubUsers();
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: Container(
                                      padding: const EdgeInsets.all(24.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                "assets/ic_attention.svg",
                                                color:
                                                    LelloTheme.palleteOf(theme)
                                                        .textOpaque(),
                                                width: 50,
                                                height: 50),
                                            SizedBox(height: Dimens.spacing),
                                            Text(
                                              getString(context,
                                                  "residents_invite_dialog_title"),
                                              textAlign: TextAlign.center,
                                              style: LelloTextStyles.subtitle(
                                                      theme)!
                                                  .copyWith(
                                                color:
                                                    LelloTheme.palleteOf(theme)
                                                        .textOpaque(),
                                              ),
                                            ),
                                            SizedBox(height: Dimens.spacing),
                                            Text(
                                              getString(context,
                                                  "residents_invite_dialog_subtitle"),
                                              textAlign: TextAlign.center,
                                              style: LelloTextStyles.subtitle(
                                                      theme)!
                                                  .copyWith(
                                                color:
                                                    LelloTheme.palleteOf(theme)
                                                        .textOpaque(),
                                              ),
                                            ),
                                            SizedBox(
                                                height: Dimens.spacingLarge),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    getString(context, "back")
                                                        .toUpperCase(),
                                                    style:
                                                        LelloTextStyles.subBody(
                                                                theme)!
                                                            .copyWith(
                                                      color:
                                                          LelloTheme.palleteOf(
                                                                  theme)
                                                              .text(),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (controller.userSelected!
                                                            .phone !=
                                                        null) {
                                                      Navigator.pop(context);

                                                      await controller
                                                          .subUserSendInvite(
                                                              entity:
                                                                  AccessControlSendInviteEntity(
                                                        cpf: controller
                                                            .userSelected!.cpf,
                                                        name: controller
                                                            .userSelected!.name,
                                                        phone: controller
                                                            .userSelected!
                                                            .phone,
                                                        forwardType:
                                                            AccessControlInviteForwardType
                                                                .sms,
                                                        userType:
                                                            AccessControlInviteUserType
                                                                .resident,
                                                      ));
                                                    } else {
                                                      Flushbar(
                                                        duration: Duration(
                                                            seconds: 5),
                                                        message: getString(
                                                            context,
                                                            "residents_invite_empty_phone"),
                                                      )..show(context);
                                                    }
                                                  },
                                                  child: Text(
                                                    getString(context, "ok")
                                                        .toUpperCase(),
                                                    style:
                                                        LelloTextStyles.subBody(
                                                                theme)!
                                                            .copyWith(
                                                      color:
                                                          LelloTheme.palleteOf(
                                                                  theme)
                                                              .text(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(controller
                                                .userSelected!.mainUser &&
                                            controller.userSelected!
                                                .useFacialBiometric!
                                        ? 'assets/biometric_registered_icon.svg'
                                        : 'assets/biometric_not_registered_icon.svg'),
                                    SizedBox(width: Dimens.spacingSmall),
                                    Text(
                                      controller.userSelected!.mainUser
                                          ? controller.userSelected!
                                                  .useFacialBiometric!
                                              ? getString(context,
                                                  "residents_register_sub_user_biometric_registered")
                                              : getString(context,
                                                  "residents_register_sub_user_biometric_not_registered")
                                          : getString(context,
                                              "residents_register_sub_user_send_invide"),
                                      style: (controller
                                                  .userSelected!.mainUser &&
                                              controller.userSelected!
                                                  .useFacialBiometric!)
                                          ? TextStyle(
                                              color: LightPallete().success(),
                                            )
                                          : TextStyle(
                                              color: LightPallete().warning(),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  LightPallete().warning(),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    },
                  ),
                ],
              ),
              if (controller.userSelected!.id ==
                      sessionBloc.state.session?.me?.id &&
                  controller.userSelected!.useFacialBiometric! &&
                  controller.biometricImageLink.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: Dimens.spacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SecondaryButton(
                            onPressed: () {
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (_) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(Icons.close,
                                                  color:
                                                      LightPallete().primary()),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        CustomCachedNetworkImage(
                                          link: controller.biometricImageLink,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            height: 40,
                            buttonBorderColor: LightPallete().success(),
                            child: Text(
                              getString(context, 'residents_see_photo'),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: LightPallete().success(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: Dimens.spacing),
                        Flexible(
                          flex: 1,
                          child: StreamBuilder<List<CircuitItemRule>>(
                              stream: circuitBreakController.ruleStream.stream,
                              builder: (context, snapshot) {
                                return CircuitBreakerWidget(
                                  appContainer: ApplicationContainer.instance(),
                                  reference: sessionBloc
                                      .state.session?.condominium?.reference,
                                  applicationRbac: ApplicationRbac
                                      .morarMoradoresBiometriaRecadastro,
                                  rbacEnabled: true,
                                  child: SecondaryButton(
                                    onPressed: () {
                                      controller.checkService().then(
                                          (value) => controller.getSubUsers());
                                    },
                                    height: 40,
                                    buttonBorderColor: LightPallete().warning(),
                                    child: Text(
                                      getString(
                                          context, 'residents_send_new_photo'),
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: LightPallete().warning(),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimens.spacingLarge),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
