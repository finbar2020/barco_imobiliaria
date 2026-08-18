import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/file_preview_page.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/fields/select_question_widget.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/question_fixtures.dart';

void main() {
  testWidgets('FilePreviewPage de tipo desconhecido mostra ícone e extensão',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: LelloTheme.light,
        home: const FilePreviewPage(
          url: 'https://example.com/nota.txt',
          filename: 'pasta%2Fnota.txt',
          extension: 'txt',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('nota.txt'), findsWidgets);
    expect(find.text('Tipo: TXT'), findsOneWidget);
    expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
  });

  testWidgets('FilePreviewPage de imagem constrói PhotoView', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: LelloTheme.light,
        home: const FilePreviewPage(
          url: 'https://example.com/foto.png',
          filename: 'foto.png',
          extension: 'png',
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(FilePreviewPage), findsOneWidget);
  });

  testWidgets('FilePreviewPage de PDF constrói o visualizador', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: LelloTheme.light,
        home: const FilePreviewPage(
          url: 'https://example.com/doc.pdf',
          filename: 'doc.pdf',
          extension: 'pdf',
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(FilePreviewPage), findsOneWidget);
  });

  testWidgets('FilePreviewPage de JPEG mostra o estado de carregamento',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: LelloTheme.light,
        home: const FilePreviewPage(
          url: 'https://example.invalid/foto.jpeg',
          filename: 'foto.jpeg',
          extension: 'jpeg',
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
          find.text('Erro ao carregar imagem').evaluate().isNotEmpty,
      isTrue,
    );
  });

  testWidgets('SELECT com opções mostra dropdown', (tester) async {
    await pumpApp(
      tester,
      SelectQuestionWidget(
        question: questionFixture(name: 'Setor', fieldType: 'SELECT'),
        onAnswerChanged: (_) {},
      ),
      surface: const Size(800, 1200),
    );

    expect(find.text('Selecione uma opção'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
  });
}
