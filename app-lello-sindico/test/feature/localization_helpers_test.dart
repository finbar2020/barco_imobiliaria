import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreement_analysis_type.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis_element.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_finished.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_refused.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_quote.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';

class _TestLoc extends AppLocalization {
  _TestLoc() : super(const Locale('pt', 'BR'));

  @override
  String? translate(String key) => key;
}

class _TestLocDelegate extends LocalizationsDelegate<AppLocalization> {
  const _TestLocDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalization> load(Locale locale) async => _TestLoc();

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) =>
      false;
}

void main() {
  testWidgets('TaskStatusType e TaskType cobrem cores da paleta Lello',
      (tester) async {
    late Color completed;
    late Color pending;
    late Color inProgress;
    late Color routine;
    late Color serviceOrder;

    await tester.pumpWidget(
      MaterialApp(
        theme: LelloTheme.light,
        home: Builder(
          builder: (context) {
            final theme = Theme.of(context);
            completed = TaskStatusType.completed.color(theme);
            pending = TaskStatusType.pending.color(theme);
            inProgress = TaskStatusType.inProgress.color(theme);
            routine = TaskType.routine.color(theme);
            serviceOrder = TaskType.serviceOrder.color(theme);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(completed, isA<Color>());
    expect(pending, isA<Color>());
    expect(inProgress, isA<Color>());
    expect(routine, isA<Color>());
    expect(serviceOrder, const Color(0xFFE5073E));
    expect(
      TaskSummaryData(
        totalTasks: 3,
        statuses: [
          TaskStatus(status: TaskStatusType.pending, count: 1),
          TaskStatus(status: TaskStatusType.inProgress, count: 1),
          TaskStatus(status: TaskStatusType.completed, count: 1),
        ],
      ).statuses,
      hasLength(3),
    );
  });

  testWidgets('getString fake cobre meses, morador, relatório e gráficos',
      (tester) async {
    late List<String> months;
    late List<String> names;
    late List<String> accesses;

    await tester.pumpWidget(
      MaterialApp(
        theme: LelloTheme.light,
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: const [
          _TestLocDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) {
            final theme = Theme.of(context);
            months = [
              for (var month = 1; month <= 12; month++) ...[
                AgreementQuote(dueDate: DateTime(2026, month, 10))
                    .getMonthYear(context),
                Agreement(approvalDate: DateTime(2026, month, 10))
                    .getDateMonthWritten(context),
              ],
              Agreement(proposaldedDate: DateTime(2026, 4, 10))
                  .getDateMonthWritten(context, onlyMonthYear: true),
              Agreement().getDateMonthWritten(context),
              AgreementQuote().getMonthYear(context),
            ];
            names = [
              for (final status in TaskStatusType.values)
                '${status.name(context)}|${status.statusLabel(context)}',
              TaskType.routine.name(context),
              TaskType.serviceOrder.name(context),
            ];
            accesses = [
              for (final access in [
                'morar.proprietario',
                'morar.restrito',
                'morar.parcial',
                'morar.morador',
                'morar.inquilino',
                'outro',
              ])
                Resident(typeAccess: access).access(context) ?? 'vazio',
            ];
            AgreementsFinished(
              agreementsPerformedAutomaticallyQtd: 1,
              agreementsManuallyApprovedQtd: 0,
              reportPaymentMethod: const [],
              reportInstallments: [
                AgreementsAnalysisElement(
                  description: '2',
                  value: 3,
                  percentage: 50,
                ),
              ],
              reportDueDate: const [],
            ).getReportInstallmentsForChart(context);
            AgreementsRefused(
              agreementsReprovedQtd: 1,
              reportReprovedReason: [
                AgreementsAnalysisElement(
                  description: AgreementAnalysisType.installmentQtd,
                  value: 1,
                  percentage: 40,
                ),
                AgreementsAnalysisElement(
                  description: AgreementAnalysisType.dueDate,
                  value: 1,
                  percentage: 60,
                ),
                AgreementsAnalysisElement(
                  description: 'x',
                  value: 1,
                  percentage: 0,
                ),
              ],
              reportInstallments: const [],
              reportDueDate: const [],
            ).getReportReprovedReasonChart(context);
            return Column(
              children: [
                Report(
                  newMessage: true,
                  reportContents: [ReportContents(id: '1')],
                ).getNewMessageWidget(context, theme),
                Report(
                  newMessage: true,
                  reportContents: [
                    ReportContents(id: '1'),
                    ReportContents(id: '2'),
                  ],
                ).getNewMessageWidget(context, theme),
                Report(newMessage: false).getNewMessageWidget(context, theme),
              ],
            );
          },
        ),
      ),
    );
    await tester.pump();

    expect(months.where((m) => m.contains('january')), isNotEmpty);
    expect(names, contains('task_type_routine'));
    expect(accesses.first, 'residents_owner');
    expect(accesses.last, 'vazio');
  });
}
