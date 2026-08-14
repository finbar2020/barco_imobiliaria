import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lello/core/dependency/application_container.dart';
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
            headers: customHeader,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    ));
  }

  Future<File> getPdf(File? file) async {
    var fileName = 'ocorrencia_file';
    var data = await http.get(Uri.parse(widget.attachmentLink));
    var bytes = data.bodyBytes;
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$fileName.pdf");
    File urlFile = await file.writeAsBytes(bytes);
    setState(() {
      file = urlFile;
    });
    return urlFile;
  }
}
