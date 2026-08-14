import 'package:flutter/material.dart';

import 'package:essentials/essentials.dart';

class InactivityTimerDraggable extends StatelessWidget {
  final int timer;
  final int duration;

  const InactivityTimerDraggable({
    Key? key,
    required this.timer,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLastSeconds = timer <= 10;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: isLastSeconds ? 60 : 50,
          width: isLastSeconds ? 60 : 50,
          decoration: BoxDecoration(
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(3, 3),
                spreadRadius: 1,
              )
            ],
            color: LelloTheme.palleteOf(theme).primary(),
            borderRadius: BorderRadius.circular(isLastSeconds ? 60 : 50),
          ),
          child: const SizedBox(),
        ),
        SizedBox(
          height: isLastSeconds ? 60 : 50,
          width: isLastSeconds ? 60 : 50,
          child: CircularProgressIndicator(
            value: timer.toDouble() / duration.toDouble(),
          ),
        ),
        Container(
          height: isLastSeconds ? 60 : 50,
          width: isLastSeconds ? 60 : 50,
          decoration: BoxDecoration(
            color: LelloTheme.palleteOf(theme).primary(),
            borderRadius: BorderRadius.circular(isLastSeconds ? 60 : 50),
            border: Border.all(
              color: LelloTheme.palleteOf(theme).background(),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              "${timer.toString()}s",
              style: isLastSeconds
                  ? LelloTheme.light.textTheme.titleLarge!.merge(
                      TextStyle(
                        color: LelloTheme.palleteOf(theme).background(),
                      ),
                    )
                  : LelloTheme.light.textTheme.bodyMedium!.merge(
                      TextStyle(
                        color: LelloTheme.palleteOf(theme).background(),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
