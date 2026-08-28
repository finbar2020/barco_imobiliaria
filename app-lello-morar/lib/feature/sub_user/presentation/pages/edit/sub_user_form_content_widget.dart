import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_edit_controller.dart';
import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/send_access_renew_request_success_page.dart';

import '../../../../../core/widgets/loading_widget.dart';
import '../../../../../generated/l10n.dart';
import '../../../../change_ownership/presentation/widget/change_ownership_generic_input.dart';
import '../../../../vehicles/domain/entity/concierge_creator.dart';

class SubUserFormDetails extends StatefulWidget {
  final SubUserEditController controller;
  final Validator validator;
  final ThemeData theme;
  final SessionBloc sessionBloc;
  final bool flagBilletByEmail;
  final ValueChanged<bool> onBilletFlagChanged;
  final VoidCallback onAccessRenewalRequest;

  const SubUserFormDetails({
    Key? key,
    required this.controller,
    required this.validator,
    required this.theme,
    required this.sessionBloc,
    required this.flagBilletByEmail,
    required this.onBilletFlagChanged,
    required this.onAccessRenewalRequest,
  }) : super(key: key);

  @override
  State<SubUserFormDetails> createState() => _SubUserFormDetailsState();
}

class _SubUserFormDetailsState extends State<SubUserFormDetails> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller.userSelected?.expiresAt != null) {
      final expirationDate = widget.controller.userSelected!.expiresAt!;
      widget.controller.selectedExpirationDate = expirationDate;
      widget.controller.expirationDateController.text =
          expirationDate.toFormattedString();
    } else {
      widget.controller.selectedExpirationDate = null;
      widget.controller.expirationDateController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.controller.userSelected!;
    final mainUser = widget.controller.mainUser;
    final canEdit = widget.controller.activeEditMainUser &&
        widget.controller.mainUser.role != 'morar.morador';

    return isLoading
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: LoadingWidget(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCreatorInfo(context, user),
              SizedBox(height: Dimens.spacing),
              _buildStaticField(context, 'email', user.cpf),
              SizedBox(height: Dimens.spacing),
              _buildField(
                  context,
                  'full_name',
                  user.name,
                  widget.controller.nameController,
                  canEdit,
                  TextInputType.text,
                  widget.validator.validateRequired,
                  (value) => widget.controller.newMe?.name = value),
              SizedBox(height: Dimens.spacing),
              _buildField(
                  context,
                  'profile_update_email',
                  user.email,
                  widget.controller.emailController,
                  canEdit,
                  TextInputType.text,
                  widget.validator.validateEmail,
                  (value) => widget.controller.newMe?.email = value),
              SizedBox(height: Dimens.spacing),
              _buildPhoneField(context, user.phone ?? ''),
              SizedBox(height: Dimens.spacingSmall),
              if (user.expiresAt != null && !(widget.controller.mainUser.id != user.id &&
                  widget.controller.mainUser.role == 'morar.proprietario' &&
                  !isSecondNameMasked(
                      widget.controller.userSelected?.name ?? ''))) ...[
                SizedBox(height: Dimens.spacing),
                Text('Data de expiração de acesso',
                    style: LelloTextStyles.bodyBold(widget.theme)),
                SizedBox(height: Dimens.spacingSmall),
                Text(
                  DateFormat('dd/MM/yyyy').format(user.expiresAt!),
                  style: LelloTextStyles.body(widget.theme)?.copyWith(
                    color: _getExpirationDateColor(user.expiresAt!),
                    fontWeight:
                        user.expiresAt!.difference(DateTime.now()).inDays < 30
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                if (user.expiresAt!.difference(DateTime.now()).inDays < 30 &&
                    user.id == widget.controller.mainUser.id)
                  _buildExpirationWarning(context, user),
                SizedBox(height: Dimens.spacing),
              ],
              if (!canEdit) _buildEditWarning(context),
              if (widget.controller.mainUser.id != user.id &&
                  widget.controller.mainUser.role == 'morar.proprietario' &&
                  !isSecondNameMasked(
                      widget.controller.userSelected?.name ?? '')) ...[
                SizedBox(height: Dimens.spacing),
                const Divider(),
                const SizedBox(height: 16),
                ChangeOwnershipGenericInput(
                  isRequired: false,
                  selectTypePerson: '',
                  readyOnly: true,
                  controller: widget.controller.expirationDateController,
                  title: S.of(context).expirationAccessDate,
                  hint: getString(context, 'gdp_timesheet_select'),
                  formatter: [fullDateFormatter()],
                  borderColor: user.expiresAt != null &&
                          user.expiresAt!.difference(DateTime.now()).inDays < 0
                      ? Colors.red
                      : null,
                  keyboardType: TextInputType.numberWithOptions(),
                  validator: null,
                  selectDate: () async {
                    final date = await datePicker(
                      context,
                      selectedDate: user.expiresAt != null &&
                              user.expiresAt!
                                      .difference(DateTime.now())
                                      .inDays <
                                  0
                          ? DateTime.now()
                          : widget.controller.selectedExpirationDate,
                      firstDate: DateTime.now(),
                    );
                    if (date.isAfter(DateTime.now())) {
                      widget.controller.changeExpirationDate(date);
                      widget.controller.userSelected = widget
                          .controller.userSelected
                          ?.copyWith(expiresAt: date);
                    }
                  },
                  clear: () {
                    widget.controller.changeExpirationDate(null);
                    widget.controller.userSelected = widget
                        .controller.userSelected
                        ?.copyWith(clearExpiresAt: true);
                  },
                ),
                SizedBox(height: Dimens.spacingSmall),
                if (user.expiresAt != null &&
                    user.expiresAt!.difference(DateTime.now()).inDays < 0)
                  Text(
                    'o período de acesso consta expirado. este usuário não tem acesso.'
                        .toUpperCase(),
                    style: LelloTextStyles.captionBold(widget.theme)?.copyWith(
                      color: LelloTheme.palleteOf(widget.theme).error(),
                    ),
                  ),
              ],
              if (isMoradorOrInquilino(mainUser.role ?? '') &&
                  widget.controller.mainUser.id != user.id)
                SizedBox(height: Dimens.spacing),
              if (isMoradorOrInquilino(mainUser.role ?? '') &&
                  widget.controller.mainUser.id != user.id) ...[
                SizedBox(height: Dimens.spacing),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.spacingSmall),
                    side: BorderSide(
                      color: LelloTheme.palleteOf(widget.theme).textAccent(),
                      width: 1.0,
                    ),
                  ),
                  leading: Icon(
                    Icons.error,
                    color: LelloTheme.palleteOf(widget.theme).textAccent(),
                  ),
                  tileColor: LelloTheme.palleteOf(widget.theme)
                      .textAccent()
                      .withAlpha(50),
                  title: Text(
                    'Ao adicionar um morador, o proprietário terá a permissão de bloqueá-lo quando quiser.',
                    style: LelloTextStyles.body(widget.theme),
                  ),
                )
              ],
              SizedBox(height: Dimens.spacing),
              buildBilletSwitch(
                context,
                widget.theme,
                widget.controller,
                widget.flagBilletByEmail,
                widget.onBilletFlagChanged,
              ),
              if (widget.controller.billetByEmailCounter > 0 &&
                  !shouldHideSwitch(widget.controller))
                ListTile(
                  leading: Icon(Icons.error,
                      color: LelloTheme.palleteOf(widget.theme).warning()),
                  title: Text(
                    widget.controller.billetByEmailCounter < 3
                        ? 'Atualmente, há ${widget.controller.billetByEmailCounter} usuários cadastrados para receber cópias de boletos por e-mail. Você pode adicionar mais ${3 - widget.controller.billetByEmailCounter} usuários, totalizando o limite de 3.'
                        : getString(
                            context, 'max_residents_with_billet_by_email'),
                    style: LelloTextStyles.bodyBold(widget.theme),
                  ),
                ),
              SizedBox(height: Dimens.spacing),
              const Divider(),
            ],
          );
  }

  bool shouldHideSwitch(SubUserEditController controller) {
    return controller.mainUser.role == 'morar.morador' ||
        (controller.mainUser.role == 'morar.inquilino' &&
            controller.mainUser.id != controller.userSelected?.id) ||
        isSecondNameMasked(controller.userSelected?.name ?? '');
  }

  bool canChangeBilletByEmail(SubUserEditController controller) {
    return (controller.billetByEmailCounter < 3 ||
            controller.userSelected?.flagBoletoEmail == true) &&
        (controller.mainUser.id != controller.userSelected?.id &&
            controller.mainUser.role == 'morar.proprietario');
  }

  Widget buildBilletSwitch(
      BuildContext context,
      ThemeData theme,
      SubUserEditController controller,
      bool flagBilletByEmail,
      ValueChanged<bool> onBilletFlagChanged) {
    return shouldHideSwitch(controller)
        ? Container()
        : SwitchListTile(
            title: Text(
              getString(context, 'receive_billet_by_email'),
              style: LelloTextStyles.body(theme),
            ),
            enableFeedback: false,
            visualDensity: const VisualDensity(horizontal: -4),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: flagBilletByEmail,
            onChanged: canChangeBilletByEmail(controller)
                ? (value) {
                    controller.userSelected = controller.userSelected
                        ?.copyWith(flagBoletoEmail: value);
                    onBilletFlagChanged(value);
                  }
                : null,
          );
  }

  Widget _buildCreatorInfo(BuildContext context, dynamic user) {
    final creatorType = user.creator?.type ?? ConciergeCreatorType.portaria;
    final creatorName = user.creator?.name ?? '';
    final createdBy = _createdBy(context, creatorType, creatorName);
    return Text(
      createdBy,
      style: LelloTextStyles.captionBold(widget.theme)?.copyWith(
        color: LelloTheme.palleteOf(widget.theme).error(),
      ),
    );
  }

  Widget _buildStaticField(BuildContext context, String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, title),
        SizedBox(height: Dimens.spacingSmall),
        Text(
          value ?? getString(context, 'not_informed'),
          overflow: TextOverflow.ellipsis,
          style: LelloTextStyles.body(widget.theme)?.copyWith(
            color: LelloTheme.palleteOf(widget.theme).textOpaque(),
          ),
        ),
      ],
    );
  }

  bool isMoradorOrInquilino(String role) => role == 'morar.inquilino';

  Widget _buildField(
    BuildContext context,
    String title,
    String? initialValue,
    TextEditingController controller,
    bool enabled,
    TextInputType inputType,
    String? Function(String?) validator,
    Function(String?) onSave,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, title),
        SizedBox(height: Dimens.spacingSmall),
        enabled
            ? TextFormField(
                controller: controller,
                validator: validator,
                keyboardType: inputType,
                enabled: !isSecondNameMasked(
                    widget.controller.userSelected?.name ?? ''),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onChanged: onSave,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: getString(context, title),
                ),
              )
            : Text(
                initialValue ?? getString(context, 'not_informed'),
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.body(widget.theme)?.copyWith(
                  color: LelloTheme.palleteOf(widget.theme).textOpaque(),
                ),
              ),
      ],
    );
  }

  Widget _buildPhoneField(BuildContext context, String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, 'registration_lello_user_phone_title'),
        SizedBox(height: Dimens.spacingSmall),
        widget.controller.activeEditMainUser
            ? TextFormField(
                keyboardType: TextInputType.number,
                controller: widget.controller.phoneController,
                onChanged: (value) {
                  widget.controller.phone = value;
                  widget.controller.userSelected =
                      widget.controller.userSelected?.copyWith(phone: value);
                },
                onSaved: (value) => widget.controller.phone = value ?? '',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
                validator: widget.validator.validateRequired,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "(00) 9 0000-0000",
                  counterText: '',
                ),
              )
            : Text(
                phone.isNotEmpty ? phone : getString(context, 'not_informed'),
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.body(widget.theme)?.copyWith(
                  color: LelloTheme.palleteOf(widget.theme).textOpaque(),
                ),
              ),
      ],
    );
  }

  Widget _buildExpirationDateField(
      BuildContext context, String expirationDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, 'registration_lello_user_phone_title'),
        SizedBox(height: Dimens.spacingSmall),
        Text(
          expirationDate.isNotEmpty
              ? expirationDate
              : getString(context, 'not_informed'),
          overflow: TextOverflow.ellipsis,
          style: LelloTextStyles.body(widget.theme)?.copyWith(
            color: LelloTheme.palleteOf(widget.theme).textOpaque(),
          ),
        ),
      ],
    );
  }

  Widget _buildEditWarning(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.error, color: LelloTheme.palleteOf(widget.theme).warning()),
        SizedBox(width: Dimens.spacingSmall),
        Flexible(
          child: Text(
            'APENAS O PRÓPRIO USUÁRIO PODE ATUALIZAR ESSES DADOS',
            maxLines: 2,
            style: LelloTextStyles.captionBold(widget.theme)?.copyWith(
              color: LelloTheme.palleteOf(widget.theme).warning(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpirationWarning(BuildContext context, SubUser user) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: LelloTheme.palleteOf(widget.theme).error().withAlpha(50),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: LelloTheme.palleteOf(widget.theme).error(),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.error,
                  color: LelloTheme.palleteOf(widget.theme).error()),
              SizedBox(width: Dimens.spacingSmall),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    style: LelloTextStyles.caption(widget.theme),
                    children: user.accessRenewalRequestStatus != null &&
                            (user.accessRenewalRequestDate
                                        ?.difference(DateTime.now())
                                        .inDays ??
                                    0) <
                                7
                        ? [
                            TextSpan(
                              text: 'Sua solicitação foi enviada. ',
                              style: LelloTextStyles.captionBold(widget.theme),
                            ),
                            TextSpan(
                                text:
                                    'Em breve você poderá solicitar novamente. Acompanhe o andamento aqui ou Resolva Fácil.')
                          ]
                        : [
                            TextSpan(
                                text:
                                    'Está na hora de renovar a data de expiração do seu acesso. '),
                            TextSpan(
                              text: 'Solicite antes de ser bloqueado.',
                              style: LelloTextStyles.captionBold(widget.theme),
                            )
                          ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimens.spacing),
        if ((user.accessRenewalRequestStatus == null ||
                (user.accessRenewalRequestDate
                            ?.difference(DateTime.now())
                            .inDays ??
                        0) >=
                    7) &&
            user.id == widget.controller.mainUser.id)
          PrimaryButton(
            text: 'Solicitar renovação',
            onPressed: () async {
              final result = await widget.controller.sendAccessRenewRequest();
              if (result) {
                setState(() {
                  isLoading = true;
                });
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const SendAccessRenewRequestSuccessPage(),
                  ),
                );
                widget.controller.userSelected = user.copyWith(
                  accessRenewalRequestDate: DateTime.now(),
                  accessRenewalRequestStatus: 'SOLICITADO',
                );
                await widget.controller.getSubUsers();
                setState(() {
                  isLoading = false;
                });
                widget.onAccessRenewalRequest();
              }
            },
          ),
      ],
    );
  }

  Text _buildLabel(BuildContext context, String title) {
    return Text(
      "${getString(context, title)}${widget.controller.activeEditMainUser ? " *" : ""}",
      style: LelloTextStyles.bodyBold(widget.theme),
    );
  }

  bool _canToggleBilletEmail() {
    return widget.sessionBloc
            .checkRback(ApplicationRbac.morarMoradoresSubmoradoresDetalhes) &&
        (widget.controller.billetByEmailCounter < 3 ||
            widget.controller.userSelected?.flagBoletoEmail == true);
  }

  Color _getExpirationDateColor(DateTime date) {
    return date.difference(DateTime.now()).inDays < 30
        ? LelloTheme.palleteOf(widget.theme).error()
        : LelloTheme.palleteOf(widget.theme).textOpaque();
  }

  bool isSecondNameMasked(String fullName) {
    final names = fullName.split(' ');
    if (names.length < 2) return false;
    final firstName = names[0];
    final secondName = names[1];

    return firstName.runes.any((char) => String.fromCharCode(char) != '*') &&
        secondName.runes.every((char) => String.fromCharCode(char) == '*');
  }

  String _createdBy(BuildContext context, ConciergeCreatorType creatorType,
      String createdBy) {
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
}
