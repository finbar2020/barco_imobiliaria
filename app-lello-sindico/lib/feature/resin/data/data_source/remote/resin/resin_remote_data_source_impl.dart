import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin/resin_api.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin/resin_remote_data_source.dart';
import 'package:lello/feature/resin/data/model/resin_check_max_value_param_model.dart';
import 'package:lello/feature/resin/data/model/resin_params_model.dart';
import 'package:lello/feature/resin/data/model/resin_person_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_dto_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_filter_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_receipt_model.dart';

class ResinRemoteDataSourceImpl extends ResinRemoteDataSource {
  final ResinApi api;
  ResinRemoteDataSourceImpl({required this.api});

  @override
  Future<ResinParamsModel> getResinParams(String condominiumId) async {
    final response = await api.getResinParams(condominiumId);
    final resinParamsModel =
        ApiMapper.map(response, (json) => ResinParamsModel.fromJson(json));

    return resinParamsModel;
  }

  @override
  Future<List<ResinPersonModel>> getResinPeople(String condominiumId) async {
    final response = await api.getResinPeople(condominiumId);
    final resinPeople =
        ApiMapper.mapList(response, (json) => ResinPersonModel.fromJson(json));

    return resinPeople;
  }

  @override
  Future<List<ResinRefundModel>> getResinRefunds(
      String condominiumId, ResinRefundFilterModel filter) async {
    final response = await api.getResinRefunds(
      condominiumId,
      startDate: filter.startDate,
      endDate: filter.endDate,
      protocol: filter.protocol,
      status: filter.status,
      inconsistency: filter.inconsistency,
      type: filter.type,
    );
    final resinRefundsModel =
        ApiMapper.mapList(response, (json) => ResinRefundModel.fromJson(json));

    return resinRefundsModel;
  }

  @override
  Future<ResinRefundModel> createResinRefund(
      String condominiumId, ResinRefundDTOModel refundDTO) async {
    final response = await api.createNewRefund(condominiumId, refundDTO);
    final resinRefundModel =
        ApiMapper.map(response, (json) => ResinRefundModel.fromJson(json));

    return resinRefundModel;
  }

  @override
  Future<ResinRefundModel> getResinRefundDetails(
      String condominiumId, String refundId) async {
    final response = await api.getResinRefundDetails(
      condominiumId,
      refundId,
    );
    final resinRefundModel =
        ApiMapper.map(response, (json) => ResinRefundModel.fromJson(json));

    return resinRefundModel;
  }

  @override
  Future<ResinRefundReceiptModel> uploadNewReceipt(String condominiumId,
      String refundId, ResinRefundReceiptModel receiptModel) async {
    final response =
        await api.uploadNewReceipt(condominiumId, refundId, receiptModel);
    ResinRefundReceiptModel receiptModelResponse = ApiMapper.map(
        response, (json) => ResinRefundReceiptModel.fromJson(json));
    return receiptModelResponse;
  }

  @override
  Future<bool> refundCancel(String condominiumId, String refundId) async {
    final response = await api.refundCancel(condominiumId, refundId);
    if (response.isSuccessful) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> refundEdit(
      String condominiumId, ResinRefundDTOModel refundDTO) async {
    final response = await api.refundEdit(condominiumId, refundDTO);
    if (response.isSuccessful == false) {
      throw response.error ?? "";
    } else {
      return true;
    }
  }

  @override
  Future<ResinCheckMaxValueParamModel> checkMaxValue(
      String condominiumId, String type, double value) async {
    final response = await api.checkMaxValue(condominiumId, type, value);
    final checkMaxValue = ApiMapper.map(
        response, (json) => ResinCheckMaxValueParamModel.fromJson(json));

    return checkMaxValue;
  }
}
