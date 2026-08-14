import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../../core/dependency/application_container.dart';
import '../controllers/change_address_controller.dart';

class ChangeAddressFailurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller =
        ApplicationContainer.instance().resolve<ChangeAddressController>();
    return Theme(
      data: theme,
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          backgroundColor: LelloTheme.palleteOf(theme).warning(),
          body: Padding(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset("assets/ic_blocked_info.svg",
                      width: 92, height: 92),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(getString(context, "error_unknown"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor(),
                      )),
                  SizedBox(height: Dimens.spacingXLarge),
                  PrimaryButton(
                      onPressed: () {
                        controller.updateAddress(
                          condominiumId: controller.session.condominium!.id!,
                          unit: controller.updatedUnit,
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        getString(context, 'try_again'),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: LelloTheme.palleteOf(theme).text(),
                        ),
                      ),
                      buttonColor: LelloTheme.palleteOf(theme).background()),
                  SizedBox(height: Dimens.spacing),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size.fromHeight(54.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(width: 1, color: Colors.white),
                    ),
                    child: Center(
                      child: Text(getString(context, "cancel"),
                          style: LelloTextStyles.button(theme)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pop(context);
    return true;
  }
}
