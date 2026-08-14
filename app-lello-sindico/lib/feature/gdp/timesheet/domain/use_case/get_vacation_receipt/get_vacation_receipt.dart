import 'dart:io';
import 'package:essentials/essentials.dart';

abstract class GetVacationReceipt
    extends UseCase<File, GetVacationReceiptParam> {}

class GetVacationReceiptParam {
  final String archiveName;

  GetVacationReceiptParam({required this.archiveName});
}
