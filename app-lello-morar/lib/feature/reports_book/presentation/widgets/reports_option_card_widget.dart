import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morar/feature/reports_book/domain/entity/report_option.dart';

class ReportsOptionCardWidget extends StatelessWidget {
  final ReportOption reportOption;
  final bool isFirstPage;
  const ReportsOptionCardWidget({
    Key? key,
    required this.reportOption,
    this.isFirstPage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: reportOption.onTap,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SvgPicture.asset(reportOption.assetImage),
                ),
                SizedBox(width: Dimens.homeMenuIconSize),
                Expanded(
                    flex: 5,
                    child: Text(
                      reportOption.title,
                      style: LelloTextStyles.subtitleBold(theme),
                    )),
                Expanded(
                  flex: 1,
                  child: reportOption.newMessages
                      ? Container(
                          height: 10.0,
                          width: 10.0,
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1),
      ],
    );
  }
}
