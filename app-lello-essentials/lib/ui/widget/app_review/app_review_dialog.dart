import 'package:essentials/enum/app_origin_enum.dart';
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
        // Data ausente, vazia ou inválida (corrompida) é tratada como
        // "sem data": grava a data atual para reiniciar o intervalo.
        if (date == null || date.isEmpty || DateTime.tryParse(date) == null) {
          _setDate();
        } else {
          bool showReviewDialog =
              _checkDateInterval(date: date, reviewInterval: reviewInterval);
          if (showReviewDialog) {
            // Validação concluída: usa o fluxo de review nativo da loja.
            // O dialog próprio (AppReviewDialogWidget) foi desativado; `context`
            // e `origin` permanecem na assinatura por compatibilidade.
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

  // Função responsável por atualizar a data da última exibição do dialog de avaliação.
  static Future<void> _setDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, DateTime.now().toString());
  }
}
