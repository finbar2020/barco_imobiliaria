import 'package:essentials/essentials.dart';
import 'package:flutter/cupertino.dart';

class ZeroPaperItemModel extends Equatable {
  final ZeroPaperPreferenceTypeEnum type;
  final ZeroPaperPreferenceChoiceEnum choice;

  ZeroPaperItemModel({
    required this.type,
    required this.choice,
  });

  @override
  List<Object> get props => [type, choice];

  ZeroPaperItemModel copyWith({
    ZeroPaperPreferenceTypeEnum? type,
    ZeroPaperPreferenceChoiceEnum? choice,
  }) {
    return ZeroPaperItemModel(
      type: type ?? this.type,
      choice: choice ?? this.choice,
    );
  }
}

enum ZeroPaperPreferenceTypeEnum {
  bankSlip,
  minutesAndNotices,
  statements,
  announcements,
}

extension ZeroPaperPreferenceTypeEnumExtension on ZeroPaperPreferenceTypeEnum {
  String getLabel(BuildContext context) {
    switch (this) {
      case ZeroPaperPreferenceTypeEnum.bankSlip:
        return getString(context, 'preferences_zero_paper_slips');
      case ZeroPaperPreferenceTypeEnum.minutesAndNotices:
        return getString(context, 'preferences_zero_paper_minutes');
      case ZeroPaperPreferenceTypeEnum.statements:
        return getString(context, 'preferences_zero_paper_statements');
      case ZeroPaperPreferenceTypeEnum.announcements:
        return getString(context, 'preferences_zero_paper_announcements');
    }
  }
}

enum ZeroPaperPreferenceChoiceEnum {
  email,
  printed,
  both,
}
