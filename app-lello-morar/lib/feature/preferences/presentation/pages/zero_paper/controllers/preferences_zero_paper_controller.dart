import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_entity.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_entity.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_enum.dart';
import 'package:morar/feature/preferences/domain/use_case/get_preferences_zero_paper/get_preferences_zero_paper.dart';
import 'package:morar/feature/preferences/domain/use_case/put_preferences_zero_paper/put_preferences_zero_paper.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/bloc/preferences_zero_paper_bloc.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/bloc/preferences_zero_paper_event.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/bloc/preferences_zero_paper_state.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class PreferencesZeroPaperController {
  final PreferencesZeroPaperBloc bloc;
  final GetZeroPaperUseCase getZeroPaperUseCase;
  final PutZeroPaperUseCase putZeroPaperUseCase;
  final SessionBloc sessionBloc;
  PreferencesZeroPaperController({
    required this.bloc,
    required this.getZeroPaperUseCase,
    required this.putZeroPaperUseCase,
    required this.sessionBloc,
  });

  Future<void> getZeroPaper() async {
    bloc.add(PreferencesZeroPaperLoadingEvent());

    if (sessionBloc.state.session?.condominium?.id == null) {
      bloc.add(PreferencesZeroPaperFailureEvent(error: ""));
      return;
    }

    final response = await getZeroPaperUseCase.call(
        GetZeroPaperParam(unityId: sessionBloc.state.session!.unity!.id!));
    response.fold(
        (error) => bloc.add(PreferencesZeroPaperFailureEvent(error: "")),
        (res) => bloc.add(PreferencesZeroPaperLoadedEvent(
              preferences: res,
              digitalAnnouncements:
                  setValueDigitalPreferences(res.deliveryAnnouncements),
              printedAnnouncements:
                  setValuePrintedPreferences(res.deliveryAnnouncements),
              digitalActs: setValueDigitalPreferences(res.deliveryActs),
              printedActs: setValuePrintedPreferences(res.deliveryActs),
              digitalSlips: setValueDigitalPreferences(res.deliverySlips),
              printedSlips: setValuePrintedPreferences(res.deliverySlips),
              digitalStatements:
                  setValueDigitalPreferences(res.deliveryStatements),
              printedStatements:
                  setValuePrintedPreferences(res.deliveryStatements),
            )));
  }

  Future<void> putZeroPaper(
      PreferencesZeroPaperLoadedState loaded, bool allUnits) async {
    bloc.add(PreferencesZeroPaperLoadingEvent());
    PreferencesZeroPaperEntity zeroPaper = PreferencesZeroPaperEntity(
      deliveryAnnouncements: setValueEntityFromBooleans(
          loaded.digitalAnnouncements, loaded.printedAnnouncements),
      deliveryActs:
          setValueEntityFromBooleans(loaded.digitalActs, loaded.printedActs),
      deliverySlips:
          setValueEntityFromBooleans(loaded.digitalSlips, loaded.printedSlips),
      deliveryStatements: setValueEntityFromBooleans(
          loaded.digitalStatements, loaded.printedStatements),
      allUnits: allUnits,
    );
    PreferencesEntity entity = PreferencesEntity(zeroPaper: zeroPaper);

    final response =
        await putZeroPaperUseCase.call(PutZeroPaperParam(entity: entity));

    response.fold(
        (error) => bloc.add(PreferencesZeroPaperFailureEvent(error: "")),
        (res) => bloc.add(PreferencesZeroPaperSuccessEvent()));
  }

  bool setValueDigitalPreferences(String? preference) {
    if (preference == enumToString(PreferencesZeroPaperEnum.digital)) {
      return true;
    } else if (preference == enumToString(PreferencesZeroPaperEnum.printed)) {
      return false;
    } else {
      return true;
    }
  }

  bool setValuePrintedPreferences(String? preference) {
    if (preference == enumToString(PreferencesZeroPaperEnum.digital)) {
      return false;
    } else if (preference == enumToString(PreferencesZeroPaperEnum.printed)) {
      return true;
    } else {
      return true;
    }
  }

  String setValueEntityFromBooleans(bool digital, bool printed) {
    if (digital == true && printed == false) {
      return enumToString(PreferencesZeroPaperEnum.digital)!;
    } else if (digital == false && printed == true) {
      return enumToString(PreferencesZeroPaperEnum.printed)!;
    } else {
      return enumToString(PreferencesZeroPaperEnum.printed_digital)!;
    }
  }
}
