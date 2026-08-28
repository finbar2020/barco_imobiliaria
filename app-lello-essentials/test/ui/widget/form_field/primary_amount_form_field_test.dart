import 'package:essentials/ui/widget/form_field/primary_amount_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  TextField campo(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField));

  testWidgets('valores padrão: sem borda, sem contador, uma linha',
      (tester) async {
    await pumpApp(tester, PrimaryAmountFormField());

    final tf = campo(tester);
    expect(tf.decoration!.border, InputBorder.none);
    expect(tf.decoration!.counterText, '');
    expect(tf.decoration!.hintText, '');
    expect(tf.decoration!.hintStyle!.fontSize, isNull);
    expect(tf.style!.fontSize, isNull);
    expect(tf.maxLines, 1);
    expect(tf.textAlign, TextAlign.start);
    expect(tf.textInputAction, TextInputAction.next);
    expect(tf.inputFormatters, isEmpty);
    expect(tf.enabled, isTrue);
  });

  testWidgets('fontSize, textAlign, multiline, hint e enabled', (tester) async {
    await pumpApp(
      tester,
      PrimaryAmountFormField(
        fontSize: 28,
        textAlign: TextAlign.end,
        textInputType: TextInputType.multiline,
        hint: 'R\$ 0,00',
        enabled: false,
        initialValue: '10,00',
      ),
    );
    final tf = campo(tester);
    expect(tf.style!.fontSize, 28);
    expect(tf.decoration!.hintStyle!.fontSize, 28);
    expect(tf.decoration!.hintText, 'R\$ 0,00');
    expect(tf.textAlign, TextAlign.end);
    expect(tf.maxLines, 5);
    expect(tf.enabled, isFalse);
    expect(find.text('10,00'), findsOneWidget);
  });

  testWidgets('formatter, maxLength, callbacks e validação', (tester) async {
    final mudancas = <String>[];
    final enviados = <String>[];
    String? salvo;
    final formKey = GlobalKey<FormState>();
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await pumpApp(
      tester,
      Form(
        key: formKey,
        child: PrimaryAmountFormField(
          key: const Key('valor'),
          focusNode: focusNode,
          formatter: FilteringTextInputFormatter.digitsOnly,
          maxLength: 3,
          textInputType: TextInputType.number,
          action: TextInputAction.done,
          onChanged: mudancas.add,
          onFieldSubmitted: enviados.add,
          onSaved: (v) => salvo = v,
          validator: (v) => (v == null || v.isEmpty) ? 'informe' : null,
        ),
      ),
    );

    expect(find.byKey(const Key('valor')), findsOneWidget);
    final tf = campo(tester);
    expect(tf.keyboardType, TextInputType.number);
    expect(tf.maxLength, 3);
    expect(tf.inputFormatters, hasLength(1));
    expect(tf.focusNode, same(focusNode));

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('informe'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'R\$12345');
    await tester.pump();
    expect(mudancas, ['123']);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(enviados, ['123']);

    expect(formKey.currentState!.validate(), isTrue);
    formKey.currentState!.save();
    expect(salvo, '123');
  });

  testWidgets('aceita controller externo', (tester) async {
    final controller = TextEditingController(text: '99');
    addTearDown(controller.dispose);
    await pumpApp(tester, PrimaryAmountFormField(controller: controller));
    expect(find.text('99'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '100');
    expect(controller.text, '100');
  });

  testWidgets('golden', (tester) async {
    await pumpApp(
      tester,
      Column(
        children: [
          PrimaryAmountFormField(hint: 'R\$ 0,00', fontSize: 32),
          PrimaryAmountFormField(
            initialValue: 'R\$ 1.250,00',
            fontSize: 32,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/primary_amount_form_field.png'),
    );
  });
}
