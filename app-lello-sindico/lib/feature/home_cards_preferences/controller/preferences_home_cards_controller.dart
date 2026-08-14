import 'dart:convert';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/home/domain/entity/home_item_enum.dart';
import 'package:lello/feature/home_cards_preferences/bloc/preferences_home_cards_bloc.dart';
import 'package:lello/feature/home_cards_preferences/bloc/preferences_home_cards_events.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class PreferencesHomeCardsController {
  final SessionBloc sessionBloc;
  final PreferencesHomeCardsBloc bloc;
  PreferencesHomeCardsController({
    required this.bloc,
    required this.sessionBloc,
  });

  List<HomeItemEnum> cards = [];
  List<HomeItemEnum> favorites = [];
  SharedPreferences? preferences;
  String sharedKey = "PREFERENCES_HOME_CARDS_MANAGER";
  String sharedKeyOnboarding = "PREFERENCES_HOME_CARDS_ONBOARDING_MANAGER";

  Future<void> getCards(BuildContext context) async {
    bloc.add(PreferencesHomeCardsLoadingEvent());
    try {
      preferences = await SharedPreferences.getInstance();
      var getfavorites = await preferences
          ?.getString("$sharedKey${sessionBloc.state.session?.me?.cpf}");
      var getOnboardingInfo = await preferences?.getString(
          "$sharedKeyOnboarding${sessionBloc.state.session?.me?.cpf}");
      var onboarding = checkShowOnboarding(getOnboardingInfo);
      if (onboarding) {
        bloc.add(PreferencesHomeCardsLoadedEvent(
            cards: cards, favorites: favorites, showOnboarding: true));
      } else {
        checkFavoritesCard(getfavorites);
        ordenedCardsList(context);
        bloc.add(PreferencesHomeCardsLoadedEvent(
            cards: cards, favorites: favorites));
      }
    } catch (e) {
      bloc.add(PreferencesHomeCardsFailedEvent());
    }
  }

  Future<void> savePreferences(BuildContext context) async {
    bloc.add(PreferencesHomeCardsLoadingEvent());
    try {
      List<String> stringFavorites = favorites.map((e) => e.title).toList();
      await preferences
          ?.remove("$sharedKey${sessionBloc.state.session?.me?.cpf}");
      await preferences?.setString(
        "$sharedKey${sessionBloc.state.session?.me?.cpf}",
        json.encode({
          'favorites': stringFavorites,
        }),
      );
      ordenedCardsList(context);
      bloc.add(PreferencesHomeCardsLoadedEvent(
          cards: cards, favorites: favorites, success: true));
    } catch (e) {
      bloc.add(PreferencesHomeCardsFailedEvent());
    }
  }

  Future<void> saveOnboardingInfo(BuildContext context) async {
    await preferences?.setString(
      "$sharedKeyOnboarding${sessionBloc.state.session?.me?.cpf}",
      json.encode({
        'onboarding': true,
      }),
    );
  }

  onTap(int index) {
    if (favorites.length < 6) {
      if (favorites.contains(cards[index])) {
        favorites.remove(cards[index]);
      } else {
        favorites.add(cards[index]);
      }
    } else {
      if (favorites.contains(cards[index])) {
        favorites.remove(cards[index]);
      }
    }
    bloc.add(
        PreferencesHomeCardsLoadedEvent(cards: cards, favorites: favorites));
  }

  void dispose() {
    cards = [];
    favorites = [];
  }

  ordenedCardsList(BuildContext context) {
    List<HomeItemEnum> values = HomeItemEnum.values
        .where((element) =>
            element.rbac(sessionBloc) && !favorites.contains(element))
        .toList();
    favorites =
        favorites.where((element) => element.rbac(sessionBloc)).toList();
    List<HomeItemEnum> priority = values
        .where(
            (element) => element.priority < 3 && !favorites.contains(element))
        .toList();
    priority.sort((a, b) => a.priority.compareTo(b.priority));
    List<HomeItemEnum> ordenedByName = values
        .where(
            (element) => element.priority > 2 && !favorites.contains(element))
        .toList();
    ordenedByName.sort((a, b) => getString(context, a.title)
        .toUpperCase()
        .compareTo(getString(context, b.title).toUpperCase()));
    cards = [...favorites, ...priority, ...ordenedByName];
  }

  checkFavoritesCard(String? getfavorites) {
    if (getfavorites != null && getfavorites.isNotEmpty) {
      var decode = json.decode(getfavorites);
      if (decode['favorites'].isNotEmpty) {
        List<HomeItemEnum> favs = [];
        List.generate(decode['favorites'].length, (index) {
          HomeItemEnum.values.forEach((element) {
            if (element.title == decode['favorites'][index]) {
              favs.add(element);
            }
          });
        });
        favorites = favs;
      }
    }
  }

  bool checkShowOnboarding(String? onboarding) {
    if (onboarding != null && onboarding.isNotEmpty) {
      var decode = json.decode(onboarding);
      return decode['onboarding'] != true;
    } else {
      return true;
    }
  }
}
