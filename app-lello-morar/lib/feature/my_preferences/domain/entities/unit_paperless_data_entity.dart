
import 'package:essentials/essentials.dart';

class UnitPaperlessDataEntity {
  final bool printedSlips;
  final bool emailSlips;
  final bool printedStatements;
  final bool emailStatements;
  final bool printedMinutes;
  final bool emailMinutes;
  final bool printedAnnouncements;
  final bool emailAnnouncements;

  UnitPaperlessDataEntity({
    required this.printedSlips,
    required this.emailSlips,
    required this.printedStatements,
    required this.emailStatements,
    required this.printedMinutes,
    required this.emailMinutes,
    required this.printedAnnouncements,
    required this.emailAnnouncements,
  });

  UnitPaperlessDataEntity copyWith({
    bool? printedSlips,
    bool? emailSlips,
    bool? printedStatements,
    bool? emailStatements,
    bool? printedMinutes,
    bool? emailMinutes,
    bool? printedAnnouncements,
    bool? emailAnnouncements,
  }) =>
      UnitPaperlessDataEntity(
        printedSlips: printedSlips ?? this.printedSlips,
        emailSlips: emailSlips ?? this.emailSlips,
        printedStatements: printedStatements ?? this.printedStatements,
        emailStatements: emailStatements ?? this.emailStatements,
        printedMinutes: printedMinutes ?? this.printedMinutes,
        emailMinutes: emailMinutes ?? this.emailMinutes,
        printedAnnouncements: printedAnnouncements ?? this.printedAnnouncements,
        emailAnnouncements: emailAnnouncements ?? this.emailAnnouncements,
      );

  factory UnitPaperlessDataEntity.fromJson(Map<String, dynamic> json) {
    return UnitPaperlessDataEntity(
      printedSlips: json['boletosImpressos'],
      emailSlips: json['boletosEmail'],
      printedStatements: json['demonstrativosImpresso'],
      emailStatements: json['demonstrativosEmail'],
      printedMinutes: json['atasEditaisImpresso'],
      emailMinutes: json['atasEditaisEmail'],
      printedAnnouncements: json['comunicadosImpressos'],
      emailAnnouncements: json['comunicadosEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boletosImpressos': printedSlips,
      'boletosEmail': emailSlips,
      'demonstrativosImpresso': printedStatements,
      'demonstrativosEmail': emailStatements,
      'atasEditaisImpresso': printedMinutes,
      'atasEditaisEmail': emailMinutes,
      'comunicadosImpressos': printedAnnouncements,
      'comunicadosEmail': emailAnnouncements,
    };
  }
}
