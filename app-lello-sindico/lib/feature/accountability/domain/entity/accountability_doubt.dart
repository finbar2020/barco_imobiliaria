import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_answer.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_attachments.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_situation.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_question_type_solicitation.dart';

class AccountabilityDoubt {
  String? id;
  String message = "";
  DoubtSituation questionSituation = DoubtSituation.in_progress;
  List<Attachments> attachments = [];
  List<AccountabilityDoubtAnswer> answers = [];
  DateTime period;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  AccountabilityQuestionType? doubtType;
  List<AccountabilityGroupedAccaountEntrie> entiries = [];
  List<File> attachmentsFiles = [];

  bool noEnterieSelected = false;

  late String baseUrl;

  String get selectedTypeText => doubtType?.name ?? "";

  // static DoubtSituation situationFromString(String questionSituation) {
  //   switch (questionSituation) {
  //     case "InProgress":
  //       return DoubtSituation.in_progress;
  //     case "Reply":
  //       return DoubtSituation.;
  //     default:
  //       return DoubtSituation.InProgress;
  //   }
  // }

  // static String situationToString(DoubtSituation questionSituation) {
  //   switch (questionSituation) {
  //     case DoubtSituation.InProgress:
  //       return DoubtSituation.InProgress.toString().split('.').last;
  //     case DoubtSituation.Reply:
  //       return DoubtSituation.Reply.toString().split('.').last;
  //     default:
  //       return DoubtSituation.All.toString().split('.').last;
  //   }
  // }

  AccountabilityDoubt({
    required this.period,
  });

  Color get questionSituationColor {
    switch (questionSituation) {
      case DoubtSituation.in_approval:
        return const Color(0XFF3865A3);
      case DoubtSituation.in_progress:
        return const Color(0XFF3865A3);
      case DoubtSituation.delayed:
        return const Color(0X00ffcc00);
      case DoubtSituation.completed:
        return const Color(0XFF42B883);
      case DoubtSituation.completed_delay:
        return const Color(0XFF42B883);
      case DoubtSituation.canceled_user:
        return const Color(0XFFFF6600);
      case DoubtSituation.canceled_deadline:
        return const Color(0XFFFF6600);
      case DoubtSituation.reproved:
        return const Color(0XFFCB2640);
    }
  }

  String get questionSituationText {
    switch (questionSituation) {
      case DoubtSituation.in_approval:
        return "accountability_list_question_item_status_in_approval";
      case DoubtSituation.in_progress:
        return "accountability_list_question_item_status_in_progress";
      case DoubtSituation.delayed:
        return "accountability_list_question_item_status_delayed";
      case DoubtSituation.completed:
        return "accountability_list_question_item_status_completed";
      case DoubtSituation.completed_delay:
        return "accountability_list_question_item_status_completed_delay";
      case DoubtSituation.canceled_user:
        return "accountability_list_question_item_status_canceled_user";
      case DoubtSituation.canceled_deadline:
        return "accountability_list_question_item_status_canceled_deadline";
      case DoubtSituation.reproved:
        return "accountability_list_question_item_status_reproved";
    }
  }
}
