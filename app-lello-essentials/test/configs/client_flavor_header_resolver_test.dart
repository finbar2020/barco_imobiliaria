import 'package:essentials/configs/client_flavor_header_resolver.dart';
import 'package:essentials/configs/flavor_config.dart';
import 'package:essentials/configs/hubert_configuration.dart';
import 'package:essentials/configs/lello_configuration.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String resolver(AppOriginEnum origem, String pacote) =>
      ClientFlavorHeaderResolver.resolve(
          appOrigin: origem, packageName: pacote);

  group('marca Lello', () {
    setUp(() => FlavorConfig.config = const LelloConfiguration());

    test('morador: pacote morar → MORAR, pacote viver → VIVER', () {
      expect(resolver(AppOriginEnum.owner, 'app.lello.morar'), 'MORAR');
      expect(resolver(AppOriginEnum.owner, 'app.lello.viver'), 'VIVER');
    });

    test('síndico: pacote sindico → APPSINDICO, viver → APPSINDICO_VIVER', () {
      expect(resolver(AppOriginEnum.manager, 'app.lello.sindico'),
          'APPSINDICO');
      expect(resolver(AppOriginEnum.manager, 'app.lello.sindico.viver'),
          'APPSINDICO_VIVER');
    });

    test('colaborador é sempre APPDPREP', () {
      expect(resolver(AppOriginEnum.employee, 'app.lello.dprep'), 'APPDPREP');
      expect(resolver(AppOriginEnum.employee, 'app.lello.viver'), 'APPDPREP');
    });

    test('detecção de "viver" ignora maiúsculas', () {
      expect(resolver(AppOriginEnum.owner, 'APP.LELLO.VIVER'), 'VIVER');
      expect(resolver(AppOriginEnum.owner, 'ViVeR'), 'VIVER');
    });

    test('pacote vazio é tratado como morar', () {
      expect(resolver(AppOriginEnum.owner, ''), 'MORAR');
      expect(resolver(AppOriginEnum.manager, ''), 'APPSINDICO');
    });

    test('resolveCompanyId devolve o id da Lello', () {
      expect(ClientFlavorHeaderResolver.resolveCompanyId(), '1');
    });
  });

  group('marca Hubert', () {
    setUp(() => FlavorConfig.config = const HubertConfiguration());

    test('morador viver vira HUBERT; morar continua MORAR', () {
      expect(resolver(AppOriginEnum.owner, 'app.lello.viver'), 'HUBERT');
      expect(resolver(AppOriginEnum.owner, 'app.lello.morar'), 'MORAR');
    });

    test('síndico viver vira APPSINDICO_HUBERT; sindico continua APPSINDICO',
        () {
      expect(resolver(AppOriginEnum.manager, 'app.lello.sindico.viver'),
          'APPSINDICO_HUBERT');
      expect(resolver(AppOriginEnum.manager, 'app.lello.sindico'),
          'APPSINDICO');
    });

    test('colaborador segue APPDPREP', () {
      expect(resolver(AppOriginEnum.employee, 'app.viver'), 'APPDPREP');
    });

    test('resolveCompanyId devolve o id da Hubert', () {
      expect(ClientFlavorHeaderResolver.resolveCompanyId(), '2');
    });
  });

  // O `return _morar` final de `resolve` é inalcançável: os três valores de
  // `AppOriginEnum` já são tratados antes dele.
  test('todas as origens têm cabeçalho', () {
    FlavorConfig.config = const LelloConfiguration();
    for (final origem in AppOriginEnum.values) {
      expect(resolver(origem, 'app'), isNotEmpty);
    }
  });
}
