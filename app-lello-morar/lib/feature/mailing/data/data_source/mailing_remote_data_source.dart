import 'dart:typed_data';

import 'package:essentials/paginator/paginator_model.dart';

abstract class MailingRemoteDataSource {
  Future<PaginatorModel> getMailings(String unitId, {bool showAll = false});

  Future<Uint8List?> getPicture(String hash);
}
