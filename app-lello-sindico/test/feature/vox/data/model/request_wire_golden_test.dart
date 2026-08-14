import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/vox/data/model/announcement_request_model.dart';
import 'package:lello/feature/vox/data/model/fine_request_model.dart';
import 'package:lello/feature/vox/data/model/warning_request_model.dart';
import 'package:lello/feature/vox/domain/entity/document_attachment.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';

/// Golden de contrato de fio das solicitações de documento (POST /requests/service).
///
/// Congela, byte-a-byte, o JSON que os models ATUAIS enviam hoje. A unificação
/// (branch melhorias-vox / item B) tem que reproduzir exatamente estes mapas —
/// incluindo dívidas técnicas deliberadamente preservadas (Q5):
///   * `flag_overrride` (typo de 3 erres) é a chave real esperada pelo backend.
///   * `single_copies_quantity` vai como String no comunicado e int na adv./multa.
///   * advertência/multa têm `occurrence_date`; comunicado não.
///   * multa tem `value` e não tem `reason`/`model`; advertência tem `reason`/`model`.
///
/// A comparação usa jsonDecode(jsonEncode(toJson())) para (a) ser independente da
/// ordem das chaves e (b) materializar os attachments aninhados como mapas reais.

/// Data fixa e determinística para `occurrence_date`.
final occurrence = DateTime.utc(2026, 6, 20, 12, 0, 0);
const occurrenceWire = "2026-06-20T12:00:00.000Z";

const attachmentWire = {
  "type": "application/pdf",
  "content": "YmFzZTY0",
  "name": "doc.pdf",
};

/// JSON de fio esperado — fonte da verdade compartilhada entre o baseline (models
/// atuais) e a verificação dos models unificados.
final expectedWarningWire = <String, dynamic>{
  "id": "w1",
  "service_id": "790850",
  "condominium_id": "c1",
  "unity_id": "u1",
  "content": "<h1>",
  "block": "A",
  "reason": "Barulho",
  "model": "m1",
  "recipient_list": ["r1", "r2"],
  "flag_email_distribution": true,
  "occurrence_date": occurrenceWire,
  "flag_print_distribution": false,
  "flag_overrride": true,
  "recipient_type": 4,
  "flag_email_body_attachment": false,
  "single_copies_quantity": 2,
  "user_id": "usr1",
  "attachments": [attachmentWire],
};

final expectedFineWire = <String, dynamic>{
  "id": "f1",
  "user_id": "usr1",
  "service_id": "790851",
  "condominium_id": "c1",
  "unity_id": "u1",
  "content": "<h1>",
  "block": "A",
  "recipient_list": ["r1"],
  "flag_email_distribution": true,
  "flag_print_distribution": false,
  "flag_overrride": true,
  "recipient_type": 5,
  "flag_email_body_attachment": false,
  "single_copies_quantity": 3,
  "attachments": [attachmentWire],
  "value": "150.00",
  "occurrence_date": occurrenceWire,
};

final expectedAnnouncementWire = <String, dynamic>{
  "id": "a1",
  "service_id": "790829",
  "condominium_id": "c1",
  "unity_id": "u1",
  // Comunicado tem título; na solicitação ele é embutido no content (texto
  // literal, sem Base64), pois o fio não tem campo de título separado.
  "content": "Aviso\nConteúdo: <h1>",
  "block": "A",
  "recipient_list": ["r1"],
  "flag_email_distribution": true,
  "flag_print_distribution": false,
  "flag_overrride": true,
  // 'todos' agora trafega como 3 (RecipientType.all). No fluxo de solicitação o
  // backend ignora recipient_type (usa block/units), então é inócuo aqui.
  "recipient_type": 3,
  "flag_email_body_attachment": false,
  "single_copies_quantity": "5",
  "attachments": [attachmentWire],
};

/// Normaliza para a forma final de fio (independente de ordem, attachments como mapas).
Map<String, dynamic> wire(Map<String, dynamic> toJson) =>
    jsonDecode(jsonEncode(toJson)) as Map<String, dynamic>;

void main() {
  group('Fio das solicitações — fromEntity reproduz o contrato congelado', () {
    // Anexo da entidade carrega bytes crus; o model encoda Base64.
    // utf8("base64") -> base64 "YmFzZTY0" (igual ao baseline).
    final attachment = DocumentAttachment(
      type: "application/pdf",
      bytes: Uint8List.fromList(utf8.encode("base64")),
      name: "doc.pdf",
    );
    // Conteúdo HTML puro; na solicitação trafega como texto puro (sem Base64),
    // fiel ao contrato antigo.
    const html = "<h1>";

    test('WarningRequestModel.fromEntity reproduz o fio congelado', () {
      final entity = DocumentRequest(
        id: "w1",
        userId: "usr1",
        condominiumId: "c1",
        unityId: "u1",
        content: html,
        block: "A",
        reason: "Barulho",
        model: "m1",
        recipientList: ["r1", "r2"],
        recipientType: RecipientType.block,
        flagEmailDistribution: true,
        occurrenceDate: occurrence,
        flagPrintDistribution: false,
        flagOverride: true,
        flagEmailBodyAttachment: false,
        singleCopiesQuantity: 2,
        attachments: [attachment],
      );

      expect(wire(WarningRequestModel.fromEntity(entity).toJson()),
          expectedWarningWire);
    });

    test('FineRequestModel.fromEntity reproduz o fio congelado', () {
      final entity = DocumentRequest(
        id: "f1",
        userId: "usr1",
        condominiumId: "c1",
        unityId: "u1",
        content: html,
        block: "A",
        recipientList: ["r1"],
        recipientType: RecipientType.units,
        flagEmailDistribution: true,
        flagPrintDistribution: false,
        flagOverride: true,
        flagEmailBodyAttachment: false,
        singleCopiesQuantity: 3,
        attachments: [attachment],
        value: "150.00",
        occurrenceDate: occurrence,
      );

      expect(
          wire(FineRequestModel.fromEntity(entity).toJson()), expectedFineWire);
    });

    test('AnnouncementRequestModel.fromEntity reproduz o fio congelado', () {
      final entity = DocumentRequest(
        id: "a1",
        condominiumId: "c1",
        unityId: "u1",
        content: html,
        title: "Aviso",
        block: "A",
        recipientList: ["r1"],
        recipientType: RecipientType.all,
        flagEmailDistribution: true,
        flagPrintDistribution: false,
        flagOverride: true,
        flagEmailBodyAttachment: false,
        singleCopiesQuantity: 5,
        attachments: [attachment],
      );

      expect(wire(AnnouncementRequestModel.fromEntity(entity).toJson()),
          expectedAnnouncementWire);
    });
  });
}
