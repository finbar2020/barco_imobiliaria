import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';

class DigitalMeetingWidget extends StatelessWidget {
  final VoidCallback onTap;
  final DigitalMeeting model;
  const DigitalMeetingWidget({
    Key? key,
    required this.model,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      model.name!,
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                    SizedBox(height: Dimens.spacingXSmall),
                    Text(
                      "${getString(context, "access_control_start")}: ${model.inicio}",
                      style: LelloTextStyles.caption(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textOpaque()),
                    ),
                    SizedBox(height: Dimens.spacingXSmall),
                    Text(
                      '${getString(context, "access_control_end")}: ${model.fim}',
                      style: LelloTextStyles.caption(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textOpaque()),
                    ),
                    SizedBox(height: Dimens.spacingXSmall),
                    Visibility(
                      visible: model.reuniao.isNotEmpty,
                      child: Text(
                        '${getString(context, "meeting")}: ${model.reuniao}',
                        style: LelloTextStyles.caption(theme),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 10.0,
                            width: 10.0,
                            decoration: BoxDecoration(
                              color: getColor(model.statusMeeting ?? "", theme),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: Dimens.spacingSmall),
                          Text(
                            model.statusMeeting!,
                            overflow: TextOverflow.ellipsis,
                            style: LelloTextStyles.subBody(theme)!.copyWith(
                              color: getColor(model.statusMeeting ?? "", theme),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimens.spacing),
              if (model.validandoAcesso)
                Icon(
                  Icons.keyboard_arrow_right,
                  color: LelloTheme.palleteOf(theme).textOpaque(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(String statusMeeting, ThemeData theme) {
    switch (statusMeeting) {
      case "Iniciada":
        return LelloTheme.palleteOf(theme).success();
      case "Aguardando":
        return LelloTheme.palleteOf(theme).warning();
      case "Encerrada":
        return LelloTheme.palleteOf(theme).textOpaque();
      default:
        return LelloTheme.palleteOf(theme).text();
    }
  }
}
