import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/hex_color.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_date.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_itens.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_recurrence.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_type_entry_enum.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_provider_controller.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_visitant_controller.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_appointments_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_cpf_dialog.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_day_selector_widget.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_delete_visit_dialog.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class AccessControlVisitantInfoWidget extends StatefulWidget {
  const AccessControlVisitantInfoWidget({
    Key? key,
    required this.accessControlStore,
    required this.state,
    required this.isVisitant,
    required this.newVisit,
    required this.isEdit,
    required this.authorization,
    required this.isGeneric,
  }) : super(key: key);

  final EditVisitantState state;
  final AccessControlStore accessControlStore;
  final AccessControlAuthorizations authorization;
  final bool isVisitant;
  final bool newVisit;
  final bool isEdit;
  final bool isGeneric;

  @override
  _AccessControlVisitantInfoWidgetState createState() =>
      _AccessControlVisitantInfoWidgetState();
}

class _AccessControlVisitantInfoWidgetState
    extends State<AccessControlVisitantInfoWidget> {
  final _formKey = GlobalKey<FormState>();
  final _validator = ApplicationContainer.instance().resolve<Validator>();

  final controllerName = new TextEditingController();
  final controllerDocument = new TextEditingController();
  final controllerDocumentForeign = new TextEditingController();
  final controllerBusiness = new TextEditingController();

  final dateFormat = DateFormat.yMd("pt_BR");

  String newName = "";
  String newDocument = "";
  String newBusiness = "";
  String newDocumentForeign = "";
  int choiceEntry = AccessControlTypeEntry.unavailable.index;
  bool firstBuild = true;
  bool isForeign = false;

  List<String> access = ["Pontual", "Recorrente"];
  var _selectAccess;

  List<String> foreignDocumentType = ["RNE", "Passaporte"];
  var _selectForeignDocumentType;

  DateTime? firstDate;
  DateTime? secondDate;

  bool selectBiometricAccess = false;

  String cpf = "";

  SessionBloc? sessionBloc;

  AccessControlVisitantController visitantController =
      ApplicationContainer.instance()
          .resolve<AccessControlVisitantController>();
  AccessControlProviderController providerController =
      ApplicationContainer.instance()
          .resolve<AccessControlProviderController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    sessionBloc = BlocProvider.of(context);
    _validator.context = context;
    _firstBuild();
    return DismissKeyboard(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                color: LelloTheme.palleteOf(theme).backgroundDark(),
                width: double.infinity,
                height: Dimens.spacingLarge,
                child: Center(
                  child: Text(
                    '${sessionBloc?.state.session?.condominium?.name ?? ''} - ${sessionBloc?.state.session?.unity?.title ?? ''}',
                    overflow: TextOverflow.ellipsis,
                    style: LelloTextStyles.body(theme),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimens.spacingSmall),
                    if (!widget.newVisit && !widget.isEdit)
                      _buidTextFieldTitle("full_name", true, theme),
                    if (!widget.newVisit && !widget.isEdit)
                      SizedBox(height: Dimens.spacingSmall),
                    if (!widget.newVisit && !widget.isEdit)
                      _buildNameTextField(),
                    if (widget.isVisitant)
                      SizedBox(height: Dimens.spacingMedium),
                    if (widget.isVisitant) showForeignOption(theme),
                    if (isForeign) showForeignDocuments(theme),
                    if (!widget.newVisit && !widget.isEdit)
                      SizedBox(height: Dimens.spacing),
                    if (!isForeign) showCpfInput(theme),
                    if (!widget.isVisitant &&
                        !widget.newVisit &&
                        !widget.isEdit)
                      SizedBox(height: Dimens.spacing),
                    if (!widget.isVisitant &&
                        !widget.newVisit &&
                        !widget.isEdit)
                      _buidTextFieldTitle("access_control_firm", false, theme),
                    if (!widget.isVisitant &&
                        !widget.newVisit &&
                        !widget.isEdit)
                      SizedBox(height: Dimens.spacingSmall),
                    if (!widget.isVisitant &&
                        !widget.newVisit &&
                        !widget.isEdit)
                      _buildBusinessTextField(),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      getString(context, "access_control_auth"),
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                    SizedBox(height: Dimens.spacing),
                    _accessControlAuthTile(
                        AccessControlTypeEntry.interfonar.index, theme),
                    Divider(),
                    _accessControlAuthTile(
                        AccessControlTypeEntry.acessoDireto.index, theme),
                    if (choiceEntry ==
                        AccessControlTypeEntry.acessoDireto.index)
                      SizedBox(height: Dimens.spacingMedium),
                    if (choiceEntry ==
                        AccessControlTypeEntry.acessoDireto.index)
                      _buildAccessTypeColumn(
                          context,
                          theme,
                          widget.accessControlStore.bloc.state
                              as EditVisitantState,
                          sessionBloc!),
                    SizedBox(height: Dimens.spacingXLarge),
                    _saveButton(theme),
                    if (widget.isEdit) SizedBox(height: Dimens.spacing),
                    if (widget.isEdit)
                      CircuitBreakerWidget(
                          reference: sessionBloc
                                  ?.state.session?.condominium?.reference ??
                              "",
                          appContainer: ApplicationContainer.instance(),
                          applicationRbac: ApplicationRbac
                              .morarAutorizarEntradaExcluirAgendamento,
                          rbacEnabled: sessionBloc!.checkRback(ApplicationRbac
                              .morarAutorizarEntradaExcluirAgendamento),
                          child:
                              _deleteButton(sessionBloc!, theme, widget.state)),
                    SizedBox(height: Dimens.spacing),
                    _cancelRegister(sessionBloc!, theme),
                    SizedBox(height: Dimens.spacing),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showForeignOption(ThemeData theme) {
    if (!widget.newVisit && !widget.isEdit) {
      return foreignOption(theme);
    } else {
      if (selectBiometricAccess &&
          widget.state.visitant.documentFormatted == null) {
        return foreignOption(theme);
      }
      return Container();
    }
  }

  Widget showForeignDocuments(ThemeData theme) {
    if (!widget.newVisit && !widget.isEdit) {
      return foreignDocument(theme);
    } else {
      if (selectBiometricAccess &&
          widget.state.visitant.foreignDocument == null) {
        return foreignDocument(theme);
      }
      return Container();
    }
  }

  Widget foreignDocument(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.spacingMedium),
        _buidTextFieldTitle(
            "access_control_document", selectBiometricAccess, theme),
        SizedBox(height: Dimens.spacingSmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                width: 1.0, color: LelloTheme.palleteOf(theme).separator()),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: DropdownButton(
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down),
              underline: SizedBox.shrink(),
              hint: Text(
                getString(context, "access_control_choose_option"),
                style: LelloTextStyles.body(theme),
              ),
              value: _selectForeignDocumentType,
              items: foreignDocumentType.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              onChanged: (value) {
                setState(() {
                  _selectForeignDocumentType = value;
                });
              }),
        ),
        SizedBox(height: Dimens.spacingMedium),
        _buidTextFieldTitle(
            "access_control_document_number", selectBiometricAccess, theme),
        SizedBox(height: Dimens.spacingSmall),
        _buildDocumentForeignTextField(),
      ],
    );
  }

  Widget foreignOption(ThemeData theme) {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          isForeign = !isForeign;
        });
      },
      child: Row(
        children: [
          Container(
            height: 20.0,
            width: 20.0,
            decoration: BoxDecoration(
              color: isForeign
                  ? theme.primaryColor
                  : LelloTheme.palleteOf(theme).customColor(),
              border: Border.all(
                color: isForeign
                    ? theme.primaryColor
                    : LelloTheme.palleteOf(theme).grey(),
              ),
            ),
            child: Icon(
              Icons.check,
              size: 20.0,
              color: isForeign
                  ? LelloTheme.palleteOf(theme).customColor()
                  : Colors.transparent,
            ),
          ),
          SizedBox(width: Dimens.spacingSmall),
          Text(
            getString(context, "access_control_foreign"),
            style: LelloTextStyles.bodyBold(theme),
          ),
        ],
      ),
    );
  }

  Widget showCpfInput(ThemeData theme) {
    if (!widget.newVisit && !widget.isEdit) {
      return Column(
        children: [
          SizedBox(height: Dimens.spacing),
          _buidTextFieldTitle("cpf", true, theme),
          SizedBox(height: Dimens.spacingSmall),
          _buildDocumentTextField(),
        ],
      );
    } else {
      if (selectBiometricAccess && widget.state.visitant.document == null) {
        return Column(
          children: [
            SizedBox(height: Dimens.spacing),
            _buidTextFieldTitle("cpf", true, theme),
            SizedBox(height: Dimens.spacingSmall),
            _buildDocumentTextField(),
          ],
        );
      }
      return Container();
    }
  }

  Column _buildAccessTypeColumn(BuildContext context, ThemeData theme,
      EditVisitantState state, SessionBloc sessionBloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sessionBloc.state.session?.condominium?.useFacialBiometric == true)
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectBiometricAccess = !selectBiometricAccess;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      height: 15.0,
                      width: 15.0,
                      decoration: BoxDecoration(
                        color: selectBiometricAccess
                            ? theme.primaryColor
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectBiometricAccess
                              ? theme.primaryColor
                              : LelloTheme.palleteOf(theme).grey(),
                        ),
                      ),
                    ),
                    SizedBox(width: Dimens.spacingSmall),
                    Text(
                      getString(context, "access_control_access_biometric"),
                      overflow: TextOverflow.ellipsis,
                      style: LelloTextStyles.body(theme),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: Container(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        getString(context,
                                            "access_control_info_dialog"),
                                        style: LelloTextStyles.subtitle(theme)!
                                            .copyWith(
                                                color:
                                                    LelloTheme.palleteOf(theme)
                                                        .text())),
                                    Center(
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(getString(context, "ok")
                                              .toUpperCase())),
                                    ),
                                  ],
                                )),
                          ));
                },
                iconSize: 20.0,
                icon: Icon(Icons.info_outline_rounded),
              ),
            ],
          ),
        if (selectBiometricAccess) SizedBox(height: Dimens.spacingMedium),
        if (selectBiometricAccess)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buidTextFieldTitle(
                  "registration_lello_user_phone_title", true, theme),
              SizedBox(height: Dimens.spacingSmall),
              _buildPhoneInput(state),
              SizedBox(height: Dimens.spacingMedium),
            ],
          ),
        Text(
          getString(context, "access_control_access_type"),
          style: LelloTextStyles.bodyBold(theme),
        ),
        SizedBox(height: Dimens.spacingSmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                width: 1.0, color: LelloTheme.palleteOf(theme).separator()),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: DropdownButton(
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down),
              underline: SizedBox.shrink(),
              hint: Text(
                getString(context, "access_control_choose_option"),
              ),
              value: _selectAccess,
              items: access.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              onChanged: (value) {
                if (value == "Recorrente") {
                  state.model.recurrence = AccessControlRecurrence(
                    recurrenceType: "DAILY",
                  );
                } else {
                  state.model.recurrence = null;
                }
                setState(() {
                  _selectAccess = value;
                  firstDate = null;
                  secondDate = null;
                });
              }),
        ),
        SizedBox(height: Dimens.spacingMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Text(
                      getString(context,
                          _selectAccess == "Recorrente" ? "from" : "date"),
                      style: LelloTextStyles.subtitle(theme),
                    ),
                    Text(
                      getString(context, "resident_required"),
                      style: LelloTextStyles.body(theme)!
                          .copyWith(color: theme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            if (_selectAccess == "Recorrente")
              SizedBox(width: Dimens.spacingMedium),
            if (_selectAccess == "Recorrente")
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Text(
                        getString(context, "to"),
                        style: LelloTextStyles.subtitle(theme),
                      ),
                      Text(
                        getString(context, "resident_required"),
                        style: LelloTextStyles.body(theme)!
                            .copyWith(color: theme.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: Dimens.spacingSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  _showDatePicker(
                    context,
                    theme,
                    widget.accessControlStore.bloc.state as EditVisitantState,
                    true,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: HexColor("#E0E0E0")),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${firstDate != null ? dateFormat.format(firstDate!) : "dd/mm/aa"}",
                      overflow: TextOverflow.ellipsis,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).hubText(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: Dimens.spacingMedium),
            _selectAccess == "Recorrente"
                ? Expanded(
                    child: Opacity(
                      opacity: firstDate != null ? 1.0 : 0.3,
                      child: InkWell(
                        onTap: firstDate != null
                            ? () {
                                _showDatePicker(
                                  context,
                                  theme,
                                  (widget.accessControlStore.bloc.state
                                      as EditVisitantState),
                                  false,
                                );
                              }
                            : null,
                        child: Container(
                          height: 55.0,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1.0,
                              color: LelloTheme.palleteOf(theme).separator(),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "${secondDate != null ? dateFormat.format(secondDate!) : "dd/mm/aa"}",
                              overflow: TextOverflow.ellipsis,
                              style: LelloTextStyles.subtitle(theme)!.copyWith(
                                color: LelloTheme.palleteOf(theme).hubText(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(child: Container()),
          ],
        ),
        if (_selectAccess == "Recorrente")
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimens.spacingMedium),
              Text(
                getString(context, "access_control_repeat"),
                style: LelloTextStyles.subtitle(theme),
              ),
              SizedBox(height: Dimens.spacingSmall),
              DaySelector(
                accessControlStore: widget.accessControlStore,
                ignore: createIgnoreList(),
              ),
            ],
          ),
      ],
    );
  }

  List<bool> createIgnoreList() {
    List<bool> ignore = [true, true, true, true, true, true, true];
    if (firstDate == null || secondDate == null) {
      ignore = [false, false, false, false, false, false, false];
      return ignore;
    } else {
      List<DateTime> dates = [];
      var difference = secondDate!
          .difference(
              DateTime(firstDate!.year, firstDate!.month, firstDate!.day))
          .inDays;
      debugPrint("Diferenca => $difference");
      dates.add(firstDate!);
      List.generate(difference, (index) {
        dates.add(dates[index].add(Duration(days: 1)));
      });
      debugPrint("Diferenca dates => $dates");
      if (difference >= 7) {
        ignore = [false, false, false, false, false, false, false];
        return ignore;
      } else {
        List.generate(dates.length, (index) {
          switch (dates[index].weekday) {
            case 1: //segunda
            case 2: //terca
            case 3: //quarta
            case 4: //quinta
            case 5: //sexta
            case 6: //sabado
              ignore[dates[index].weekday] = false;
              break;
            case 7: //domingo
              ignore[0] = false;
              break;
          }
        });
        return ignore;
      }
    }
  }

  Row _buidTextFieldTitle(String title, bool isRequired, ThemeData theme) {
    return Row(
      children: [
        Text(
          getString(context, title),
          style: LelloTextStyles.bodyBold(theme),
        ),
        SizedBox(
          width: Dimens.spacingSmall,
        ),
        if (isRequired)
          Text(
            getString(context, "resident_required"),
            style: LelloTextStyles.body(theme)!
                .copyWith(color: theme.primaryColor),
          ),
      ],
    );
  }

  Padding _buildNameTextField() {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: TextFormField(
        controller: controllerName,
        textInputAction: TextInputAction.done,
        onChanged: (val) {
          newName = val.trim();
        },
        validator: _validator.validateRequiredWithoutText,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: getString(context, "write"),
        ),
      ),
    );
  }

  Padding _buildDocumentTextField() {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: TextFormField(
        controller: controllerDocument,
        textInputAction: TextInputAction.done,
        onChanged: (val) {
          newDocument = val;
          cpf = val;
          if (cpf.length == 14) {
            var visitant = hasVisitantWithThisCpf();
            if (visitant != null) {
              showDialogCpf(visitant);
            }
          }
        },
        inputFormatters: [cpfFormatter()],
        validator: (text) => _validator.validateCPF(text),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Informe o CPF",
        ),
      ),
    );
  }

  Padding _buildDocumentForeignTextField() {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: TextFormField(
        controller: controllerDocumentForeign,
        textInputAction: TextInputAction.done,
        onChanged: (val) {
          if (val.length >= 7) {
            var visitant = hasVisitantWithThisCpf();
            if (visitant != null) {
              showDialogCpf(visitant);
            }
          }
        },
        inputFormatters: _selectForeignDocumentType == "RNE"
            ? [rneFormatter()]
            : [passportFormatter()],
        validator: (value) => _selectForeignDocumentType != null
            ? _selectForeignDocumentType == "RNE"
                ? _validator.validateRNE(value)
                : _validator.validatePassport(value)
            : selectBiometricAccess
                ? _validator.validateRequired(value)
                : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText:
              _selectForeignDocumentType == "RNE" ? "0000000-0" : "0000000",
        ),
      ),
    );
  }

  Padding _buildBusinessTextField() {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: TextFormField(
        controller: controllerBusiness,
        textInputAction: TextInputAction.done,
        onChanged: (val) {
          newBusiness = val;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: getString(context, "write"),
        ),
      ),
    );
  }

  Row _accessControlAuthTile(int auth, ThemeData theme) {
    return Row(
      children: [
        InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              choiceEntry = auth;
              firstDate = null;
              secondDate = null;
            });
          },
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              color: choiceEntry == auth
                  ? theme.primaryColor
                  : LelloTheme.palleteOf(theme).customColor(),
              shape: BoxShape.circle,
              border: Border.all(
                color: choiceEntry == auth
                    ? theme.primaryColor
                    : LelloTheme.palleteOf(theme).grey(),
              ),
            ),
            child: Icon(
              Icons.check,
              color: choiceEntry == auth
                  ? LelloTheme.palleteOf(theme).customColor()
                  : Colors.transparent,
            ),
          ),
        ),
        SizedBox(width: Dimens.spacingSmall),
        Text(
          auth == AccessControlTypeEntry.interfonar.index
              ? getString(context, "access_control_phone")
              : getString(context, "access_control_access_direct"),
          style: LelloTextStyles.subtitle(theme),
        ),
      ],
    );
  }

  Container _saveButton(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 54.0,
      child: PrimaryButton(
        text: getString(
            context,
            selectBiometricAccess && !widget.newVisit
                ? "access_control_save_send_button"
                : "save"),
        onPressed: () {
          // `_firstBuild` sempre define `choiceEntry` (acesso direto ou
          // interfonar) a partir da autorização, e a tile só troca entre esses
          // dois valores; logo `unavailable` nunca chega aqui e a validação
          // "validation_invalid_authorization" foi removida por ser morta.
          if (choiceEntry != AccessControlTypeEntry.interfonar.index &&
              _selectAccess == "Pontual" &&
              firstDate == null) {
            Flushbar(
              duration: Duration(seconds: 5),
              message: "Necessário informar uma data.",
            )..show(context);
          } else if (choiceEntry != AccessControlTypeEntry.interfonar.index &&
              _selectAccess == "Recorrente" &&
              (firstDate == null || secondDate == null)) {
            Flushbar(
              duration: Duration(seconds: 3),
              message: "Necessário informar uma data de início e final.",
            )..show(context);
          } else if (_formKey.currentState!.validate()) {
            List<AccessControlItens> itens = [];
            widget.state.visitant.gestUnits.last.autorizationTypeInt =
                choiceEntry;
            widget.state.visitant.name = controllerName.text;
            widget.state.visitant.business = controllerBusiness.text;
            if (widget.state.visitant.phone != null) {
              widget.state.visitant.phone = widget.state.visitant.phone!
                  .replaceAll(RegExp(r'[^0-9]'), '');
              widget.state.visitant.phone = _getPhone(
                  widget.state.visitant.phone!.substring(0, 2),
                  widget.state.visitant.phone!.substring(2));
            }
            var ignoreList = createIgnoreList();
            List.generate(widget.state.model.choices.length, (index) {
              if (widget.state.model.choices[index] == true &&
                  ignoreList[index] == true) {
                setState(() {
                  widget.state.model.choices[index] = false;
                });
              }
            });
            List.generate(widget.state.model.choices.length, (index) {
              if (widget.state.model.choices[index]) {
                itens.add(AccessControlItens(
                  recurrenceValue: index + 1,
                  end: AccessControlDate(
                    aecond: 0,
                    hour: 0,
                    minute: 0,
                    nano: 0,
                  ),
                  start: AccessControlDate(
                    aecond: 0,
                    hour: 0,
                    minute: 0,
                    nano: 0,
                  ),
                ));
              }
            });
            setInfo(widget.state);
            widget.state.model.recurrence?.itens = itens;
            if (widget.state.model.recurrence != null &&
                widget.state.model.choices.contains(true) == false) {
              widget.state.model.recurrence!.itens = [];
              if (ignoreList.contains(false)) {
                List<int> indexs = [];
                List.generate(ignoreList.length, (index) {
                  if (ignoreList[index] == false) {
                    indexs.add(index + 1);
                  }
                });
                List.generate(indexs.length, (index) {
                  widget.state.model.recurrence!.itens!.add(AccessControlItens(
                    recurrenceValue: indexs[index],
                    end: AccessControlDate(
                        hour: 0, minute: 0, aecond: 0, nano: 0),
                    start: AccessControlDate(
                        hour: 0, minute: 0, aecond: 0, nano: 0),
                  ));
                });
              } else {
                List.generate(7, (index) {
                  widget.state.model.recurrence!.itens!.add(AccessControlItens(
                    recurrenceValue: index + 1,
                    end: AccessControlDate(
                        hour: 0, minute: 0, aecond: 0, nano: 0),
                    start: AccessControlDate(
                        hour: 0, minute: 0, aecond: 0, nano: 0),
                  ));
                });
              }
            }
            widget.state.model.useFacialBiometric = selectBiometricAccess;
            widget.state.model.autorizationType = setAuthType(choiceEntry);
            var visitant = hasVisitantWithThisCpf();
            widget.state.visitant.document = controllerDocument.text;
            widget.state.visitant.foreignDocument = isForeign
                ? controllerDocumentForeign.text
                    .replaceAll(RegExp(r'[\.\-]'), '')
                : null;
            widget.state.visitant.typeDocument = isForeign
                ? _selectForeignDocumentType?.toString().toUpperCase()
                : null;
            if (visitant != null &&
                visitant.idGest != widget.state.visitant.idGest) {
              showDialogCpf(visitant);
            } else {
              saveOrEdit();
            }
          }
        },
      ),
    );
  }

  AccessControl? hasVisitantWithThisCpf() {
    if (cpf.isNotEmpty) {
      String result = cpf.replaceAll(RegExp('[^A-Za-z0-9]'), '');

      var visitant = widget.state.visitants
          .where((element) => element.documentFormatted == result);
      if (visitant.isNotEmpty) {
        return visitant.first;
      }

      var provider = widget.state.providers
          .where((element) => element.documentFormatted == result);
      if (provider.isNotEmpty) {
        return provider.first;
      }

      return null;
    }

    if (controllerDocumentForeign.text.isNotEmpty && !widget.isEdit) {
      String result =
          controllerDocumentForeign.text.replaceAll(RegExp('[^A-Za-z0-9]'), '');
      var visitant = widget.state.visitants.where((element) =>
          element.documentFormatted == result &&
          element.typeDocumentFormatted == _selectForeignDocumentType);
      if (visitant.isNotEmpty) {
        return visitant.first;
      }
    }
    return null;
  }

  showDialogCpf(AccessControl visitant) {
    showDialog(
      context: context,
      builder: (context) => AccessControlCpfDialog(
        sessionBloc: sessionBloc!,
        isVisitant: visitant.prestador == false,
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AccessControlAppointmentsPage(
                    isGeneric: widget.isGeneric,
                    accessControlStore: widget.accessControlStore,
                    accessControl: visitant),
              ));
        },
      ),
    );
  }

  saveOrEdit() {
    bool isVisitant = !widget.state.visitant.prestador;
    if (widget.newVisit) {
      isVisitant
          ? visitantController.saveVisitantVisit(
              visitant: widget.state.visitant,
              authorizations: widget.state.model,
              cpf: cpf)
          : providerController.saveProviderVisit(
              visitant: widget.state.visitant,
              authorizations: widget.state.model,
              cpf: cpf);
    } else if (widget.isEdit) {
      isVisitant
          ? visitantController.editVisitantScheduledVisit(
              visitant: widget.state.visitant,
              authorizations: widget.state.model,
              cpf: cpf,
            )
          : providerController.editProviderScheduledVisit(
              visitant: widget.state.visitant,
              authorizations: widget.state.model,
              cpf: cpf,
            );
    } else {
      isVisitant
          ? visitantController.saveVisitantAccess(
              model: widget.state.visitant,
              authorizations: widget.state.model,
              useFacialBiometric: selectBiometricAccess,
            )
          : providerController.saveProviderAccess(
              model: widget.state.visitant,
              authorizations: widget.state.model,
              useFacialBiometric: selectBiometricAccess,
            );
    }
  }

  setAuthType(int auth) {
    if (choiceEntry == AccessControlTypeEntry.interfonar.index) {
      return "PHONE";
    } else {
      if (_selectAccess == "Pontual") {
        return "PONTUAL";
      } else {
        return "ACESSO_GRANTED";
      }
    }
  }

  void setInfo(EditVisitantState state) {
    if (choiceEntry == AccessControlTypeEntry.interfonar.index) {
      state.model.recurrence = null;
      state.model.start = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        0,
      ).toIso8601String();
      state.model.end = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        0,
      ).toIso8601String();
      state.model.initHour = "0";
      state.model.initMinute = "0";
      state.model.endHour = "0";
      state.model.endMinute = "0";
    } else {
      if (_selectAccess == "Recorrente") {
        DateTime start = state.model.startDate;
        state.model.start = DateTime(
          start.year,
          start.month,
          start.day,
          start.hour,
          start.minute,
        ).toIso8601String();
      }
      if (_selectAccess == "Pontual") {
        state.model.recurrence = null;
        state.model.start = DateTime(
          state.model.startDate.year,
          state.model.startDate.month,
          state.model.startDate.day,
          0,
          0,
        ).toIso8601String();
        state.model.end = DateTime(
          state.model.startDate.year,
          state.model.startDate.month,
          state.model.startDate.day,
          0,
          0,
        ).toIso8601String();
      }
    }
  }

  Container _deleteButton(
      SessionBloc sessionBloc, ThemeData theme, EditVisitantState state) {
    return Container(
      padding: const EdgeInsets.only(right: 2.0),
      height: 54.0,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: LelloTheme.palleteOf(theme).customColor(),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: theme.primaryColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_forever_outlined,
              color: theme.primaryColor,
            ),
            SizedBox(width: Dimens.spacingSmall),
            Text(
              getString(context, "access_control_delete_visit"),
              style: LelloTextStyles.button(theme)!
                  .copyWith(color: theme.primaryColor),
            ),
          ],
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AccessControlDeleteVisitDialog(
              sessionBloc: sessionBloc,
              onTap: () {
                Navigator.pop(context);
                widget.accessControlStore.deleteVisit(
                    recurrenceId: state.model.id ?? "",
                    visitant: state.visitant,
                    authorizations: state.model);
              },
            ),
          );
        },
      ),
    );
  }

  Container _cancelRegister(SessionBloc sessionBloc, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.only(right: 2.0),
      height: 54.0,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: LelloTheme.palleteOf(theme).customColor(),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: LelloTheme.palleteOf(theme).textOpaque(),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          widget.isEdit
              ? "Descartar alterações"
              : getString(context, "access_control_cancel_register"),
          style: LelloTextStyles.button(theme)!.copyWith(color: Colors.black),
        ),
        onPressed: () {
          widget.isEdit
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccessControlAppointmentsPage(
                      accessControlStore: widget.accessControlStore,
                      isGeneric: widget.isGeneric,
                      accessControl: widget.state.visitant,
                    ),
                  ))
              : Navigator.pushReplacementNamed(
                  context,
                  ApplicationRoute.accessControl,
                  arguments: AcessControlPageArgs(
                    tabIndex: widget.isVisitant ? 0 : 1,
                    isGeneric: widget.isGeneric,
                  ),
                );
        },
      ),
    );
  }

  void _showDatePicker(BuildContext context, ThemeData theme,
      EditVisitantState state, bool isStart) {
    DatePicker.showDatePicker(context,
        minTime: isStart ? DateTime.now() : firstDate,
        currentTime: isStart
            ? DateTime.now()
            : secondDate != null
                ? secondDate
                : firstDate,
        maxTime: isStart
            ? secondDate != null
                ? secondDate
                : null
            : firstDate!.add(Duration(days: 365)),
        locale: LocaleType.pt,
        theme: DatePickerTheme(
          doneStyle: TextStyle(
              color: theme.primaryColor,
              fontSize: 16.0,
              fontWeight: FontWeight.normal),
        ), onConfirm: (date) {
      setState(() {
        isStart ? firstDate = date : secondDate = date;
      });

      if (isStart) {
        state.model.start = DateTime(
          date.year,
          date.month,
          date.day,
          0,
          0,
        ).toIso8601String();
      } else {
        state.model.end = DateTime(
          date.year,
          date.month,
          date.day,
          0,
          0,
        ).toIso8601String();
      }
    });
  }

  Widget _buildPhoneInput(EditVisitantState state) {
    var ddd = _initialDDD(state.visitant.phone ?? "");
    var phone = _initialPhone(state.visitant.phone ?? "");
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Dimens.spacingXLarge,
          child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: ddd,
            onSaved: (value) => ddd = value ?? "",
            textInputAction: TextInputAction.next,
            validator: _validator.validateRequired,
            onChanged: (value) {
              if (value.length == 2) {
                FocusScope.of(context).nextFocus();
              }
              ddd = value;
              state.visitant.phone = ddd;
            },
            textAlign: TextAlign.center,
            maxLength: 2,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              counterText: '',
              hintText: "00",
            ),
          ),
        ),
        SizedBox(
          width: Dimens.spacingSmall,
        ),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: phone,
            onChanged: (value) {
              phone = value;
              state.visitant.phone = _getPhone(ddd, phone);
            },
            onSaved: (value) => phone = value ?? "",
            inputFormatters: [cellphoneFormatter()],
            validator: _validator.validateRequired,
            maxLength: 10,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "00000.0000",
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }

  /// O formato ("+55 ..." ou "(DD) ...") é testado no texto original; os
  /// recortes são feitos sobre os dígitos.
  String _initialDDD(String initialValue) {
    final raw = initialValue.trim();
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.startsWith("+55")) {
      return digits.length > 4 ? digits.substring(2, 4) : "";
    }
    if (raw.startsWith("(")) {
      return digits.length > 2 ? digits.substring(0, 2) : "";
    }
    if (digits.length > 9) return digits.substring(0, 2);
    return "";
  }

  String _initialPhone(String initialValue) {
    final raw = initialValue.trim();
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.startsWith("+55")) {
      return digits.length > 4 ? digits.substring(4) : "";
    }
    if (raw.startsWith("(")) {
      return digits.length > 2 ? digits.substring(2) : "";
    }
    if (digits.length > 9) return digits.substring(2);
    return digits;
  }

  String _getPhone(String ddd, String phone) {
    String val = "";
    if (ddd.isNotEmpty) {
      val = "($ddd)";
    }
    if (phone.isNotEmpty) {
      val += phone;
    }
    return val;
  }

  _firstBuild() {
    if (firstBuild) {
      controllerName.text = widget.state.visitant.name ?? "";
      controllerDocument.text = widget.state.visitant.documentFormatted ?? "";
      controllerBusiness.text = widget.state.visitant.business ?? "";
      controllerDocumentForeign.text =
          widget.state.visitant.documentFormatted ?? "";
      newName = widget.state.visitant.name ?? "";
      newDocument = widget.state.visitant.documentFormatted ?? "";
      newBusiness = widget.state.visitant.business ?? "";
      isForeign = widget.state.visitant.typeDocument?.isNotEmpty == true;
      controllerDocumentForeign.text =
          widget.state.visitant.documentFormatted ?? "";
      _selectForeignDocumentType = widget.state.visitant.typeDocumentFormatted;
      selectBiometricAccess = widget.state.model.useFacialBiometric ?? false;
      if (widget.authorization.authType == "Recorrente") {
        choiceEntry = AccessControlTypeEntry.acessoDireto.index;
        _selectAccess = access[1];
        firstDate = widget.authorization.startDate;
        secondDate = widget.authorization.endDate;
      } else if (widget.authorization.authType == "Pontual") {
        choiceEntry = AccessControlTypeEntry.acessoDireto.index;
        firstDate = widget.authorization.startDate;
        _selectAccess = access[0];
      } else {
        choiceEntry = AccessControlTypeEntry.interfonar.index;
        _selectAccess = access[0];
      }
      firstBuild = false;
    }
  }
}
