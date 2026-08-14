import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_request_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_type_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_detail/get_occurrence_detail.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_vacation/get_occurrence_vacation.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_vacation_receipt/get_vacation_receipt.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_control_occurrence/post_control_occurrence.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_details_list/timesheet_details_list_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_details_list/timesheet_details_list_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class ListDetailsController {
  final SessionBloc sessionBloc;
  final GetOccurrenceDetail getOccurrenceDetail;
  final PostControlOccurrence postControlOccurrence;
  final GetOccurrenceVacation getOccurenceVacation;
  final GetVacationReceipt getVacationReceipt;
  final TimesheetDetailListsBloc bloc;
  final String baseUrl;

  ListDetailsController({
    required this.sessionBloc,
    required this.getOccurrenceDetail,
    required this.postControlOccurrence,
    required this.getOccurenceVacation,
    required this.getVacationReceipt,
    required this.bloc,
    required this.baseUrl,
  });

  final TextEditingController searchController = TextEditingController();
  List<TimesheetOccurrenceEntity> occurrences = [];
  List<TimesheetOccurrenceVacationEntity> vacations = [];
  List<bool> employesSelecteds = [];
  List<String> individualAction = [];

  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  Future<void> getDelayList(
      TimesheetOccurrenceTypeEnum type, DateTime date) async {
    bloc.add(DetailsListLoadingEvent());

    String formatDate = setDate(date);

    if (type == TimesheetOccurrenceTypeEnum.vacation) {
      final result = await getOccurenceVacation
          .call(GetOccurrenceVacationParam(date: formatDate));

      result.fold(
        (err) => bloc.add(DetailsListFailedEvent()),
        (data) {
          vacations = data;
          bloc.add(VacationsListLoadedEvent(list: data));
        },
      );
    } else {
      final result = await getOccurrenceDetail.call(
          GetOccurrenceDetailParam(date: formatDate, type: setType(type)));

      result.fold(
        (err) => bloc.add(DetailsListFailedEvent()),
        (data) {
          occurrences = data;
          employesSelecteds = List.generate(data.length, (index) => true);
          individualAction = List.generate(data.length, (index) => '');

          bloc.add(DetailsListLoadedEvent(list: occurrences));
        },
      );
    }
  }

  Future saveControlOccurrence({
    String? massActionValue,
  }) async {
    List<TimesheetOccurrenceRequestEntity> selecteds = [];
    selecteds = generateShortlist(massActionValue);

    bloc.add(DetailsListLoadingEvent());

    final result = await postControlOccurrence
        .call(PostControlOccurrenceParam(actions: selecteds));

    result.fold(
      (err) =>
          bloc.add(DetailsListLoadedEvent(list: occurrences, saveFailed: true)),
      (data) {
        bloc.add(DetailsListLoadedEvent(list: occurrences, saveSuccess: true));
      },
    );
  }

  Future getVacationDetailReceipt(String archiveName) async {
    bloc.add(DetailsListLoadingEvent());
    var customHeader = authenticationStore.getCustomHeader();

    try {
      File getFile = await DefaultCacheManager().getSingleFile(
        "$baseUrl/timesheet/occurrence/vacation/receipt/$archiveName",
        headers: customHeader,
      );
      bloc.add(VacationsListLoadedEvent(
          list: vacations, pdf: getFile, filename: archiveName));
    } catch (e) {
      bloc.add(
          VacationsListLoadedEvent(list: vacations, getArchiveFailed: true));
    }
  }

  searchCollaborator(TimesheetOccurrenceTypeEnum type) {
    var vacation = type == TimesheetOccurrenceTypeEnum.vacation;
    if (searchController.text.isEmpty) {
      if (vacation) {
        bloc.add(VacationsListLoadedEvent(list: vacations));
        return;
      } else {
        bloc.add(DetailsListLoadedEvent(list: occurrences));
        return;
      }
    }
    if (vacation) {
      var vacationList = vacations
          .where((element) => element.name
              .toUpperCase()
              .contains(searchController.text.toUpperCase()))
          .toList();
      bloc.add(VacationsListLoadedEvent(list: vacationList));
    } else {
      var searchList = occurrences
          .where((element) => element.name
              .toUpperCase()
              .contains(searchController.text.toUpperCase()))
          .toList();
      bloc.add(DetailsListLoadedEvent(list: searchList));
    }
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

  String setType(TimesheetOccurrenceTypeEnum tipo) {
    switch (tipo) {
      case TimesheetOccurrenceTypeEnum.delay:
        return "ATRASO";
      case TimesheetOccurrenceTypeEnum.fouls:
        return "FALTA";
      case TimesheetOccurrenceTypeEnum.extraHour:
        return "HORAEXTRA50,HORAEXTRA60,HORAEXTRA75,HORAEXTRA80,HORAEXTRA100,HORAEXTRA200";
      case TimesheetOccurrenceTypeEnum.vacation:
        return "FERIAS";
    }
  }

  List<TimesheetOccurrenceRequestEntity> generateShortlist(
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

  void dispose() {
    searchController.clear();
    occurrences = [];
    vacations = [];
    employesSelecteds = [];
    individualAction = [];
  }
}
