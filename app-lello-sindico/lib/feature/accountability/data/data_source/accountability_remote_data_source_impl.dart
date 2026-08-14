import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/data/data_source/accountability_api.dart';
import 'package:lello/feature/accountability/data/data_source/accountability_remote_data_source.dart';
import 'package:lello/feature/accountability/data/model/accountability_model.dart';
import 'package:lello/feature/accountability/data/model/accountability_period_model.dart';
import 'package:lello/feature/accountability/data/model/acountability_doubt_request_model.dart';
import 'package:lello/feature/accountability/data/model/acountability_doubt_response_model.dart';
import 'package:lello/feature/accountability/data/model/acountability_question_model.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_situation.dart';

class AccountabilityRemoteDataSourceImpl
    extends AccountabilityRemoteDataSource {
  final AccountabilityApi api;

  AccountabilityRemoteDataSourceImpl({required this.api});

  @override
  Future<AccountabilityModel> select(
      String condominiumId, DateTime period) async {
    final dateFormat = DateFormat("yyyy-MM");
    final response = await api.get(condominiumId, dateFormat.format(period));
    return ApiMapper.map(
        response, (json) => AccountabilityModel.fromJson(json));
  }

  @override
  Future<List<AccountabilityPeriodModel>> getPeriod(
      String condominiumId) async {
    final response = await api.getPeriod(condominiumId);
    return ApiMapper.mapList(
        response, (json) => AccountabilityPeriodModel.fromJson(json));
  }

  @override
  Future<List<AccountabilityQuestionTypeModel>> listType(
      String condominiumId) async {
    final response = await api.listType(condominiumId);
    return ApiMapper.mapList(
        response, (json) => AccountabilityQuestionTypeModel.fromJson(json));
  }

  @override
  Future<List<AccountabilityDoubtResponseModel>> listDoubt(
      String condominiumId, DoubtSituation? questionSituation) async {
    final response = await api.listDoubt(condominiumId, questionSituation);
    return ApiMapper.mapList(
        response, (json) => AccountabilityDoubtResponseModel.fromJson(json));
  }

  @override
  Future<List<AccountabilityDoubtResponseModel>> listDoubtDetail(
      String condominiumId, String id) async {
    final response = await api.listDoubtDetail(condominiumId, id);
    return ApiMapper.mapList(
        response, (json) => AccountabilityDoubtResponseModel.fromJson(json));
  }

  @override
  Future<AccountabilityDoubtResponseModel> sendDoubt(
      String condominiumId, AccountabilityDoubtRequestModel doubt) async {
    final response = await api.sendDoubt(condominiumId, doubt);
    final result = ApiMapper.map(
        response, (json) => AccountabilityDoubtResponseModel.fromJson(json));
    return result;
  }

  @override
  Future<void> sendRecommendation(String condominiumId, DateTime period) async {
    final dateFormat = DateFormat("yyyy-MM");
    final result =
        await api.postRecommendation(condominiumId, dateFormat.format(period));
    return ApiMapper.map(result, (json) => null);
  }
}
