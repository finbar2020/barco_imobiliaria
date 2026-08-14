import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_detector_page.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/access_settings_permission_denied/entity/access_settings_permissions_denied_item.dart';
import 'package:shared_features/feature/access_settings_permission_denied/presentation/page/access_settings_permission_denied_page.dart';
import 'package:shared_features/shared_features.dart';

class HomeRequestDeclinedDialog extends StatelessWidget {
  final DigitalTimesheetStatusEnum status;
  final bool isOnline;

  const HomeRequestDeclinedDialog({
    Key? key,
    required this.status,
    required this.isOnline,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_billet_alert.svg"),
            ),
            SizedBox(height: Dimens.spacing),
            Text("${getString(context, "attention")}!",
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            Text(getString(context, "home_request_denied_dialog_subtitle1"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            Text(getString(context, "home_request_denied_dialog_subtitle2"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacingLarge),
            Text(getString(context, "home_request_denied_dialog_subtitle3"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacing),
            InkWell(
              onTap: () {
                if (isOnline) {
                  Navigator.pushReplacementNamed(
                      context, ApplicationRoute.faceDetectionView,
                      arguments: FaceDetectorArgs(
                        statusEnum: status,
                        isOnline: isOnline,
                        condoRef: null,
                        employee: null,
                      )).then((result) {
                    if (result is FaceDetectorPageResult) {
                      switch (result) {
                        case FaceDetectorPageResult.locationDenied:
                          Navigator.of(context).pushNamed(
                              SharedApplicationRoute
                                  .accessSettingsPermissionDenied,
                              arguments: AcessSettingsPermissionDeniedPageArgs(
                                  acessSettingsPermissionsDeniedItem:
                                      AcessSettingsPermissionsDeniedItem(
                                          item:
                                              AcessSettingsPermissionsDeniedItemEnum
                                                  .location,
                                          isColaboradorApp: true)));
                          break;
                        default:
                          break;
                      }
                    }
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: EdgeInsets.all(Dimens.spacing),
                child: Text(
                  getString(context, "try_again").toUpperCase(),
                  style: LelloTextStyles.subBody(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).primary(),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(Dimens.spacing),
                child: Text(
                  getString(context, "later"),
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).textLight(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
