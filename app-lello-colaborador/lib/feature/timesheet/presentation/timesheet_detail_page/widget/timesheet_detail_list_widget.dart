import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_point_flag_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetDetailListWidget extends StatelessWidget {
  final Map<DateTime, List<TimesheetElementDetail>> timesheetDetail;
  const TimesheetDetailListWidget({
    Key? key,
    required this.timesheetDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return timesheetDetail.isNotEmpty
        ? ListView.builder(
            itemCount: timesheetDetail.length,
            itemBuilder: (context, indexItem) {
              var keyDia = timesheetDetail.keys.toList()[indexItem];
              var valueDia = timesheetDetail.values.toList()[indexItem];
              return Container(
                color:
                    (indexItem % 2 == 0) ? Colors.white : Colors.grey.shade50,
                child: Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text:
                              "${getString(context, "timesheet_detail_date")}: ",
                          style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).hubText()),
                        ),
                        TextSpan(
                          text: DateFormat.yMd().format(keyDia),
                          style: LelloTextStyles.subtitle(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).hubText()),
                        ),
                      ])),
                      SizedBox(height: Dimens.spacing),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              getString(context, "timesheet_detail_time"),
                              style: LelloTextStyles.subtitleBold(theme)
                                  ?.copyWith(
                                      color: LelloTheme.palleteOf(theme)
                                          .hubText()),
                            ),
                          ),
                          SizedBox(width: Dimens.spacingSmall),
                          Expanded(
                            flex: 5,
                            child: Text(
                              getString(context, "timesheet_detail_treat"),
                              style: LelloTextStyles.subtitleBold(theme)
                                  ?.copyWith(
                                      color: LelloTheme.palleteOf(theme)
                                          .hubText()),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimens.spacing),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: valueDia.length,
                        itemBuilder: ((context, index) {
                          TimesheetPointFlagEnum flag =
                              valueDia[index].timesheetFlag;
                          Color color = TimesheetPointFlag.color(context, flag);
                          return Padding(
                            padding: EdgeInsets.only(bottom: Dimens.spacing),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      Text(
                                        valueDia[index].time,
                                        style: LelloTextStyles.subtitle(theme)
                                            ?.copyWith(color: color),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: Dimens.spacingSmall),
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          getString(
                                              context,
                                              TimesheetPointFlag.titleKey(
                                                  flag)),
                                          style: LelloTextStyles.subtitle(theme)
                                              ?.copyWith(color: color),
                                        ),
                                      ),
                                      if (TimesheetPointFlag.symbol(flag)
                                          .isNotEmpty)
                                        Container(
                                          width: 24.0,
                                          height: 24.0,
                                          alignment: Alignment.center,
                                          // padding: EdgeInsets.all(Dimens.spacingSmall),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: color),
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              TimesheetPointFlag.symbol(flag),
                                              style:
                                                  LelloTextStyles.subtitleBold(
                                                          theme)
                                                      ?.copyWith(
                                                color: color,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            })
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  getString(context, "timesheet_detail_page_empty"),
                  style: LelloTextStyles.subtitle(theme)
                      ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
                ),
              ),
            ],
          );
  }
}
