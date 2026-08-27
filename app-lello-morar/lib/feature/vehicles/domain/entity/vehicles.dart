// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morar/feature/vehicles/domain/entity/concierge_creator.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicle_color_enum.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles_type_enum.dart';

import 'package:essentials/essentials.dart';

class Vehicle {
  final String? id;
  final String? type;
  final String? model;
  final String? color;
  final String? unitId;
  final String? identificationNumber;
  final bool? rentedSpace;
  final String? additionalInfo;
  final ConciergeCreator? creator;

  Vehicle({
    this.id,
    this.type,
    this.model,
    this.color,
    this.unitId,
    this.identificationNumber,
    this.rentedSpace,
    this.additionalInfo,
    this.creator,
  });

  String? get isNotValid {
    //Return null if is valid vehicle.
    //If vehicle is not valid, return justification key
    if (type == null) {
      return ("me_vehicles_fill_vehicle_type");
    }
    if ((type!.toUpperCase() == "MOTO" || type!.toUpperCase() == "CARRO") &&
        identificationNumber == null) {
      return ("me_vehicles_fill_vehicle_plate");
    }
    if (color == null) {
      return ("me_vehicles_fill_vehicle_color");
    }
    return null;
  }

  String? setType(BuildContext context, String? value) {
    if (value == getString(context, "me_vehicles_motorcycle")) {
      return toBeginningOfSentenceCase(enumToString(VehiclesType.moto));
    } else if (value == getString(context, "me_vehicles_car")) {
      return toBeginningOfSentenceCase(enumToString(VehiclesType.carro));
    } else if (value?.toUpperCase() ==
        getString(context, "me_vehicles_bike").toUpperCase()) {
      return toBeginningOfSentenceCase(enumToString(VehiclesType.bicicleta));
    } else {
      return value;
    }
  }

  String? getCor(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return getString(context, "accountability_others");
    }

    final String corEmMinusculo = value.toLowerCase();

    switch (corEmMinusculo) {
      case 'azul':
        return getString(context, "blue");
      case 'marrom':
        return getString(context, "brown");
      case 'verde':
        return getString(context, "green");
      case 'vermelho':
        return getString(context, "red");
      case 'branco':
        return getString(context, "white");
      case 'amarelo':
        return getString(context, "yellow");
      case 'prata':
        return getString(context, "silver");
      case 'preto':
        return getString(context, "black");
      case 'cinza':
        return getString(context, "gray");
      default:
        return getString(context, "accountability_others");
    }
  }

  String? setTypeCor(BuildContext context, String? value) {
    if (value == null) return null;
    
    final Map<String, ColorType> mapaDeCores = {
      getString(context, "blue"):    ColorType.azul,
      getString(context, "brown"):   ColorType.marrom,
      getString(context, "green"):   ColorType.verde,
      getString(context, "red"):     ColorType.vermelho,
      getString(context, "white"):   ColorType.branco,
      getString(context, "yellow"):  ColorType.amarelo,
      getString(context, "silver"):  ColorType.prata,
      getString(context, "black"):   ColorType.preto,
      getString(context, "gray"):    ColorType.cinza,
    };

    final typeCor = mapaDeCores[value] ?? ColorType.outros;

    return toBeginningOfSentenceCase(enumToString(typeCor));
  }

  String descriptionText(
    BuildContext context,
  ) {
    switch (creator?.type) {
      case ConciergeCreatorType.appmorar:
        return "${getString(context, "creator_vehicle")} ${creator?.name ?? ""}";
      case ConciergeCreatorType.appsindico:
        return getString(context, "creator_vehicle_sindico");
      case ConciergeCreatorType.portaria:
        return getString(context, "creator_vehicle_concierge");
      default:
        return getString(context, "creator_vehicle_concierge");
    }
  }

  String setSvgIcon() {
    switch (type) {
      case "MOTO":
        return 'assets/moto_icon.svg';
      case "CARRO":
        return 'assets/vehicles_icon.svg';
      case "BICICLETA":
        return 'assets/ic_bicicleta.svg';
      default:
        return 'assets/vehicles_icon.svg';
    }
  }

  bool showPlateInfo() {
    if (type!.toUpperCase() == "BICICLETA") {
      return false;
    } else {
      return true;
    }
  }

  Vehicle copyWith({
    String? id,
    String? type,
    String? model,
    String? color,
    String? unitId,
    String? identificationNumber,
    bool? rentedSpace,
    String? additionalInfo,
    ConciergeCreator? creator,
  }) {
    return Vehicle(
      id: id ?? this.id,
      type: type ?? this.type,
      model: model ?? this.model,
      color: color ?? this.color,
      unitId: unitId ?? this.unitId,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      rentedSpace: rentedSpace ?? this.rentedSpace,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      creator: creator ?? this.creator,
    );
  }
}
