import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/paginator/meta.dart';
import 'package:essentials/paginator/paginator.dart';
import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/billets/data/model/billet_found_model.dart';
import 'package:morar/feature/billets/data/model/billet_instructions_model.dart';
import 'package:morar/feature/billets/data/model/billet_model.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';
import 'package:morar/feature/billets/domain/entity/billet_found.dart';
import 'package:morar/feature/billets/domain/entity/billet_instructions.dart';
import 'package:morar/feature/billets/domain/entity/billet_status_enum.dart';
import 'package:morar/feature/billets/domain/repository/billets_repository.dart';
import 'package:morar/feature/billets/domain/use_case/billets_pdf_use_case.dart';
import 'package:morar/feature/billets/domain/use_case/billets_pdf_use_case_impl.dart';
import 'package:morar/feature/billets/domain/use_case/billets_use_case.dart';
import 'package:morar/feature/billets/domain/use_case/billets_use_case_impl.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';

class _FakeRepository extends Fake implements BilletsRepository {
  final calls = <List<Object?>>[];

  @override
  Future<Try<Paginator>> getBillets(String reference, String unitId,
      {bool showAll = false}) async {
    calls.add([reference, unitId, showAll]);
    return Success(Paginator(data: const [], meta: Meta(totalItems: 0)));
  }

  @override
  Future<Try<DocumentFile>> getPdf(String nrBillet) async {
    calls.add([nrBillet]);
    return Success(DocumentFile(name: 'b.pdf', data: 'YQ=='));
  }
}

void main() {
  group('Billet', () {
    test('vencido depende do status e da data', () {
      expect(Billet().vencido, isNull);
      final past = DateTime.now().subtract(const Duration(days: 3));
      final future = DateTime.now().add(const Duration(days: 3));
      expect(
        Billet(period: past, situation: BilletStatusEnum.pendente).vencido,
        isTrue,
      );
      expect(
        Billet(period: future, situation: BilletStatusEnum.pendente).vencido,
        isFalse,
      );
      expect(
        Billet(period: past, situation: BilletStatusEnum.baixado).vencido,
        isFalse,
      );
    });

    test('formata datas do vencimento', () {
      final billet = Billet(period: DateTime(2026, 3, 9));
      expect(billet.vencimentoMesDia, '09/03');
      expect(billet.vencimentoFullDate, DateFormat.yMd().format(DateTime(2026, 3, 9)));
      expect(billet.mes, 'March');
      expect(Billet().vencimentoMesDia, ' - ');
      expect(Billet().vencimentoFullDate, ' - ');
      expect(Billet().mes, ' - ');
    });

    test('statusText cobre todos os status', () {
      expect(Billet(situation: BilletStatusEnum.pendente).statusText,
          'income_billet_detail_situation_open');
      expect(Billet(situation: BilletStatusEnum.cancelado).statusText,
          'income_billet_detail_situation_canceled');
      expect(Billet(situation: BilletStatusEnum.baixado).statusText,
          'income_billet_detail_situation_paid_out');
      expect(Billet(situation: BilletStatusEnum.acordo).statusText,
          'income_billet_detail_situation_agreement');
      expect(Billet(situation: BilletStatusEnum.outros).statusText,
          'income_billet_detail_situation_other');
    });

    test('color segue a paleta do tema', () {
      final theme = LelloTheme.light;
      final pallete = LelloTheme.palleteOf(theme);
      expect(Billet(situation: BilletStatusEnum.pendente).color(theme),
          pallete.warning());
      expect(Billet(situation: BilletStatusEnum.cancelado).color(theme),
          theme.primaryColor);
      expect(Billet(situation: BilletStatusEnum.baixado).color(theme),
          pallete.success());
      expect(Billet(situation: BilletStatusEnum.acordo).color(theme),
          pallete.text());
    });

    test('dueDate e colorDueDate', () {
      final past = DateTime.now().subtract(const Duration(days: 3));
      final future = DateTime.now().add(const Duration(days: 3));
      final vencido = Billet(period: past, situation: BilletStatusEnum.pendente);
      final aVencer =
          Billet(period: future, situation: BilletStatusEnum.pendente);
      expect(vencido.dueDate, 'Vencido em ${vencido.vencimentoMesDia}');
      expect(vencido.colorDueDate, Colors.red);
      expect(aVencer.dueDate, 'Vence em ${aVencer.vencimentoMesDia}');
      expect(aVencer.colorDueDate, Colors.black);
      expect(Billet(situation: BilletStatusEnum.baixado).dueDate, '');
      expect(Billet(situation: BilletStatusEnum.baixado).colorDueDate,
          Colors.black);
    });

    test('BilletFound formata o valor', () {
      expect(BilletFound(value: 1234.5).valueFormatted, '1,234.50');
      expect(BilletFound().valueFormatted, endsWith('.00'));
    });
  });

  group('BilletModel', () {
    final json = {
      'id': 'b1',
      'value': 150.5,
      'period': '2026-03-09T00:00:00.000',
      'situation': 'pendente',
      'nr_billet': '123',
      'code': 'c',
      'notification_parameter': 'np',
      'name': 'Taxa',
      'is_duplicate': true,
      'founds': [
        {'description': 'd', 'value': 1.0}
      ],
      'instructions': {
        'late_billet': 'l',
        'second_billet': 's',
        'after_maturity': 'a',
      },
    };

    test('fromJson → toEntity → fromEntity → toJson', () {
      final model = BilletModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, 'b1');
      expect(entity.situation, BilletStatusEnum.pendente);
      expect(entity.period, DateTime(2026, 3, 9));
      expect(entity.founds.single.description, 'd');
      expect(entity.instructions!.lateBillet, 'l');
      expect(entity.isDuplicate, isTrue);

      final back = BilletModel.fromEntity(entity)!;
      expect(back.situation, 'pendente');
      expect(back.founds.single.value, 1.0);
      expect(back.instructions!.afterMaturity, 'a');
      final out = back.toJson();
      expect(out['nr_billet'], '123');
      expect(out['name'], 'Taxa');
      expect(BilletModel.fromEntity(null), isNull);
    });

    test('status desconhecido vira outros', () {
      expect(BilletModel(situation: 'xpto').toEntity().situation,
          BilletStatusEnum.outros);
      expect(BilletModel().toEntity().situation, BilletStatusEnum.outros);
    });

    test('modelos auxiliares', () {
      final found = BilletFoundModel.fromEntity(
          BilletFound(description: 'x', value: 2));
      expect(found.toJson(), {'description': 'x', 'value': 2.0});
      expect(BilletFoundModel.fromJson({'description': 'y'}).toEntity().description,
          'y');
      expect(BilletInstructionsModel.fromEntity(null), isNull);
      final instr = BilletInstructionsModel.fromEntity(
          BilletInstructions()..secondBillet = '2')!;
      expect(instr.toJson()['second_billet'], '2');
      expect(BilletInstructionsModel.fromJson({'late_billet': 'z'})
          .toEntity()
          .lateBillet, 'z');
    });
  });

  group('use cases', () {
    late _FakeRepository repository;

    setUp(() => repository = _FakeRepository());

    test('BilletsUseCaseImpl valida parâmetros', () async {
      final useCase = BilletsUseCaseImpl(repository: repository);
      final semRef = await useCase(BilletsParams(reference: '', unitId: 'u'));
      final semUnit = await useCase(BilletsParams(reference: 'r', unitId: ''));
      expect(semRef.fold((f) => f, (_) => null), isA<InvalidParamFailure>());
      expect(semUnit.fold((f) => f, (_) => null), isA<InvalidParamFailure>());
      expect(repository.calls, isEmpty);

      final ok = await useCase(
          BilletsParams(reference: 'r', unitId: 'u', showAll: true));
      expect(ok.fold((_) => null, (p) => p.meta!.totalItems), 0);
      expect(repository.calls.single, ['r', 'u', true]);
    });

    test('BilletsPdfUseCaseImpl valida parâmetros', () async {
      final useCase = BilletsPdfUseCaseImpl(repository: repository);
      final vazio = await useCase(BilletsPdfParams(nrBillet: ''));
      expect(vazio.fold((f) => f, (_) => null), isA<InvalidParamFailure>());
      final ok = await useCase(BilletsPdfParams(nrBillet: '9'));
      expect(ok.fold((_) => null, (d) => d.name), 'b.pdf');
      expect(repository.calls.single, ['9']);
    });
  });
}
