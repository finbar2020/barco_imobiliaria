import 'package:badges/badges.dart' as badges;
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/hex_color.dart';
import 'package:morar/feature/home/presentation/bloc/home_bloc.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/shared_features.dart';

class HomeAppBar extends StatefulWidget {
  final VoidCallback gestureOnTap;
  final VoidCallback pictureOnTap;
  final VoidCallback onNotificationTap;
  final NotificationListBloc notificationListBloc;
  final bool isDropdownOpen;
  final bool isGeneric;

  const HomeAppBar({
    Key? key,
    required this.gestureOnTap,
    required this.pictureOnTap,
    required this.onNotificationTap,
    required this.notificationListBloc,
    this.isDropdownOpen = false,
    this.isGeneric = false,
  }) : super(key: key);

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final HomeBloc bloc = ApplicationContainer.instance().resolve();
  late SessionBloc sessionBloc;

  @override
  void initState() {
    super.initState();
    sessionBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);

    return BlocBuilder<SessionBloc, SessionState>(
      bloc: sessionBloc,
      builder: (context, state) {
        final me = state.session?.me;
        final condoName = state.session?.condominium?.name ?? '';
        final unityTitle = state.session?.unity?.namedTitle ?? '';

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status bar background
            Container(
              height: MediaQuery.of(context).padding.top,
              color: pallete.appBarHome(),
            ),
            // Header bar
            Container(
              height: 72,
              decoration: BoxDecoration(
                color: pallete.appBarHome(),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Building icon
                  SvgPicture.asset(
                    'assets/condo-icon.svg',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),

                  // Condo name + unit (tappable)
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.gestureOnTap,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              condoName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: LelloTextStyles.body(theme)?.copyWith(
                                color: pallete.customColor(),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (unityTitle.isNotEmpty)
                            Text(
                              ' - $unityTitle',
                              style: LelloTextStyles.body(theme)?.copyWith(
                                color: pallete.customColor(),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          const SizedBox(width: 4),
                          AnimatedRotation(
                            turns: widget.isDropdownOpen ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: pallete.customColor(),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Notification bell icon
                  _buildNotificationIcon(context),

                  const SizedBox(width: 16),

                  // Avatar
                  _buildProfilePicture(context, me),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onNotificationTap,
      behavior: HitTestBehavior.opaque,
      child: BlocConsumer(
        bloc: widget.notificationListBloc,
        listener: (context, state) {},
        builder: (context, state) {
          final bellIcon = SvgPicture.asset(
            'assets/notification-icon.svg',
            width: 40,
            height: 40,
          );

          if (state is NotificationListPageState &&
              state.notificationsNotRead > 0) {
            return badges.Badge(
              badgeAnimation: const badges.BadgeAnimation.fade(
                animationDuration: Duration(milliseconds: 300),
              ),
              badgeStyle: badges.BadgeStyle(
                badgeColor: HexColor('#FF9315'),
                shape: badges.BadgeShape.circle,
                padding: const EdgeInsets.all(3),
              ),
              position: badges.BadgePosition.topEnd(end: -2, top: -2),
              badgeContent: Text(
                state.notificationsNotRead > 99
                    ? '99+'
                    : state.notificationsNotRead.toString(),
                style: LelloTextStyles.caption(theme)?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 8,
                ),
              ),
              child: bellIcon,
            );
          }

          return bellIcon;
        },
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context, Me? me) {
    return GestureDetector(
      onTap: widget.pictureOnTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: me != null
              ? CustomCachedNetworkImage(
                  link: me.pictureLink,
                  errorImageAssetsPath: "assets/user-icon.svg",
                )
              : SvgPicture.asset("assets/user-icon.svg", width: 40),
        ),
      ),
    );
  }
}
