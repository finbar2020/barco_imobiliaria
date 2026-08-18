import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_bloc.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_events.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_state.dart';
import 'package:colaborador/feature/home_cards_preferences/widgets/preferences_home_cards_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — preferences cards grid', (tester) async {
    final bloc = PreferencesHomeCardsBloc()
      ..add(PreferencesHomeCardsLoadedEvent(
        cards: [
          HomeItemEnum.digitalPoint,
          HomeItemEnum.proof,
          HomeItemEnum.timeSheet,
          HomeItemEnum.myDocuments,
        ],
        favorites: [HomeItemEnum.digitalPoint, HomeItemEnum.proof],
      ));
    addTearDown(bloc.close);

    await pumpApp(
      tester,
      BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is! PreferencesHomeCardsLoadedState) {
            return const SizedBox.shrink();
          }
          return Wrap(
            children: List.generate(
              state.cards.length,
              (index) => PreferencesHomeCardWidget(
                imagePath: state.cards[index].icon,
                sessionBloc: FakeSessionBloc(),
                text: state.cards[index].titleKey,
                isFavorite: state.favorites.contains(state.cards[index]),
                onTap: () {},
              ),
            ),
          );
        },
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(480, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/preferences_cards_grid.png'),
    );
  });
}
