import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_controller.dart';

class TimesheetCard extends StatelessWidget {
  final bool showIcon;
  final TimesheetEmployee item;
  final ThemeData theme;
  final TimesheetController controller;
  const TimesheetCard({
    super.key,
    required this.item,
    required this.theme,
    required this.controller,
    this.showIcon = true,
  });

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
                  child: item.imageHash != null
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          httpHeaders: controller.customHeader,
                          imageUrl: controller.photoUrl(item.imageHash!),
                          placeholder: (context, url) => Container(
                            padding: const EdgeInsets.all(16.0),
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) =>
                              SvgPicture.asset("assets/user_placeholder.svg",
                                  width: 32),
                        )
                      : SvgPicture.asset(
                          "assets/user_placeholder.svg",
                          width: 32,
                        ),
                ),
              ),
              SizedBox(width: Dimens.spacingSmall),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? '',
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                    SizedBox(height: Dimens.spacingXSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.role ?? '',
                            style: LelloTextStyles.body(theme)!.copyWith(
                                color:
                                    LelloTheme.palleteOf(theme).textLight())),
                        if (showIcon)
                          Icon(Icons.arrow_forward_ios,
                              color: LelloTheme.palleteOf(theme).textLight()),
                      ],
                    ),
                    SizedBox(height: Dimens.spacingXSmall),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Turno: ", style: LelloTextStyles.body(theme)),
                        SizedBox(width: Dimens.spacingXSmall),
                        Flexible(
                          child: Text(item.turn ?? '',
                              style: LelloTextStyles.body(theme)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showIcon) SizedBox(height: Dimens.spacingSmall),
          if (showIcon) Divider(),
        ],
      ),
    );
  }
}
