import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../bloc/inactivity/inactivity_state.dart';
import 'inactivity_timer_draggable.dart';

class InactivityBlocBuilder extends StatelessWidget {
  final InactivityCubit inactivityCubit;
  const InactivityBlocBuilder({
    Key? key,
    required this.inactivityCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocBuilder(
      bloc: inactivityCubit,
      builder: (context, state) {
        if (state.runtimeType == ChangeTimeState) {
          return Positioned(
            top: inactivityCubit.offsetBubble.dy,
            left: inactivityCubit.offsetBubble.dx,
            child: Draggable(
              onDragEnd: (details) {
                inactivityCubit.setOffset(details.offset);
              },
              feedback: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: LelloTheme.palleteOf(theme).primary(),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: LelloTheme.palleteOf(theme).background(),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    "${(state as ChangeTimeState).timer.toString()}s",
                    style: LelloTheme.light.textTheme.bodyMedium!.merge(
                      TextStyle(
                        color: LelloTheme.palleteOf(theme).background(),
                      ),
                    ),
                  ),
                ),
              ),
              child: InactivityTimerDraggable(
                duration: inactivityCubit.duration,
                timer: state.timer,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
