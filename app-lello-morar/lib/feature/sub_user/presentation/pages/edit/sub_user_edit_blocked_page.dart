import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_card_widget.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../controllers/sub_user_edit_controller.dart';

class SubUserEditBlockedPage extends StatefulWidget {
  SubUserEditBlockedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SubUserEditBlockedPage> createState() => _SubUserEditBlockedPage();
}

class _SubUserEditBlockedPage extends State<SubUserEditBlockedPage> {
  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();

  final controller =
      ApplicationContainer.instance().resolve<SubUserEditController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubUserCardWidget(
          model: controller.userSelected!,
          sessionBloc: sessionBloc,
          isBlocked: true,
          isList: true,
          isEdit: true,
          onPressed: () {
            _showDialogBlockUser(
              context,
            );
          },
        ),
        SizedBox(height: Dimens.spacingMedium),
        Opacity(
          opacity: 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildHintAboveInput(context, "email", theme),
                SizedBox(height: Dimens.spacingSmall),
                Text(
                  controller.userSelected!.cpf ??
                      getString(context, "not_informed"),
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.body(theme),
                ),
                SizedBox(height: Dimens.spacing),
                _buildHintAboveInput(context, "full_name", theme),
                SizedBox(height: Dimens.spacingSmall),
                Text(
                  controller.userSelected!.name ??
                      getString(context, "not_informed"),
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.body(theme),
                ),
                SizedBox(height: Dimens.spacing),
                _buildHintAboveInput(context, "profile_update_email", theme),
                SizedBox(height: Dimens.spacingSmall),
                Text(
                  controller.userSelected!.email ??
                      getString(context, "not_informed"),
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.body(theme),
                ),
                SizedBox(height: Dimens.spacing),
                _buildHintAboveInput(
                    context, "registration_lello_user_phone_title", theme),
                SizedBox(height: Dimens.spacingSmall),
                Text(
                  controller.userSelected!.phone ??
                      getString(context, "not_informed"),
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.body(theme),
                ),
                SizedBox(height: Dimens.spacingMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Text _buildHintAboveInput(
      BuildContext context, String title, ThemeData theme) {
    return Text(getString(context, title),
        style: LelloTextStyles.bodyBold(theme));
  }

  void _showDialogBlockUser(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Você optou por desbloquear esse usuário.',
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.body(theme)),
              SizedBox(height: 8),
              Text('Deseja continuar?',
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.bodyBold(theme)),
              SizedBox(height: 16),
              PrimaryButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await controller.subUserUpdate(
                      isUseApp: false,
                      isBlock: true,
                    );
                  },
                  text: 'Sim, desbloquear'),
              SizedBox(height: 8),
              SecondaryButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: 'Não, quero voltar',
                  buttonBorderColor: LelloTheme.palleteOf(theme).primary()),
            ],
          ),
        ),
      ),
    );
  }
}
