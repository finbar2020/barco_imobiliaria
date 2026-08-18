import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_bloc.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_events.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_state.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

Widget _saveButton(PreferencesHomeCardsBloc bloc) {
  return BlocBuilder(
    bloc: bloc,
    builder: (context, state) {
      final cardsState = state as PreferencesHomeCardsState;
      return PrimaryButton(
        text: 'save',
        onPressed: cardsState.cards.length > 4
            ? cardsState.favorites.length < 4
                ? null
                : () {}
            : () {},
      );
    },
  );
}

void main() {
  testWidgets('botão salvar habilitado com até 4 cards', (tester) async {
    final bloc = PreferencesHomeCardsBloc()
      ..add(PreferencesHomeCardsLoadedEvent(
        cards: [HomeItemEnum.digitalPoint, HomeItemEnum.proof],
        favorites: [HomeItemEnum.digitalPoint],
      ));
    addTearDown(bloc.close);

    await pumpApp(tester, _saveButton(bloc), localized: true);
    expect(tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull);
  });

  testWidgets('botão salvar desabilitado com 5+ cards e poucos favoritos',
      (tester) async {
    final bloc = PreferencesHomeCardsBloc()
      ..add(PreferencesHomeCardsLoadedEvent(
        cards: [
          HomeItemEnum.digitalPoint,
          HomeItemEnum.proof,
          HomeItemEnum.timeSheet,
          HomeItemEnum.myDocuments,
          HomeItemEnum.benefits,
        ],
        favorites: [HomeItemEnum.digitalPoint],
      ));
    addTearDown(bloc.close);

    await pumpApp(tester, _saveButton(bloc), localized: true);
    expect(tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull);
  });

  testWidgets('botão salvar habilitado com 5+ cards e 4 favoritos',
      (tester) async {
    final bloc = PreferencesHomeCardsBloc()
      ..add(PreferencesHomeCardsLoadedEvent(
        cards: [
          HomeItemEnum.digitalPoint,
          HomeItemEnum.proof,
          HomeItemEnum.timeSheet,
          HomeItemEnum.myDocuments,
          HomeItemEnum.benefits,
        ],
        favorites: [
          HomeItemEnum.digitalPoint,
          HomeItemEnum.proof,
          HomeItemEnum.timeSheet,
          HomeItemEnum.myDocuments,
        ],
      ));
    addTearDown(bloc.close);

    await pumpApp(tester, _saveButton(bloc), localized: true);
    expect(tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull);
  });
}
