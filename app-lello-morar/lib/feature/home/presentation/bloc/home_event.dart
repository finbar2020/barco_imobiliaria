import 'package:essentials/essentials.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class ShowCondominiumSelectorHomeEvent extends HomeEvent {
  const ShowCondominiumSelectorHomeEvent();
}

class ShowAgreementDialogEvent extends HomeEvent {
  const ShowAgreementDialogEvent();
}

class CollapseCondominiumSelectorHomeEvent extends HomeEvent {
  const CollapseCondominiumSelectorHomeEvent();
}

class RegisterFcmTokenEvent extends HomeEvent {
  final dynamic condominiumId;

  const RegisterFcmTokenEvent(this.condominiumId);

  @override
  List<Object?> get props => [condominiumId];
}

class GetBannersEvent extends HomeEvent {
  const GetBannersEvent();
}

class HomeToGoEvent extends HomeEvent {
  const HomeToGoEvent();
}

class PostTermsEvent extends HomeEvent {
  const PostTermsEvent();
}

class GetFavoritesCardsEvent extends HomeEvent {
  const GetFavoritesCardsEvent();
}
