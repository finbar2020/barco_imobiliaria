import 'package:essentials/ui/widget/form_field/primary_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  TextField campo(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField));

  testWidgets('valores padrão: borda outline, sem contador, uma linha, ação next',
      (tester) async {
    await pumpApp(tester, PrimaryTextFormField());

    final tf = campo(tester);
    expect(tf.decoration!.border, isA<OutlineInputBorder>());
    expect(tf.decoration!.counterText, '');
    expect(tf.decoration!.hintText, '');
    expect(tf.decoration!.labelText, isNull);
    expect(tf.maxLines, 1);
    expect(tf.textInputAction, TextInputAction.next);
    expect(tf.inputFormatters, isEmpty);
    expect(tf.enabled, isTrue);
    expect(tf.maxLength, isNull);
    expect(tf.keyboardType, TextInputType.text);
  });

  testWidgets('multiline usa 5 linhas e enabled=false desabilita',
      (tester) async {
    await pumpApp(
      tester,
      PrimaryTextFormField(
        textInputType: TextInputType.multiline,
        enabled: false,
        initialValue: 'texto inicial',
      ),
    );
    final tf = campo(tester);
    expect(tf.maxLines, 5);
    expect(tf.enabled, isFalse);
    expect(tf.keyboardType, TextInputType.multiline);
    expect(find.text('texto inicial'), findsOneWidget);
  });

  testWidgets('hint, label, formatter, maxLength e callbacks', (tester) async {
    final mudancas = <String>[];
    final enviados = <String>[];
    String? salvo;
    var toques = 0;
    final formKey = GlobalKey<FormState>();
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await pumpApp(
      tester,
      Form(
        key: formKey,
        child: PrimaryTextFormField(
          key: const Key('campo'),
          focusNode: focusNode,
          hint: 'Digite aqui',
          labelText: 'Nome',
          formatter: FilteringTextInputFormatter.digitsOnly,
          maxLength: 4,
          action: TextInputAction.done,
          onChanged: mudancas.add,
          onFieldSubmitted: enviados.add,
          onSaved: (v) => salvo = v,
          onTap: () => toques++,
          validator: (v) => (v == null || v.isEmpty) ? 'obrigatório' : null,
        ),
      ),
    );

    expect(find.byKey(const Key('campo')), findsOneWidget);
    expect(find.text('Nome'), findsOneWidget);
    final tf = campo(tester);
    expect(tf.decoration!.hintText, 'Digite aqui');
    expect(tf.decoration!.labelText, 'Nome');
    expect(tf.maxLength, 4);
    expect(tf.textInputAction, TextInputAction.done);
    expect(tf.inputFormatters, hasLength(1));
    expect(tf.focusNode, same(focusNode));

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('obrigatório'), findsOneWidget);

    await tester.tap(find.byType(TextField));
    expect(toques, 1);

    await tester.enterText(find.byType(TextField), 'ab12cd345');
    await tester.pump();
    expect(mudancas, ['1234'], reason: 'só dígitos e no máximo 4');

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(enviados, ['1234']);

    expect(formKey.currentState!.validate(), isTrue);
    formKey.currentState!.save();
    expect(salvo, '1234');
  });

  testWidgets('aceita controller externo', (tester) async {
    final controller = TextEditingController(text: 'controlado');
    addTearDown(controller.dispose);
    await pumpApp(tester, PrimaryTextFormField(controller: controller));
    expect(find.text('controlado'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'novo');
    expect(controller.text, 'novo');
  });

  testWidgets('golden', (tester) async {
    await pumpApp(
      tester,
      Column(
        children: [
          PrimaryTextFormField(labelText: 'Nome', hint: 'Digite seu nome'),
          const SizedBox(height: 16),
          PrimaryTextFormField(initialValue: 'Maria da Silva'),
        ],
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/primary_text_form_field.png'),
    );
  });
}
