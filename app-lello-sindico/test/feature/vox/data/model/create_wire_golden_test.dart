import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/vox/data/model/announcement_create_model.dart';
import 'package:lello/feature/vox/data/model/warning_create_model.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';

/// Golden de contrato de fio da CRIAÇÃO direta (advertência e comunicado).
/// Mesma disciplina do request: congela o JSON dos models antigos e prova que
/// os novos reproduzem a mesma forma de fio.

final occurrence = DateTime.utc(2026, 6, 20, 12, 0, 0);
const occurrenceWire = "2026-06-20T12:00:00.000Z";

final expectedWarningCreateWire = <String, dynamic>{
  "content": "PGgxPg==",
  "created_at": null,
  "description": "desc",
  "flag_email_body_attachment": false,
  "flag_email_distribution": true,
  "flag_print_distribution": false,
  "id": null,
  "model_id": "m1",
  "name": "Nome",
  "occurrence_date": occurrenceWire,
  "pages_quantity": null,
  "reason": "Barulho",
  "reason_id": "r1",
  "recipient_list": ["u1"],
  "recipient_type": 4,
  "single_copies_quantity": 2,
  "status": null,
  "unity_id": "u1",
};

final expectedAnnouncementCreateWire = <String, dynamic>{
  "template_id": "t1",
  "model_id": "m1",
  "title": "Titulo",
  "content": "PGgxPg==",
  "flag_email_distribution": true,
  "flag_print_distribution": false,
  "flag_overrride": true,
  "recipient_type": 3,
  "recipient_list": ["u1"],
  "flag_email_body_attachment": false,
  "single_copies_quantity": "5",
};

Map<String, dynamic> wire(Map<String, dynamic> toJson) =>
    jsonDecode(jsonEncode(toJson)) as Map<String, dynamic>;

void main() {
  group('Advertência CREATE — paridade de fio', () {
    test('WarningCreateModel reproduz o fio congelado', () {
      final model = WarningCreateModel()
        ..content = "PGgxPg=="
        ..description = "desc"
        ..flagEmailBodyAttachment = false
        ..flagEmailDistribution = true
        ..flagPrintDistribution = false
        ..modelId = "m1"
        ..name = "Nome"
        ..occurrenceDate = occurrence
        ..reason = "Barulho"
        ..reasonId = "r1"
        ..recipientList = ["u1"]
        ..recipientType = 4
        ..singleCopiesQuantity = 2
        ..unityId = "u1";
      expect(wire(model.toJson()), expectedWarningCreateWire);
    });

    test('WarningCreateModel.fromEntity encoda HTML e mapeia recipientType', () {
      final entity = DocumentRequest(
        content: "<h1>",
        recipientType: RecipientType.block,
      );
      final json = WarningCreateModel.fromEntity(entity).toJson();
      expect(json["content"], "PGgxPg==");
      expect(json["recipient_type"], 4);
    });
  });

  group('Comunicado CREATE — paridade de fio', () {
    test('AnnouncementCreateModel reproduz o fio congelado', () {
      final model = AnnouncementCreateModel()
        ..templateId = "t1"
        ..modelId = "m1"
        ..title = "Titulo"
        ..content = "PGgxPg=="
        ..flagEmailDistribution = true
        ..flagPrintDistribution = false
        ..flagOverride = true
        ..recipientType = 3
        ..recipientList = ["u1"]
        ..flagEmailBodyAttachment = false
        ..singleCopiesQuantity = "5";
      expect(wire(model.toJson()), expectedAnnouncementCreateWire);
    });

    test('AnnouncementCreateModel.fromEntity envia content base64 e NÃO envia content_html',
        () {
      final entity = DocumentRequest(
        content: "<h1>",
        singleCopiesQuantity: 5,
        recipientType: RecipientType.all,
      );
      final json = AnnouncementCreateModel.fromEntity(entity).toJson();
      expect(json["content"], "PGgxPg==");
      // O backend novo decodifica content_html como Base64; não enviamos.
      expect(json.containsKey("content_html"), false);
      expect(json["single_copies_quantity"], "5");
      expect(json["recipient_type"], 3);
    });
  });
}
