import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/vox/data/model/document_template_model.dart';
import 'package:lello/feature/vox/data/model/fine_model.dart';
import 'package:lello/feature/vox/data/model/warning_model.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';

void main() {
  test('WarningModel fromJson/toJson/toDocument/toDetail', () {
    final parsed = WarningModel.fromJson({
      'id': 'w1',
      'name': 'Advertência',
      'description': 'desc',
      'content': 'YQ==',
      'status': 'OPEN',
      'pages_quantity': 2,
      'created_at': '2026-01-15',
      'flag_email_distribution': true,
      'flag_print_distribution': false,
      'flag_email_body_attachment': true,
      'reason': 'barulho',
      'reason_id': 'r1',
      'model_id': 'm1',
      'occurrence_date': '2026-01-10T00:00:00.000Z',
      'unity_id': 'u1',
      'recipient_type': 3,
      'single_copies_quantity': 3,
    });
    expect(parsed.name, 'Advertência');
    expect(parsed.toJson()['id'], 'w1');

    final document = parsed.toDocument();
    expect(document.id, 'w1');
    expect(document.reason, 'barulho');
    expect(document.recipientType, RecipientType.all);

    final detail = parsed.toDetail();
    expect(detail.id, 'w1');
    expect(detail.flagEmailDistribution, isTrue);
  });

  test('FineModel fromJson/toDocument/toDetail', () {
    final parsed = FineModel.fromJson({
      'id': 'f1',
      'name': 'Multa',
      'description': 'desc',
      'reason': 'atraso',
      'occurrence_date': '2026-02-01T00:00:00.000Z',
      'content': 'YQ==',
      'created_at': '2026-02-02T00:00:00.000Z',
      'flag_email_distribution': false,
      'flag_print_distribution': true,
      'pages_quantity': 1,
      'status': 'OPEN',
    });
    expect(parsed.toDocument().name, 'Multa');
    expect(parsed.toDetail().status, 'OPEN');
    expect(parsed.toJson()['id'], 'f1');
  });

  test('DocumentTemplateModel fromJson/toEntity', () {
    final parsed = DocumentTemplateModel.fromJson({
      'id': 't1',
      'name': 'Modelo',
      'description': 'desc',
      'group': 'g1',
      'thumbnail': 'https://img',
    });
    final entity = parsed.toEntity();
    expect(entity.id, 't1');
    expect(entity.name, 'Modelo');
    expect(parsed.toJson()['thumbnail'], 'https://img');
  });
}
