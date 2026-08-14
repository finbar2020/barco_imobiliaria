import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/space_list/space_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/space_list/space_state.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class SpaceListWidget extends StatefulWidget {
  final Widget? header;
  final Function(Space)? onPressed;

  const SpaceListWidget({Key? key, this.header, this.onPressed})
      : super(key: key);
  @override
  SpaceListWidgetState createState() => SpaceListWidgetState();
}

class SpaceListWidgetState extends State<SpaceListWidget> {
  final SpaceBloc bloc = ApplicationContainer.instance().resolve();

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  ScrollController? controller;
  Unit? selectedUnit;
  Space? selectedSpace;
  bool blockedUser = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: BlocConsumer(
          bloc: bloc,
          listener: (context, state) {},
          builder: (context, state) {
            if (state is SpaceLoadingState) {
              return const Column(
                children: [
                  Expanded(
                    child: LoadingWidget(),
                  ),
                ],
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Qual unidade desejada?'),
                      SizedBox(
                        height: Dimens.spacingSmall,
                      ),
                      DropdownButtonFormField(
                        isExpanded: false,
                        hint: const Text('Selecione'),
                        onSaved: (value) {
                          setState(() {
                            selectedUnit = value as Unit;
                          });
                        },
                        value: selectedUnit,
                        items: (state as SpaceState)
                            .unitsList
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value.title ?? ""),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedUnit = value as Unit;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text('Que espaço deseja reservar'),
                      SizedBox(
                        height: Dimens.spacingSmall,
                      ),
                      DropdownButtonFormField(
                        isExpanded: false,
                        onSaved: (value) {
                          selectedSpace = value as Space;
                        },
                        hint: const Text('Selecione'),
                        value: selectedSpace,
                        items: state.data
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value.name ?? ""),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSpace = value as Space;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: Visibility(
                          visible: blockedUser,
                          child: Center(
                              child: Text(
                            'Esta unidade não pode reservar a área porque possui cotas ou acordos em aberto',
                            style: LelloTextStyles.error(theme),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: PrimaryButton(
                      buttonColor: theme.primaryColor,
                      theme: theme,
                      text: 'Avançar',
                      onPressed: selectedSpace != null && selectedUnit != null
                          ? () {
                              if (selectedSpace!
                                      .reservationRule.blockedForDefaulters! &&
                                  !selectedUnit!.adimplente!) {
                                setState(() {
                                  blockedUser = true;
                                });
                              } else {
                                if (selectedSpace!
                                        .reservationRule.blockedForSettlers! &&
                                    selectedUnit!.agreement!) {
                                  setState(() {
                                    blockedUser = true;
                                  });
                                } else {
                                  Navigator.of(context).pushNamed(
                                      ApplicationRoute.spaceReservationCalendar,
                                      arguments: SpaceCalendarArguments(
                                          space: selectedSpace!,
                                          unit: selectedUnit!));
                                  setState(() {
                                    blockedUser = false;
                                  });
                                }
                              }
                            }
                          : () {}),
                )
              ],
            );
          }),
    );
  }
}

class SpaceCalendarArguments {
  Space? space;
  Unit? unit;
  SpaceCalendarArguments({this.space, this.unit});
}
