import 'package:essentials/essentials.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_intro.dart';

class ComfortPartner {
  String id;
  ComfortPartnerIntro partnerIntro;
  String targetPublic;
  String imageHash;
  String clobContent;
  String email;
  String instagram;
  String instagramLink;
  String site;
  ComfortCTA cta;
  ComfortPartnerCategory category;
  int biggestDiscountPercentage;
  String redirect;
  double rating;
  int ratingsNumber;
  double categoryOrder;
  double partnerOrder;
  String notificationParameter;

  ComfortPartner({
    required this.id,
    required this.partnerIntro,
    required this.targetPublic,
    required this.imageHash,
    required this.clobContent,
    required this.category,
    required this.biggestDiscountPercentage,
    required this.redirect,
    required this.rating,
    required this.ratingsNumber,
    required this.categoryOrder,
    required this.partnerOrder,
    required this.notificationParameter,
    required this.email,
    required this.instagram,
    required this.instagramLink,
    required this.site,
    required this.cta,
  });

  String get ratingFormatted => rating.toStringAsFixed(1);

  String get siteFormatted {
    if (site.contains("www")) {
      String format = site.split("www")[1];
      return "www$format";
    }
    return site;
  }

  String get emailUrl => "mailto:$email";

  String getPartnerSubtitle(BuildContext context) {
    String discount = "";
    if (biggestDiscountPercentage != 0) {
      discount = (getString(context, "comfort_discount_of_up"))
          .replaceAll("###", "$biggestDiscountPercentage");
    }

    String comfortType = partnerIntro.getComfortType(context);
    return discount.isNotEmpty ? "$comfortType\n$discount" : "$comfortType";
  }
}
