import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_details.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';

class ComfortPartnerIntro {
  String id;
  String title;
  String? partnerImageLink;
  ComfortPartnerDetails? partnerDetails;
  bool favorite;
  ComfortType comfortType;

  ComfortPartnerIntro({
    required this.id,
    required this.title,
    required this.comfortType,
    required this.partnerDetails,
    required this.favorite,
    this.partnerImageLink,
  });

  String getComfortType(BuildContext context) {
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
}
