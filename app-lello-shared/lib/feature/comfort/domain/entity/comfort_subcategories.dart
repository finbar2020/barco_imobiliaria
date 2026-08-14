import 'package:essentials/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';

class ComfortSubcategories {
  ComfortType? comfortType;

  ComfortSubcategories({this.comfortType});

  static String enumToStringSubcategories(
      BuildContext context, ComfortType? comfortType) {
    switch (comfortType) {
      case ComfortType.all:
        return getString(context, "comfort_request_filter_subcategories_all");
      case ComfortType.cleaning:
        return getString(context, "comfort_cleaning");
      case ComfortType.maintenance:
        return getString(context, "comfort_maintenance");
      case ComfortType.laundry:
        return getString(context, "comfort_laundry");
      case ComfortType.gym:
        return getString(context, "comfort_gym");
      case ComfortType.market:
        return getString(context, "comfort_market");
      case ComfortType.hairdresser:
        return getString(context, "comfort_hairdresser");
      case ComfortType.marketplace:
        return getString(context, "comfort_marketplace");
      case ComfortType.e_commerce:
        return getString(context, "comfort_e-commerce");
      case ComfortType.sports:
        return getString(context, "comfort_sports");
      case ComfortType.children:
        return getString(context, "comfort_children");
      case ComfortType.leisure:
        return getString(context, "comfort_leisure");
      case ComfortType.mobility:
        return getString(context, "comfort_mobility");
      case ComfortType.business:
        return getString(context, "comfort_business");
      case ComfortType.health:
        return getString(context, "comfort_health");
      case ComfortType.services:
        return getString(context, "comfort_services");
      case ComfortType.winery:
        return getString(context, "comfort_winery");
      case ComfortType.smart_lockers:
        return getString(context, "comfort_smart_lockers");
      case ComfortType.beverages:
        return getString(context, "comfort_beverages");
      case ComfortType.electric_charger:
        return getString(context, "comfort_electric_charger");
      case ComfortType.selective_collection:
        return getString(context, "comfort_selective_collection");
      case ComfortType.vehicle_access_control:
        return getString(context, "comfort_vehicle_access_control");
      case ComfortType.community_garden:
        return getString(context, "comfort_community_garden");
      case ComfortType.sustainable_innovation:
        return getString(context, "comfort_sustainable_innovation");
      case ComfortType.community_laundry:
        return getString(context, "comfort_community_laundry");
      case ComfortType.chocolate_shop:
        return getString(context, "comfort_chocolate_shop");
      case ComfortType.digital_media_elevators:
        return getString(context, "comfort_digital_media_elevators");
      case ComfortType.mini_market:
        return getString(context, "comfort_mini_market");
      case ComfortType.architecture_project:
        return getString(context, "comfort_architecture_project");
      case ComfortType.renovation:
        return getString(context, "comfort_renovation");
      case ComfortType.insurance:
        return getString(context, "comfort_insurance");
      case ComfortType.licenses_and_certificates:
        return getString(context, "comfort_licenses_and_certificates");
      case ComfortType.pedestrian_access_control:
        return getString(context, "comfort_pedestrian_access_control");
      case ComfortType.educational:
        return getString(context, "comfort_educational");
      case ComfortType.playroom:
        return getString(context, "comfort_playroom");
      case ComfortType.solar_panels:
        return getString(context, "comfort_solar_panels");
      case ComfortType.automation:
        return getString(context, "comfort_automation");
      case ComfortType.pharmacy:
        return getString(context, "comfort_pharmacy");
      case ComfortType.wellness:
        return getString(context, "comfort_wellness");
      case ComfortType.decoration:
        return getString(context, "comfort_decoration");
      case ComfortType.biometrics:
        return getString(context, "comfort_biometrics");
      case ComfortType.energy:
        return getString(context, "comfort_energy");
      case ComfortType.connectivity:
        return getString(context, "comfort_connectivity");
      case ComfortType.security:
        return getString(context, "comfort_security");
      case ComfortType.beauty:
        return getString(context, "comfort_beauty");
      case ComfortType.longevity:
        return getString(context, "comfort_longevity");
      case ComfortType.finance:
        return getString(context, "comfort_finance");
      case ComfortType.travel:
        return getString(context, "comfort_travel");
      default:
        return getString(context, "comfort_others");
    }
  }

  static ComfortType stringToEnumSubcategories(
      BuildContext context, String? category) {
    if (category ==
        getString(context, "comfort_request_filter_subcategories_all")) {
      return ComfortType.all;
    } else if (category == getString(context, "comfort_cleaning")) {
      return ComfortType.cleaning;
    } else if (category == getString(context, "comfort_maintenance")) {
      return ComfortType.maintenance;
    } else if (category == getString(context, "comfort_laundry")) {
      return ComfortType.laundry;
    } else if (category == getString(context, "comfort_gym")) {
      return ComfortType.gym;
    } else if (category == getString(context, "comfort_market")) {
      return ComfortType.market;
    } else if (category == getString(context, "comfort_hairdresser")) {
      return ComfortType.hairdresser;
    } else if (category == getString(context, "comfort_marketplace")) {
      return ComfortType.marketplace;
    } else if (category == getString(context, "comfort_e-commerce")) {
      return ComfortType.e_commerce;
    } else if (category == getString(context, "comfort_sports")) {
      return ComfortType.sports;
    } else if (category == getString(context, "comfort_children")) {
      return ComfortType.children;
    } else if (category == getString(context, "comfort_leisure")) {
      return ComfortType.leisure;
    } else if (category == getString(context, "comfort_mobility")) {
      return ComfortType.mobility;
    } else if (category == getString(context, "comfort_business")) {
      return ComfortType.business;
    } else if (category == getString(context, "comfort_health")) {
      return ComfortType.health;
    } else if (category == getString(context, "comfort_services")) {
      return ComfortType.services;
    } else if (category == getString(context, "comfort_winery")) {
      return ComfortType.winery;
    } else if (category == getString(context, "comfort_smart_lockers")) {
      return ComfortType.smart_lockers;
    } else if (category == getString(context, "comfort_beverages")) {
      return ComfortType.beverages;
    } else if (category == getString(context, "comfort_electric_charger")) {
      return ComfortType.electric_charger;
    } else if (category == getString(context, "comfort_selective_collection")) {
      return ComfortType.selective_collection;
    } else if (category ==
        getString(context, "comfort_vehicle_access_control")) {
      return ComfortType.vehicle_access_control;
    } else if (category == getString(context, "comfort_community_garden")) {
      return ComfortType.community_garden;
    } else if (category ==
        getString(context, "comfort_sustainable_innovation")) {
      return ComfortType.sustainable_innovation;
    } else if (category == getString(context, "comfort_community_laundry")) {
      return ComfortType.community_laundry;
    } else if (category == getString(context, "comfort_chocolate_shop")) {
      return ComfortType.chocolate_shop;
    } else if (category ==
        getString(context, "comfort_digital_media_elevators")) {
      return ComfortType.digital_media_elevators;
    } else if (category == getString(context, "comfort_mini_market")) {
      return ComfortType.mini_market;
    } else if (category == getString(context, "comfort_architecture_project")) {
      return ComfortType.architecture_project;
    } else if (category == getString(context, "comfort_renovation")) {
      return ComfortType.renovation;
    } else if (category == getString(context, "comfort_insurance")) {
      return ComfortType.insurance;
    } else if (category ==
        getString(context, "comfort_licenses_and_certificates")) {
      return ComfortType.licenses_and_certificates;
    } else if (category ==
        getString(context, "comfort_pedestrian_access_control")) {
      return ComfortType.pedestrian_access_control;
    } else if (category == getString(context, "comfort_educational")) {
      return ComfortType.educational;
    } else if (category == getString(context, "comfort_playroom")) {
      return ComfortType.playroom;
    } else if (category == getString(context, "comfort_solar_panels")) {
      return ComfortType.solar_panels;
    } else if (category == getString(context, "comfort_automation")) {
      return ComfortType.automation;
    } else if (category == getString(context, "comfort_pharmacy")) {
      return ComfortType.pharmacy;
    } else if (category == getString(context, "comfort_wellness")) {
      return ComfortType.wellness;
    } else if (category == getString(context, "comfort_decoration")) {
      return ComfortType.decoration;
    } else if (category == getString(context, "comfort_biometrics")) {
      return ComfortType.biometrics;
    } else if (category == getString(context, "comfort_energy")) {
      return ComfortType.energy;
    } else if (category == getString(context, "comfort_connectivity")) {
      return ComfortType.connectivity;
    } else if (category == getString(context, "comfort_security")) {
      return ComfortType.security;
    } else if (category == getString(context, "comfort_beauty")) {
      return ComfortType.beauty;
    } else if (category == getString(context, "comfort_longevity")) {
      return ComfortType.longevity;
    } else if (category == getString(context, "comfort_finance")) {
      return ComfortType.finance;
    } else if (category == getString(context, "comfort_travel")) {
      return ComfortType.travel;
    } else {
      return ComfortType.others;
    }
  }
}
