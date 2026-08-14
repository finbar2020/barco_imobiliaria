import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/session/domain/entity/session.dart';

import '../../controllers/sub_user_edit_controller.dart';

class SubUserEditConcludePage extends StatefulWidget {
  final bool blocked;
  final Session session;

  const SubUserEditConcludePage({
    Key? key,
    this.blocked = false,
    required this.session,
  }) : super(key: key);

  @override
  _SubUserEditConcludePageState createState() =>
      _SubUserEditConcludePageState();
}

class _SubUserEditConcludePageState extends State<SubUserEditConcludePage> {
  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<SubUserEditController>();
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: 'Moradores',
          theme: theme,
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
                Text(
                  widget.blocked
                      ? 'Usuário bloqueado com sucesso!'
                      : 'Usuário desbloqueado com sucesso!',
                  textAlign: TextAlign.center,
                  style:
                      LelloTextStyles.headline(theme)?.copyWith(fontSize: 32),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25.0),
          child: PrimaryButton(
            text: "Fechar",
            onPressed: () {
              controller.getSubUsers();
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
