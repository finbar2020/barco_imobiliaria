import 'package:essentials/essentials.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';

abstract class PreferencesHomeCardsState extends Equatable {
  final List<HomeItemEnum> cards;
  final List<HomeItemEnum> favorites;

  const PreferencesHomeCardsState({
    required this.cards,
    required this.favorites,
  });

  @override
  List<Object?> get props => [cards, favorites];
}

class PreferencesHomeCardsLoadingState extends PreferencesHomeCardsState {
  const PreferencesHomeCardsLoadingState()
      : super(cards: const [], favorites: const []);
}

class PreferencesHomeCardsLoadedState extends PreferencesHomeCardsState {
  final bool success;
  final bool showOnboarding;

  const PreferencesHomeCardsLoadedState({
    required List<HomeItemEnum> cards,
    required List<HomeItemEnum> favorites,
    this.success = false,
    this.showOnboarding = false,
  }) : super(cards: cards, favorites: favorites);

  @override
  List<Object?> get props => [cards, favorites, success, showOnboarding];
}

class PreferencesHomeCardsFailedState extends PreferencesHomeCardsState {
  const PreferencesHomeCardsFailedState()
      : super(cards: const [], favorites: const []);
}
