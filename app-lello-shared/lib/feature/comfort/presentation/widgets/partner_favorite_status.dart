import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_intro.dart';

class PartnerFavoriteStatusWidget extends StatefulWidget {
  const PartnerFavoriteStatusWidget({
    Key? key,
    required this.onTap,
    required this.partnerIntro,
  }) : super(key: key);

  final ComfortPartnerIntro partnerIntro;
  final Function(String partnerId, String partnerName, bool favorite) onTap;

  @override
  State<PartnerFavoriteStatusWidget> createState() =>
      _PartnerFavoriteStatusWidgetState();
}

class _PartnerFavoriteStatusWidgetState
    extends State<PartnerFavoriteStatusWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double favoriteIconSize = 32.0;
    return InkWell(
      onTap: () {
        widget.onTap(widget.partnerIntro.id, widget.partnerIntro.title,
            !widget.partnerIntro.favorite);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(Dimens.spacingMedium, Dimens.spacingMedium,
            Dimens.spacingMedium, 0),
        child: widget.partnerIntro.favorite
            ? Icon(
                Icons.favorite,
                color: theme.primaryColor,
                size: favoriteIconSize,
              )
            : SvgPicture.asset(
                "assets/ic_partner_favorite.svg",
                height: favoriteIconSize,
                width: favoriteIconSize,
              ),
      ),
    );
  }
}
