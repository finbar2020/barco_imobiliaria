import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/banners/presentation/bloc/banners_event.dart';
import 'package:shared_features/feature/banners/presentation/bloc/banners_state.dart';

class BannersBloc extends Bloc {
  BannersBloc() : super(EmptyBannersState()) {
    on<BannersLoadingEvent>(handleBannersLoadingEvent);
    on<BannersLoadedEvent>(handleBannersLoadedEvent);
    on<BannersErrorEvent>(handleBannersErrorEvent);
  }

  void handleBannersLoadingEvent(BannersLoadingEvent event, Emitter emit) {
    emit(LoadingBannersState());
  }

  void handleBannersLoadedEvent(BannersLoadedEvent event, Emitter emit) {
    emit(LoadedBannersState(banners: event.banners));
  }

  void handleBannersErrorEvent(BannersErrorEvent event, Emitter emit) {
    emit(ErrorBannersState());
  }
}
