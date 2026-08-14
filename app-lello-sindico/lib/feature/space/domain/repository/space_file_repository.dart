import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class SpaceFileRepository {
  Future<Try<String>> upload(String condominiumId, String spaceId, File file,
      StreamController<double> progress);
}
