import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';

class AccessControlVisitantCard extends StatelessWidget {
  final AccessControl model;
  final VoidCallback onTap;
  final AccessControlAuthorizations authorization;
  const AccessControlVisitantCard({
    Key? key,
    required this.onTap,
    required this.model,
    required this.authorization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: LelloTheme.palleteOf(theme).customColor(),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.grey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildResidentPicture(),
                      SizedBox(width: Dimens.spacingMedium),
                      Expanded(
                          child: _buildServiceProviderInfo(theme, context)),
                    ],
                  ),
                ),
                SizedBox(width: Dimens.spacingSmall),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column _buildServiceProviderInfo(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (model.name != null)
          Text(
            model.name!,
            overflow: TextOverflow.ellipsis,
            style: LelloTextStyles.bodyBold(theme),
          ),
        if (model.name != null) SizedBox(height: Dimens.spacingXSmall),
        authorization.authType == "Interfonar"
            ? Text(
                getString(
                  context,
                  "access_control_phone",
                ),
                style: LelloTextStyles.body(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              )
            : Text(
                authorization.authType,
                style: LelloTextStyles.body(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
        if (model.type == "SERVICE")
          Text(
            model.business ?? getString(context, "access_control_provider"),
            style: LelloTextStyles.body(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
      ],
    );
  }

  Container _buildResidentPicture() {
    return Container(
      width: 56.0,
      height: 56.0,
      child: SvgPicture.asset("assets/user_placeholder.svg", width: 32),
    );
  }
}
