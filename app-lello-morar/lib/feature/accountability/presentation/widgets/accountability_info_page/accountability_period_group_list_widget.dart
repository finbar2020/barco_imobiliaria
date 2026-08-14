import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_page/accountability_group_summary_widget.dart';

class AccountabilityPeriodGroupListWidget extends StatelessWidget {
  final String title;
  final List<AccountabilityGrouped> groupedEntries;
  const AccountabilityPeriodGroupListWidget({
    Key? key,
    required this.title,
    required this.groupedEntries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Dimens.spacingMedium, Dimens.spacingMedium, Dimens.spacingMedium, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: LelloTextStyles.title(theme),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            getString(context, "accountability_historial_releases"),
            style: LelloTextStyles.titleSmall(theme),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Expanded(
            child: ListView.separated(
              itemCount: groupedEntries.length,
              itemBuilder: (context, index) => AccountabilityGroupSummaryWidget(
                accountabilityGrouped: groupedEntries[index],
              ),
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: Dimens.spacing),
                child: Divider(height: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
