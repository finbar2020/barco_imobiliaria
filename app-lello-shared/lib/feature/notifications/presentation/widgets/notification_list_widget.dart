import 'dart:collection';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_details_widget.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_list_tile.dart';

import '../../../../shared_features.dart';

class NotificationListWidget extends StatefulWidget {
  final NotificationController controller;
  final VoidCallback closeOverlay;
  final dynamic sessionBloc;
  final Function(SingleNotification notification) onTap;
  final List<SingleNotification> notificationList;
  final AppOriginEnum appOriginEnum;
  final String? configurationPage;
  final VoidCallback? onConfigurationTap;
  final bool? checkRbac;
  final SharedApplicationContainer applicationContainer;
  final NotificationScopeLabelBuilder? scopeLabelBuilder;
  NotificationListWidget({
    required this.closeOverlay,
    required this.controller,
    required this.sessionBloc,
    required this.onTap,
    required this.notificationList,
    required this.appOriginEnum,
    required this.applicationContainer,
    this.checkRbac,
    this.configurationPage,
    this.onConfigurationTap,
    this.scopeLabelBuilder,
  });
  @override
  _NotificationListWidgetState createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        String? currentContext = widget.controller.getCurrentContext;

        SingleNotification? inAppNotification;

        // verificar se tem id de notificação para redirecionar
        if (widget.controller.redirectNotificationId?.isNotEmpty == true) {
          inAppNotification =
              widget.notificationList.firstWhereOrNull((element) {
            return element.senderId == widget.controller.redirectNotificationId;
          });
        }
        // verificar se tem uuid de grupo para redirecionar
        else if (widget.controller.redirectUuidGroup?.isNotEmpty == true) {
          inAppNotification =
              widget.notificationList.firstWhereOrNull((element) {
            return (element.reference == currentContext &&
                element.uuidGroup == widget.controller.redirectUuidGroup);
          });
          // se não encontrar a notificação no grupo e reference/currentContext
          //buscar a primeira dp grupo
          if (inAppNotification == null) {
            inAppNotification =
                widget.notificationList.firstWhereOrNull((element) {
              return element.uuidGroup == widget.controller.redirectUuidGroup;
            });
          }
        }

        widget.controller.setRedirectNotificationId(null);
        widget.controller.setUuidGroup(null);

        if (inAppNotification?.id?.isNotEmpty == true) {
          widget.controller.loadSingleNotification(
              fromPush: true, notificationId: inAppNotification!.id!);
          Navigator.of(context).push(MaterialPageRoute(
            settings: RouteSettings(name: "/notification-details-from-push"),
            builder: (context) => NotificationDetailsWidget(
                notification: inAppNotification,
                controller: widget.controller,
                onTap: widget.onTap,
                configurationPage: widget.configurationPage,
                onConfigurationTap: widget.onConfigurationTap,
                checkRbac: widget.checkRbac,
                appOriginEnum: widget.appOriginEnum,
                applicationContainer: widget.applicationContainer,
                scopeLabelBuilder: widget.scopeLabelBuilder,
                fromPush: false),
          ));
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    var curentState = widget.controller.bloc.state;

    if (curentState is NotificationListPageState) {
      if (curentState.loading || curentState.pagError) return;
    }
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) {
      widget.controller.loadPagination();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Menu items in Figma order: Preferências, Marcar todas, Excluir
    final menuLabels = [
      'Preferências', // Figma label
      getString(
          context, "notification_first_drop_down"), // Marcar todas como lidas
      getString(
          context, "notification_second_drop_down"), // Excluir notificações
    ];

    return Theme(
      data: theme,
      child: BlocConsumer(
          listener: (context, state) {},
          bloc: widget.controller.bloc,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: LelloTheme.palleteOf(theme).background(),
                title: Text(
                  getString(context, "notification"),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings),
                    color: LelloTheme.palleteOf(theme).text(),
                    onPressed: () =>
                        _showSettingsMenu(context, theme, menuLabels),
                  ),
                ],
              ),
              body: _buildList(context, state as NotificationListPageState,
                  theme, menuLabels),
            );
          }),
    );
  }

  Widget _buildList(
    BuildContext context,
    NotificationListPageState state,
    ThemeData theme,
    List<String> items,
  ) {
    if (widget.notificationList.isEmpty)
      return RefreshIndicator(
        onRefresh: () async {
          widget.controller.getNotificationList();
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    getString(context, "dont_have_notifications"),
                    style: TextStyle(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      );

    // Group notifications by period
    final groupedNotifications =
        _groupNotificationsByPeriod(widget.notificationList);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCondominiumBar(),
        // Notification list grouped by period
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              widget.controller.getNotificationList();
            },
            child: RawScrollbar(
              thickness: 5,
              controller: _scrollController,
              thumbVisibility: true,
              thumbColor: LelloTheme.palleteOf(theme).grey(),
              child: ListView.builder(
                controller: _scrollController,
                // Garante o puxar-para-atualizar mesmo com a lista menor que
                // a tela.
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _countGroupedItems(groupedNotifications),
                itemBuilder: (context, index) {
                  return _buildGroupedItem(groupedNotifications, index);
                },
              ),
            ),
          ),
        ),
        if (state.loading)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (state.pagError)
          Center(
            child: Container(
              width: double.infinity,
              child: TextButton(
                onPressed: widget.controller.loadPagination,
                child: Text(
                  getString(context, "try_again"),
                  style: LelloTextStyles.button(theme)!.copyWith(
                    decoration: TextDecoration.underline,
                    color: LelloTheme.palleteOf(theme).textAccent(),
                    decorationColor: LelloTheme.palleteOf(theme).textAccent(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Groups notifications by period key, preserving order.
  LinkedHashMap<String, List<SingleNotification>> _groupNotificationsByPeriod(
      List<SingleNotification> notifications) {
    final grouped = LinkedHashMap<String, List<SingleNotification>>();
    for (final notification in notifications) {
      final key = notification.datePeriodKey;
      if (key.isEmpty) continue;
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(notification);
    }
    return grouped;
  }

  /// Counts total items including section headers.
  int _countGroupedItems(
      LinkedHashMap<String, List<SingleNotification>> grouped) {
    var total = 0;
    for (final entry in grouped.entries) {
      total += 1; // header
      total += entry.value.length; // items
    }
    return total;
  }

  /// Builds either a section header or a notification tile.
  Widget _buildGroupedItem(
      LinkedHashMap<String, List<SingleNotification>> grouped, int index) {
    int currentIndex = 0;
    for (final entry in grouped.entries) {
      if (index == currentIndex) {
        // Section header
        return Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 4),
          child: Text(
            entry.key,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
        );
      }
      currentIndex++;
      for (int i = 0; i < entry.value.length; i++) {
        if (index == currentIndex) {
          return NotificationListTile(
            closeOverlay: widget.closeOverlay,
            notification: entry.value[i],
            controller: widget.controller,
            onTap: widget.onTap,
            checkRbac: widget.checkRbac,
            appOriginEnum: widget.appOriginEnum,
            configurationPage: widget.configurationPage,
            applicationContainer: widget.applicationContainer,
            scopeLabelBuilder: widget.scopeLabelBuilder,
          );
        }
        currentIndex++;
      }
    }
    return const SizedBox.shrink();
  }

  /// Builds the condominium info bar.
  Widget _buildCondominiumBar() {
    String condominiumText = '';
    try {
      final session = widget.sessionBloc.state.session;
      final condoName = session?.condominium?.layout?.companyName ?? '';
      final condoReference = session?.condominium?.reference?.toString() ?? '';
      if (condoName.isNotEmpty && condoReference.isNotEmpty) {
        condominiumText = '$condoName - $condoReference';
      } else if (condoReference.isNotEmpty) {
        condominiumText = condoReference;
      } else if (condoName.isNotEmpty) {
        condominiumText = condoName;
      }
    } catch (_) {}

    if (condominiumText.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        condominiumText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0x99000000), // rgba(0,0,0,0.6)
          letterSpacing: 0.25,
          height: 17 / 14,
        ),
      ),
    );
  }

  void _showSettingsMenu(
      BuildContext context, ThemeData theme, List<String> items) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position =
        button.localToGlobal(Offset.zero, ancestor: overlay);

    const menuIconAssets = [
      'assets/ic_preferences.svg', // Preferências
      'assets/ic_mark_as_read.svg', // Marcar todas como lidas
      'assets/ic_delete-fill.svg', // Excluir notificações
    ];

    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + button.size.width,
        position.dy,
        position.dx + button.size.width,
        position.dy + button.size.height,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.white,
      elevation: 8,
      items: List.generate(items.length, (index) {
        final isDelete = index == 2;
        final color = isDelete ? const Color(0xFFF22200) : Colors.black;
        return PopupMenuItem<int>(
          value: index,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                if (index == 1)
                  Image.asset(
                    'assets/ic_mark_as_read.png',
                    width: 16,
                    height: 16,
                    package: 'shared_features',
                  )
                else
                  SvgPicture.asset(
                    menuIconAssets[index],
                    width: 16,
                    height: 16,
                    package: 'shared_features',
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    items[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ).then((index) {
      if (index != null) {
        choiceAction(index, theme, widget.notificationList);
      }
    });
  }

  void choiceAction(
      int choice, ThemeData theme, List<SingleNotification> notificationList) {
    if (choice == 0) {
      // Preferências
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
    } else if (choice == 1) {
      // Marcar todas como lidas
      List<SingleNotification> unreads = notificationList
          .where((element) => element.markRead == false)
          .toList();
      if (unreads.length > 0) {
        widget.controller.markAllRead();
      } else {
        Flushbar(
          duration: Duration(seconds: 5),
          message: "Todas as notificações já foram lidas.",
        )..show(context);
      }
    } else if (choice == 2) {
      // Excluir notificações
      _buildExcludedDialog(theme);
    }
  }

  Future<dynamic> _buildExcludedDialog(ThemeData theme) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 50.0,
                      color: LelloTheme.palleteOf(theme).textOpaque(),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      getString(context, "attention"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.titleSmall(theme)!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: LelloTheme.palleteOf(theme).textOpaque()),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Text(
                      getString(context, "notification_dialog_subtitle"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textOpaque()),
                    ),
                    SizedBox(height: Dimens.spacingLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            widget.controller.deleteAllRead(read: false);
                            Navigator.pop(context);
                          },
                          child: Text(
                            getString(
                                context, "notification_dialog_first_button"),
                            style: LelloTextStyles.subBody(theme)!.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                        Container(
                          width: 110.0,
                          child: InkWell(
                            onTap: () {
                              widget.controller.deleteAllRead(read: true);
                              Navigator.pop(context);
                            },
                            child: Text(
                              getString(
                                  context, "notification_dialog_second_button"),
                              textAlign: TextAlign.center,
                              style: LelloTextStyles.subBody(theme)!.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          getString(context, "cancel").toUpperCase(),
                          style: LelloTextStyles.subBody(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).textOpaque(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
