import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class MeProfileButtonsWidget extends StatelessWidget {
  final Function beginEditFunction;
  final Function deleteFunction;
  const MeProfileButtonsWidget({
    Key? key,
    required this.beginEditFunction,
    required this.deleteFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    late SessionBloc sessionBloc = BlocProvider.of(context);
    return Column(
      children: [
        PrimaryButton(
            text: getString(context, "edit"),
            onPressed: () {
              beginEditFunction();
            }),
        SizedBox(height: Dimens.spacingMedium),
        TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => deleteDialog(context, theme),
              );
            },
            child: Text(
              getString(context, "delete_account"),
              style: LelloTextStyles.button(theme)
                  ?.copyWith(color: theme.textTheme.bodyLarge!.color),
            )),
      ],
    );
  }

  Widget deleteDialog(BuildContext context, ThemeData theme) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 50.0,
              color: Colors.black,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "delete_account_dialog_title"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.titleSmall(theme)!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "delete_account_dialog_subtitle"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "delete_account_dialog_subtitle_complement"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme),
            ),
            SizedBox(height: Dimens.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    getString(context, "cancel").toUpperCase(),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    deleteFunction();
                  },
                  child: Text(
                    getString(context, "exclude").toUpperCase(),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
