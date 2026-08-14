import 'package:essentials/essentials.dart';
import 'package:morar/feature/home/domain/entity/home_banner.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeViewState extends HomeState {
  final bool showCondominumSelector;
  final List<HomeItemEnum>? cards;

  const HomeViewState({
    required this.showCondominumSelector,
    this.cards,
  });

  @override
  List<Object?> get props => [showCondominumSelector, cards];
}

class LoadingBannersState extends HomeState {
  const LoadingBannersState();
}

class LoadedBannersState extends HomeState {
  final List<HomeBanner> banners;

  const LoadedBannersState({
    required this.banners,
  });

  @override
  List<Object?> get props => [banners];
}

class ShowAgreementDialogState extends HomeState {
  const ShowAgreementDialogState();
}

class FailedBannersState extends HomeState {
  const FailedBannersState();
}

class LoadingHomeToGoState extends HomeState {
  const LoadingHomeToGoState();
}

class ShowHomeToGoState extends HomeState {
  const ShowHomeToGoState();
}

class LoadedHomeToGoState extends HomeState {
  final String link;

  const LoadedHomeToGoState({required this.link});

  @override
  List<Object?> get props => [link];
}

class FailedHomeToGoState extends HomeState {
  const FailedHomeToGoState();
}

class LoadedFavoritesCardsState extends HomeState {
  final List<HomeItemEnum> cards;

  const LoadedFavoritesCardsState({required this.cards});

  @override
  List<Object?> get props => [cards];
}
