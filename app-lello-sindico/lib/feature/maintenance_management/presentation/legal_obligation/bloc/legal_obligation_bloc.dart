import 'package:essentials/essentials.dart';

import 'legal_obligation_event.dart';
import 'legal_obligation_state.dart';

abstract class LegalObligationBloc
    extends Bloc<LegalObligationEvent, LegalObligationState> {
  LegalObligationBloc(super.initialState);
}
