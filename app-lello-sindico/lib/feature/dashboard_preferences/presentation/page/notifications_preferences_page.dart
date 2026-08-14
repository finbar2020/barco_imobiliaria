import 'package:essentials/essentials.dart' hide Switch;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/loading_widget.dart';

import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/presentation/bloc/notifications_preferences_bloc.dart';
import 'package:lello/feature/dashboard_preferences/presentation/bloc/notifications_preferences_state.dart';
import 'package:lello/feature/dashboard_preferences/presentation/controller/notifications_preferences_controller.dart';
import 'package:lello/feature/dashboard_preferences/presentation/widget/notifications_preferences_widget.dart';

class NotificationsPreferencesPage extends StatefulWidget {
  const NotificationsPreferencesPage({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) =>
            const NotificationsPreferencesPage(),
      ),
    );
  }

  @override
  State<NotificationsPreferencesPage> createState() =>
      _NotificationsPreferencesPageState();
}

class _NotificationsPreferencesPageState
    extends State<NotificationsPreferencesPage> {
  final controller = ApplicationContainer.instance()
      .resolve<NotificationsPreferencesController>();
  final Environment env =
      ApplicationContainer.instance().resolve<Environment>();
  List<bool> checkList = [];
  List<bool> checkeds = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    controller.getNotificationsPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: BlocConsumer<NotificationsPreferencesBloc,
          NotificationsPreferencesState>(
        bloc: controller.notificationsPreferencesBloc,
        listener: (context, state) {
          if (state is UpdateNotificationsPreferencesLoadedState) {
            Navigator.pushNamed(
                context, ApplicationRoute.notificationsPreferencesSuceeded);
          }
          if (state is NotificationsPreferencesLoadingState) {
            loading = true;
          } else {
            loading = false;
          }
          if (state is NotificationsPreferencesUpdateFailedState) {
            Navigator.pushNamed(
                context, ApplicationRoute.notificationsPreferencesFailure);
          }
        },
        builder: (context, state) {
          return Material(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 16, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/ic_preferences.svg',
                                package: 'shared_features',
                                color: LelloTheme.palleteOf(theme).text(),
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Preferências de notificações",
                                style:
                                    LelloTextStyles.titleBold(theme)!.copyWith(
                                  color: LelloTheme.palleteOf(theme).text(),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Defina as configurações de notificação.",
                            style: LelloTextStyles.bodyBold(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).text(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: notificationPreferencesPageBody(theme, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget notificationPreferencesPageBody(
      ThemeData theme, NotificationsPreferencesState state) {
    if (state is NotificationsPreferencesFailedState) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: ErrorHandlingWidget(
          reTryFunction: () {
            controller.getNotificationsPreferences();
          },
          backFunction: () => Navigator.pop(context, true),
          isProduction: env.isProduction,
          error: state.failure?.error.toString() ?? "",
          errorCode: state.failure?.code.toString() ?? "",
          textReturnButton: "back_to_the_previous_page",
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Column(children: [
                    if (state is NotificationsPreferencesLoadingState)
                      const Expanded(
                        child: Center(
                          child: LoadingWidget(),
                        ),
                      ),
                    if (state is NotificationsPreferencesEmptyState)
                      Expanded(
                        child: Center(
                          child: Text(
                            getString(
                                context, "request_fine_empty_error_message"),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (state is NotificationsPreferencesLoadedState)
                      Column(
                        children: [
                          _viewListNotificationsPendences(state, theme)
                        ],
                      ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _viewListNotificationsPendences(
      NotificationsPreferencesLoadedState state, ThemeData theme) {
    List<NotificationsPreferences>? commonNotifications = state
        .notificationsPreference
        ?.where((element) => element.configType == "notification")
        .toList();
    List<NotificationsPreferences>? gdpNotifications = state
        .notificationsPreference
        ?.where((element) => element.configType != "notification")
        .toList();

    if (state.notificationsPreference!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Dimens.spacingXSmall),
          SizedBox(height: Dimens.spacingXSmall),
          SizedBox(height: Dimens.spacingXSmall),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Switch.adaptive(
                  activeColor: theme.primaryColor,
                  value: commonNotifications!.every((e) => e.active) &&
                      gdpNotifications!.every((e) => e.active),
                  onChanged: (value) {
                    setState(() {
                      for (var item in commonNotifications) {
                        item.active = value;
                      }
                      for (var item in gdpNotifications!) {
                        item.active = value;
                      }
                    });
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Todos os tipos de notificação",
                    style: LelloTextStyles.bodyBold(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          SizedBox(height: Dimens.spacingSmall),
          ...List.generate(
            commonNotifications.length,
            (index) => NotificationsPreferencesWidget(
              notificationsPreferences: commonNotifications[index],
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Row(
            children: [
              SvgPicture.asset(
                'assets/ic_preferences.svg',
                package: 'shared_features',
                color: LelloTheme.palleteOf(theme).text(),
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
              Text(
                getString(context, "gdp_timesheet"),
                style: LelloTextStyles.subtitleBold(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
            ],
          ),
          SizedBox(height: Dimens.spacingSmall),
          ...List.generate(
            gdpNotifications!.length,
            (index) => NotificationsPreferencesWidget(
              notificationsPreferences: gdpNotifications[index],
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            "Defina como deseja ser notificado sobre o Ponto Digital.",
            style: LelloTextStyles.body(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
          SizedBox(height: Dimens.spacingMedium),
          _buildCheckDist(theme, state.notificationsPreference,
              NotificationsPreferencesType.email),
          const Divider(height: 16, thickness: 0.5, color: Colors.grey),
          _buildCheckDist(theme, state.notificationsPreference,
              NotificationsPreferencesType.notification),
          SizedBox(height: Dimens.spacingMedium),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PrimaryButton(
                  text: getString(context, "save"),
                  onPressed: canSave(state.notificationsPreference)
                      ? () {
                          controller.updateNotificationsPreferences(
                              notificationsPreferences:
                                  state.notificationsPreference!);
                          Navigator.pop(context);
                        }
                      : null),
            ],
          ),
          //replacement: Center(child: LoadingWidget()),
        ],
      );
    }
  }

  bool canSave(List<NotificationsPreferences>? list) {
    return list?.every((element) => element.listType.isNotEmpty) ?? false;
  }

  Widget _buildCheckDist(ThemeData theme, List<NotificationsPreferences>? list,
      NotificationsPreferencesType type) {
    bool isActive =
        list?.any((element) => element.listType.contains(type)) ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          setState(() {
            var currentValue =
                list?.any((element) => element.listType.contains(type));
            if (currentValue == true) {
              list?.forEach((element) {
                element.listType.remove(type);
              });
            } else {
              list?.forEach((element) {
                element.listType.add(type);
              });
            }
          });
        },
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? theme.primaryColor : Colors.grey[400]!,
                  width: isActive ? 6.0 : 1.5,
                ),
                color: Colors.transparent,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                getString(context,
                    "notification_preferences_type_${type == NotificationsPreferencesType.email ? "email" : "notification"}"),
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
