import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';

import '../../../../../generated/l10n.dart';

class SubUserRemoveSuccessPage extends StatefulWidget {
  const SubUserRemoveSuccessPage({required this.name, Key? key})
      : super(key: key);

  final String name;

  @override
  State<SubUserRemoveSuccessPage> createState() =>
      _SubUserRemoveSuccessPageState();
}

class _SubUserRemoveSuccessPageState extends State<SubUserRemoveSuccessPage> {
  SessionBloc sessionBloc = ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).pending_requests,
          useGetString: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  size: 92,
                  color: LelloTheme.palleteOf(theme).success(),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      widget.name,
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)?.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' foi excluído(a) com sucesso!',
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)?.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 54.0,
            child: PrimaryButton(
              child: Text(
                getString(context, "close"),
                style: LelloTextStyles.button(theme),
              ),
              onPressed: () {
                ApplicationContainer.instance()
                    .resolve<SubUserController>()
                    .getSubUsers();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
