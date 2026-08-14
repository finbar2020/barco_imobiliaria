import 'dart:io';
import 'dart:ui';
import 'package:essentials/essentials.dart';
import 'package:flutter/foundation.dart';

class ImageProcessingService {
  Future<XFile> processImage(XFile originalFile, {Size? screenSize}) async {
    if (screenSize == null) return originalFile;

    if (kIsWeb) {
      return originalFile;
    }

    File image = await FlutterExifRotation.rotateImage(path: originalFile.path);

    return await cropFileByScreenSize(XFile(image.path), screenSize);
  }

  Future<XFile> cropFileByScreenSize(XFile file, Size screenSize) async {
    final bytes = await file.readAsBytes();
    final Image? image = decodeImage(bytes);

    if (image == null) return file;

    double screenSizewidth = screenSize.width - 40;
    double screenSizeheight = screenSize.height;

    var x = image.width / screenSizewidth;
    var y = image.height / screenSizeheight;

    double midWidth = screenSizewidth * x / 2;
    double midHeight = screenSizeheight * y / 2;

    double startWidth = 0;
    double startHeigth = 0;
    double size = 0;

    if (screenSizewidth < screenSizeheight) {
      //width menor
      size = screenSizewidth;
      startWidth = midWidth - size / 2;
      startHeigth = midHeight - size / 2;
    } else {
      size = screenSizeheight;
      startWidth = midWidth - size / 2;
      startHeigth = midHeight - size / 2;
    }

    var cropedImage = copyCrop(
      image,
      width: startWidth.floor(),
      height: startHeigth.floor(),
      x: size.floor(),
      y: size.floor(),
    );

    Uint8List bt = Uint8List.fromList(encodePng(cropedImage));
    return XFile.fromData(bt);
  }
}
