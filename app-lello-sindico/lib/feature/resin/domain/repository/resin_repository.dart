import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_filter.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';

abstract class ResinRepository {
  Future<Try<ResinParams>> getResinParams(String condominiumId);

  Future<Try<List<ResinPerson>>> getResinPeople(String condominiumId);

  Future<Try<List<ResinRefund>>> getResinRefunds(
      String condominiumId, ResinRefundFilter filter);

  Future<Try<ResinRefund>> createResinRefund(
      String condominiumId, ResinRefund refund);

  Future<Try<ResinRefund>> getResinRefundDetails(
      String condominiumId, String refundId);

  Future<Try<ResinRefundReceipt>> uploadNewReceipt(
      String condominiumId, String refundId, ResinRefundReceipt receipt);

  Future<Try<bool>> refundCancel(String condominiumId, String refundId);

  Future<Try<bool>> refundEdit(String condominiumId, ResinRefund refund);

  Future<Try<List<ResinPerson>>> getResinPeopleFromCache(String condominiumId);

  Future<Try<List<ResinRefund>>> getResinRefundsFromCache(String condominiumId);

  Future<Try<ResinCheckMaxValueParam>> checkMaxValue(
      String condominiumId, String type, double value);
}
