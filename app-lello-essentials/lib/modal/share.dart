import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareText(String content, {Rect? sharePositionOrigin}) async {
  try {
    await Share.share(
      content,
      sharePositionOrigin: sharePositionOrigin,
    );
  } catch (ex) {
    debugPrint('[Share] shareText error: $ex');
  }
}

Future<void> shareFile(XFile content, {Rect? sharePositionOrigin}) async {
  try {
    await Share.shareXFiles(
      [content],
      sharePositionOrigin: sharePositionOrigin,
    );
  } catch (ex) {
    debugPrint('[Share] shareFile error: $ex');
  }
}
