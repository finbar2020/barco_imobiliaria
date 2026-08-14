import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';

abstract class PreferencesHomeCardsEvent {
  List<HomeItemEnum> cards;
  List<HomeItemEnum> favorites;
  PreferencesHomeCardsEvent({
    required this.cards,
    required this.favorites,
  });
}

class PreferencesHomeCardsLoadingEvent extends PreferencesHomeCardsEvent {
  PreferencesHomeCardsLoadingEvent() : super(cards: [], favorites: []);
}

class PreferencesHomeCardsLoadedEvent extends PreferencesHomeCardsEvent {
  final bool success;
  final bool showOnboarding;
  PreferencesHomeCardsLoadedEvent({
    required List<HomeItemEnum> cards,
    required List<HomeItemEnum> favorites,
    this.showOnboarding = false,
    this.success = false,
  }) : super(cards: cards, favorites: favorites);
}

class PreferencesHomeCardsFailedEvent extends PreferencesHomeCardsEvent {
  PreferencesHomeCardsFailedEvent() : super(cards: [], favorites: []);
}
