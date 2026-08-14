import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';

class DayAppointmentsCard extends StatelessWidget {
  const DayAppointmentsCard({
    super.key,
    required this.item,
    required this.theme,
  });

  final DayAppointmentsEntity item;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40.0,
                width: 40.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10000.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: item.pictureLink,
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
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.collaborator.name,
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                    SizedBox(height: Dimens.spacingXSmall),
                    Text(item.collaborator.jobPosition,
                        style: LelloTextStyles.body(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).textLight())),
                    SizedBox(height: Dimens.spacingXSmall),
                    Text(item.marks, style: LelloTextStyles.body(theme)),
                    if (item.showItem) SizedBox(height: Dimens.spacingXSmall),
                    if (item.showItem)
                      Row(
                        children: [
                          Text("Registro Ponto:",
                              style: LelloTextStyles.body(theme)),
                          SizedBox(width: Dimens.spacingXSmall),
                          SvgPicture.asset("assets/ic_map_locale.svg"),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
