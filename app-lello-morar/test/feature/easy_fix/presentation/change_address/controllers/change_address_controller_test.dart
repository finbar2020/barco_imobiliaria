import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
import 'package:morar/feature/easy_fix/domain/entity/city_entity.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';

import 'package:morar/feature/easy_fix/domain/use_case/get_cities_usecase.dart';
import 'package:morar/feature/easy_fix/domain/use_case/get_easy_fix_unit_usecase.dart';
import 'package:morar/feature/easy_fix/domain/use_case/update_address_usecase.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_bloc.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_state.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/controllers/change_address_controller.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class GetCitiesUsecaseMock extends Mock implements GetCitiesUsecase {}

class GetEasyFixUnitUsecaseMock extends Mock implements GetEasyFixUnitUsecase {}

class UpdateAddressUsecaseMock extends Mock implements UpdateAddressUsecase {}

class SessionBlocMock extends Mock implements SessionBloc {}

void main() {
  late ChangeAddressBloc bloc;
  late SessionBloc sessionBloc;
  late ChangeAddressController controller;
  late GetCitiesUsecase getCitiesUsecase;
  late GetEasyFixUnitUsecase getEasyFixUnitUsecase;
  late UpdateAddressUsecase updateAddressUsecase;

  setUpAll(() {
    registerFallbackValue(GetEasyFixUnitParam(condominiumId: ""));
    registerFallbackValue(GetCitiesParams(condominiumId: "", uf: ""));
    registerFallbackValue(
        UpdateAddressParams(condominiumId: "", unit: EasyFixUnit.filled()));
  });

  setUp(() {
    bloc = ChangeAddressBloc();
    sessionBloc = SessionBlocMock();
    getCitiesUsecase = GetCitiesUsecaseMock();
    getEasyFixUnitUsecase = GetEasyFixUnitUsecaseMock();

    updateAddressUsecase = UpdateAddressUsecaseMock();
    controller = ChangeAddressController(
      getCitiesUsecase: getCitiesUsecase,
      getEasyFixUnitUsecase: getEasyFixUnitUsecase,
      updateAddressUsecase: updateAddressUsecase,
      bloc: bloc,
      sessionBloc: sessionBloc,
    );
  });
  group(
    "Get Easy Fix Unit |",
    () {
      test(
        "should get easy fix unit",
        () async {
          when(
            () => getEasyFixUnitUsecase(any()),
          ).thenAnswer(
            (_) async => Success(EasyFixUnit.filled()),
          );

          expect(
              bloc.stream,
              emitsInOrder([
                isA<ChangeAddressLoadingState>(),
                isA<ChangeAddressLoadedState>()
              ]));

          final result = await controller.getEasyFixUnit(condominiumId: "");

          expect(result, EasyFixUnit.filled());
        },
      );

      test(
        "should return a failure",
        () async {
          when(
            () => getEasyFixUnitUsecase(any()),
          ).thenAnswer(
            (_) async => Rejection(UnknownFailure("")),
          );

          expect(
              bloc.stream,
              emitsInOrder([
                isA<ChangeAddressLoadingState>(),
                isA<ChangeAddressFailureState>()
              ]));

          final result = await controller.getEasyFixUnit(condominiumId: "");

          expect(result, null);
        },
      );
    },
  );

  group(
    "Get Cities |",
    () {
      final list = [City(ibgeCode: 0000, name: "TestCity")];
      test(
        "should get cities list",
        () async {
          when(
            () => getCitiesUsecase(any()),
          ).thenAnswer(
            (_) async => Success(list),
          );

          final result = await controller.getCities(condominiumId: "", uf: "");

          expect(result, list);
        },
      );

      test(
        "should return a empty list",
        () async {
          when(
            () => getCitiesUsecase(any()),
          ).thenAnswer(
            (_) async => Rejection(UnknownFailure("")),
          );

          final result = await controller.getCities(condominiumId: "", uf: "");

          expect(result, []);
        },
      );
    },
  );

  group(
    "Update Address |",
    () {
      test(
        "should update the address",
        () async {
          when(
            () => updateAddressUsecase(any()),
          ).thenAnswer(
            (_) async => Success(voidRight),
          );

          expect(
              bloc.stream,
              emitsInOrder([
                isA<ChangeAddressLoadingState>(),
                isA<ChangeAddressSuccessState>()
              ]));

          await controller.updateAddress(
            condominiumId: "",
            unit: EasyFixUnit.filled(),
          );
        },
      );

      test(
        "should return a failure",
        () async {
          when(
            () => updateAddressUsecase(any()),
          ).thenAnswer(
            (_) async => Rejection(UnknownFailure("")),
          );

          expect(
              bloc.stream,
              emitsInOrder([
                isA<ChangeAddressLoadingState>(),
                isA<ChangeAddressFailureState>()
              ]));

          await controller.updateAddress(
            condominiumId: "",
            unit: EasyFixUnit.filled(),
          );
        },
      );
    },
  );
  test(
    "should return formatted phone",
    () {
      final phone = controller.phoneFormatted("62998222044");
      expect(phone, "(62) 99822-2044");
    },
  );
}
