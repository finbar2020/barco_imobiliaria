import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/space/presentation/widget/space_list_widget.dart';

class ReservationRegistrationSpacePage extends StatelessWidget {
  const ReservationRegistrationSpacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            theme: theme,
            title: getString(context, "space_reserve_space_moving")),
        body: _buildList(context, theme),
      ),
    );
  }

  Widget _buildList(BuildContext context, ThemeData theme) {
    return SpaceListWidget(
      onPressed: (space) {
        //final registration = ReservationRegistration()..space = space;
      },
      header: Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(getString(context, "space_reservation_select"),
                style: LelloTextStyles.title(theme))
          ],
        ),
      ),
    );
  }
}
