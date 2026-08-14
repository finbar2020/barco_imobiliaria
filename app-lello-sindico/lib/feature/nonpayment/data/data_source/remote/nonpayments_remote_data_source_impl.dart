import 'package:essentials/essentials.dart';
import 'package:lello/feature/nonpayment/data/data_source/remote/nonpayments_api.dart';
import 'package:lello/feature/nonpayment/data/data_source/remote/nonpayments_remote_data_source.dart';
import 'package:lello/feature/nonpayment/data/model/nonpayments_model.dart';

class NonPaymentsRemoteDataSourceImpl extends NonPaymentsRemoteDataSource {
  final NonPaymentsApi api;

  NonPaymentsRemoteDataSourceImpl({required this.api});

  @override
  Future<NonPaymentModel> get(String condominiumId, String period) async {
    final response = await api.get(condominiumId, period);
    final result =
        ApiMapper.map(response, (json) => NonPaymentModel.fromJson(json));

    return result.copyWith(
      details: result.details!
          .map(
            (e) => e?.copyWith(
              resident: e.resident?.copyWith(
                unit: e.resident?.unit!.copyWith(condominiumId: condominiumId),
              ),
            ),
          )
          .toList(),
    );
  }
}
