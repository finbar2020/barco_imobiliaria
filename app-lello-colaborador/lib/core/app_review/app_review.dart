import 'dart:convert';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/app_review/app_review_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppReview {
  // Função responsável por chamar a avaliação do app, presente no projeto app-lello-essentials
  static call({required BuildContext context}) {
    SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();

    int reviewInterval =
        _getReviewInterval(remoteConfig: sessionBloc.remoteConfig);

    AppReviewDialog.call(
        context: context,
        origin: AppOriginEnum.owner,
        reviewInterval: reviewInterval);
  }

  // Função que retornará o intervalo para mostrar dialog de avaliação em MILISSEGUNDOS.
  static int _getReviewInterval({required FirebaseRemoteConfig? remoteConfig}) {
    int defaultValue = 86400000;
    try {
      if (remoteConfig == null) {
        return defaultValue;
      }
      int reviewAppInterval = jsonDecode(
          remoteConfig.getString(CustomFirebaseRemoteConfig.reviewAppInterval));
      return reviewAppInterval;
    } catch (e) {
      return defaultValue;
    }
  }
}
