import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/rbac/shared_application_rbac.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/test_container.dart';

void main() {
  test('SharedApplicationRbac expõe as chaves de comodidades', () {
    expect(SharedApplicationRbac.morarComodidades, 'morar.comodidades');
    expect(SharedApplicationRbac.morarComodidadesVoce, 'morar.comodidades.voce');
    expect(SharedApplicationRbac.morarComodidadesCasa, 'morar.comodidades.casa');
    expect(SharedApplicationRbac.morarComodidadesPet, 'morar.comodidades.pet');
    expect(SharedApplicationRbac.morarComodidadesVeiculo,
        'morar.comodidades.veiculo');
    expect(SharedApplicationRbac.morarComodidadesFamilia,
        'morar.comodidades.familia');
    expect(SharedApplicationRbac.morarComodidadesOutros,
        'morar.comodidades.outros');
    final all = [
      SharedApplicationRbac.morarComodidadesVoce,
      SharedApplicationRbac.morarComodidadesCasa,
      SharedApplicationRbac.morarComodidadesPet,
      SharedApplicationRbac.morarComodidadesVeiculo,
      SharedApplicationRbac.morarComodidadesFamilia,
      SharedApplicationRbac.morarComodidadesOutros,
    ];
    expect(all, everyElement(startsWith('${SharedApplicationRbac.morarComodidades}.')));
  });

  test('SharedApplicationContainer é o contrato resolvido pelas telas', () async {
    final SharedApplicationContainer container = TestSharedContainer()
      ..register<String>('valor')
      ..registerLazy<int>(() => 7);
    expect(container.resolve<String>(), 'valor');
    expect(container.resolve<int>(), 7);
    expect(container.getBaseUrl(), 'http://localhost');
    await container.resetLazySingleton<int>();
    expect(container.resolve<int>(), 7);
    expect(() => container.resolve<double>(), throwsA(anything));
  });
}
