import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_certificate/get_occurrence_certificate.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_certificate/timesheet_certificate_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_certificate/timesheet_certificate_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class TimesheetCertificateController {
  final SessionBloc sessionBloc;
  final GetOccurrenceCertificate getOccurrenceCertificate;
  final TimesheetCertificateBloc bloc;
  final String baseUrl;

  TimesheetCertificateController({
    required this.sessionBloc,
    required this.getOccurrenceCertificate,
    required this.bloc,
    required this.baseUrl,
  });

  final TextEditingController searchController = TextEditingController();
  List<TimesheetOccurrenceCertificateEntity> certificates = [];

  DateTime date = DateTime.now();

  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  Future<void> getCertificates(DateTime date) async {
    bloc.add(TimesheetCertificateLoadingEvent());

    String formatDate = setDate(date);

    final result = await getOccurrenceCertificate
        .call(GetOccurrenceCertificateParam(date: formatDate));

    result.fold(
      (err) => bloc.add(TimesheetCertificateFailedEvent()),
      (data) {
        certificates = data;
        bloc.add(TimesheetCertificateLoadedEvent(list: data));
      },
    );
  }

  Future getCertificateArchive(String archiveName) async {
    bloc.add(TimesheetCertificateLoadingEvent());
    var customHeader = authenticationStore.getCustomHeader();

    try {
      File getFile = await DefaultCacheManager().getSingleFile(
        "$baseUrl/timesheet/occurrence/certificate/$archiveName",
        headers: customHeader,
      );
      bloc.add(TimesheetCertificateLoadedEvent(
          list: certificates, pdf: getFile, filename: archiveName));
    } catch (e) {
      bloc.add(TimesheetCertificateLoadedEvent(
          list: certificates, getArchiveFailed: true));
    }
  }

  searchCollaborator() {
    if (searchController.text.isEmpty) {
      bloc.add(TimesheetCertificateLoadedEvent(list: certificates));
      return;
    }
    var searchList = certificates
        .where((element) => element.name
            .toUpperCase()
            .contains(searchController.text.toUpperCase()))
        .toList();
    bloc.add(TimesheetCertificateLoadedEvent(list: searchList));
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

  void dispose() {
    searchController.clear();
    certificates = [];
  }
}
