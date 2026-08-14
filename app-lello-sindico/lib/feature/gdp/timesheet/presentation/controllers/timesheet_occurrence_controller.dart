import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/extension/string_extension.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_request_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_type_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_groupped_occurrence/get_grouped_occurrence.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_control_occurrence/post_control_occurrence.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_manual_appointment/post_manual_appointment.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_occurrence/timesheet_occurrence_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_occurrence/timesheet_occurrence_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class TimesheetOccurrenceController {
  final SessionBloc sessionBloc;
  final GetGroupedOccurrence getGroupedOccurrence;
  final PostControlOccurrence postControlOccurrence;
  final PostManualAppointment postManualAppointment;
  final TimesheetOccurrenceBloc bloc;

  TimesheetOccurrenceController({
    required this.sessionBloc,
    required this.getGroupedOccurrence,
    required this.postControlOccurrence,
    required this.postManualAppointment,
    required this.bloc,
  });

  List<TimesheetOccurrenceEntity> occurrences = [];
  List<TimesheetOccurrenceEntity> filterOcurrencesList = [];
  List<bool> employesSelecteds = [];
  List<String> individualAction = [];
  DateTime selectDate = DateTime.now();

  List<String> employeesNames = [];
  Map<TimesheetOccurrenceTypeEnum, String> filterTypes = {
    TimesheetOccurrenceTypeEnum.delay: "Atraso",
    TimesheetOccurrenceTypeEnum.fouls: "Falta sem justificativa",
    TimesheetOccurrenceTypeEnum.vacation: "Folga",
    TimesheetOccurrenceTypeEnum.extraHour: "Hora extra"
  };

  DateTime? filterSelectDate;
  String? filterSelectedEmployee;
  String? filterSelectedType;

  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  Future<void> getOccurrences(
      TimesheetOccurrenceTypeEnum? type, DateTime date, String? numCra) async {
    bloc.add(TimesheetOccurrenceLoadingEvent());

    String formatDate = setDate(date);
    selectDate = date;

    final result = await getGroupedOccurrence
        .call(GetGroupedOccurrenceParam(date: formatDate, type: setType()));

    result.fold(
      (err) => bloc.add(TimesheetOccurrenceFailedEvent()),
      (data) {
        occurrences = data;
        List<TimesheetOccurrenceEntity> occurrencesFilteredFromTimesheet = [];
        if (numCra != null) {
          occurrencesFilteredFromTimesheet =
              data.where((element) => element.numCra == numCra).toList();
          filterSelectedEmployee = capitalizeFirstLetter(
              data.firstWhere((element) => element.numCra == numCra).name);
          generateListCheckbox(occurrencesFilteredFromTimesheet);
          employeesNames = List.generate(
              data.length, (index) => capitalizeFirstLetter(data[index].name));
          employeesNames = employeesNames.toSet().toList();
          employeesNames.sort(((a, b) => a.compareTo(b)));
          bloc.add(TimesheetOccurrenceLoadedEvent(
            list: occurrencesFilteredFromTimesheet,
            employeeFiltered: filterSelectedEmployee,
          ));
        } else {
          generateListCheckbox(occurrences);
          employeesNames = List.generate(
              data.length, (index) => capitalizeFirstLetter(data[index].name));
          employeesNames = employeesNames.toSet().toList();
          employeesNames.sort(((a, b) => a.compareTo(b)));
          bloc.add(TimesheetOccurrenceLoadedEvent(
            list: occurrences,
          ));
        }
      },
    );
  }

  Future saveControlOccurrence({
    String? massActionValue,
  }) async {
    List<TimesheetOccurrenceRequestEntity> selecteds = [];
    selecteds = generateListForSave(massActionValue);

    bloc.add(TimesheetOccurrenceLoadingEvent());

    final result = await postControlOccurrence
        .call(PostControlOccurrenceParam(actions: selecteds));
    generateListCheckbox(occurrences);
    result.fold(
      (err) => bloc.add(
          TimesheetOccurrenceLoadedEvent(list: occurrences, saveFailed: true)),
      (data) {
        bloc.add(TimesheetOccurrenceLoadedEvent(
            list: occurrences, saveSuccess: true));
      },
    );
  }

  Future saveDefaultHour(
      String justify, List<TimesheetOccurrenceEntity> list) async {
    bloc.add(TimesheetOccurrenceLoadingEvent());
    List<TimesheetAddManualEntity> entitys = [];
    List<int> listCollaborators = [];
    List.generate(employesSelecteds.length, (index) {
      if (employesSelecteds[index]) {
        listCollaborators
            .add(employesSelecteds.indexOf(employesSelecteds[index]));
      }
    });
    List.generate(listCollaborators.length, (index) {
      entitys.add(TimesheetAddManualEntity(
        numCra: list[listCollaborators[index]].numCra,
        date: list[listCollaborators[index]].convertStringToDate(),
        justification: justify,
        type: TimesheetAddManualEnum.standard_schedule,
        single: false,
        marks: [],
      ));
    });

    final result = await postManualAppointment
        .call(PostManualAppointmentParam(entitys: entitys));
    result.fold(
      (err) => bloc.add(
          TimesheetOccurrenceLoadedEvent(list: occurrences, saveFailed: true)),
      (data) {
        generateListCheckbox(list);
        bloc.add(TimesheetOccurrenceLoadedEvent(list: list, saveSuccess: true));
      },
    );
  }

  Future filterList() async {
    List<TimesheetOccurrenceEntity> filtered = [];
    if (filterSelectDate != null) {
      if (!filterSelectDate!.isAtSameMomentAs(selectDate)) {
        bloc.add(TimesheetOccurrenceLoadingEvent());

        String formatDate = setDate(filterSelectDate!);
        selectDate = filterSelectDate!;

        final result = await getGroupedOccurrence
            .call(GetGroupedOccurrenceParam(date: formatDate, type: setType()));
        result.fold(
          (err) => bloc.add(TimesheetOccurrenceFailedEvent()),
          (data) {
            occurrences = data;
            employeesNames = List.generate(occurrences.length,
                (index) => capitalizeFirstLetter(occurrences[index].name));
            employeesNames = employeesNames.toSet().toList();
            employeesNames.sort(((a, b) => a.compareTo(b)));
            generateListCheckbox(occurrences);
          },
        );
      }
    }
    filterOcurrencesList = occurrences;
    if (filterSelectedType != null && filterSelectedEmployee != null) {
      List<TimesheetOccurrenceEntity> list = generateFiltredListFromType(
          filterSelectedType!, filterOcurrencesList);
      filtered = generateFiltredListFromName(filterSelectedEmployee!, list);
      generateListCheckbox(filtered);
      bloc.add(TimesheetOccurrenceLoadedEvent(
          list: filtered,
          employeeFiltered: filterSelectedEmployee,
          typeFiltered: filterSelectedType));
      return;
    } else if (filterSelectedType != null) {
      filtered = generateFiltredListFromType(
          filterSelectedType!, filterOcurrencesList);
      generateListCheckbox(filtered);
      bloc.add(TimesheetOccurrenceLoadedEvent(
          list: filtered, typeFiltered: filterSelectedType));
      return;
    } else if (filterSelectedEmployee != null) {
      filtered = generateFiltredListFromName(
          filterSelectedEmployee!, filterOcurrencesList);
      generateListCheckbox(filtered);
      bloc.add(TimesheetOccurrenceLoadedEvent(
          list: filtered, employeeFiltered: filterSelectedEmployee));
      return;
    } else {
      generateListCheckbox(filterOcurrencesList);
      bloc.add(TimesheetOccurrenceLoadedEvent(list: filterOcurrencesList));
      return;
    }
  }

  clearFilter() {
    generateListCheckbox(occurrences);
    bloc.add(TimesheetOccurrenceLoadedEvent(list: occurrences));
  }

  generateListCheckbox(List list) {
    employesSelecteds = List.generate(list.length, (index) => true);
    individualAction = List.generate(list.length, (index) => '');
  }

  setMonth(int month) {
    if (month < 10) {
      return "0$month";
    } else {
      return month.toString();
    }
  }

  setDay(int day) {
    if (day < 10) {
      return "0$day";
    } else {
      return day.toString();
    }
  }

  setDate(DateTime date) {
    return "${date.year}-${setMonth(date.month)}-${setDay(date.day)}";
  }

  String setType() {
    return "ATRASO,HORAEXTRA50,HORAEXTRA60,HORAEXTRA75,HORAEXTRA80,HORAEXTRA200,HORAEXTRA100,FALTA,FOLGA,ADICIONALNOTURNO,ATESTADO";
  }

  List<TimesheetOccurrenceRequestEntity> generateListForSave(
      String? massActionValue) {
    List<TimesheetOccurrenceRequestEntity> selecteds = [];
    if (massActionValue != null) {
      List<int> listCollaborators = [];
      List.generate(employesSelecteds.length, (index) {
        if (employesSelecteds[index]) {
          listCollaborators
              .add(employesSelecteds.indexOf(employesSelecteds[index]));
        }
        List.generate(listCollaborators.length, (index) {
          selecteds.add(TimesheetOccurrenceRequestEntity(
            date: occurrences[listCollaborators[index]].referenceDate,
            numCra: occurrences[listCollaborators[index]].numCra,
            tipoControleOcorrencia:
                massActionValue == 'Abonar' ? "ABONO" : "DESCONTO",
          ));
        });
      });
    } else {
      List<String> actionsSelecteds =
          individualAction.where((element) => element.isNotEmpty).toList();
      List<int> list = [];
      List.generate(actionsSelecteds.length, (index) {
        list.add(actionsSelecteds.indexOf(actionsSelecteds[index]));
      });
      List.generate(list.length, (index) {
        selecteds.add(TimesheetOccurrenceRequestEntity(
          date: occurrences[list[index]].referenceDate,
          numCra: occurrences[list[index]].numCra,
          tipoControleOcorrencia:
              actionsSelecteds[index] == 'Abonar' ? "ABONO" : "DESCONTO",
        ));
      });
    }
    return selecteds;
  }

  List<TimesheetOccurrenceEntity> generateFiltredListFromType(
      String type, List<TimesheetOccurrenceEntity> list) {
    List<TimesheetOccurrenceEntity> filtered = [];
    if (type == "Atraso") {
      filtered = list
          .where((element) =>
              element.occurrenceType.toUpperCase().contains("ATRASO"))
          .toList();
    } else if (type == "Folga") {
      filtered = list
          .where((element) =>
              element.occurrenceType.toUpperCase().contains("FOLGA"))
          .toList();
    } else if (type == "Falta sem justificativa") {
      filtered = list
          .where((element) =>
              element.occurrenceType.toUpperCase().contains("FALTA"))
          .toList();
    } else if (type == "Hora extra") {
      filtered = list
          .where((element) =>
              element.occurrenceType.toUpperCase().contains("HORAEXTRA") ||
              element.occurrenceType.toUpperCase().contains("ADICIONALNOTURNO"))
          .toList();
    }

    return filtered;
  }

  List<String> dropdownItems(String type) {
    return type.contains("Folga")
        ? ['Inserir horário padrão']
        : ["Abonar", "Descontar"];
  }

  List<TimesheetOccurrenceEntity> generateFiltredListFromName(
      String name, List<TimesheetOccurrenceEntity> list) {
    List<TimesheetOccurrenceEntity> filtered = [];
    filtered = list
        .where((element) =>
            element.name.toUpperCase().contains(name.toUpperCase()))
        .toList();
    return filtered;
  }

  capitalizeFirstLetter(String name) {
    String capitalizedString =
        name.trimRight().split(' ').map((word) => word.capitalize()).join(' ');
    return capitalizedString;
  }

  void dispose() {
    occurrences = [];
    employesSelecteds = [];
    individualAction = [];
    employeesNames = [];
  }
}
