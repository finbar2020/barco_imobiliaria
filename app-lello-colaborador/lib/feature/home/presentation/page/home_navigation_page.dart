import 'dart:convert';
import 'dart:developer';

import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/messaging/message_handler.dart'
    as PushMessageHandler;
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/home/presentation/bloc/home_bloc.dart';
import 'package:colaborador/feature/home/presentation/bloc/home_state.dart';
import 'package:colaborador/feature/home/presentation/controllers/home_controller.dart';
import 'package:colaborador/feature/home/presentation/controllers/register_point_controller.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dialog_manager.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';
import 'package:colaborador/feature/home/presentation/widget/home_navigation_loaded_offline_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/home_navigation_loaded_online_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/ghost_notification/data/model/ghost_notification_model.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/messaging/use_case/ghost_notification_usecase.dart';

Future<Map<String, dynamic>>? myBackgroundMessageHandler(
    Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];

    if (kDebugMode) {
      log('Home Push Notification Teste $data');
    }
    if (data is Map) {
      return Future.value(Map<String, dynamic>.from(data));
    }
    return null;
  }
  return null;
}

class HomeNavigationPage extends StatefulWidget {
  const HomeNavigationPage({Key? key}) : super(key: key);

  @override
  State<HomeNavigationPage> createState() => _HomeNavigationPageState();
}

class _HomeNavigationPageState extends State<HomeNavigationPage>
    with WidgetsBindingObserver {
  final HomeController controller =
      ApplicationContainer.instance().resolve<HomeController>();
  final RegisterPointController registerController =
      ApplicationContainer.instance().resolve<RegisterPointController>();
  final HomeDialogBloc dialogBloc =
      ApplicationContainer.instance().resolve<HomeDialogBloc>();
  NotificationController notificationController =
      ApplicationContainer.instance().resolve<NotificationController>();
  final InactivityCubit inactivityCubit =
      ApplicationContainer.instance().resolve<InactivityCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.colaboradorHomeTimerStart();
    controller.setUpConnectivity();
    controller.ghostNotificationUsecase =
        ApplicationContainer.instance().resolve<GhostNotificationUsecase>();
  }

  @override
  dispose() {
    controller.connectivitySubscription!.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        verifyLogoutGhostNotification();
        controller.sessionSubscription();
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeDialogBloc, HomeDialogState>(
          bloc: dialogBloc,
          listener: (context, state) {
            if (state is NotificationPermissionState) {
              Navigator.pushNamed(
                  context, ApplicationRoute.permissionNotification);
            }
          },
        ),
      ],
      child: PushMessageHandler.MessageHandler(
        notificationController: notificationController,
        appWidget: BlocConsumer<SessionBloc, SessionState>(
          bloc: controller.sessionBloc,
          listener: (context, state) {
            if (state is SessionFailedState) {
              inactivityCubit.cancel();
              Navigator.pushReplacementNamed(
                  context, SharedApplicationRoute.expiredSession);
            }
            if (state is SessionExpiredTabletState) {
              Navigator.pushReplacementNamed(
                  context, SharedApplicationRoute.login);
            } else if (state is SessionLoadedState &&
                controller.authenticationStore.bloc.state
                    is AuthenticatedState) {
              registerFcm(state);
            }
          },
          builder: (context, state) {
            if (state is SessionInitialState || state is SessionLoadingState) {
              return const LoadingHomeWidget();
            }
            if (state is SessionLoadedState) {
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) {
                  controller.getDigitalPoints();
                  notificationController.getNotificationList();
                },
              );
              return HomeBlocBuilder(
                sessionState: state,
                registerController: registerController,
                controller: controller,
                notificationController: notificationController,
              );
            }
            if (state is SessionFailedState) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.pushReplacementNamed(
                      context, SharedApplicationRoute.expiredSession);
                },
              );
              return const SizedBox.shrink();
            }
            if (state is SessionExpiredTabletState) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.pushReplacementNamed(
                      context, SharedApplicationRoute.login);
                },
              );
              return const SizedBox.shrink();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  registerFcm(SessionLoadedState sessionBloc) {
    controller.homeBloc.registerFcmToken(sessionBloc.session.me.condominiums);
  }

  verifyLogoutGhostNotification() async {
    var preferences = await getSharedPreference();
    String? ghost =
        preferences.getString(SharedPreferencesKeys.ghostNotificationLogout);
    if (ghost != null && ghost.isNotEmpty) {
      GhostNotificationModel model = _deserialize(ghost);
      await preferences.setString(
          SharedPreferencesKeys.ghostNotificationLogout, "");
      controller.ghostNotificationUsecase.call(GhostNotificationParams(
        id: model.id!,
        type: "LIMPEZA_DADOS",
      ));
    }
  }

  Future<SharedPreferences> getSharedPreference() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.reload();
    return instance;
  }

  GhostNotificationModel _deserialize(String serialized) =>
      GhostNotificationModel.fromJson(json.decode(serialized));
}

class LoadingHomeWidget extends StatelessWidget {
  const LoadingHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: LelloTheme.palleteOf(theme).customColor(),
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            SizedBox(height: Dimens.spacingLarge),
            Text(
              getString(context, "home_page_fetching_profile"),
              style: LelloTextStyles.title(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            Text(
              getString(context, "please_wait"),
              style: LelloTextStyles.subBody(theme),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeBlocBuilder extends StatelessWidget {
  final RegisterPointController registerController;
  final HomeController controller;
  final SessionLoadedState sessionState;
  final NotificationController notificationController;
  const HomeBlocBuilder({
    Key? key,
    required this.registerController,
    required this.controller,
    required this.sessionState,
    required this.notificationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: controller.homeBloc,
      builder: (context, homeState) {
        if (homeState is HomeLoadedState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              SharedPreferences.getInstance().then(
                (value) => HomeDialogManager.showHomeDialog(
                  context,
                  controller.isConnected,
                  value,
                  digitalPoints: homeState.digitalPoints,
                ),
              );
            },
          );
          if (controller.isConnected) {
            return HomeNavigationLoadedOnlineWidget(
              registerController: registerController,
              controller: controller,
              digitalPoints: homeState.digitalPoints,
              notificationController: notificationController,
            );
          } else {
            return HomeNavigationLoadedOfflineWidget(
              session: sessionState.session,
              digitalPoints: homeState.digitalPoints,
              notificationController: notificationController,
            );
          }
        }
        if (homeState is HomeLoadingState) {
          return const LoadingHomeWidget();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
