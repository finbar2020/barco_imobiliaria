import 'package:essentials/essentials.dart' hide Switch;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/presentation/controller/notifications_preferences_controller.dart';

class NotificationsPreferencesWidget extends StatefulWidget {
  final NotificationsPreferences notificationsPreferences;
  const NotificationsPreferencesWidget(
      {Key? key, required this.notificationsPreferences})
      : super(
          key: key,
        );

  @override
  State<NotificationsPreferencesWidget> createState() =>
      _NotificationsPreferencesWidgetState();
}

class NotificationOption {
  int value;
  String msg;
  bool active;
  NotificationOption({
    required this.value,
    required this.msg,
    required this.active,
  });
}

class _NotificationsPreferencesWidgetState
    extends State<NotificationsPreferencesWidget> {
  final controller = ApplicationContainer.instance()
      .resolve<NotificationsPreferencesController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<NotificationOption> options = <NotificationOption>[
      NotificationOption(value: 0, msg: "Nenhum", active: true),
      NotificationOption(value: 1, msg: "Diariamente", active: true),
      NotificationOption(value: 7, msg: "1x por semana", active: true),
      NotificationOption(value: 15, msg: "A cada 15 dias", active: true),
      NotificationOption(value: 30, msg: "1x por mês", active: true),
    ];

    if (widget.notificationsPreferences.quarentineDays != null &&
        !options.any((element) =>
            element.value == widget.notificationsPreferences.quarentineDays)) {
      options.add(NotificationOption(
        value: widget.notificationsPreferences.quarentineDays!,
        msg:
            ("${widget.notificationsPreferences.quarentineDays} ${getString(context, "notification_preferences_day${widget.notificationsPreferences.quarentineDays! > 1 ? "s" : ""}")}"),
        active: false,
      ));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Switch.adaptive(
                activeColor: theme.primaryColor,
                value: widget.notificationsPreferences.active,
                onChanged: (value) {
                  setState(() {
                    widget.notificationsPreferences.active = value;
                    if (widget.notificationsPreferences.configType !=
                            "notification" &&
                        widget.notificationsPreferences.quarentineDays == 0 &&
                        widget.notificationsPreferences.active) {
                      widget.notificationsPreferences.quarentineDays = options
                          .firstWhere((element) => element.value > 0)
                          .value;
                    }
                  });
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  getString(context,
                                  "notification_preferences_${widget.notificationsPreferences.module.toString()}")
                              .isEmpty ==
                          false
                      ? getString(context,
                          "notification_preferences_${widget.notificationsPreferences.module.toString()}")
                      : widget.notificationsPreferences.altText,
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
              ),
              if (widget.notificationsPreferences.configType != "notification")
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isDense: true,
                      icon: Icon(Icons.arrow_drop_down,
                          color: LelloTheme.palleteOf(theme).text(), size: 20),
                      hint: Align(
                        alignment: Alignment.centerRight,
                        child: widget.notificationsPreferences.quarentineDays ==
                                null
                            ? Text(
                                getString(
                                    context, "notification_preferences_period"),
                                style: LelloTextStyles.body(theme)?.copyWith(
                                  color: LelloTheme.palleteOf(theme).hubText(),
                                ),
                              )
                            : Text(
                                "${widget.notificationsPreferences.quarentineDays.toString()} ${getString(context, "days")}",
                                style: LelloTextStyles.body(theme)?.copyWith(
                                  color: LelloTheme.palleteOf(theme).hubText(),
                                ),
                              ),
                      ),
                      disabledHint: Text(
                        getString(context,
                            "notification_preferences_period_disabled"),
                        style: LelloTextStyles.body(theme)?.copyWith(
                          color: LelloTheme.palleteOf(theme).hubText(),
                        ),
                      ),
                      value: !widget.notificationsPreferences.active
                          ? null
                          : widget.notificationsPreferences.quarentineDays,
                      items: options
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.value,
                              enabled: e.active,
                              child: Text(
                                e.msg,
                                style: LelloTextStyles.body(theme)?.copyWith(
                                  color: LelloTheme.palleteOf(theme).text(),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: !widget.notificationsPreferences.active
                          ? null
                          : (int? newValue) {
                              setState(() {
                                widget.notificationsPreferences.quarentineDays =
                                    newValue!;
                                widget.notificationsPreferences.active =
                                    newValue != 0;
                              });
                            },
                    ),
                  ),
                ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey[300]!),
      ],
    );
  }
}
