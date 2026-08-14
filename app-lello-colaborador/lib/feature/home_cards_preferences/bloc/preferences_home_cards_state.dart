import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';

abstract class PreferencesHomeCardsState {
  List<HomeItemEnum> cards;
  List<HomeItemEnum> favorites;
  PreferencesHomeCardsState({
    required this.cards,
    required this.favorites,
  });
}

class PreferencesHomeCardsLoadingState extends PreferencesHomeCardsState {
  PreferencesHomeCardsLoadingState() : super(cards: [], favorites: []);
}

class PreferencesHomeCardsLoadedState extends PreferencesHomeCardsState {
  final bool success;
  final bool showOnboarding;
  PreferencesHomeCardsLoadedState({
    required List<HomeItemEnum> cards,
    required List<HomeItemEnum> favorites,
    this.success = false,
    this.showOnboarding = false,
  }) : super(cards: cards, favorites: favorites);
}

class PreferencesHomeCardsFailedState extends PreferencesHomeCardsState {
  PreferencesHomeCardsFailedState() : super(cards: [], favorites: []);
}
