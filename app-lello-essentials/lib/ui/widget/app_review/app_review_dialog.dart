import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/ui/widget/app_review/app_review_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppReviewDialog {
  static String _key = "REVIEW_DATE_CHECK";

  //Função para exibição do Dialog de Avaliação,acionada pelos gatilhos, caso seja validada.
  static Future call({
    required BuildContext context,
    required AppOriginEnum origin,
    required int reviewInterval,
  }) async {
    try {
      // Validar se o dialog de avaliação deve ser mostrado ao usuário;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final InAppReview inAppReview = InAppReview.instance;
      bool isReviewAvailable = await inAppReview.isAvailable();
      if (isReviewAvailable) {
        String? date = prefs.getString(_key);
        if (date == null || date.isEmpty) {
          _setDate();
        } else {
          bool showReviewDialog =
              _checkDateInterval(date: date, reviewInterval: reviewInterval);
          if (showReviewDialog) {
            // Validação concluída: Mostrar dialog;
            // _show(context: context, origin: origin);
            inAppReview.requestReview();
          }
        }
      }
    } catch (e) {
      //Erro durante a validação. Ignorar dialog de avaliação;
      return;
    }
  }

  // Função que checará se o intervalo de tempo para exibição do Dialog de avaliação foi atingido.
  static bool _checkDateInterval(
      {required String date, required int reviewInterval}) {
    try {
      int difference =
          DateTime.now().difference(DateTime.parse(date)).inMilliseconds;
      return difference >= reviewInterval ? true : false;
    } catch (e) {
      return false;
    }
  }

  // Função responsável por exibir o Dialog de avaliação na tela.
  // ignore: unused_element
  static Future _show({
    required BuildContext context,
    required AppOriginEnum origin,
  }) async {
    _setDate();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppReviewDialogWidget(appOriginEnum: origin),
    );
  }

  // Função responsável por atualizar a data da última exibição do dialog de avaliação.
  static Future<void> _setDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, DateTime.now().toString());
  }
}
