import 'dart:convert';

import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_bloc.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_events.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

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
  String sharedKey = "PREFERENCES_HOME_CARDS_EMPLOYEE";
  String sharedKeyOnboarding = "PREFERENCES_HOME_CARDS_ONBOARDING_EMPLOYEE";

  Future<void> getCards(BuildContext context) async {
    bloc.add(PreferencesHomeCardsLoadingEvent());
    try {
      preferences = await SharedPreferences.getInstance();
      var getfavorites =
          preferences?.getString("$sharedKey${sessionBloc.getSession?.me.cpf}");
      var getOnboardingInfo = preferences
          ?.getString("$sharedKeyOnboarding${sessionBloc.getSession?.me.cpf}");
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
      List<String> stringFavorites = favorites.map((e) => e.titleKey).toList();
      await preferences?.remove("$sharedKey${sessionBloc.getSession?.me.cpf}");
      await preferences?.setString(
        "$sharedKey${sessionBloc.getSession?.me.cpf}",
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
      "$sharedKeyOnboarding${sessionBloc.getSession?.me.cpf}",
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
            element.checkRbac(sessionBloc) && !favorites.contains(element))
        .toList();
    favorites =
        favorites.where((element) => element.checkRbac(sessionBloc)).toList();
    List<HomeItemEnum> priority = values
        .where(
            (element) => element.priority() < 3 && !favorites.contains(element))
        .toList();
    priority.sort((a, b) => a.priority().compareTo(b.priority()));
    List<HomeItemEnum> ordenedByName = values
        .where(
            (element) => element.priority() > 2 && !favorites.contains(element))
        .toList();
    ordenedByName.sort((a, b) => getString(context, a.titleKey)
        .toUpperCase()
        .compareTo(getString(context, b.titleKey).toUpperCase()));
    cards = [...favorites, ...priority, ...ordenedByName];
  }

  checkFavoritesCard(String? getfavorites) {
    if (getfavorites != null && getfavorites.isNotEmpty) {
      var decode = json.decode(getfavorites);
      if (decode['favorites'].isNotEmpty) {
        List<HomeItemEnum> favs = [];
        List.generate(decode['favorites'].length, (index) {
          for (var element in HomeItemEnum.values) {
            if (element.titleKey == decode['favorites'][index]) {
              favs.add(element);
            }
          }
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
