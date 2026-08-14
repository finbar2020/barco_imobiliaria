import 'package:essentials/essentials.dart';

abstract class HomeState extends Equatable {
  final bool showCondominumSelector;

  const HomeState({required this.showCondominumSelector});

  @override
  List<Object?> get props => [showCondominumSelector];
}

class HomeViewState extends HomeState {
  const HomeViewState({required super.showCondominumSelector});
}
