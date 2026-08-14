import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/core/uploader/uploader.dart';
import 'package:lello/feature/payment/domain/repository/payment_file_repository.dart';

class PaymentFileRepositoryImpl extends PaymentFileRepository {
  final Uploader uploader;

  PaymentFileRepositoryImpl({required this.uploader});
  @override
  Future<Try<String>> upload(String condominiumId, File file,
      {required Function(String) onComplete,
      required Function(Exception) onError}) {
    final completer = Completer<Try<String>>();
    uploader.upload("condominiums/$condominiumId/payments/files", file,
        onComplete: (data) {
      return completer.complete(Success(data));
    }, onError: (err) {
      return completer.complete(Rejection(UnknownFailure(err)));
    });
    return completer.future;
  }
}
