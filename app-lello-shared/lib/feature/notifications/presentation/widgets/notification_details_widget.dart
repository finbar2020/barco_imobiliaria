import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_list_tile.dart';
import 'package:shared_features/shared_features.dart';

class NotificationDetailsWidget extends StatefulWidget {
  final SingleNotification? notification;
  final NotificationController controller;
  final String? listNotificationContext;
  final bool fromPush;
  final Function(SingleNotification notification) onTap;
  final String? configurationPage;
  final VoidCallback? onConfigurationTap;
  final AppOriginEnum? appOriginEnum;
  final bool? checkRbac;
  final SharedApplicationContainer applicationContainer;
  final NotificationScopeLabelBuilder? scopeLabelBuilder;
  const NotificationDetailsWidget({
    Key? key,
    this.notification,
    required this.controller,
    required this.fromPush,
    required this.onTap,
    this.appOriginEnum,
    this.checkRbac,
    this.listNotificationContext,
    this.configurationPage,
    this.onConfigurationTap,
    required this.applicationContainer,
    this.scopeLabelBuilder,
  }) : super(key: key);

  @override
  _NotificationDetailsWidgetState createState() =>
      _NotificationDetailsWidgetState();
}

class _NotificationDetailsWidgetState extends State<NotificationDetailsWidget> {
  SingleNotification notification = SingleNotification();

  @override
  void initState() {
    if (widget.notification != null) {
      notification = widget.notification!;
    } else if (widget.notification == null &&
        widget.listNotificationContext != null) {
      widget.controller.loadSingleNotification(
          notificationId: widget.listNotificationContext!,
          fromPush: widget.fromPush);
    } else {
      notification = widget.notification!;
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<String> items = [
      getString(context, "exclude"),
      getString(context, "notification_third_drop_down"),
    ];
    notification.markRead = true;
    final scopeLabel = widget.scopeLabelBuilder?.call(notification);
    return Scaffold(
      appBar: CustomAppBar(title: "notification"),
      body: BlocConsumer(
        bloc: widget.controller.bloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is NotificationListLoadingState)
            return Column(
              children: [
                Expanded(
                  child: LoadingWidget(),
                ),
              ],
            );
          if (state is NotificationListLoadedFailedState) {
            return _buildError();
          }
          if (state is NotificationListPageState) {
            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimens.spacing),
                      AppBar(
                        backgroundColor: Colors.transparent,
                        toolbarHeight: 80,
                        automaticallyImplyLeading: false,
                        centerTitle: false,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        notification.getModuleTitle(context),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF0058A0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimens.spacingXSmall),
                                  Row(
                                    children: [
                                      notification
                                          .iconFromModule(theme.primaryColor),
                                      SizedBox(width: Dimens.spacingSmall),
                                      Expanded(
                                        child: AutoSizeText(
                                          '${notification.title}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (scopeLabel != null) ...[
                                    SizedBox(height: Dimens.spacingXSmall),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 48 + Dimens.spacingSmall),
                                      child: Text(
                                        scopeLabel,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF666666),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              PopupMenuButton<int>(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                ),
                                iconSize: 35.0,
                                itemBuilder: (context) => items
                                    .map<PopupMenuEntry<int>>(
                                        (e) => PopupMenuItem(
                                              child: Text(e),
                                              value: items.indexOf(e),
                                            ))
                                    .toList(),
                                onSelected: (index) => choiceAction(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.dateFormatted ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: LelloTheme.palleteOf(theme).hubText(),
                                ),
                              ),
                              SizedBox(height: Dimens.spacing),
                              Flexible(
                                child: notification.isHtml
                                    ? HtmlWidget(
                                        '${notification.getInAppMessage}',
                                        onErrorBuilder:
                                            (context, element, error) => Text(
                                          '${notification.getInAppMessage}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: LelloTheme.palleteOf(theme)
                                                  .hubText()),
                                        ),
                                      )
                                    : Text(
                                        '${notification.getInAppMessage}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: LelloTheme.palleteOf(theme)
                                                .hubText()),
                                      ),
                              ),
                              if (notification.imageLink != null)
                                SizedBox(height: Dimens.spacing),
                              if (notification.imageLink != null)
                                CustomCachedNetworkImage(
                                  link: notification.imageLink,
                                  applicationContainer:
                                      widget.applicationContainer,
                                ),
                              SizedBox(height: Dimens.spacingLarge),
                              _validShowButton(),
                              SizedBox(height: Dimens.spacingLarge),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      size: 20.0,
                                      color: theme.primaryColor,
                                    ),
                                    SizedBox(width: Dimens.spacingXSmall),
                                    Text(
                                      getString(context, "back"),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  void choiceAction(int choice) {
    if (choice == 0) {
      widget.controller
          .deleteNotification(notificationId: notification.id ?? "");
      Navigator.pop(context);
    } else if (choice == 1) {
      if (widget.onConfigurationTap != null) {
        widget.onConfigurationTap!();
      } else if (widget.configurationPage != null) {
        Navigator.pushNamed(context, widget.configurationPage!);
      } else {
        Flushbar(
          duration: Duration(seconds: 5),
          message: getString(context, "notification_coming"),
        )..show(context);
      }
    }
  }

  Widget _buildError() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          getString(context, "warning_failed_message"),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildButtonFeature() {
    if (notification.canRedirect) {
      return Center(
        child: PrimaryButton(
          text: getString(context, "notification_button_redirect"),
          buttonColor: Color(0xFF0058A0),
          onPressed: () {
            registerAnalyticsEvent();
            widget.onTap(notification);
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildButtonExternal() {
    if (notification.redirectPath != null) {
      return Center(
        child: PrimaryButton(
          text: getString(context, "notification_button_redirect"),
          buttonColor: Color(0xFF0058A0),
          onPressed: () async {
            registerAnalyticsEvent();
            try {
              var url = notification.redirectPath!;
              var hasScheme = url.startsWith("http") || url.startsWith("HTTP");
              if (hasScheme == false) {
                url = "https://$url";
              }
              await launchUrl(Uri.parse(url));
            } catch (e) {
              Flushbar(
                duration: Duration(seconds: 5),
                message:
                    getString(context, "notification_error_redirect_external"),
              )..show(context);
            }
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _validShowButton() {
    try {
      FeaturesRoutesEnum? path;
      path = stringToEnum(FeaturesRoutesEnum.values, notification.redirectPath);
      if (path != null) {
        switch (path) {
          case FeaturesRoutesEnum.NOTIFICACOES_NAO_LIDAS:
          case FeaturesRoutesEnum.PORTARIA_BLOQUEADA:
          case FeaturesRoutesEnum.PORTARIA_LIBERADA:
            return Container();
          default:
            return showButton();
        }
      } else if (notification.typeRedirect == "EXTERNAL") {
        return showButton();
      } else {
        return Container();
      }
    } catch (e) {
      return showButton();
    }
  }

  Widget showButton() {
    if (notification.typeRedirect == "FEATURE") {
      return buildButtonFeature();
    } else if (notification.typeRedirect == "EXTERNAL") {
      return buildButtonExternal();
    } else {
      return Container();
    }
  }

  String get getUnityId {
    switch (widget.appOriginEnum) {
      case AppOriginEnum.employee:
        return "";
      case AppOriginEnum.owner:
        return widget.controller.sessionBloc.state.session?.unity?.title ?? "";
      case AppOriginEnum.manager:
        return "";
      default:
        return "";
    }
  }

  registerAnalyticsEvent() {
    String referenceValue = "";
    String unity = "";
    AnalyticsEvent? event;

    switch (widget.appOriginEnum) {
      case AppOriginEnum.owner:
        event = AnalyticsEventsOwner.notificacoeCTA();
        referenceValue = widget
                .controller.sessionBloc.state.session!.condominium?.reference
                ?.toString() ??
            "";
        unity = widget.controller.sessionBloc.state.session?.unity?.title
                ?.toString() ??
            "";
        break;

      case AppOriginEnum.employee:
        event = AnalyticsEventsEmployee.notificacoeCTA();
        referenceValue = widget
                .controller.sessionBloc.state.session!.condominium?.reference
                ?.toString() ??
            "";
        break;

      case AppOriginEnum.manager:
        event = AnalyticsEventsManager.notificacoeCTA();
        referenceValue = widget.controller.sessionBloc.state.session
                ?.selectedCondominium?.reference
                ?.toString() ??
            "";
        break;

      default:
        return; // Exit the function if no valid case is matched
    }

    AnalyticsLogEvents.logEvent(
      event: event!,
      userId: widget.controller.sessionBloc.state.session?.me?.id ?? "",
      unitValue: unity,
      referenceValue: referenceValue,
      appOrigin: widget.appOriginEnum!,
      otherParameters: {
        "id_parceiro": notification.redirectId ?? "",
        "id_partner": notification.redirectId ?? "",
      },
    );
  }
}
