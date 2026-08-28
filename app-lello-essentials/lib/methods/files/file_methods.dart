import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../app_localization.dart';
import '../../modal/pdf_viewer.dart';

class FileMethods {
  static void viewFile(
    BuildContext context,
    File file, {
    bool canDownload = false,
  }) {
    try {
      if (file.path.contains('.pdf')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(
                pdfFile: file, title: 'PDF', canDownload: canDownload),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailScreenFile(attachmentFile: file);
            },
          ),
        );
      }
    } catch (e) {
      // O Flushbar também precisa de Navigator; sem ele só registra o erro.
      if (Navigator.maybeOf(context) == null) {
        debugPrint('[FileMethods] viewFile error: $e');
        return;
      }
      showSnackBar(context,
          getString(context, "file_invalid", defaultText: "Arquivo inválido"));
    }
  }

  static Widget imageBody(
    BuildContext context,
    File file, {
    double? imageIconSize,
  }) {
    try {
      if (file.path.contains('.pdf')) {
        return IgnorePointer(
          child: Container(
            height: imageIconSize,
            width: imageIconSize,
            child: PdfViewer.file(
              file.path,
            ),
          ),
        );
      }
      return Container(
        height: imageIconSize,
        width: imageIconSize,
        child: Hero(
          tag: 'imageHero',
          child: Image.file(file),
        ),
      );
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(
            context,
            getString(context, "file_invalid",
                defaultText: "Arquivo inválido"));
      });
      return SvgPicture.asset("assets/ic_documents.svg");
    }
  }

  static void showSnackBar(BuildContext context, String text) {
    Flushbar(
      message: text,
      duration: Duration(seconds: 4),
    )..show(context);
  }

  static Future<File> getFileFromUrl(String url, {name, path}) async {
    var fileName = 'AppLelloFile';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = (await getApplicationDocumentsDirectory()).path;
      if (path != null) dir = path;
      File file = File("$dir/" + fileName);
      print(dir);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }
}

class DetailScreenFile extends StatelessWidget {
  final File attachmentFile;
  const DetailScreenFile({
    Key? key,
    required this.attachmentFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.file(
              attachmentFile,
            ),
          ),
        ),
      ),
    );
  }
}
