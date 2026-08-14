import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';

class ComfortPartnerCoupon {
  String id;
  String code;
  String title;
  int discountPercentage;
  bool highlight;
  String description;
  String saleType;
  bool reusable;
  int useLimit;
  DateTime? dateInsertion;
  DateTime? dateRemoval;
  String imageHash;
  String? imageLink;
  String? partnerId;
  ComfortType? comfortType;
  String notificationParameter;

  ComfortPartnerCoupon({
    required this.id,
    required this.code,
    required this.title,
    required this.discountPercentage,
    required this.highlight,
    required this.description,
    required this.saleType,
    required this.dateInsertion,
    required this.dateRemoval,
    required this.imageHash,
    required this.reusable,
    required this.useLimit,
    required this.notificationParameter,
    this.imageLink,
    this.partnerId,
    this.comfortType,
  });

  String getComfortType(BuildContext context) {
    switch (comfortType) {
      case ComfortType.cleaning:
        return getString(context, "comfort_cleaning");
      case ComfortType.maintenance:
        return getString(context, "comfort_maintenance");
      case ComfortType.laundry:
        return getString(context, "comfort_laundry");
      default:
        return getString(context, "comfort_others");
    }
  }
}
