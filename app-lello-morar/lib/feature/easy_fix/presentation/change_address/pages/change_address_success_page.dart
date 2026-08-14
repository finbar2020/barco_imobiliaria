import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/app_review/app_review.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/controllers/change_address_controller.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../../../session/presentation/bloc/session_bloc.dart';

class ChangeAddressSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionBloc = ApplicationContainer.instance().resolve<SessionBloc>();
    final controller =
        ApplicationContainer.instance().resolve<ChangeAddressController>();
    return Theme(
      data: theme,
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          backgroundColor: LelloTheme.palleteOf(theme).success(),
          body: Padding(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset("assets/ic_success.svg",
                      width: 92, height: 92),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(
                    getString(context, "change_address_success_page_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(
                    '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme)
                          .backgroundDark()
                          .withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(
                    getString(context, "change_address_success_page_subtitle"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  PrimaryButton(
                    onPressed: () {
                      controller.getEasyFixUnit(
                        condominiumId: controller.session.condominium!.id!,
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      getString(context, 'conclude'),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
                    buttonColor: theme.colorScheme.onPrimary,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    AppReview.call(context: context);
    return true;
  }
}
