import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_state.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_change_rule_success_page.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_rule_days_time_widget.dart';

class ReservationChangeRulesPage extends StatefulWidget {
  const ReservationChangeRulesPage({Key? key}) : super(key: key);

  @override
  _ReservationChangeRulesPageState createState() =>
      _ReservationChangeRulesPageState();
}

class _ReservationChangeRulesPageState
    extends State<ReservationChangeRulesPage> {
  bool first = true;

  var _itemSelecionado;
  var _periodoSelecionado;
  List<String> periods = [
    "1 dia",
    "2 dias",
    "3 dias",
    "1 semana",
    "2 semanas",
    "3 semanas",
    "1 mês",
    "2 meses",
    "3 meses",
    "Não há prazo de antecedência"
  ];

  ReservationChangeRulesBloc bloc = ApplicationContainer.instance().resolve();

  @override
  void initState() {
    super.initState();
    bloc.getRules();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: PrimaryAppBar(
          iconColor: theme.primaryColor,
          theme: theme,
          title: getString(context, "space_change_rules"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: BlocConsumer(
            bloc: bloc,
            listener: (context, state) {
              if (state is PostSuccessState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReservationChangeRuleSuccessPage()),
                );
              }
            },
            builder: (context, state) {
              if (state is ReservationChangeRulesLoadingState ||
                  state is ReservationChangeRulesEmptyState) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                      const Center(
                        child: Text("Por favor, aguarde."),
                      ),
                    ],
                  ),
                );
              }
              if (state is ReservationChangeRulesFailedGetState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        "Ocorreu um erro ao buscar as regras da mudança. Tente novamente mais tarde.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }
              if (state is ReservationChangeRulesFailedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(
                      child: Text(
                        "Erro ao salvar as regras de mudança. Tente novamente mais tarde.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }
              if (state is ReservationChangeRulesLoadedState) {
                if (first) {
                  setData(state);
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getString(context, "space_change_rules_first_info"),
                        style: LelloTextStyles.bodyBold(theme),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      _buildUnitRule(context, state, theme),
                      SizedBox(height: Dimens.spacingMedium),
                      _buildPeriodRule(context, state, theme),
                      SizedBox(height: Dimens.spacingMedium),
                      ReservationRuleDaysTimeWidget(
                        isWeek: true,
                        state: state,
                      ),
                      SizedBox(height: Dimens.spacing),
                      ReservationRuleDaysTimeWidget(
                        isWeek: false,
                        state: state,
                      ),
                      SizedBox(height: Dimens.spacingLarge),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          buttonColor: theme.primaryColor,
                          text: getString(context, "save"),
                          onPressed: () {
                            if (_itemSelecionado == null &&
                                _periodoSelecionado == null) {
                              Flushbar(
                                duration: const Duration(seconds: 1),
                                message: "Preencha os campos obrigatórios*",
                              ).show(context);
                            } else if (_validateHours(state) != "") {
                              Flushbar(
                                duration: const Duration(seconds: 2),
                                message: _validateHours(state),
                              ).show(context);
                            } else {
                              bloc.postRules(body: state.rules);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: Dimens.spacing),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void setData(ReservationChangeRulesLoadedState state) {
    if (state.rules.spaceId != null) {
      _itemSelecionado = (state.rules.maxPerDay).toString();
      _periodoSelecionado = periods[state.rules.diasAntecedencia];
    }
    first = false;
  }

  Column _buildUnitRule(BuildContext context,
      ReservationChangeRulesLoadedState state, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quantas unidades podem fazer mudança por dia?*",
          style: LelloTextStyles.caption(theme)!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Dimens.spacingSmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.0, color: Colors.grey),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: DropdownButton(
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              underline: const SizedBox.shrink(),
              hint: const Text("Selecione"),
              value: _itemSelecionado,
              items: List.generate(
                10,
                (index) => DropdownMenuItem<String>(
                  value: index.toString(),
                  child: Text(
                    "${index + 1} ${index == 0 ? "unidade" : "unidades"}/dia",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              onChanged: (value) {
                setState(() {
                  _itemSelecionado = value;
                });
                state.rules.maxPerDay = int.parse(value as String);
              }),
        ),
      ],
    );
  }

  Column _buildPeriodRule(BuildContext context,
      ReservationChangeRulesLoadedState state, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Qual é o prazo de antecedência para reservar mudança?*",
          style: LelloTextStyles.caption(theme)!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Dimens.spacingSmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.0, color: Colors.grey),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: DropdownButton(
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              underline: const SizedBox.shrink(),
              hint: const Text("Selecione"),
              value: _periodoSelecionado,
              items: List.generate(
                periods.length,
                (i) => DropdownMenuItem<String>(
                  value: periods[i],
                  child: Text(
                    periods[i],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              onChanged: (value) {
                setState(() {
                  _periodoSelecionado = value;
                  var test = periods.indexOf(value as String);
                  state.rules.setDays = test;
                });
              }),
        ),
      ],
    );
  }

  String _validateHours(ReservationChangeRulesLoadedState state) {
    if ((state.rules.allowedDaysList!.contains(0) ||
            state.rules.allowedDaysList!.contains(6)) &&
        (state.rules.weekendHourStart == "00:00:00" ||
            state.rules.weekendHourEnd == "00:00:00")) {
      return "Preencha campos de horário";
    }
    if ((state.rules.allowedDaysList!.contains(1) ||
            state.rules.allowedDaysList!.contains(2) ||
            state.rules.allowedDaysList!.contains(3) ||
            state.rules.allowedDaysList!.contains(4) ||
            state.rules.allowedDaysList!.contains(5)) &&
        (state.rules.weekHourStart == "00:00:00" ||
            state.rules.weekHourEnd == "00:00:00")) {
      return "Preencha campos de horário";
    }
    return "";
  }
}
