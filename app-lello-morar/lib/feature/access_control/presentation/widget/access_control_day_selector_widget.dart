import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/widgets/hex_color.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';

class DaySelector extends StatefulWidget {
  final AccessControlStore accessControlStore;
  final List<bool> ignore;
  const DaySelector({
    Key? key,
    required this.accessControlStore,
    required this.ignore,
  }) : super(key: key);

  @override
  _DaySelectorState createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  List<String> week = ["D", "S", "T", "Q", "Q", "S", "S"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    return BlocBuilder(
      bloc: widget.accessControlStore.bloc,
      builder: (context, state) {
        if (state is EditVisitantState) {
          return Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            children: [
              ...List.generate(
                  week.length,
                  (index) => IgnorePointer(
                        ignoring: widget.ignore[index],
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              setState(() {
                                state.model.choices[index] =
                                    !state.model.choices[index];
                              });
                            });
                          },
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: widget.ignore[index]
                                    ? HexColor("#989898")
                                    : state.model.choices[index]
                                        ? LelloTheme.palleteOf(theme).success()
                                        : LelloTheme.palleteOf(theme)
                                            .separator(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Center(
                              child: Text(
                                week[index],
                                style: LelloTextStyles.body(theme)!.copyWith(
                                  color: widget.ignore[index]
                                      ? HexColor("#989898")
                                      : state.model.choices[index]
                                          ? LelloTheme.palleteOf(theme)
                                              .customColor()
                                          : LelloTheme.palleteOf(theme).grey(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
            ],
          );
        }
        return Container();
      },
    );
  }
}
