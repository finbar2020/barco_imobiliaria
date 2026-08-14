import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/shared_features.dart';

class ComfortPartnerListCard extends StatelessWidget {
  final ComfortPartner? partner;
  final SharedApplicationContainer applicationContainer;
  final Function(ComfortPartner partner) onPressed;

  static const double _borderRadius = 12.0;
  static const double _borderWidth = 1.0;
  static const double _logoAreaHeight = 96.0;

  const ComfortPartnerListCard({
    Key? key,
    required this.partner,
    required this.onPressed,
    required this.applicationContainer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (partner == null) return SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onPressed(partner!),
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Container(
          width: cardWidth(),
          height: cardHeight(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(
              color: LelloTheme.palleteOf(theme).grey().withValues(alpha: 0.35),
              width: _borderWidth,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: _logoAreaHeight,
                width: cardWidth(),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(_borderRadius - 1),
                  ),
                  child: CustomCachedNetworkImage(
                    applicationContainer: applicationContainer,
                    link: partner!.partnerIntro.partnerImageLink,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.spacingSmall,
                    vertical: Dimens.spacingSmall,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      partner!.partnerIntro.title,
                      style: LelloTextStyles.bodyBold(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static double cardHeight() => 140.0;
  static double cardWidth() => 138.0;
}
