import 'dart:io';

import 'package:essentials/functional/failure.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/core/modal/theme_color_dialog.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_your_condo_remote_config.dart';

import 'session_event.dart';

abstract class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc(super.initialState);

  void beginLoadSession({bool onLogin = false});
  void selectCondominium(Condominium condo, BuildContext context);
  void updateMe(Me? me);
  void logout({Failure? error, bool? restartApp});
  void emptyState();
  void getConsultor(ConsultantEntity consultantEntity);

  void updatePicture(File image);

  bool checkRback(String rbac);
  bool checkConfig(String rbac);

  FirebaseRemoteConfig? getRemoteConfig();

  Map<String, dynamic>? mostAccessedCards;

  List<ComfortYourCondoRemoteConfig> getComfortToYourCondo();

  bool showAccessProfileJanitorGDP();

  bool get iSPreferencesPersonalizationActive;
  Future<bool> iSsplashIgnoreBiometricActive();

  ThemeColorValue? getThemeColor();

  void updateThemeColor(ThemeColorValue? value);
}
