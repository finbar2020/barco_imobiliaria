import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/income/data/data_source/remote/income_api.dart';
import 'package:lello/feature/income/data/data_source/remote/income_remote_data_source.dart';
import 'package:lello/feature/income/data/model/income_model.dart';

class IncomeRemoteDataSourceImpl extends IncomeRemoteDataSource {
  final IncomeApi api;
  final dateFormat = DateFormat("yyyy-MM");

  IncomeRemoteDataSourceImpl({required this.api});

  @override
  Future<IncomeModel> select(String condominiumId, DateTime period) async {
    final response = await api.get(condominiumId, dateFormat.format(period));
    final result =
        ApiMapper.map(response, (json) => IncomeModel.fromJson(json));

    return result.copyWith(
        pendingBillets: result.pendingBillets!
            .map(
              (e) => e!.copyWith(
                unit: e.unit!.copyWith(condominiumId: condominiumId),
              ),
            )
            .toList());
  }
}
