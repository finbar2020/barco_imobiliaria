import 'package:colaborador/feature/me/domain/entity/me_step.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_event.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/fixtures.dart';

void main() {
  final me = testMe();

  group('MeState', () {
    test('estado inicial não carrega colaborador', () {
      expect(const MeInitialState().me, isNull);
      expect(const MeInitialState(), const MeInitialState());
    });

    test('estados iguais com o mesmo colaborador', () {
      expect(MeLoadedState(me), MeLoadedState(me));
      expect(MeLoadingState(me: me), MeLoadingState(me: me));
      expect(MeLoadedState(me) == MeLoadedState(testMe()), isFalse);
    });

    test('estado de cache é um estado carregado', () {
      expect(MeLoadedCacheState(me), isA<MeLoadedState>());
      expect(MeLoadedCacheState(me).me, me);
    });

    test('falha de carregamento guarda o erro', () {
      final failure = KnownFailure('500', 'erro');

      final state = MeLoadFailedState(failure);

      expect(state.failure, failure);
      expect(state.me, isNull);
    });

    test('estados de edição mantêm o colaborador editado', () {
      expect(MeEditState(me).me, me);
      expect(MeEditLoadingState(me), isA<MeEditState>());
      expect(MeEditSucceededState(me), isA<MeLoadedState>());
    });

    test('edição de telefone diferencia canal de validação', () {
      const phone = MeEditPhoneChangedState(isPhone: true);
      const email = MeEditPhoneChangedState(isEmail: true);

      expect(phone.isPhone, isTrue);
      expect(phone.isEmail, isFalse);
      expect(email.isEmail, isTrue);
      expect(phone == email, isFalse);
    });

    test('estados de senha carregam as senhas informadas', () {
      final loading = MeEditPasswordLoadingState(me, 'antiga', 'nova');
      final failed = MeEditPasswordFailedState(
        me,
        'antiga',
        'nova',
        KnownFailure('400', 'x'),
      );

      expect(loading, isA<MeEditPasswordState>());
      expect(failed.error, isA<KnownFailure>());
    });

    test('estados de exclusão de conta carregam o colaborador', () {
      expect(MeDeleteAccountSuccessState(me).me, me);
      expect(MeDeleteAccountFailedState(me).me, me);
    });
  });

  group('MeState props', () {
    final erro = KnownFailure('400', 'falhou');
    final codeRequest = CodeRequest(
      source: CodeValidationSource.phone,
      origin: CodeValidationOrigin.changeNumber,
      value: '11999999999',
      token: '',
      cpf: '12345678901',
      id: 'c1',
    );

    test('falha de carga compara colaborador e erro', () {
      expect(MeLoadFailedState(erro), MeLoadFailedState(erro));
      expect(
        MeLoadFailedState(erro) == MeLoadFailedState(KnownFailure('500', 'x')),
        isFalse,
      );
    });

    test('edição compara pedido e validação de código', () {
      expect(
        MeEditState(me, codeRequest: codeRequest),
        MeEditState(me, codeRequest: codeRequest),
      );
      expect(MeEditState(me) == MeEditState(me, codeRequest: codeRequest),
          isFalse);
    });

    test('falha de senha compara colaborador e erro', () {
      expect(
        MeEditPasswordFailedState(me, 'a', 'b', erro),
        MeEditPasswordFailedState(me, 'a', 'b', erro),
      );
    });

    test('senha alterada com sucesso mantém o colaborador', () {
      expect(MeEditPasswordSucceededState(me).me, me);
    });

    test('falha na edição compara todos os campos', () {
      expect(
        MeEditFailedState(me, erro, codeRequest: codeRequest),
        MeEditFailedState(me, erro, codeRequest: codeRequest),
      );
      expect(
        MeEditFailedState(me, erro) == MeEditFailedState(me, erro,
            codeRequest: codeRequest),
        isFalse,
      );
    });

    test('estados de upload de foto carregam o colaborador', () {
      expect(MeUploadProfileLoadingState(me).me, me);
      expect(MeUploadProfileSucceededState(me).me, me);
      expect(
        MeUploadProfileFailedState(me, erro),
        MeUploadProfileFailedState(me, erro),
      );
    });

    test('falha ao pedir o código compara o motivo', () {
      expect(
        MeEditRequestCodeFailedState(me, erro),
        MeEditRequestCodeFailedState(me, erro),
      );
      expect(
        MeEditRequestCodeFailedState(me, erro) ==
            MeEditRequestCodeFailedState(me, KnownFailure('500', 'x')),
        isFalse,
      );
    });
  });

  group('MeEvent', () {
    test('load compara pelo forceUpdate', () {
      expect(const MeLoadEvent(), const MeLoadEvent());
      expect(const MeLoadEvent(forceUpdate: true) == const MeLoadEvent(),
          isFalse);
    });

    test('troca de senha compara pelas senhas', () {
      const a = MeBeginEditSavePasswordEvent(
        originPassword: 'antiga',
        password: 'nova',
      );
      const b = MeBeginEditSavePasswordEvent(
        originPassword: 'antiga',
        password: 'nova',
      );

      expect(a, b);
      expect(a.password, 'nova');
    });

    test('pedido de código compara pelo canal', () {
      const phone = MeRequestValidationCodeEvent(
        isPhoneCheck: true,
        isEmailCheck: false,
      );
      const email = MeRequestValidationCodeEvent(
        isPhoneCheck: false,
        isEmailCheck: true,
      );

      expect(phone == email, isFalse);
      expect(phone.isPhoneCheck, isTrue);
    });

    test('eventos simples são iguais entre si', () {
      expect(const MeBeginEditEvent(), const MeBeginEditEvent());
      expect(const MeRevertEditEvent(), const MeRevertEditEvent());
      expect(const ResendTokenEvent(), const ResendTokenEvent());
      expect(const MeLogoutEvent(), const MeLogoutEvent());
    });

    test('mudança de passo carrega o passo escolhido', () {
      const event = MeChangeStepEvent(step: MeStep.profile);

      expect(event.step, MeStep.profile);
    });

    test('escolha de imagem carrega a origem', () {
      const event = MeChooseImageEvent(ImageSource.camera);

      expect(event.source, ImageSource.camera);
      expect(event == const MeChooseImageEvent(ImageSource.gallery), isFalse);
    });

    test('exclusão de conta carrega o colaborador', () {
      expect(MeDeleteAccountEvent(me).me, me);
    });
  });
}
