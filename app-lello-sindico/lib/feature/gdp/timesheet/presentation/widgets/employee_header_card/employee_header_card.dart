import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetEmployeeHeaderCard extends StatelessWidget {
  const TimesheetEmployeeHeaderCard({
    super.key,
    required this.theme,
    required this.pictureLink,
    required this.name,
    required this.jobPosition,
    required this.date,
  });

  final ThemeData theme;
  final String pictureLink;
  final String name;
  final String jobPosition;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42.0,
              width: 42.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: pictureLink,
                  placeholder: (context, url) => Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => SvgPicture.asset(
                      "assets/user_placeholder.svg",
                      width: 32),
                ),
              ),
            ),
            SizedBox(width: Dimens.spacingSmall),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capitalizeFirstLetter(name).trimRight(),
                    style: LelloTextStyles.bodyBold(theme),
                  ),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(jobPosition.isNotEmpty ? jobPosition : "-",
                      style: LelloTextStyles.body(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textLight())),
                  SizedBox(height: Dimens.spacingXSmall),
                ],
              ),
            ),
            SizedBox(width: Dimens.spacingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.today,
                  size: Dimens.spacing,
                ),
                Text(
                  date,
                  style: LelloTextStyles.body(theme),
                )
              ],
            )
          ],
        ),
        SizedBox(height: Dimens.spacingSmall)
      ],
    );
  }

  String capitalizeFirstLetter(String name) {
    String capitalizedString =
        name.trimRight().split(' ').map((word) => word.capitalize).join(' ');
    return capitalizedString;
  }
}
