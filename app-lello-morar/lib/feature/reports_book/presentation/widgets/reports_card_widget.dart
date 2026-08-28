import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';

class ReportsCardWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Report report;
  final String? index;

  const ReportsCardWidget({
    Key? key,
    this.onTap,
    this.index,
    required this.report,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 140),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: Colors.white.withOpacity(0.9),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacing),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getString(context, report.getTypeReport),
                              style: LelloTextStyles.bodyBold(theme),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: Dimens.spacingXSmall),
                            Text(
                              index! + report.getDate,
                              style: LelloTextStyles.subBody(theme),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: Dimens.spacingXSmall),
                            report.public
                                ? Text(
                                    getString(context, "reports_public"),
                                    style: LelloTextStyles.subBody(theme)!
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Text(
                                    getString(context, "reports_not_public"),
                                    style: LelloTextStyles.subBody(theme)!
                                        .copyWith(
                                      color:
                                          LelloTheme.palleteOf(theme).primary(),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            if (report.newMessage!)
                              Column(
                                children: [
                                  SizedBox(height: Dimens.spacingSmall),
                                  Row(
                                    children: [
                                      Container(
                                        height: 10.0,
                                        width: 10.0,
                                        decoration: BoxDecoration(
                                          color: LelloTheme.palleteOf(theme)
                                              .warning(),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: Dimens.spacingSmall),
                                      Text(
                                        getString(
                                            context, 'reports_new_message'),
                                        style: LelloTextStyles.body(theme)
                                            ?.copyWith(
                                          color: LelloTheme.palleteOf(theme)
                                              .warning(),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            SizedBox(height: Dimens.spacing),
                            Text(
                              report.reportContents!.length != 0
                                  ? report.reportContents!.last.content!
                                  : getString(context, "reports_no_content"),
                              style: LelloTextStyles.body(theme),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Flexible: limita a largura da situação para as
                        // reticências do texto funcionarem.
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(Dimens.spacingSmall),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getString(context, report.getSituation),
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          LelloTextStyles.body(theme)!.copyWith(
                                        color: color(
                                            closed: report.closed!,
                                            theme: theme),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Dimens.spacing),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 35.0,
                                color: LelloTheme.palleteOf(theme).grey(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color color({required bool closed, required ThemeData theme}) {
    {
      switch (closed) {
        case false:
          return theme.primaryColor;
        case true:
          return LelloTheme.palleteOf(theme).success();
      }
    }
  }
}
