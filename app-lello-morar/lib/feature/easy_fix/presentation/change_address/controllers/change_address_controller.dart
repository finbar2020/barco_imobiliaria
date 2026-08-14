// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/feature/easy_fix/domain/entity/city_entity.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';
import 'package:morar/feature/easy_fix/domain/use_case/get_easy_fix_unit_usecase.dart';
import 'package:morar/feature/easy_fix/domain/use_case/update_address_usecase.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_bloc.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_event.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

import '../../../../session/domain/entity/session.dart';
import '../../../domain/use_case/get_cities_usecase.dart';

class ChangeAddressController {
  final GetCitiesUsecase getCitiesUsecase;
  final GetEasyFixUnitUsecase getEasyFixUnitUsecase;
  final UpdateAddressUsecase updateAddressUsecase;
  final ChangeAddressBloc bloc;
  final SessionBloc sessionBloc;

  ChangeAddressController({
    required this.getCitiesUsecase,
    required this.getEasyFixUnitUsecase,
    required this.updateAddressUsecase,
    required this.bloc,
    required this.sessionBloc,
  });

  EasyFixUnit? unit;
  List<City> cities = [];
  List<String> states = [];

  // [TextControllers]
  TextEditingController addressController = TextEditingController(text: "");
  TextEditingController addressNumberController =
      TextEditingController(text: "");
  TextEditingController addressComplementController =
      TextEditingController(text: "");
  TextEditingController addressNeighborhoodController =
      TextEditingController(text: "");
  TextEditingController addressStateController =
      TextEditingController(text: "");

  // [Form Fields]
  String email = "";
  String cellphone = "";
  String phone = "";
  String cep = "";

  City? addressCity;

  void init() async {
    states = await getStates();
    getEasyFixUnit(condominiumId: session.condominium!.id!);
  }

  Future<EasyFixUnit?> getEasyFixUnit({required String condominiumId}) async {
    bloc.add(ChangeAddressLoadingEvent());
    final result = await getEasyFixUnitUsecase(
      GetEasyFixUnitParam(condominiumId: condominiumId),
    );
    return result.fold(
      (failure) {
        bloc.add(ChangeAddressFailureEvent(failure: failure));
        return null;
      },
      (unit) async {
        this.unit = unit;
        setFields(unit);
        if (unit.addressState != null) {
          cities = await getCities(
              condominiumId: condominiumId, uf: unit.addressState!);
        }
        bloc.add(ChangeAddressLoadedEvent(unit: unit));
        return unit;
      },
    );
  }

  Future<void> getAddressByCep({required String cep}) async {
    final viaCepSearchCep = ViaCepSearchCep();
    final infoCepJSON = await viaCepSearchCep.searchInfoByCep(
      cep: cep.replaceAll(RegExp('[^0-9]'), ''),
    );
    return infoCepJSON.fold((l) => l, (cep) async {
      addressController.text = cep.logradouro ?? "";
      addressNumberController.text = "";
      addressComplementController.text = cep.complemento ?? "";
      addressNeighborhoodController.text = cep.bairro ?? "";
      addressStateController.text = cep.uf ?? "";
      cities = await getCities(
        condominiumId: session.condominium!.id!,
        uf: cep.uf!,
      );
      addressCity = cities.singleWhere(
        (element) =>
            element.name ==
            removeDiacritics(cep.localidade?.toUpperCase() ?? ""),
      );
    });
  }

  Future<void> updateAddress({
    required String condominiumId,
    required EasyFixUnit unit,
  }) async {
    bloc.add(ChangeAddressLoadingEvent());
    final result = await updateAddressUsecase(
      UpdateAddressParams(condominiumId: condominiumId, unit: unit),
    );
    result.fold(
      (failure) {
        bloc.add(ChangeAddressFailureEvent(failure: failure));
      },
      (success) {
        bloc.add(ChangeAddressSuccessEvent());
      },
    );
  }

  Future<List<City>> getCities({
    required String condominiumId,
    required String uf,
  }) async {
    final result = await getCitiesUsecase(
      GetCitiesParams(condominiumId: condominiumId, uf: uf),
    );
    return result.fold(
      (failure) {
        return [];
      },
      (cities) {
        return cities;
      },
    );
  }

  void setFields(EasyFixUnit unit) {
    email = unit.email;
    cellphone = unit.cellphone;
    phone = unit.phone;
    cep = unit.cep;
    addressController.text = unit.address;
    addressNumberController.text = unit.addressNumber;
    addressComplementController.text = unit.addressComplement ?? "";
    addressNeighborhoodController.text = unit.addressNeighborhood;
    addressStateController.text = unit.addressState ?? "";
    addressCity = unit.addressCity;
  }

  EasyFixUnit get updatedUnit {
    return EasyFixUnit(
      name: unit!.name,
      cpfCnpj: unit!.cpfCnpj,
      email: email,
      cellphone: cellphone.replaceAll(RegExp('[^0-9]'), ''),
      phone: phone,
      cep: cep,
      address: addressController.text,
      addressNumber: addressNumberController.text,
      addressComplement: addressComplementController.text,
      addressNeighborhood: addressNeighborhoodController.text,
      addressState: addressStateController.text,
      addressCity: addressCity,
    );
  }

  String? phoneFormatted(String phone) {
    if (phone.isNotEmpty) {
      final ddd = phone.substring(0, 2);
      final first = phone.substring(2, 7);
      final second = phone.substring(7);
      return "($ddd) $first-$second";
    }
    return null;
  }

  Future<List<String>> getStates() async {
    final String response =
        await rootBundle.loadString('assets/brazil_states.json');
    final data = await json.decode(response);
    return List.from(data.map((e) => e['sigla']));
  }

  Session get session => sessionBloc.state.session!;
}
