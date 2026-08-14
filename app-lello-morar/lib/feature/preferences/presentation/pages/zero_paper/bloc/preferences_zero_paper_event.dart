import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_entity.dart';

abstract class PreferencesZeroPaperEvent extends Equatable {
  const PreferencesZeroPaperEvent();

  @override
  List<Object?> get props => [];
}

class PreferencesZeroPaperLoadingEvent extends PreferencesZeroPaperEvent {
  const PreferencesZeroPaperLoadingEvent();
}

class PreferencesZeroPaperLoadedEvent extends PreferencesZeroPaperEvent {
  final PreferencesZeroPaperEntity preferences;
  final bool digitalAnnouncements;
  final bool printedAnnouncements;
  final bool digitalActs;
  final bool printedActs;
  final bool digitalSlips;
  final bool printedSlips;
  final bool digitalStatements;
  final bool printedStatements;

  const PreferencesZeroPaperLoadedEvent({
    required this.preferences,
    this.digitalAnnouncements = true,
    this.printedAnnouncements = false,
    this.digitalActs = true,
    this.printedActs = false,
    this.digitalSlips = true,
    this.printedSlips = false,
    this.digitalStatements = true,
    this.printedStatements = false,
  });

  @override
  List<Object?> get props => [
        preferences,
        digitalAnnouncements,
        printedAnnouncements,
        digitalActs,
        printedActs,
        digitalSlips,
        printedSlips,
        digitalStatements,
        printedStatements,
      ];
}

class PreferencesZeroPaperSuccessEvent extends PreferencesZeroPaperEvent {
  const PreferencesZeroPaperSuccessEvent();
}

class PreferencesZeroPaperFailureEvent extends PreferencesZeroPaperEvent {
  final String error;

  const PreferencesZeroPaperFailureEvent({required this.error});

  @override
  List<Object?> get props => [error];
}
