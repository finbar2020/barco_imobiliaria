import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AccessControlCpfDialog extends StatelessWidget {
  final SessionBloc sessionBloc;
  final VoidCallback onTap;
  final bool isVisitant;
  const AccessControlCpfDialog({
    Key? key,
    required this.sessionBloc,
    required this.onTap,
    required this.isVisitant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
              isVisitant
                  ? getString(context, "access_control_cpf_visitant_title")
                  : getString(context, "access_control_cpf_provider_title"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.titleSmall(theme)!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              isVisitant
                  ? getString(context, "access_control_cpf_visitant_subtitle")
                  : getString(context, "access_control_cpf_provider_subtitle"),
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
                  onTap: onTap,
                  child: Text(
                    "VAMOS LÁ",
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
