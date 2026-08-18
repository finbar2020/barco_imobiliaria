import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_event.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_state.dart';

abstract class QuickFixBloc extends Bloc<QuickFixEvent, QuickFixState> {
  QuickFixBloc(QuickFixState initialState) : super(initialState);

  void beginLoad();
}
