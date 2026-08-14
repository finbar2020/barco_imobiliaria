import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class ShowPDFWidget extends StatefulWidget {
  final String attachmentLink;
  const ShowPDFWidget({
    Key? key,
    required this.attachmentLink,
  }) : super(key: key);

  @override
  _ShowPDFWidgetState createState() => _ShowPDFWidgetState();
}

class _ShowPDFWidgetState extends State<ShowPDFWidget> {
  File? urlFile;
  Map<String, String>? customHeader;
  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  @override
  void initState() {
    super.initState();
    customHeader = authenticationStore.getCustomHeader();
    getPdf(urlFile).then(
      (value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(
            pdfFile: value,
            title: 'PDF Ocorrências',
            fileName:
                'ocorrencia_file_${DateFormat("yyyy_MM_dd_HH_mm_ss").format(DateTime.now())}.pdf',
            canDownload: true,
            headers: customHeader,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    ));
  }

  Future<File> getPdf(File? file) async {
    var getFile = await DefaultCacheManager().getSingleFile(
      widget.attachmentLink,
    );
    // var fileName =
    //     'ocorrencia_file_${DateFormat("yyyy_MM_dd_HH_mm_ss").format(DateTime.now())}.pdf';
    // var dir = await getApplicationDocumentsDirectory();
    // var newFile = getFile.copySync("${dir.path}/" + fileName);
    setState(() {
      file = getFile;
    });
    return getFile;

    // var fileName = 'ocorrencia_file';
    // var data = await http.get(Uri.parse(widget.attachmentLink));
    // var bytes = data.bodyBytes;
    // var dir = await getApplicationDocumentsDirectory();
    // File file = File("${dir.path}/" + fileName + ".pdf");
    // File urlFile = await file.writeAsBytes(bytes);
    // return urlFile;
  }
}
