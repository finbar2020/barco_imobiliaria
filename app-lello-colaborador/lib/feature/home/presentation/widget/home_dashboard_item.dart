import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class HomeDashboardItem extends StatefulWidget {
  final HomeItemEnum homeItem;

  const HomeDashboardItem({
    Key? key,
    required this.homeItem,
  }) : super(key: key);

  @override
  State<HomeDashboardItem> createState() => _HomeDashboardItemState();
}

class _HomeDashboardItemState extends State<HomeDashboardItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(Dimens.spacingSmall),
      child: InkWell(
        onTap: () => widget.homeItem.onTap(context: context),
        child: Container(
          height: 100.0,
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.spacingSmall, vertical: Dimens.spacing),
          decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: LelloTheme.palleteOf(theme).grey(),
              ),
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                widget.homeItem.icon,
                height: 32,
              ),
              SizedBox(
                height: Dimens.spacing,
              ),
              Flexible(
                child: FittedBox(
                  child: Text(
                    getString(context, widget.homeItem.titleKey),
                    style: LelloTextStyles.body(theme),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
