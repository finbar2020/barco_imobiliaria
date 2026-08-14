import 'package:lello/feature/resin/data/model/resin_check_max_value_param_model.dart';
import 'package:lello/feature/resin/data/model/resin_params_model.dart';
import 'package:lello/feature/resin/data/model/resin_person_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_dto_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_filter_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_receipt_model.dart';

abstract class ResinRemoteDataSource {
  Future<ResinParamsModel> getResinParams(String condominiumId);

  Future<List<ResinPersonModel>> getResinPeople(String condominiumId);

  Future<List<ResinRefundModel>> getResinRefunds(
      String condominiumId, ResinRefundFilterModel filter);

  Future<ResinRefundModel> createResinRefund(
      String condominiumId, ResinRefundDTOModel refund);

  Future<ResinRefundModel> getResinRefundDetails(
      String condominiumId, String refundId);

  Future<ResinRefundReceiptModel> uploadNewReceipt(
      String condominiumId, String refundId, ResinRefundReceiptModel receipt);

  Future<bool> refundCancel(String condominiumId, String refundId);

  Future<bool> refundEdit(String condominiumId, ResinRefundDTOModel refund);

  Future<ResinCheckMaxValueParamModel> checkMaxValue(
      String condominiumId, String type, double value);
}
