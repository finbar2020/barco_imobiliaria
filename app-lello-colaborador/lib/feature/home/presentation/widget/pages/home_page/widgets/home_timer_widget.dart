import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class HomeTimerWidget extends StatefulWidget {
  const HomeTimerWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeTimerWidget> createState() => _HomeTimerWidgetState();
}

class _HomeTimerWidgetState extends State<HomeTimerWidget> {
  bool runTimer = true;
  String _timeString = "";
  String _dayString = "";

  @override
  void initState() {
    super.initState();
    setUp();
    Timer.periodic(
        const Duration(seconds: 1), (Timer timer) => _getTime(timer));
  }

  @override
  void dispose() {
    runTimer = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingSmall),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
            horizontal: Dimens.spacingMedium, vertical: Dimens.spacing),
        decoration: BoxDecoration(
            color: LelloTheme.palleteOf(theme).greyCard(),
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _timeString,
              style: LelloTextStyles.titleSmall(theme),
            ),
            SizedBox(
              height: Dimens.spacingSmall,
            ),
            Text(
              _dayString,
              style: LelloTextStyles.body(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  String _formatDay(DateTime dateTime) {
    return DateFormat('EEEE, dd/MM/yyyy').format(dateTime);
  }

  void _getTime(Timer timer) {
    if (!runTimer) {
      timer.cancel();
      return;
    }
    setState(() {
      setUp();
    });
  }

  void setUp() {
    _timeString = _formatTime(DateTime.now());
    _dayString = _formatDay(DateTime.now());
  }
}
