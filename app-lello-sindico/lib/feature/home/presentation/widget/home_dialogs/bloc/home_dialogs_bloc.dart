import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_event.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';

abstract class HomeDialogBloc extends Bloc<HomeDialogEvent, HomeDialogState> {
  HomeDialogBloc(HomeDialogState initialState) : super(initialState);
  void initialState();
  void showUpdate();
  void switchRolesNeeded(Condominium switchCondominium);
}
