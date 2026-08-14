import 'dart:io';

import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/get_cities/get_cities_units.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/register_employee_referral/employee_referral.dart';
import 'package:colaborador/feature/employee_referral/presentation/bloc/employee_referral_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'employee_referral_bloc_event.dart';

class EmployeeReferralBloc
    extends Bloc<EmployeeReferralEvent, EmployeeReferralState> {
  final RegisterEmployeeReferralUsecase registerEmployeeReferralcase;
  final GetCitiesUsecase getCitiesUsecase;
  final SessionBloc sessionBloc;

  List<CityEntity> cities = [];

  EmployeeReferralBloc({
    required this.registerEmployeeReferralcase,
    required this.sessionBloc,
    required this.getCitiesUsecase,
  }) : super(const EmployeeReferralInitialState()) {
    on<RegisterEmployeeReferralEvent>(_registerEmployeeReferral);
    on<GetCitiesEvent>(_mapGetCities);
    getCities();
  }

  Future<void> _registerEmployeeReferral(
    RegisterEmployeeReferralEvent event,
    Emitter<EmployeeReferralState> emit,
  ) async {
    emit(const EmployeeReferralRegisterLoadingState());

    String condoId = sessionBloc.getSession?.condominium.id ?? "";
    String employeeId = sessionBloc.getSession?.userId ?? "";

    final result =
        await registerEmployeeReferralcase.call(RegisterEmployeeReferralParam(
      condoId: condoId,
      employeeReferralEntity: event.employeeReferralEntity,
      employeeId: employeeId,
    ));

    EmployeeReferralState response = result.fold((error) {
      return const EmployeeReferralRegisterFailedState();
    }, (s3) {
      EmployeeAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsEmployee.indicaVagaEventoFinalizado(),
        referenceValue:
            sessionBloc.getSession?.condominium.reference.toString() ?? "",
        otherParameters: {
          "cidade": event.employeeReferralEntity.city ?? "",
          "regiao": event.employeeReferralEntity.region ?? "",
          "vaga": event.employeeReferralEntity.description ?? ""
        },
      );
      return const EmployeeReferralRegisterLoadedState();
    });

    emit(response);
  }

  Future<void> _mapGetCities(
    GetCitiesEvent event,
    Emitter<EmployeeReferralState> emit,
  ) async {
    emit(const GetCitiesLoadingState());
    String condoId = sessionBloc.getSession?.condominium.id ?? "";
    String employeeId = sessionBloc.getSession?.userId ?? "";

    final result = await getCitiesUsecase.call(
      GetCitiesParam(
        condoId: condoId,
        employeeId: employeeId,
      ),
    );

    EmployeeReferralState response = result.fold(
      (err) {
        return GetCitiesFailedState(
          errorDescription: err.error ?? "",
          errorCode: err.code.toString(),
        );
      },
      (res) {
        cities = res;
        return const GetCitiesLoadedState();
      },
    );

    emit(response);
  }

  void registerEmployeeReferral({
    required String description,
    required String city,
    required File file,
    String? region,
    String? fileTempHash,
  }) {
    add(
      RegisterEmployeeReferralEvent(
        employeeReferralEntity: EmployeeReferralEntity(
            description: description, city: city, file: file, region: region),
      ),
    );
  }

  void getCities() {
    add(
      const GetCitiesEvent(),
    );
  }
}
