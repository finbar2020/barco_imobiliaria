import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_form_content_widget.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_dialog_info.dart';
import '../../../../../core/dependency/application_container.dart';
import '../../../domain/entity/sub_user_role.dart';
import '../../controllers/sub_user_edit_controller.dart';

class SubUserEditRegisteredPage extends StatefulWidget {
  final GlobalKey<FormState> formkey;

  const SubUserEditRegisteredPage({Key? key, required this.formkey})
      : super(key: key);

  @override
  State<SubUserEditRegisteredPage> createState() =>
      _SubUserEditRegisteredPage();
}

class _SubUserEditRegisteredPage extends State<SubUserEditRegisteredPage> {
  final sessionBloc = ApplicationContainer.instance().resolve<SessionBloc>();
  final controller =
      ApplicationContainer.instance().resolve<SubUserEditController>();
  final Validator _validator = ApplicationContainer.instance().resolve();

  bool flagBilletByEmail = false;

  @override
  void initState() {
    super.initState();
    final selectedUser = controller.userSelected;
    controller.nameController.text = selectedUser?.name ?? "";
    controller.emailController.text = selectedUser?.email ?? "";
    controller.cpfController.text = selectedUser?.cpf ?? "";
    controller.phoneController.text = selectedUser?.phone ?? '';
    controller.phone = selectedUser?.phone ?? '';
    flagBilletByEmail = selectedUser?.flagBoletoEmail ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;

    return Form(
      key: widget.formkey,
      child: Column(
        children: [
          _buildRoleSelector(context, theme),
          SizedBox(height: Dimens.spacingMedium),
          const Divider(),
          SizedBox(height: Dimens.spacing),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildFormContent(context, theme),
          ),
        ],
      ),
    );
  }

  bool isSecondNameMasked(String fullName) {
    final names = fullName.split(' ');
    if (names.length < 2) return false;
    final firstName = names[0];
    final secondName = names[1];

    return firstName.runes.any((char) => String.fromCharCode(char) != '*') &&
        secondName.runes.every((char) => String.fromCharCode(char) == '*');
  }

  Widget _buildRoleSelector(BuildContext context, ThemeData theme) {
    final roleItems = controller.roles.map((SubUserRole item) {
      return DropdownMenuItem<SubUserRole>(
        value: item,
        enabled: item.enabled == true,
        child: Text(
          item.description ?? "",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: item.enabled == true ? Colors.black : Colors.grey,
          ),
        ),
      );
    }).toList();

    final selectedRole = controller.roles.firstWhere(
      (e) => e.description == controller.userSelected?.roleDescription,
      orElse: () => SubUserRole(
        role: controller.userSelected?.role ?? '',
        description: controller.userSelected?.roleDescription ?? '',
        enabled: true,
      ),
    );

    final canEdit = sessionBloc.checkRback(
                ApplicationRbac.morarMoradoresSubmoradoresDetalhes) &&
            controller.mainUser.role == 'morar.proprietario' ||
        (controller.mainUser.id != controller.userSelected?.id &&
            controller.mainUser.role == 'morar.inquilino');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${getString(context, 'resident_access_profile')}*',
                style: LelloTextStyles.bodyBold(theme),
              ),
              SizedBox(height: Dimens.spacingSmall),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: LelloTheme.palleteOf(theme).customColor(),
                  border: Border.all(
                    width: 1.0,
                    color: LelloTheme.palleteOf(theme).grey(),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: DropdownButton<SubUserRole>(
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  underline: const SizedBox.shrink(),
                  hint: Text(getString(context, "choose_an_option")),
                  value: selectedRole,
                  items: roleItems,
                  onTap: canEdit &&
                          !isSecondNameMasked(
                              controller.userSelected?.name ?? '')
                      ? () => FocusScope.of(context).unfocus()
                      : null,
                  onChanged: canEdit &&
                          !isSecondNameMasked(
                              controller.userSelected?.name ?? '')
                      ? (SubUserRole? value) {
                          setState(() {
                            controller.userSelected =
                                controller.userSelected?.copyWith(
                              role: value?.role,
                              roleDescription: value?.description,
                            );
                            controller.verifyChanges = true;
                          });
                        }
                      : null,
                ),
              ),
              if (canEdit) ...[
                SizedBox(height: Dimens.spacingSmall),
                const SubUserDialogInfo(),
              ]
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent(BuildContext context, ThemeData theme) {
    return SubUserFormDetails(
      controller: controller,
      validator: _validator,
      theme: theme,
      sessionBloc: sessionBloc,
      flagBilletByEmail: flagBilletByEmail,
      onBilletFlagChanged: (value) {
        setState(() {
          flagBilletByEmail = value;
        });
      },
      onAccessRenewalRequest: () {
        setState(() {});
      },
    );
  }
}
