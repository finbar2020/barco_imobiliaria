// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

import 'package:essentials/essentials.dart';

class UnitListItem extends StatelessWidget {
  final bool isDetails;
  final Unit unit;

  const UnitListItem({
    Key? key,
    this.isDetails = false,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDetails)
          Expanded(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  child: SvgPicture.asset(
                    "assets/ic_group.svg",
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                Text(getString(context, "units_group"),
                    overflow: TextOverflow.ellipsis,
                    style: LelloTextStyles.bodyBold(theme)),
                Text(unit.group ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: LelloTextStyles.body(theme)),
              ],
            ),
          ),
        if (isDetails) SizedBox(width: Dimens.spacingMedium),
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                child: SvgPicture.asset(
                  "assets/ic_unit.svg",
                  alignment: Alignment.bottomCenter,
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(getString(context, "units_unit"),
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.bodyBold(theme)),
              Text(unit.title ?? "", style: LelloTextStyles.body(theme)),
            ],
          ),
        ),
        SizedBox(width: Dimens.spacingMedium),
        Expanded(
          flex: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                child: SvgPicture.asset(
                  "assets/ic_residents.svg",
                  alignment: Alignment.bottomCenter,
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(getString(context, "units_residents"),
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.bodyBold(theme)),
              Text(unit.residentCount?.toString() ?? "",
                  style: LelloTextStyles.body(theme)),
            ],
          ),
        ),
        SizedBox(width: Dimens.spacingMedium),
        Expanded(
          flex: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                child: SvgPicture.asset(
                  "assets/ic_vehicle.svg",
                  alignment: Alignment.bottomCenter,
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "units_vehicle"),
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.bodyBold(theme),
              ),
              Text(
                unit.vehicleCount?.toString() ?? '0',
                style: LelloTextStyles.body(theme),
              ),
            ],
          ),
        ),
        SizedBox(width: Dimens.spacingMedium),
      ],
    );
  }
}
