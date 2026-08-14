import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/hex_color.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_state.dart';

class ReservationWeekSelectorWidget extends StatefulWidget {
  final ReservationChangeRulesLoadedState state;
  const ReservationWeekSelectorWidget({
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  _ReservationWeekSelectorWidgetState createState() =>
      _ReservationWeekSelectorWidgetState();
}

class _ReservationWeekSelectorWidgetState
    extends State<ReservationWeekSelectorWidget> {
  List<String> week = [];
  List<bool> choices = [];
  List<int> listIndex = [];

  @override
  void initState() {
    super.initState();
    week = ["Seg", "Ter", "Qua", "Qui", "Sex"];
    choices = [false, false, false, false, false];
    widget.state.rules.allowedDaysList?.forEach((element) {
      if (element != 0 && element != 6) {
        choices[element - 1] = true;
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
                    if (choices[index]) {
                      widget.state.rules.allowedDaysList!.add(index + 1);
                    } else {
                      widget.state.rules.allowedDaysList!.remove(index + 1);
                    }
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
}
