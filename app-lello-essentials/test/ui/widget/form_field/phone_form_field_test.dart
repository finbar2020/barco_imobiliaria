import 'package:essentials/ui/widget/form_field/phone_form_field.dart';
import 'package:essentials/validator/validator_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Finder campoDDD() => find.byType(TextField).first;
  Finder campoTelefone() => find.byType(TextField).last;

  EditableText editavel(WidgetTester tester, Finder campo) =>
      tester.widget<EditableText>(
        find.descendant(of: campo, matching: find.byType(EditableText)),
      );

  String textoDe(WidgetTester tester, Finder campo) =>
      editavel(tester, campo).controller.text;

  bool focado(WidgetTester tester, Finder campo) =>
      editavel(tester, campo).focusNode.hasFocus;

  group('valor inicial é dividido em DDD e telefone', () {
    const casos = <String, (String, String)>{
      '': ('', ''),
      '(11)987654321': ('11', '987654321'),
      '(11) 987654321': ('11', '987654321'),
      '11987654321': ('11', '987654321'),
      '1198765432': ('11', '98765432'),
      '987654321': ('', '987654321'),
      '(11)9': ('11', '9'),
      '(11)': ('11', ''),
      '(11) ': ('11', ''),
    };

    for (final caso in casos.entries) {
      testWidgets('"${caso.key}"', (tester) async {
        await pumpApp(tester, PhoneFormField(initialValue: caso.key));
        expect(textoDe(tester, campoDDD()), caso.value.$1);
        expect(textoDe(tester, campoTelefone()), caso.value.$2);
      });
    }

    /// Corrigido: `_initialDDD` aceita `length >= 4` e `_initialPhone`
    /// `length > 4` para valores com parênteses, então "(11)" mantém o DDD
    /// e "(11)9" mantém o dígito do telefone (casos acima). Um "(1" curto
    /// demais continua descartado sem lançar.
    testWidgets('"(1" incompleto é descartado sem lançar', (tester) async {
      await pumpApp(tester, PhoneFormField(initialValue: '(1'));
      expect(tester.takeException(), isNull);
      expect(textoDe(tester, campoDDD()), '');
      expect(textoDe(tester, campoTelefone()), '');
    });
  });

  testWidgets('renderiza dois campos numéricos com hints e sem contador',
      (tester) async {
    await pumpApp(tester, PhoneFormField());
    expect(find.byType(TextField), findsNWidgets(2));

    final ddd = tester.widget<TextField>(campoDDD());
    expect(ddd.decoration!.hintText, '00');
    expect(ddd.decoration!.counterText, '');
    expect(ddd.maxLength, 2);
    expect(ddd.keyboardType, TextInputType.number);
    expect(ddd.enabled, isTrue);

    final telefone = tester.widget<TextField>(campoTelefone());
    expect(telefone.decoration!.hintText, '999999999');
    expect(telefone.maxLength, 9);
    expect(telefone.keyboardType, TextInputType.number);
  });

  testWidgets(
      'enabled=false desabilita os dois campos e focusNode é usado no DDD',
      (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    await pumpApp(tester, PhoneFormField(enabled: false, focusNode: node));

    expect(tester.widget<TextField>(campoDDD()).enabled, isFalse);
    expect(tester.widget<TextField>(campoTelefone()).enabled, isFalse);
    expect(tester.widget<TextField>(campoDDD()).focusNode, same(node));
  });

  testWidgets('digitar o DDD completo move o foco e monta o valor salvo',
      (tester) async {
    String? salvo;
    final formKey = GlobalKey<FormState>();
    await pumpApp(
      tester,
      Form(
        key: formKey,
        child: PhoneFormField(onSaved: (v) => salvo = v),
      ),
    );

    await tester.enterText(campoDDD(), '1');
    await tester.pump();
    expect(focado(tester, campoDDD()), isTrue,
        reason: 'com 1 dígito o foco continua no DDD');

    await tester.enterText(campoDDD(), '11');
    await tester.pump();
    expect(focado(tester, campoTelefone()), isTrue);

    await tester.enterText(campoTelefone(), '987654321');
    await tester.pump();
    formKey.currentState!.save();
    expect(salvo, '(11)987654321');

    // Apagar o telefone devolve o foco ao DDD.
    await tester.enterText(campoTelefone(), '');
    await tester.pump();
    expect(focado(tester, campoDDD()), isTrue);
    formKey.currentState!.save();
    expect(salvo, '(11)');

    // Sem DDD o valor é só o telefone.
    await tester.enterText(campoDDD(), '');
    await tester.enterText(campoTelefone(), '987654321');
    await tester.pump();
    formKey.currentState!.save();
    expect(salvo, '987654321');
  });

  testWidgets(
      'ação "next" no DDD foca o telefone e submit no telefone chama onFieldSubmitted',
      (tester) async {
    final enviados = <String>[];
    await pumpApp(tester, PhoneFormField(onFieldSubmitted: enviados.add));

    await tester.showKeyboard(campoDDD());
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(focado(tester, campoTelefone()), isTrue);

    await tester.enterText(campoTelefone(), '987654321');
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(enviados, ['987654321']);
  });

  testWidgets('submit no telefone sem onFieldSubmitted não lança',
      (tester) async {
    await pumpApp(tester, PhoneFormField());
    await tester.enterText(campoTelefone(), '987654321');
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('widgetValidator valida DDD obrigatório e celular válido',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    await pumpApp(
      tester,
      Form(
        key: formKey,
        child: PhoneFormField(widgetValidator: ValidatorImpl()),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('validation_required'), findsOneWidget);
    expect(find.text('validation_invalid_phone'), findsOneWidget);

    await tester.enterText(campoDDD(), '11');
    await tester.enterText(campoTelefone(), '987654321');
    await tester.pump();
    expect(formKey.currentState!.validate(), isTrue);
    await tester.pump();
    expect(find.text('validation_required'), findsNothing);
    expect(find.text('validation_invalid_phone'), findsNothing);
  });

  /// Corrigido: o builder renderiza `state.errorText` abaixo dos campos, no
  /// estilo de erro do tema, e o remove quando o valor volta a ser válido.
  testWidgets('validator externo invalida o Form e exibe a mensagem',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    await pumpApp(
      tester,
      Form(
        key: formKey,
        child: PhoneFormField(
          initialValue: '(11)987654321',
          validator: (v) => v == '(11)987654321' ? 'erro externo' : null,
        ),
      ),
    );

    expect(find.text('erro externo'), findsNothing);
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pumpAndSettle();
    expect(find.text('erro externo'), findsOneWidget);
    final erro = tester.widget<Text>(find.text('erro externo'));
    expect(erro.style?.color,
        Theme.of(tester.element(campoDDD())).colorScheme.error);

    await tester.enterText(campoTelefone(), '987654322');
    await tester.pump();
    expect(formKey.currentState!.validate(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('erro externo'), findsNothing);
  });

  testWidgets('golden com erro do validator externo', (tester) async {
    final formKey = GlobalKey<FormState>();
    await pumpApp(
      tester,
      Form(
        key: formKey,
        child: PhoneFormField(
          initialValue: '(11)987654321',
          validator: (_) => 'Telefone não permitido',
        ),
      ),
    );
    formKey.currentState!.validate();
    await tester.pumpAndSettle();
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/phone_form_field_error.png'),
    );
  });

  testWidgets('golden', (tester) async {
    await pumpApp(tester, PhoneFormField(initialValue: '(11)987654321'));
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/phone_form_field.png'),
    );
  });
}
