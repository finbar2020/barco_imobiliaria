import 'package:colaborador/core/widgets/loading_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetSignLoadingBody extends StatelessWidget {
  const TimesheetSignLoadingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingWidget(
            message: getString(context, "timesheet_sign_loading"),
          ),
        ],
      ),
    );
  }
}
