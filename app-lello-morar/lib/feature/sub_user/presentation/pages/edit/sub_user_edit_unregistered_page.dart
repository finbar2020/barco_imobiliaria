import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_card_widget.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_dialog_info.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../../../../generated/l10n.dart';
import '../../../../access_control/domain/entity/access_control_invite_forward_type.dart';
import '../../../../access_control/domain/entity/access_control_send_invite.dart';
import '../../../../access_control/domain/entity/access_invite_user_type_enum.dart';
import '../../../../change_ownership/presentation/widget/change_ownership_generic_input.dart';
import '../../../../vehicles/domain/entity/concierge_creator.dart';
import '../../../domain/entity/sub_user_role.dart';
import '../../controllers/sub_user_edit_controller.dart';

class SubUserEditUnregisteredPage extends StatefulWidget {
  final GlobalKey<FormState> formkey;

  SubUserEditUnregisteredPage({
    required this.formkey,
    Key? key,
  }) : super(key: key);

  @override
  State<SubUserEditUnregisteredPage> createState() =>
      _SubUserEditUnregisteredPage();
}

class _SubUserEditUnregisteredPage extends State<SubUserEditUnregisteredPage> {
  final Validator _validator = ApplicationContainer.instance().resolve();

  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();

  final controller =
      ApplicationContainer.instance().resolve<SubUserEditController>();

  var flagBilletByEmail = false;

  @override
  void initState() {
    controller.nameController.text = controller.userSelected?.name ?? "";
    controller.emailController.text = controller.userSelected?.email ?? "";
    controller.cpfController.text = controller.userSelected?.cpf ?? "";
    controller.phoneController.text = controller.userSelected?.phone ?? '';
    controller.maskedPhoneController.text =
        controller.userSelected?.phone ?? '';
    controller.phone = controller.userSelected?.phone ?? '';
    flagBilletByEmail = controller.userSelected?.flagBoletoEmail ?? false;
    if (controller.userSelected?.expiresAt != null) {
      final expirationDate = controller.userSelected!.expiresAt!;
      controller.selectedExpirationDate = expirationDate;
      controller.expirationDateController.text =
          expirationDate.toFormattedString();
    } else {
      controller.selectedExpirationDate = null;
      controller.expirationDateController.text = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    return DismissKeyboard(
      child: Container(
        color: Colors.transparent,
        child: Form(
          key: widget.formkey,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
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
                                color: LelloTheme.palleteOf(theme).grey()),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down),
                            underline: SizedBox.shrink(),
                            hint: Text(getString(context, "choose_an_option")),
                            value: controller.roles.firstWhere(
                              (element) =>
                                  element.description ==
                                  controller.userSelected!.roleDescription,
                              orElse: () => SubUserRole(
                                role: controller.userSelected?.role,
                                description:
                                    controller.userSelected?.roleDescription,
                              ),
                            ),
                            items: controller.roles.map((SubUserRole item) {
                              return DropdownMenuItem<SubUserRole>(
                                value: item,
                                enabled: item.enabled == true,
                                child: Text(
                                  item.description ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: item.enabled == true
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              );
                            }).toList(),
                            onTap: !isSecondNameMasked(
                                    controller.userSelected?.name ?? '')
                                ? () => FocusScope.of(context).unfocus()
                                : null,
                            onChanged: !isSecondNameMasked(
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimens.spacingSmall),
              if (!isMoradorOrInquilino(controller.mainUser.role ?? '')) ...[
                SubUserDialogInfo(),
                SizedBox(height: Dimens.spacing),
              ],
              const Divider(),
              SizedBox(height: Dimens.spacing),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _createdBy(
                          controller.userSelected?.creator?.type ??
                              ConciergeCreatorType.portaria,
                          controller.userSelected?.creator?.name ?? ''),
                      style: LelloTextStyles.captionBold(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).error(),
                      ),
                    ),
                    if (_createdBy(
                      controller.userSelected?.creator?.type ??
                          ConciergeCreatorType.portaria,
                      '',
                    ).isNotEmpty)
                      SizedBox(height: Dimens.spacing),
                    Text(
                      '${getString(context, 'name')}*',
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: controller.nameController,
                      enabled: !isSecondNameMasked(
                          controller.userSelected?.name ?? ''),
                      textCapitalization: TextCapitalization.words,
                      onChanged: (val) {
                        controller.userSelected =
                            controller.userSelected?.copyWith(name: val);
                        controller.userSelected =
                            controller.userSelected!.copyWith(name: val);
                        setState(() {});
                      },
                      validator: _validator.validateRequired,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: getString(context, "full_name"),
                      ),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      "${getString(context, "cpf")}/${getString(context, "cnpj")}*",
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    TextFormField(
                      onChanged: (value) {
                        controller.userSelected =
                            controller.userSelected?.copyWith(cpf: value);
                        controller.userSelected =
                            controller.userSelected!.copyWith(cpf: value);
                        if (value.length == 14 || value.length == 18) {
                          setState(() {});
                        }
                      },
                      controller: controller.cpfController,
                      enabled: !isSecondNameMasked(
                          controller.userSelected?.name ?? ''),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CpfOuCnpjFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                      validator: _validator.validateCPForCNPJ,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: getString(context, "type_email_cnpj"),
                      ),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${getString(context, "profile_update_email")}*',
                                  style: LelloTextStyles.bodyBold(theme)),
                              SizedBox(height: Dimens.spacingSmall),
                              TextFormField(
                                controller: controller.emailController,
                                validator: _validator.validateEmail,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                enabled: !isSecondNameMasked(
                                    controller.userSelected?.name ?? ''),
                                onChanged: (val) {
                                  controller.userSelected = controller
                                      .userSelected!
                                      .copyWith(email: val);
                                  controller.verifyChanges = true;
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: getString(context, "write"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Dimens.spacingMedium),
                        Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${getString(context, "mobile_phone_required")}*',
                                  style: LelloTextStyles.bodyBold(theme)),
                              SizedBox(height: Dimens.spacingSmall),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: !isSecondNameMasked(
                                        controller.userSelected?.name ?? '')
                                    ? controller.phoneController
                                    : controller.maskedPhoneController,
                                enabled: !isSecondNameMasked(
                                    controller.userSelected?.name ?? ''),
                                onChanged: (value) {
                                  controller.phone = value;
                                  controller.userSelected = controller
                                      .userSelected
                                      ?.copyWith(phone: value);
                                  controller.userSelected = controller
                                      .userSelected!
                                      .copyWith(phone: value);
                                  setState(() {});
                                },
                                onSaved: (value) =>
                                    controller.phone = value ?? "",
                                inputFormatters: isSecondNameMasked(
                                        controller.userSelected?.name ?? '')
                                    ? []
                                    : [
                                        FilteringTextInputFormatter.digitsOnly,
                                        TelefoneInputFormatter(),
                                      ],
                                validator: _validator.validateCellPhone,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "(00) 9 0000-0000",
                                  counterText: '',
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    if (controller.mainUser.id != controller.userSelected?.id &&
                        controller.mainUser.role == 'morar.proprietario') ...[
                      SizedBox(height: Dimens.spacing),
                      const Divider(),
                      SizedBox(height: Dimens.spacing),
                      ChangeOwnershipGenericInput(
                        isRequired: false,
                        selectTypePerson: '',
                        controller: controller.expirationDateController,
                        title: S.of(context).expirationAccessDate,
                        hint: getString(context, 'gdp_timesheet_select'),
                        readyOnly: true,
                        formatter: [fullDateFormatter()],
                        borderColor:
                            (controller.userSelected?.expiresAt != null &&
                                    (controller.userSelected?.expiresAt!
                                                .difference(DateTime.now())
                                                .inDays ??
                                            0) <
                                        0)
                                ? Colors.red
                                : null,
                        keyboardType: TextInputType.numberWithOptions(),
                        validator: null,
                        selectDate: () async {
                          final date = await datePicker(
                            context,
                            selectedDate: (controller.userSelected?.expiresAt?.difference(DateTime.now()).inDays ?? 0) < 0
                                ? DateTime.now()
                                : controller.selectedExpirationDate,
                            firstDate: DateTime.now(),
                          );
                          if (date.isAfter(DateTime.now())) {
                            controller.changeExpirationDate(date);
                            controller.userSelected = controller.userSelected
                                ?.copyWith(expiresAt: date);
                            controller.userSelected = controller.userSelected!
                                .copyWith(expiresAt: date);
                          }
                        },
                        clear: () {
                          controller.changeExpirationDate(null);
                          controller.userSelected = controller.userSelected
                              ?.copyWith(expiresAt: null);
                          controller.userSelected = controller.userSelected!
                              .copyWith(expiresAt: null);
                          setState(() {});
                        },
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                      if (controller.userSelected?.expiresAt != null &&
                          (controller.userSelected?.expiresAt!
                                      .difference(DateTime.now())
                                      .inDays ??
                                  0) <
                              0)
                        Text(
                          'o período de acesso consta expirado. este usuário não tem acesso.'
                              .toUpperCase(),
                          style: LelloTextStyles.captionBold(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).error(),
                          ),
                        ),
                    ],
                    if (isMoradorOrInquilino(
                        controller.mainUser.role ?? '')) ...[
                      SizedBox(height: Dimens.spacing),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimens.spacingSmall),
                          side: BorderSide(
                            color: LelloTheme.palleteOf(theme).textAccent(),
                            width: 1.0,
                          ),
                        ),
                        leading: Icon(
                          Icons.error,
                          color: LelloTheme.palleteOf(theme).textAccent(),
                        ),
                        tileColor: LelloTheme.palleteOf(theme)
                            .textAccent()
                            .withAlpha(50),
                        title: Text(
                          'Ao adicionar um morador, o proprietário terá a permissão de bloqueá-lo quando quiser.',
                          style: LelloTextStyles.body(theme),
                        ),
                      )
                    ],
                    buildBilletSwitch(context, controller, theme),
                    if (controller.billetByEmailCounter > 0 &&
                        !shouldHideSwitch(controller)) ...[
                      ListTile(
                        leading: Icon(
                          Icons.error,
                          color: LelloTheme.palleteOf(theme).warning(),
                        ),
                        title: Text(
                          controller.billetByEmailCounter < 3
                              ? 'Atualmente, há ${controller.billetByEmailCounter} usuários cadastrados para receber cópias de boletos por e-mail. Você pode adicionar mais ${3 - controller.billetByEmailCounter} usuários, totalizando o limite de 3.'
                              : getString(context,
                                  'max_residents_with_billet_by_email'),
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                      ),
                      SizedBox(height: Dimens.spacing),
                      const Divider()
                    ],
                    SizedBox(height: Dimens.spacing),
                    const Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool shouldHideSwitch(SubUserEditController controller) {
    return controller.mainUser.role == 'morar.morador' ||
        (controller.mainUser.role == 'morar.inquilino' &&
            controller.mainUser.id != controller.userSelected?.id) ||
        isSecondNameMasked(controller.userSelected?.name ?? '');
  }

  bool canChangeBilletByEmail(SubUserEditController controller) {
    return controller.billetByEmailCounter < 3 ||
        controller.userSelected?.flagBoletoEmail == true;
  }

  Widget buildBilletSwitch(
      BuildContext context, SubUserEditController controller, ThemeData theme) {
    return shouldHideSwitch(controller)
        ? Container()
        : Padding(
            padding: EdgeInsets.only(top: 10),
            child: SwitchListTile(
              title: Text(
                getString(context, 'receive_billet_by_email'),
                style: LelloTextStyles.body(theme),
              ),
              enableFeedback: false,
              visualDensity: VisualDensity(horizontal: -4),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: flagBilletByEmail,
              onChanged: canChangeBilletByEmail(controller)
                  ? (value) {
                      flagBilletByEmail = value;
                      controller.userSelected = controller.userSelected
                          ?.copyWith(flagBoletoEmail: value);
                      setState(() {});
                    }
                  : null,
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

  bool isMoradorOrInquilino(String role) =>
      role == 'morar.morador' || role == 'morar.inquilino';

  _showInviteDialog({
    required SubUserEditController controller,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/ic_attention.svg",
                    color: LelloTheme.palleteOf(theme).textOpaque(),
                    width: 50,
                    height: 50),
                SizedBox(height: Dimens.spacing),
                Text(
                  getString(context, "residents_invite_dialog_title"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).textOpaque(),
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                Text(
                  controller.verifyChanges
                      ? getString(context, "residents_save_changes_dialog")
                      : getString(context, "residents_invite_dialog_subtitle"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).textOpaque(),
                  ),
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
                        getString(context, "back").toUpperCase(),
                        style: LelloTextStyles.subBody(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).text(),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.subUserSendInvite(
                            entity: AccessControlSendInviteEntity(
                          cpf: controller.userSelected!.cpf,
                          name: controller.userSelected!.name,
                          phone: controller.userSelected!.phone,
                          forwardType: AccessControlInviteForwardType.sms,
                          userType: AccessControlInviteUserType.resident,
                        ));
                        Navigator.pop(context);
                      },
                      child: Text(
                        controller.verifyChanges
                            ? getString(context, "residents_save_changes")
                                .toUpperCase()
                            : getString(context, "ok").toUpperCase(),
                        style: LelloTextStyles.subBody(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).text(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _createdBy(ConciergeCreatorType creatorType, String createdBy) {
    switch (creatorType) {
      case ConciergeCreatorType.moradorcriador:
      case ConciergeCreatorType.moradorcriadorsemlogin:
      case ConciergeCreatorType.appmorar:
        return getString(context, 'creator_vehicle').toUpperCase() +
            " " +
            createdBy.toUpperCase();
      case ConciergeCreatorType.appsindico:
        return getString(context, 'creator_vehicle_sindico').toUpperCase();
      case ConciergeCreatorType.portaria:
        return getString(context, 'creator_vehicle_concierge').toUpperCase();
      case ConciergeCreatorType.resolvafacil:
        return 'Cadastrado pelo Resolva Fácil'.toUpperCase();
    }
  }

  _showDialogBlockUser({
    required BuildContext context,
    required SubUserEditController controller,
  }) {
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/ic_exclamation.svg'),
                SizedBox(height: Dimens.spacing),
                Text(
                  getString(context, "attention"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.titleSmall(theme)!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                  controller.userSelected!.blocked!
                      ? getString(context, "resident_sure_unlock_profile")
                      : getString(context, "resident_sure_lock_profile"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme),
                ),
                SizedBox(height: Dimens.spacingXLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        getString(context, "no").toUpperCase(),
                        style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).text(),
                        ),
                      ),
                    ),
                    SizedBox(width: Dimens.spacing),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        controller.subUserUpdate(
                          isBlock: true,
                          isUseApp: false,
                        );
                      },
                      child: Text(
                        getString(context, "yes").toUpperCase(),
                        style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
