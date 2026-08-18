import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/home/presentation/bloc/home_event.dart';
import 'package:lello/feature/home/presentation/bloc/home_state.dart';

abstract class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(HomeState initialState) : super(initialState);

  void showCondominiumSelector();
  void collapseCondominiumSelector();
  void registerFcmToken();
}
