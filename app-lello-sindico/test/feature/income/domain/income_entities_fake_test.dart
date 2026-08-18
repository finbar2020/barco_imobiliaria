import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';
import 'package:lello/feature/income/domain/entity/billet_filter_parameters.dart';
import 'package:lello/feature/income/domain/entity/billet_status_enum.dart';
import 'package:lello/feature/income/domain/entity/income.dart';
import 'package:lello/feature/income/domain/entity/income_forecast.dart';
import 'package:lello/feature/income/domain/entity/income_share.dart';
import 'package:lello/feature/income/domain/repository/income_repository.dart';
import 'package:lello/feature/income/domain/use_case/get_monthly_income/get_income.dart';
import 'package:lello/feature/income/domain/use_case/get_monthly_income/get_monthly_income_impl.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

class _FakeIncomeRepo extends Fake implements IncomeRepository {
  Object? last;

  @override
  Future<Try<Income?>> select(
      DataOrigin origin, String condominiumId, DateTime period) async {
    last = '$origin|$condominiumId|${period.month}';
    return Success(
      Income(
        period: period,
        value: 12500,
        shares: [IncomeShare(title: 'Taxa', total: 10, share: 0.8)],
        forecast: [IncomeForecast()],
        pendingBillets: [
          Billet(id: 'b1', unit: Unit(title: '101'), value: 450),
        ],
      ),
    );
  }
}

void main() {
  test('rejeita condomínio vazio e encaminha origem e período', () async {
    final repo = _FakeIncomeRepo();
    final usecase = GetIncomeImpl(repository: repo);

    expect(
      await usecase(
        GetIncomeParam(
          condominiumId: '',
          origin: DataOrigin.remote,
          period: DateTime(2026, 8),
        ),
      ),
      isA<Rejection<Income?>>(),
    );

    final result = await usecase(
      GetIncomeParam(
        condominiumId: 'c1',
        origin: DataOrigin.local,
        period: DateTime(2026, 8, 1),
      ),
    );
    expect(result, isA<Success<Income?>>());
    final income = (result as Success<Income?>).get();
    expect(income?.value, 12500);
    expect(income?.shares?.single.title, 'Taxa');
    expect(income?.pendingBillets?.single.unit?.title, '101');
    expect(repo.last, 'DataOrigin.local|c1|8');
  });

  test('filtro de boleto preserva status no copyWith', () {
    final filter = BilletFilter(query: '101', status: BilletStatus.open)
        .copyWith(status: BilletStatus.paid);
    expect(filter.query, '101');
    expect(filter.status, BilletStatus.paid);
  });
}
