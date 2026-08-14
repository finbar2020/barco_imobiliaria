import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class PaymentFileRepository {
  Future<Try<String>> upload(String condominiumId, File file,
      {required Function(String) onComplete,
      required Function(Exception) onError});
}
