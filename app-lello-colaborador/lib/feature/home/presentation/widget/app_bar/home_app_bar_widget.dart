import 'package:colaborador/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/colors/carimbeira_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeAppBar {
  static PreferredSize show(
          BuildContext context, Session session, Function()? onProfileTap) =>
      PreferredSize(
        preferredSize: _getSize(context),
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarColor: CarimbeiraPallete().statusBarColor(),
          ),
          child: HomeAppBarWidget(
            session: session,
            onProfileTap: onProfileTap,
          ),
        ),
      );

  static Size _getSize(BuildContext context) {
    double height = _width(context) * 0.33 > 150
        ? 150
        : _width(context) * 0.33 < 150
            ? 150
            : _width(context) * 0.33;
    return Size(
      _width(context),
      height + 8.0,
    );
  }

  static ColorPallete _getColors(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return LelloTheme.palleteOf(theme);
  }

  static double _width(BuildContext context) =>
      MediaQuery.of(context).size.width;
}

class HomeAppBarWidget extends StatefulWidget {
  final Session session;
  final Function()? onProfileTap;

  const HomeAppBarWidget({
    Key? key,
    required this.session,
    this.onProfileTap,
  }) : super(key: key);

  @override
  State<HomeAppBarWidget> createState() => _HomeAppBarWidgetState();
}

class _HomeAppBarWidgetState extends State<HomeAppBarWidget> {
  double _height(BuildContext context) {
    double height = _width(context) * 0.2555555555555556 > 150
        ? 150
        : _width(context) * 0.2555555555555556;
    return height;
  }

  double _width(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Container(
          color: LelloTheme.palleteOf(theme).primary(),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                width: _width(context),
                height: _height(context),
                decoration: BoxDecoration(
                  color: LelloTheme.palleteOf(theme).primary(),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.spacingMedium,
                        vertical: Dimens.spacing,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 5,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.session.me.nameFormatted,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: LelloTheme.palleteOf(theme)
                                        .customColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(height: Dimens.spacingSmall),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.session.condominium.jobPositionFormatted,
                                style: TextStyle(
                                    color: LelloTheme.palleteOf(theme)
                                        .customColor(),
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
                          ),
                          SizedBox(height: Dimens.spacingXSmall),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.session.condominium.workShift,
                                style: TextStyle(
                                    color: LelloTheme.palleteOf(theme)
                                        .customColor(),
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Container(
                        padding: EdgeInsets.all(Dimens.spacingSmall),
                        child: _buildProfilePicture(context),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: LelloTheme.palleteOf(theme).customColor(), width: 2),
      ),
      child: InkWell(
        onTap: widget.onProfileTap,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10000.0),
            child: CustomCachedNetworkImage(
              link: widget.session.me.pictureLink,
              errorImageAssetsPath: "assets/user_placeholder.svg",
            ),
          ),
        ),
      ),
    );
  }
}
