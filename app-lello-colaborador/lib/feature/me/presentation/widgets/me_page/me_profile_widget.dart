import 'package:colaborador/core/widgets/app_version_widget.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_buttons_widget.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_info_widget.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_picture_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class MeProfileWidget extends StatefulWidget {
  const MeProfileWidget({super.key});

  @override
  _MeProfileWidgetState createState() => _MeProfileWidgetState();
}

class _MeProfileWidgetState extends State<MeProfileWidget> {
  late ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    MeBloc meBloc = BlocProvider.of(context);

    return BlocBuilder<MeBloc, MeState>(
      bloc: meBloc,
      builder: (context, state) {
        if (state.me == null) {
          return Column(
            children: [
              Expanded(
                  child: Center(
                child: Text(
                  getString(context, "unable_to_load"),
                  style: LelloTextStyles.body(theme),
                ),
              )),
              const Divider(
                height: 1,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                child: TertiaryButton(
                    text: getString(context, "logout"),
                    onPressed: () {
                      _logout();
                    }),
              )
            ],
          );
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: const AppVersionWidget(),
                  ),
                  MeProfilePictureWidget(
                    meBloc: meBloc,
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Center(
                    child: Text(
                      state.me!.name,
                      style: LelloTextStyles.headline(theme),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: TertiaryButton(
                        text: getString(context, "logout"),
                        onPressed: () {
                          _logout();
                        }),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  MeProfileInfoWidget(me: state.me!),
                  SizedBox(height: Dimens.spacingMedium),
                  MeProfileButtonsWidget(
                    beginEditFunction: () => meBloc.beginEdit(),
                    deleteFunction: () => meBloc.deleteAccount(state.me!),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _logout() {
    MeBloc bloc = BlocProvider.of(context);
    bloc.beginLogOut();
  }
}
