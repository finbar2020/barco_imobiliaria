import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';

class ReportsCardWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Report report;

  const ReportsCardWidget({
    Key? key,
    this.onTap,
    required this.report,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getString(context, report.getTypeReport),
                          style: LelloTextStyles.bodyBold(theme)!.copyWith(
                            color: report.closed
                                ? LelloTheme.palleteOf(theme).grey()
                                : LelloTheme.palleteOf(theme).text(),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "#${report.numReport} ${report.getDate()}",
                          style: LelloTextStyles.subBody(theme),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    report.getNewMessageWidget(context, theme),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          report.isPublic
                              ? Text(
                                  getString(context, 'report_public'),
                                  style: LelloTextStyles.bodyBold(theme)!.merge(
                                    TextStyle(color: theme.disabledColor),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  getString(context, 'report_confidential'),
                                  style: LelloTextStyles.bodyBold(theme)!.merge(
                                    TextStyle(color: theme.primaryColor),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                          if (report.residentsName != null)
                            Container(
                              child: Text(
                                "Condômino: ${report.residentsName}",
                                style:
                                    LelloTextStyles.bodyBold(theme)!.copyWith(
                                  color: report.closed
                                      ? LelloTheme.palleteOf(theme).grey()
                                      : LelloTheme.palleteOf(theme).text(),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          SizedBox(
                            height: 5.0,
                          ),
                          if (report.unit?.name != null)
                            Container(
                              child: Text(
                                "Unidade: ${report.unit!.name}",
                                style:
                                    LelloTextStyles.bodyBold(theme)!.copyWith(
                                  color: report.closed
                                      ? LelloTheme.palleteOf(theme).grey()
                                      : LelloTheme.palleteOf(theme).text(),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 40.0,
                        color: report.closed
                            ? LelloTheme.palleteOf(theme).grey()
                            : LelloTheme.palleteOf(theme).secondary(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
