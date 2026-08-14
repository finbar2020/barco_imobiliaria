// ignore_for_file: deprecated_member_use

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/loading_widget.dart';

import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/details/vacation_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/details/vacation_state.dart';
import 'package:lello/feature/gdp/vacation/presentation/page/schedule_vacation_details_page.dart';
import 'package:lello/feature/gdp/vacation/presentation/page/schedule_vacation_summary_page.dart';
import 'package:lello/feature/gdp/vacation/presentation/widget/vacation_accordion_content.dart';
import 'package:lello/feature/gdp/vacation/presentation/widget/vacation_schudeled_alert_dialog.dart';
import 'package:lello/feature/gdp/vacation/presentation/widget/vacation_text_field_schudele.dart';

class VacationPage extends StatefulWidget {
  const VacationPage({super.key});

  @override
  _VacationPageState createState() => _VacationPageState();
}

class PeriodConfig {
  DateTime? start;
  int? days;
  double allowanceValue;
  String? formatedAllow13;
  String? allow13Value;
  String? employeeId;
  String? employeeRegistrationNumber;
  int? employeeCompany;
  String? admissionDate;
  String? employeeName;
  String? periodAquisitive;

  PeriodConfig(
      {this.start,
      this.days,
      this.allowanceValue = 0,
      this.formatedAllow13,
      this.allow13Value,
      this.employeeId,
      this.employeeRegistrationNumber,
      this.employeeCompany,
      this.admissionDate,
      this.employeeName,
      this.periodAquisitive});

  GlobalKey<FormState> key = GlobalKey<FormState>();

  get getEnd => start?.add(Duration(days: days != null ? days! - 1 : 0));

  get getStartFormatted =>
      start != null ? DateFormat('dd/MM/yyyy').format(start!) : "";
  get getEndFormatted =>
      start != null ? DateFormat('dd/MM/yyyy').format(getEnd) : "";
}

class _VacationPageState extends State<VacationPage> {
  final VacationBloc bloc = ApplicationContainer.instance().resolve();
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  List<PeriodConfig> periodConfig = [];
  VacationLockedDays? lockedDays;
  late String formatedAllow13;
  String? allow13Value = "N";
  List<int>? periodsList;
  var periodsSelect = 1;
  var periodsDaysSelect;
  var allowanceValue = 0;
  DateTime? vacationEndDateFormatted;
  final formKeyVacation = GlobalKey<FormState>();
  List? periodsDaysList; //
  List? blockedDaysDateTime;
  var loaded = false;
  late String periodDate;
  late String periodValue = periodDate;
  bool readPageOnly = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<String> allow13 = [
      getString(context, "no"),
      getString(context, "yes"),
    ];
    formatedAllow13 = allow13[0];
    final Employee? employee =
        ModalRoute.of(context)!.settings.arguments as Employee?;
    if (!loaded && employee != null) {
      bloc.beginLoad(employee.id!);
      loaded = true;
    }

    var curestState = bloc.state;
    if (curestState is VacationLoadedState) {
      _getLockedDays(curestState.lockedDays.locked_days);
      _getvacationEndDateFormatted(curestState);
      _formatAllow13(curestState, context);
      configPeriodVacationList(curestState);
      configPeriodDaysVacationList(curestState);
    }

    return Theme(
        data: theme,
        child: Scaffold(
          appBar: PrimaryAppBar(
              iconColor: theme.primaryColor,
              theme: theme,
              title: getString(context, 'gdp_vacation_title')),
          body: BlocConsumer(
              listener: (context, state) {
                if (state is VacationLoadedState) {
                  _checkReadPageOnly(state);
                  if (readPageOnly) {
                    var vacationConfig = state.data;

                    List<PeriodConfig> scheduleConfig = [];

                    for (Vacation v in vacationConfig!.scheduledVacations!) {
                      PeriodConfig asd = PeriodConfig();
                      //asd.start = v.vacationStartDate;
                      asd.start =
                          DateFormat('dd/MM/yyyy').parse(v.vacationStartDate!);
                      asd.days = v.scheduledDays;
                      asd.allowanceValue = v.allowanceDays ?? 0;
                      asd.formatedAllow13 = v.advance13 == 'S'
                          ? getString(context, "yes")
                          : getString(context, "no");
                      asd.employeeId = v.employeeId;
                      asd.employeeRegistrationNumber =
                          v.employeeRegistrationNumber;
                      asd.admissionDate = v.admissionDate;
                      asd.employeeName = v.employeeName;
                      asd.periodAquisitive = v.getPeriodVacation;
                      scheduleConfig.add(asd);
                    }

                    //TODO: rotear para tela de detalhes
                    Navigator.popAndPushNamed(
                        context, ApplicationRoute.gdpVacationDetails,
                        arguments:
                            ScheduleVacationDetailsPageArgs(scheduleConfig));
                  }
                }
              },
              bloc: bloc,
              builder: (context, state) {
                if (state is VacationLoadedState) {
                  _checkReadPageOnly(bloc.state as VacationLoadedState);
                  return _buildBody(theme, state, allow13);
                }
                if (state is VacationLoadingState) {
                  return const Center(child: LoadingWidget());
                }
                if (state is VacationLoadFailedState) {
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: ErrorHandlingWidget(
                      reTryFunction: () {
                        if (employee?.id != null) {
                          bloc.beginLoad(employee!.id!);
                        }
                      },
                      backFunction: () => Navigator.pop(context, true),
                      isProduction: env.isProduction,
                      error: state.error?.error.toString() ?? "",
                      errorCode: state.error?.code.toString() ?? "",
                      textReturnButton: "back_to_the_previous_page",
                    ),
                  );
                }
                return Container();
              }),
        ));
  }

  Widget _buildBody(ThemeData theme, VacationLoadedState state, List allow13) {
    _formatAquisitivePeriod(state);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (readPageOnly) {
        showDialog(
            context: context,
            builder: (context) => const VacationScheduledAlertDialog());
      }
    });

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildHeader(context, theme, state),
                  _buildForm(context, theme, state, allow13),
                  if (!readPageOnly) _advanceButton(),
                  _cancelVacation(theme)
                ]),
          ))
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, ThemeData theme, VacationLoadedState state) {
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      decoration: BoxDecoration(
          color: LelloTheme.palleteOf(theme).separator(),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(getString(context, "gdp_vacation_schedule_employee"),
              style: LelloTextStyles.bodyBold(theme)),
          Text(state.data?.employeeName ?? "",
              style: LelloTextStyles.body(theme)),
          SizedBox(height: Dimens.spacingSmall),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getString(context, "gdp_vacation_employee_admission"),
                        style: LelloTextStyles.caption(theme)),
                    Text(state.data!.admissionDate.toString(),
                        style: LelloTextStyles.caption(theme)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        getString(context,
                            "gdp_vacation_employee_number_vacation_days"),
                        style: LelloTextStyles.caption(theme)),
                    Text(state.data!.allowanceDays!.toStringAsFixed(0),
                        style: LelloTextStyles.caption(theme)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        getString(context,
                            "gdp_vacation_employee_number_service_absences"),
                        style: LelloTextStyles.caption(theme)),
                    Text(state.data?.numberAbsences?.toStringAsFixed(0) ?? "",
                        style: LelloTextStyles.caption(theme)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, ThemeData theme,
      VacationLoadedState state, List allow13) {
    return Form(
        key: formKeyVacation,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getString(context, "gdp_quick_fix_report_vacation_type"),
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
                      child: IgnorePointer(
                        ignoring: readPageOnly,
                        child: DropdownButtonFormField(
                            isExpanded: true,
                            validator: (value) {
                              if (value == null) {
                                return getString(
                                    context, "validation_required");
                              }
                              return null;
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                            hint: Text(state.data?.scheduledDays != 0
                                ? state.data!.getPeriodVacation
                                : getString(context,
                                    "gdp_vacation_select_acquisition_period_vacation")),
                            items: <String>[periodValue]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(periodValue),
                              );
                            }).toList(),
                            onTap: () {
                              // FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  periodValue = value.toString();
                                }
                                //formKeyVacation.currentState!.validate();
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.spacingMedium),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getString(context,
                          "gdp_vacation_employee_vacation_period_amount"),
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
                      child: IgnorePointer(
                        ignoring: readPageOnly,
                        child: DropdownButtonFormField<int>(
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            decoration: const InputDecoration(),
                            validator: (value) {
                              if (value == null) {
                                return getString(
                                    context, "validation_required");
                              }
                              return null;
                            },
                            hint: Text(state.data?.numbersUnitVacation != 0
                                ? state.data!.getNumbersUnitVacation.toString()
                                : getString(context,
                                    "gdp_vacation_employee_vacation_set_number_periods")),
                            items: (periodsList ?? []).map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onTap: () {
                              // FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            onChanged: (newValue) {
                              setState(() {
                                _cleanInputs();
                                periodsDaysSelect = null;
                                periodsSelect = newValue!;
                                //formKeyVacation.currentState!.validate();
                                periodConfig = [];
                                for (int i = 0; i < periodsSelect; i++) {
                                  periodConfig.add(PeriodConfig());
                                }
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.spacingMedium),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getString(context,
                          "gdp_vacation_employee_number_days_per_period"),
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
                      child: IgnorePointer(
                        ignoring: readPageOnly,
                        child: DropdownButtonFormField(
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            //underline: SizedBox.shrink(),
                            hint: Text(state.data?.scheduledDays != 0
                                ? state.data!.scheduledDays.toString()
                                : getString(context,
                                    "gdp_vacation_employee_vacation_set_number_periods")),
                            value: periodsDaysSelect,
                            validator: (value) {
                              if (value == null) {
                                return getString(
                                    context, "validation_required");
                              }
                              return null;
                            },
                            items: (periodsDaysList ?? []).map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onTap: () {
                              // FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            onChanged: (value) {
                              _cleanInputs();
                              //formKeyVacation.currentState!.validate()
                              var periodoDias =
                                  _getPeriodsValues(value.toString());
                              for (var element in periodConfig) {
                                var index = periodConfig.indexOf(element);
                                element.days = periodoDias[index];
                              }
                              setState(() {
                                periodsDaysSelect = value;
                                allowanceValue = getAllowValue();
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.spacingMedium),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getString(context, "gdp_vacation_employee_allowance"),
                      style: LelloTextStyles.caption(theme)!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(state.data?.salaryAllowance != 0
                        ? state.data!.salaryAllowance.toString()
                        : allowanceValue.toString()),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      getString(context, "gdp_vacation_salary_anticipation"),
                      style: LelloTextStyles.caption(theme)!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: IgnorePointer(
                        ignoring: readPageOnly,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          //underline: SizedBox.shrink(),
                          style: TextStyle(
                              color: LelloTheme.palleteOf(theme).text()),
                          value: state.data?.advance13 == ""
                              ? formatedAllow13
                              : getString(
                                  context, state.data!.getAdvance13.toString()),
                          validator: (value) {
                            if (value == null) {
                              return getString(context, "validation_required");
                            }
                            return null;
                          },
                          items: allow13
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text('$e')))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              formatedAllow13 = newValue.toString();
                              if (newValue == "No" || newValue == "Não") {
                                allow13Value = "N";
                              } else {
                                allow13Value = "S";
                              }
                            });
                          },
                          onTap: () {
                            // FocusScope.of(context).requestFocus(new FocusNode());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.spacingMedium),
                if (state.data?.vacationStartDate != null)
                  VacationTextFieldSchudele(
                    date: state.data?.vacationStartDate,
                    text: "gdp_vacation_employee_start",
                  ),
                SizedBox(height: Dimens.spacingMedium),
                if (state.data?.vacationEndDate != null)
                  VacationTextFieldSchudele(
                      date: state.data?.vacationEndDate,
                      text: "gdp_vacation_employee_end"),
                Column(
                  children: [
                    Accordion(
                      disableScrolling: true,
                      openAndCloseAnimation: true,
                      headerPadding: const EdgeInsets.all(15.0),
                      headerBorderRadius: 5.0,
                      headerBackgroundColor: theme.primaryColor,
                      maxOpenSections: 3,
                      leftIcon:
                          const Icon(Icons.calendar_today, color: Colors.white),
                      children: [
                        if (periodConfig.isNotEmpty &&
                            periodConfig[0].days != null)
                          _buildAccordionSection(
                              context, theme, state, 0, periodConfig),
                        if (periodConfig.length > 1 &&
                            periodConfig[1].days != null)
                          _buildAccordionSection(
                              context, theme, state, 1, periodConfig),
                        if (periodConfig.length > 2 &&
                            periodConfig[2].days != null)
                          _buildAccordionSection(
                              context, theme, state, 2, periodConfig),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  AccordionSection _buildAccordionSection(BuildContext context, ThemeData theme,
      VacationLoadedState state, int index, List<PeriodConfig> periodConfig) {
    return AccordionSection(
      isOpen: true,
      header: Text(
        periodConfig.length > 1
            ? "${index + 1} - ${getString(context, "gdp_vacation_period")}"
            : getString(context, "gdp_vacation_period"),
        style: LelloTextStyles.bodyBold(theme)!.copyWith(color: Colors.white),
      ),
      content: AccordionSectionContent(
          periodConfig: periodConfig[index],
          periodNumber: index,
          lockedDays: lockedDays,
          vacationEndDateFormatted: vacationEndDateFormatted!,
          periodConfigPrevious: index == 0 ? null : periodConfig[index - 1],
          minFirstDateFromToday: state.vacationParams?.qtdInitDays ?? 1),
    );
  }

  Column _advanceButton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
          child: SizedBox(
            width: double.infinity,
            height: 54.0,
            child: PrimaryButton(
              text: getString(context, "next"),
              onPressed: () {
                var ok = true;
                var validadeDates = false;
                for (var element in periodConfig) {
                  if (!element.key.currentState!.validate()) {
                    ok = false;
                  }
                }
                if (ok) {
                  validadeDates = _validadeDates();
                }
                if (validadeDates) {
                  showFlushBar(context);
                } else {
                  var currentState = bloc.state;

                  if (ok &&
                      formKeyVacation.currentState!.validate() &&
                      currentState is VacationLoadedState) {
                    periodConfig.first.allowanceValue =
                        allowanceValue.toDouble();
                    periodConfig.first.formatedAllow13 = allow13Value == 'S'
                        ? getString(context, "yes")
                        : getString(context, "no");
                    periodConfig.first.allow13Value = allow13Value;
                    periodConfig.first.employeeId =
                        currentState.data?.employeeId;
                    periodConfig.first.employeeRegistrationNumber =
                        currentState.data?.employeeRegistrationNumber;
                    periodConfig.first.employeeCompany =
                        currentState.data?.company;
                    periodConfig.first.admissionDate =
                        currentState.data?.admissionDate;
                    periodConfig.first.employeeName =
                        currentState.data?.employee?.name;
                    periodConfig.first.periodAquisitive =
                        currentState.data?.getPeriodVacation;
                    Navigator.pushNamed(
                        context, ApplicationRoute.gdpVacationSummary,
                        arguments:
                            ScheduleVacationSummaryPageArgs(periodConfig));
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _cancelVacation(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0),
          child: Container(
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
                readPageOnly
                    ? getString(context, "back")
                    : getString(context, "cancel"),
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  _formatAquisitivePeriod(VacationLoadedState state) {
    periodDate = state.data!.getPeriodVacation;
  }

  void configPeriodVacationList(VacationLoadedState state) {
    if (periodsList == null) {
      periodsList = [];
      for (var element in (state.vacationParams?.periods ?? [])) {
        if (element?.periodsNumber != null) {
          periodsList?.add(element!.periodsNumber);
        }
      }
    }
  }

  void configPeriodDaysVacationList(VacationLoadedState state) {
    if (periodsSelect > 0) {
      periodsDaysList = [];
      periodsDaysList =
          state.vacationParams!.periods[periodsSelect - 1]!.getIntervals;
    }
  }

  List<int> _getPeriodsValues(String periodsDaysSelect) {
    List<String> periodsDaysValue =
        periodsDaysSelect.replaceAll(" - ", "").split("d");
    periodsDaysValue.removeLast();
    List<int> periodsDaysInt =
        periodsDaysValue.map((e) => int.tryParse(e) ?? 0).toList();
    return periodsDaysInt;
  }

  void _formatAllow13(VacationLoadedState state, BuildContext context) {
    if (state.data?.advance13 == null) {
      formatedAllow13 = getString(context, "no");
    } else if (state.data?.advance13 == "S") {
      formatedAllow13 = getString(context, "yes");
    } else if (state.data?.advance13 == "N") {
      formatedAllow13 = getString(context, "no");
    }
  }

  String sanitizeDateTime(DateTime dateTime) =>
      "${dateTime.year}-${dateTime.month.toString().padLeft(2, "0")}-${dateTime.day}";

  void _getvacationEndDateFormatted(VacationLoadedState state) {
    vacationEndDateFormatted = DateTime.parse(
        (state.data?.acquisitivePeriodEndDate ?? "")
            .split("/")
            .reversed
            .join());
  }

  void _cleanInputs() {
    periodConfig = [];
    for (int i = 0; i < periodsSelect; i++) {
      periodConfig.add(PeriodConfig());
    }
  }

  void _getLockedDays(List<String>? vacationLockedDays) {
    if (vacationLockedDays != null) {
      lockedDays = VacationLockedDays()..locked_days = [];
      for (var element in (vacationLockedDays)) {
        lockedDays?.add(element.split("/").reversed.join("-"));
      }
    }
  }

  Flushbar? flush;
  void showFlushBar(BuildContext context) {
    if (flush != null) {
      flush!.dismiss();
    }
    flush = Flushbar(
      message: getString(context, "gdp_vacation_date_selected_diff_Dates"),
      isDismissible: true,
      duration: const Duration(seconds: 30),
      onTap: (flush) {
        flush.dismiss();
      },
    )..show(context);
  }

  int getAllowValue() {
    if (periodsSelect == 1) {
      if (periodConfig[0].days == 20) {
        return 10;
      } else {
        return 0;
      }
    } else if (periodsSelect == 2) {
      int count = periodConfig[0].days! + periodConfig[1].days!;
      if (count == 20) {
        return 10;
      } else {
        return 0;
      }
    }
    return 0;
  }

  bool _validadeDates() {
    if (periodsSelect == 2) {
      if (periodConfig[0].start!.isAfter(periodConfig[1].start!)) {
        return true;
      } else {
        return false;
      }
    } else if (periodsSelect == 3) {
      if (periodConfig[0].start!.isAfter(periodConfig[1].start!) ||
          periodConfig[0].start!.isAfter(periodConfig[2].start!) ||
          periodConfig[1].start!.isAfter(periodConfig[2].start!)) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  void _checkReadPageOnly(VacationLoadedState state) {
    if (state.data?.vacationStartDate == null &&
        state.data?.vacationEndDate == null) {
      readPageOnly = false;
    } else {
      readPageOnly = true;
    }
  }
}
