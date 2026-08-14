import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_entity.dart';

abstract class PreferencesZeroPaperState extends Equatable {
  const PreferencesZeroPaperState();

  @override
  List<Object?> get props => [];
}

class PreferencesZeroPaperInitialState extends PreferencesZeroPaperState {
  const PreferencesZeroPaperInitialState();
}

class PreferencesZeroPaperLoadingState extends PreferencesZeroPaperState {
  const PreferencesZeroPaperLoadingState();
}

class PreferencesZeroPaperLoadedState extends PreferencesZeroPaperState {
  final PreferencesZeroPaperEntity preferences;
  bool digitalAnnouncements;
  bool printedAnnouncements;
  bool digitalActs;
  bool printedActs;
  bool digitalSlips;
  bool printedSlips;
  bool digitalStatements;
  bool printedStatements;

  PreferencesZeroPaperLoadedState({
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

class PreferencesZeroPaperSuccessState extends PreferencesZeroPaperState {
  const PreferencesZeroPaperSuccessState();
}

class PreferencesZeroPaperFailureState extends PreferencesZeroPaperState {
  final String error;

  const PreferencesZeroPaperFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
