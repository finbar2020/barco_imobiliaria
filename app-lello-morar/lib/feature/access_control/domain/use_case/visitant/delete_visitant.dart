import 'package:essentials/essentials.dart';

abstract class DeleteVisitant extends UseCase<String, DeleteVisitantParam> {}

class DeleteVisitantParam {
  final String gestId;

  DeleteVisitantParam({required this.gestId});
}
