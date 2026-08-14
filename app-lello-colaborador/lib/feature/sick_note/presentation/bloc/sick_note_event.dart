import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:essentials/essentials.dart';

abstract class SickNoteEvent extends Equatable {
  const SickNoteEvent();

  @override
  List<Object?> get props => [];
}

class SendSickNoteEvent extends SickNoteEvent {
  final SickNoteEntity sickNoteEntity;
  const SendSickNoteEvent({
    required this.sickNoteEntity,
  });

  @override
  List<Object?> get props => [sickNoteEntity];
}
