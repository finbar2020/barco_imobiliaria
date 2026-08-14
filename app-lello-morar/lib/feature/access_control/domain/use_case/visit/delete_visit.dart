import 'package:essentials/essentials.dart';

abstract class DeleteVisit extends UseCase<String, DeleteVisitParam> {}

class DeleteVisitParam {
  final String recurrenceId;

  DeleteVisitParam({required this.recurrenceId});
}
