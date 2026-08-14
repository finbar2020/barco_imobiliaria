import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/data/data_source/local/resin_local_data_source.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin/resin_remote_data_source.dart';
import 'package:lello/feature/resin/data/model/resin_check_max_value_param_model.dart';
import 'package:lello/feature/resin/data/model/resin_params_model.dart';
import 'package:lello/feature/resin/data/model/resin_person_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_dto_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_filter_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_receipt_model.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_filter.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_features/shared_features.dart';

class ResinRepositoryImpl extends ResinRepository {
  final ResinRemoteDataSource remoteDataSource;
  final ResinLocalDataSource localDataSource;

  ResinRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Try<ResinParams>> getResinParams(String condominiumId) async {
    try {
      final ResinParamsModel result =
          await remoteDataSource.getResinParams(condominiumId);

      return Success(result.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<ResinPerson>>> getResinPeople(String condominiumId) async {
    try {
      final List<ResinPersonModel> result =
          await remoteDataSource.getResinPeople(condominiumId);

      localDataSource.saveAllPeople(condominiumId, result);

      final List<ResinPerson> people =
          result.map((e) => e.toEntity()).whereType<ResinPerson>().toList();
      return Success(people);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<ResinRefund>>> getResinRefunds(
      String condominiumId, ResinRefundFilter filter) async {
    try {
      final List<ResinRefundModel> result =
          await remoteDataSource.getResinRefunds(
        condominiumId,
        ResinRefundFilterModel.fromEntity(filter),
      );

      localDataSource.saveAllRefunds(condominiumId, result);

      List<ResinRefund> refunds =
          result.map((e) => e.toEntity()).whereType<ResinRefund>().toList();

      refunds.sort((a, b) {
        if (a.requestDate == null) {
          return 1;
        }
        if (b.requestDate == null) {
          return -1;
        }
        return (b.requestDate!).compareTo(a.requestDate!);
      });

      return Success(refunds);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<ResinRefund>> createResinRefund(
      String condominiumId, ResinRefund refund) async {
    try {
      final ResinRefundModel result = await remoteDataSource.createResinRefund(
        condominiumId,
        ResinRefundDTOModel.fromResinRefundEntity(refund),
      );

      localDataSource.saveSingleRefund(condominiumId, result);

      ResinRefund refundResponse = result.toEntity()!;

      return Success(refundResponse);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<ResinRefund>> getResinRefundDetails(
      String condominiumId, String refundId) async {
    try {
      final ResinRefundModel result =
          await remoteDataSource.getResinRefundDetails(condominiumId, refundId);
      ResinRefund? refund = result.toEntity();
      if (refund == null) {
        return Rejection(UnknownFailure("Empty Element"));
      }
      await setRefundReceiptsFiles(refund: refund);

      return Success(refund);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<ResinRefundReceipt>> uploadNewReceipt(
      String condominiumId, String refundId, ResinRefundReceipt receipt) async {
    try {
      final ResinRefundReceiptModel result =
          await remoteDataSource.uploadNewReceipt(condominiumId, refundId,
              ResinRefundReceiptModel.fromEntity(receipt));
      ResinRefundReceipt receiptResponse = result.toEntity()!;

      await setRefundReceiptsFiles(receipt: receiptResponse);

      return Success(receiptResponse);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<bool>> refundCancel(String condominiumId, String refundId) async {
    try {
      final bool result =
          await remoteDataSource.refundCancel(condominiumId, refundId);
      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<bool>> refundEdit(String condominiumId, ResinRefund refund) async {
    try {
      final bool result = await remoteDataSource.refundEdit(
        condominiumId,
        ResinRefundDTOModel.fromResinRefundEntity(refund),
      );

      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<ResinPerson>>> getResinPeopleFromCache(
      String condominiumId) async {
    try {
      final List<ResinPersonModel> result =
          await localDataSource.selectAllPeople(condominiumId);

      final List<ResinPerson> people =
          result.map((e) => e.toEntity()).whereType<ResinPerson>().toList();
      return Success(people);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<ResinRefund>>> getResinRefundsFromCache(
      String condominiumId) async {
    try {
      final List<ResinRefundModel> result =
          await localDataSource.selectAllRefunds(condominiumId);

      List<ResinRefund> refunds =
          result.map((e) => e.toEntity()).whereType<ResinRefund>().toList();
      return Success(refunds);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<ResinCheckMaxValueParam>> checkMaxValue(
      String condominiumId, String type, double value) async {
    try {
      final ResinCheckMaxValueParamModel result =
          await remoteDataSource.checkMaxValue(condominiumId, type, value);
      ResinCheckMaxValueParam checkMaxValueParam = result.toEntity();
      return Success(checkMaxValueParam);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  Future setRefundReceiptsFiles(
      {ResinRefund? refund, ResinRefundReceipt? receipt}) async {
    if (refund != null) {
      await Future.forEach(refund.receipts, (ResinRefundReceipt element) async {
        if (element.digitalDocument?.bytes != null &&
            element.digitalDocument?.id != null) {
          element.digitalDocument!.file = await convertFile(
            element.digitalDocument!.bytes!,
            element.digitalDocument!.id!,
          );
        }
      });
    } else if (receipt != null) {
      if (receipt.digitalDocument?.bytes != null &&
          receipt.digitalDocument?.id != null) {
        receipt.digitalDocument!.file = await convertFile(
          receipt.digitalDocument!.bytes!,
          receipt.digitalDocument!.id!,
        );
      }
    }
  }

  Future<File?> convertFile(String bytes, String id) async {
    File? file;
    var permsStorage = await CheckPermissions.storage();
    if (permsStorage) {
      Uint8List byte = base64.decode(bytes);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File fileConverted = File("$dir/$id.pdf");
      file = await fileConverted.writeAsBytes(byte);
    }
    return file;
  }
}
