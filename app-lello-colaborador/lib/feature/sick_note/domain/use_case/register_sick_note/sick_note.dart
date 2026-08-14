
import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:essentials/essentials.dart';

abstract class RegisterSickNoteUsecase
    extends UseCase<SickNoteEntity, RegisterSickNoteParam> {}

class RegisterSickNoteParam {
  final String condoId;
  final String meId;
  final SickNoteEntity sickNoteEntity;

  RegisterSickNoteParam({
    required this.condoId,
    required this.meId,
    required this.sickNoteEntity,
  });
}
