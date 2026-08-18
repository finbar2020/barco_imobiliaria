import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_event.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_state.dart';

abstract class UnitDetailBloc extends Bloc<UnitDetailEvent, UnitDetailState> {
  UnitDetailBloc(UnitDetailState initialState) : super(initialState);

	void beginLoad(String condominiumId, String unitId);
}