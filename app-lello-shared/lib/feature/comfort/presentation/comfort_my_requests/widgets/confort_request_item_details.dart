import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/shared_features.dart';

class ConfortRequestItemDetails extends StatelessWidget {
  const ConfortRequestItemDetails({
    super.key,
    required this.appContainer,
    required this.item,
    this.hideStatus = false,
  });

  final SharedApplicationContainer appContainer;
  final ComfortCompletedRequest item;
  final bool hideStatus;

  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            buildRow(theme, context),
          ],
        ),
      ),
    );
  }

  Widget buildRow(ThemeData theme, BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCachedNetworkImage(
            applicationContainer: appContainer,
            link: item.partner.partnerIntro.partnerImageLink,
          ),
          SizedBox(width: Dimens.spacingSmall),
          Expanded(child: buildColumn(theme, context)),
        ],
      ),
    );
  }

  Widget buildColumn(ThemeData theme, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitleRow(theme, context),
        Text(
          item.partner.partnerIntro.getComfortType(context),
          textAlign: TextAlign.start,
          style: LelloTextStyles.body(theme)
              ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
        ),
        Text(
          "${DateFormat("dd/MM/yyyy - HH:mm").format(item.dateRequest).replaceAll("-", getString(context, "time_to"))}h",
          textAlign: TextAlign.start,
          style: LelloTextStyles.body(theme)
              ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
        ),
      ],
    );
  }

  Widget buildTitleRow(ThemeData theme, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            item.partner.partnerIntro.title,
            style: LelloTextStyles.bodyBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
        ),
        if (hideStatus == false) buildStatusColumn(theme, context),
      ],
    );
  }

  Widget buildStatusColumn(ThemeData theme, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Icon(
              Icons.circle,
              size: Dimens.spacingSmall,
              color: item.statusColor(theme),
            ),
            SizedBox(width: Dimens.spacingXSmall),
            Text(
              "${getString(context, item.statusText)}",
              overflow: TextOverflow.ellipsis,
              style: LelloTextStyles.subBody(theme)
                  ?.copyWith(color: item.statusColor(theme)),
            ),
          ],
        ),
      ],
    );
  }
}
