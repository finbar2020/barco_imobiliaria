import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/presentation/pages/contacts/sub_user_contacts_page.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_dialog_info.dart';

import '../../../../../generated/l10n.dart';
import '../../../../change_ownership/presentation/widget/change_ownership_generic_input.dart';
import '../../../domain/entity/sub_user_role.dart';
import '../../controllers/sub_user_add_controller.dart';
import '../send_invite/sub_user_send_invite_page.dart';

class SubUserContactInfoPage extends StatefulWidget {
  final bool isConfirm;

  const SubUserContactInfoPage({
    Key? key,
    this.isConfirm = false,
  }) : super(key: key);

  @override
  _SubUserContactInfoPageState createState() => _SubUserContactInfoPageState();
}

class _SubUserContactInfoPageState extends State<SubUserContactInfoPage> {
  final Validator _validator = ApplicationContainer.instance().resolve();
  final controller =
      ApplicationContainer.instance().resolve<SubUserAddController>();
  final _formKey = GlobalKey<FormState>();
  bool hasEmail = false;
  bool hasPhoneError = false;
  bool hasDDDError = false;
  bool _showInfoContainer = false;

  @override
  void initState() {
    controller.getContacts();
    controller.creationUser = controller.userSelected ?? SubUser();
    super.initState();

    controller.nameController.text = controller.creationUser?.name ?? '';
    controller.emailController.text = controller.creationUser?.email ?? '';
    controller.cpfCnpjController.text = controller.creationUser?.cpf ?? '';
    controller.phoneController.text = controller.creationUser?.phone ?? '';
    if (controller.creationUser?.expiresAt != null) {
      controller.expirationDateController.text =
          DateFormat('dd/MM/yyyy').format(controller.creationUser!.expiresAt!);
    }
    controller.getRoles(user: controller.mainUser).then((_) {
      setState(() {});
    });
    controller.getSubUsers().then((_) {
      setState(() {});
    });
    _showInfoContainer = controller.mainUser.role == 'morar.proprietario';
  }

  @override
  void dispose() {
    controller.userSelected = null;
    controller.itemSelecionado = null;
    controller.changeExpirationDate(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _validator.context = context;
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: WhiteAppBar(
          title: widget.isConfirm
              ? getString(context, "resident_confirm")
              : getString(context, "add_user"),
          onPressed: () {
            controller.getContacts();
            Navigator.pop(context);
          },
        ),
        body: DismissKeyboard(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedContainer(
                    color: LelloTheme.palleteOf(theme).raffle(),
                    duration: const Duration(milliseconds: 200),
                    height: _showInfoContainer ? 80 : 0,
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.only(
                      left: 16,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Os moradores que forem cadastrados por este inquilino terão a mesma data de expiração de acesso.',
                            style: LelloTextStyles.bodyBold(theme)?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _showInfoContainer = false;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    color: LelloTheme.palleteOf(theme).backgroundDark(),
                    width: double.infinity,
                    height: Dimens.spacingLarge,
                    child: Center(
                      child: Text(
                        '${controller.sessionBloc.state.session?.condominium?.name ?? ''} - ${controller.sessionBloc.state.session?.unity?.title ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        style: LelloTextStyles.body(theme),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              hint:
                                  Text(getString(context, "choose_an_option")),
                              value: controller.itemSelecionado,
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
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              onChanged: (value) {
                                setState(() {
                                  controller.allRequiresFieldsFilled();
                                  controller.setItemSelecionado(value);
                                  controller.creationUser =
                                      controller.creationUser?.copyWith(
                                    role: value?.role,
                                    roleDescription: value?.description,
                                  );
                                });
                              }),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        SubUserDialogInfo(),
                        SizedBox(height: Dimens.spacingMedium),
                        Text(
                          '${getString(context, 'name')}*',
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: controller.nameController,
                          textCapitalization: TextCapitalization.words,
                          onChanged: (val) {
                            controller.creationUser =
                                controller.creationUser?.copyWith(name: val);
                            controller.creationUser =
                                controller.creationUser!.copyWith(name: val);
                            controller.allRequiresFieldsFilled();
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
                            controller.allRequiresFieldsFilled();
                            controller.creationUser =
                                controller.creationUser?.copyWith(cpf: value);
                            controller.creationUser =
                                controller.creationUser!.copyWith(cpf: value);
                            setState(() {});
                          },
                          controller: controller.cpfCnpjController,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CpfOuCnpjFormatter()
                          ],
                          keyboardType: TextInputType.number,
                          validator: _validator.validateCPForCNPJ,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: getString(context, 'type_email_cnpj'),
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
                                      '${getString(context, 'profile_update_email')}*',
                                      style: LelloTextStyles.bodyBold(theme)),
                                  SizedBox(height: Dimens.spacingSmall),
                                  TextFormField(
                                    onChanged: (val) {
                                      controller.creationUser = controller
                                          .creationUser
                                          ?.copyWith(email: val);
                                      setState(() {
                                        if (val.isNotEmpty) {
                                          hasEmail = true;
                                        } else {
                                          hasEmail = false;
                                        }
                                      });
                                    },
                                    controller: controller.emailController,
                                    validator: hasEmail
                                        ? _validator.validateEmail
                                        : null,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: getString(context, 'write'),
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
                                      '${getString(context, 'mobile_phone_required')}*',
                                      style: LelloTextStyles.bodyBold(theme)),
                                  SizedBox(height: Dimens.spacingSmall),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      controller.phone = value;
                                      controller.creationUser =
                                          controller.creationUser?.copyWith(
                                              phone: controller.getPhone());
                                      controller.creationUser =
                                          controller.creationUser!.copyWith(
                                              phone: controller.getPhone());
                                      setState(() {});
                                    },
                                    controller: controller.phoneController,
                                    inputFormatters: [
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
                        if (controller.mainUser.role ==
                            'morar.proprietario') ...[
                          const SizedBox(height: 16),
                          ChangeOwnershipGenericInput(
                            isRequired: false,
                            selectTypePerson: '',
                            controller: controller.expirationDateController,
                            title: S.of(context).expirationAccessDate,
                            hint: getString(context, 'gdp_timesheet_select'),
                            formatter: [fullDateFormatter()],
                            keyboardType: TextInputType.numberWithOptions(),
                            validator: null,
                            selectDate: () async {
                              final date = await datePicker(
                                context,
                                selectedDate: controller.selectedExpirationDate,
                                firstDate: DateTime.now(),
                              );
                              if (date.isAfter(DateTime.now())) {
                                controller.changeExpirationDate(date);
                                controller.creationUser = controller
                                    .creationUser
                                    ?.copyWith(expiresAt: date);
                                setState(() {});
                              }
                            },
                            clear: () {
                              controller.changeExpirationDate(null);
                              controller.creationUser = controller.creationUser
                                  ?.copyWith(expiresAt: null);
                              controller.creationUser = controller.creationUser!
                                  .copyWith(expiresAt: null);
                              setState(() {});
                            },
                          ),
                        ],
                        SizedBox(height: Dimens.spacing),
                        isMoradorOrInquilino(controller.mainUser.role ?? '')
                            ? const SizedBox()
                            : Text(
                                '${getString(context, "residents_can_receive_billet_by_email")}',
                                style: LelloTextStyles.bodyBold(theme),
                              ),
                        isMoradorOrInquilino(controller.mainUser.role ?? '')
                            ? const SizedBox()
                            : SwitchListTile(
                                title: Text(
                                  getString(context, 'receive_billet_by_email'),
                                  style: LelloTextStyles.body(theme),
                                ),
                                visualDensity: VisualDensity(horizontal: -4),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value:
                                    controller.creationUser?.flagBoletoEmail ??
                                        false,
                                onChanged: controller.billetByEmailCounter < 3
                                    ? (value) {
                                        controller.creationUser = controller
                                            .creationUser
                                            ?.copyWith(flagBoletoEmail: value);
                                        controller.creationUser = controller
                                            .creationUser!
                                            .copyWith(flagBoletoEmail: value);
                                        controller.allRequiresFieldsFilled();
                                        setState(() {});
                                      }
                                    : null,
                              ),
                        SwitchListTile(
                          title: Text(
                            getString(context, 'allow_app_access'),
                            style: LelloTextStyles.body(theme),
                          ),
                          visualDensity: VisualDensity(horizontal: -4),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: controller.creationUser?.useApp ?? true,
                          onChanged: (value) {
                            controller.creationUser = controller.creationUser
                                ?.copyWith(useApp: value);
                            controller.creationUser = controller.creationUser!
                                .copyWith(useApp: value);
                            controller.allRequiresFieldsFilled();
                            setState(() {});
                          },
                        ),
                        if (isMoradorOrInquilino(
                            controller.mainUser.role ?? ''))
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
                              S.of(context).addResidentDisclaimer,
                              style: LelloTextStyles.body(theme),
                            ),
                          ),
                        if (!isMoradorOrInquilino(
                                controller.mainUser.role ?? '') &&
                            controller.billetByEmailCounter > 0)
                          ListTile(
                            leading: Icon(
                              Icons.error,
                              color: LelloTheme.palleteOf(theme).warning(),
                            ),
                            title: Text(
                              controller.billetByEmailCounter < 3
                                  ? S.of(context).billetByEmailCounterMessage(
                                      controller.billetByEmailCounter,
                                      3 - controller.billetByEmailCounter)
                                  : getString(context,
                                      'max_residents_with_billet_by_email'),
                              style: LelloTextStyles.bodyBold(theme),
                            ),
                          ),
                        SizedBox(height: Dimens.spacingMedium),
                        SecondaryButton(
                          text: getString(context, "add_from_contact_list"),
                          buttonBorderColor:
                              LelloTheme.palleteOf(theme).textAccent(),
                          onPressed: () async {
                            await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(Dimens.spacing),
                                        topRight:
                                            Radius.circular(Dimens.spacing),
                                      ),
                                      child: Container(
                                        child: SubUserContactsPage(),
                                      ),
                                    ),
                                  );
                                });
                            setState(() {});
                          },
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        PrimaryButton(
                          text: getString(context, "save"),
                          onPressed: controller.allRequiresFieldsFilled()
                              ? () {
                                  if (_formKey.currentState!.validate() &&
                                      controller.itemSelecionado != null &&
                                      !(hasDDDError || hasPhoneError)) {
                                    if (controller.creationUser != null) {
                                      Navigator.pushNamed(
                                        context,
                                        ApplicationRoute.subUserInvitation,
                                        arguments: SubUserSendInviteParams(
                                          subUser: controller.creationUser!,
                                        ),
                                      );
                                    }
                                  }
                                }
                              : null,
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isMoradorOrInquilino(String role) =>
      role == 'morar.morador' || role == 'morar.inquilino';
}
