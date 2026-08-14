import 'package:essentials/essentials.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';

abstract class PreferencesHomeCardsEvent extends Equatable {
  final List<HomeItemEnum> cards;
  final List<HomeItemEnum> favorites;

  const PreferencesHomeCardsEvent({
    required this.cards,
    required this.favorites,
  });

  @override
  List<Object?> get props => [cards, favorites];
}

class PreferencesHomeCardsLoadingEvent extends PreferencesHomeCardsEvent {
  const PreferencesHomeCardsLoadingEvent()
      : super(cards: const [], favorites: const []);
}

class PreferencesHomeCardsLoadedEvent extends PreferencesHomeCardsEvent {
  final bool success;
  final bool showOnboarding;

  const PreferencesHomeCardsLoadedEvent({
    required List<HomeItemEnum> cards,
    required List<HomeItemEnum> favorites,
    this.showOnboarding = false,
    this.success = false,
  }) : super(cards: cards, favorites: favorites);

  @override
  List<Object?> get props => [cards, favorites, showOnboarding, success];
}

class PreferencesHomeCardsFailedEvent extends PreferencesHomeCardsEvent {
  const PreferencesHomeCardsFailedEvent()
      : super(cards: const [], favorites: const []);
}
