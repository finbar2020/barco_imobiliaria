// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cross_file/cross_file.dart';
import 'package:lello/feature/income/data/repository/billets_repository.dart';

import 'package:essentials/essentials.dart';

import '../entity/billet.dart';

class DownloadBilletUsecase
    extends UseCase<XFile?, DownloadBilletUsecaseParams> {
  final BilletsRepository repository;

  DownloadBilletUsecase({required this.repository});

  @override
  Future<Try<XFile?>> call(DownloadBilletUsecaseParams params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    final result = await repository.downloadPdf(
      billet: params.billet,
      reference: params.reference,
    );
    return result;
  }

  Failure? validate(DownloadBilletUsecaseParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.billet.nrBillet == null) return InvalidParamFailure();
    if (params.reference.isEmpty) return InvalidParamFailure();

    return null;
  }
}

class DownloadBilletUsecaseParams {
  final Billet billet;
  final String reference;

  DownloadBilletUsecaseParams({
    required this.billet,
    required this.reference,
  });
}
