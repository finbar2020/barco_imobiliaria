import 'package:lello/feature/maintenance_management/domain/entity/event_details_entity.dart';

QuestionEntity questionFixture({
  String id = 'q1',
  String name = 'O equipamento está funcionando?',
  String fieldType = 'RADIO',
  bool required = true,
  List<OptionEntity>? options,
}) {
  return QuestionEntity(
    id: id,
    name: name,
    position: 1,
    formularyId: 'f1',
    hidden: false,
    required: required,
    createdAt: '2026-01-01T00:00:00Z',
    updatedAt: '2026-01-01T00:00:00Z',
    fieldType: fieldType,
    options: options ??
        [
          OptionEntity(
            id: 'opt-sim',
            name: 'Sim',
            position: 1,
            questionId: id,
            createdAt: '2026-01-01T00:00:00Z',
            updatedAt: '2026-01-01T00:00:00Z',
          ),
          OptionEntity(
            id: 'opt-nao',
            name: 'Não',
            position: 2,
            questionId: id,
            createdAt: '2026-01-01T00:00:00Z',
            updatedAt: '2026-01-01T00:00:00Z',
          ),
        ],
  );
}
