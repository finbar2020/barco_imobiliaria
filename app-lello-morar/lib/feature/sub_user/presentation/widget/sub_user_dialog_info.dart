import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import 'access_table_widget.dart';

class SubUserDialogInfo extends StatefulWidget {
  const SubUserDialogInfo({Key? key}) : super(key: key);

  @override
  _SubUserDialogInfoState createState() => _SubUserDialogInfoState();
}

class _SubUserDialogInfoState extends State<SubUserDialogInfo> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => FractionallySizedBox(
            heightFactor: 0.9,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  Text(
                    getString(
                        context, "staff_access_info_title"),
                    style:
                    LelloTextStyles.subtitleBold(theme),
                  ),
                  SizedBox(
                    height: Dimens.spacing,
                  ),
                  Text(
                    getString(context,
                        "staff_access_info_description"),
                    style: LelloTextStyles.body(theme),
                  ),
                  SizedBox(
                    height: Dimens.spacingMedium,
                  ),
                  const SingleChildScrollView(
                    child: AccessTable(),
                  )
                ],
              ),
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            size: Dimens.spacingLarge,
            color: LelloTheme.palleteOf(theme).textAccent(),
          ),
          SizedBox(
            width: Dimens.spacingSmall,
          ),
          Expanded(
            child: Text(
              getString(context, "resident_what_access_profile"),
              overflow: TextOverflow.clip,
              style: LelloTextStyles.subBody(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).textAccent(),
                decoration: TextDecoration.underline,
                decorationColor: LelloTheme.palleteOf(theme).textAccent()
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildInfos(String text) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 5.0,
              width: 5.0,
              decoration: BoxDecoration(
                color: LelloTheme.palleteOf(theme).grey(),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: Dimens.spacingXSmall,
            ),
            Expanded(child: Text(getString(context, text))),
          ],
        ),
        SizedBox(
          height: Dimens.spacingSmall,
        ),
      ],
    );
  }
}
