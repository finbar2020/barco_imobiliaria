import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/hex_color.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_state.dart';

class ReservationWeekendSelectorWidget extends StatefulWidget {
  final ReservationChangeRulesLoadedState state;
  const ReservationWeekendSelectorWidget({
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  _ReservationWeekendSelectorWidgetState createState() =>
      _ReservationWeekendSelectorWidgetState();
}

class _ReservationWeekendSelectorWidgetState
    extends State<ReservationWeekendSelectorWidget> {
  List<String> week = [];
  List<bool> choices = [];
  List<int> listIndex = [];

  @override
  void initState() {
    super.initState();
    week = ["Sab", "Dom"];
    choices = [false, false];
    widget.state.rules.allowedDaysList?.forEach((element) {
      if (element == 0) {
        choices[1] = true;
      } else if (element == 6) {
        choices[0] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        ...List.generate(
            week.length,
            (index) => InkWell(
                  onTap: () {
                    setState(() {
                      choices[index] = !choices[index];
                    });
                    setInfo();
                  },
                  child: Container(
                    width: 45.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                        color: choices[index]
                            ? theme.primaryColor
                            : HexColor("#D8D8D8"),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Center(
                      child: Text(
                        week[index],
                        style: LelloTextStyles.body(theme)!.copyWith(
                          color: choices[index]
                              ? Colors.white
                              : HexColor("#61000000"),
                        ),
                      ),
                    ),
                  ),
                )),
      ],
    );
  }

  void setInfo() {
    if (choices[0] && !widget.state.rules.allowedDaysList!.contains(6)) {
      widget.state.rules.allowedDaysList!.add(6);
    } else if (!choices[0] && widget.state.rules.allowedDaysList!.contains(6)) {
      widget.state.rules.allowedDaysList!.remove(6);
    }
    if (choices[1] && !widget.state.rules.allowedDaysList!.contains(0)) {
      widget.state.rules.allowedDaysList!.add(0);
    } else if (!choices[1] && widget.state.rules.allowedDaysList!.contains(0)) {
      widget.state.rules.allowedDaysList!.remove(0);
    }
  }
}
