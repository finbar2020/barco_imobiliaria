import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class ProfilePictureRepository {
  Future<Try<String>> upload(
    File file, {
    required Function(String) onComplete,
    required Function(Exception) onError,
  });
}
