import 'package:essentials/app_update/needs_update_enum.dart';
import 'package:essentials/app_update/update_check_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('guarda o tipo de atualização informado', () {
    expect(UpdateCheckResponse(needsUpdate: NeedsUpdate.mandatory).needsUpdate,
        NeedsUpdate.mandatory);
    expect(UpdateCheckResponse(needsUpdate: NeedsUpdate.minor).needsUpdate,
        NeedsUpdate.minor);
    expect(UpdateCheckResponse(needsUpdate: NeedsUpdate.none).needsUpdate,
        NeedsUpdate.none);
  });

  test('sem argumento o tipo fica nulo e pode ser alterado depois', () {
    final resposta = UpdateCheckResponse();
    expect(resposta.needsUpdate, isNull);
    resposta.needsUpdate = NeedsUpdate.minor;
    expect(resposta.needsUpdate, NeedsUpdate.minor);
  });

  test('enum tem os três estados na ordem esperada', () {
    expect(NeedsUpdate.values,
        [NeedsUpdate.none, NeedsUpdate.minor, NeedsUpdate.mandatory]);
  });
}
