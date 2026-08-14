import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';

class ComfortMenuItems {
  ComfortPartnerCategory category;
  double order;

  ComfortMenuItems({required this.category, required this.order});

  String get title {
    switch (category) {
      case ComfortPartnerCategory.toYou:
        return "comfort_to_you";
      case ComfortPartnerCategory.toYourHome:
        return "comfort_to_your_home";
      case ComfortPartnerCategory.toYourPet:
        return "comfort_to_your_pet";
      case ComfortPartnerCategory.toYourVehicle:
        return "comfort_to_your_vehicle";
      case ComfortPartnerCategory.toYourCondo:
        return "comfort_to_your_condo";
      case ComfortPartnerCategory.toYourFamily:
        return "comfort_to_your_family";
      case ComfortPartnerCategory.others:
        return "comfort_others";
    }
  }

  String get svgPath {
    switch (category) {
      case ComfortPartnerCategory.toYou:
        return "assets/ic_comfort_to_you.svg";
      case ComfortPartnerCategory.toYourHome:
        return "assets/ic_comfort_to_your_home.svg";
      case ComfortPartnerCategory.toYourPet:
        return "assets/ic_comfort_to_your_pet.svg";
      case ComfortPartnerCategory.toYourVehicle:
        return "assets/ic_comfort_to_your_vehicle.svg";
      case ComfortPartnerCategory.toYourCondo:
        return "assets/ic_comfort_to_your_condo.svg";
      case ComfortPartnerCategory.toYourFamily:
        return "assets/ic_comfort_to_your_family.svg";
      case ComfortPartnerCategory.others:
        return "assets/ic_comfort_others.svg";
    }
  }
}
