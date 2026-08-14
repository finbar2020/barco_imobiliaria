import 'dart:io';

import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';
import 'package:morar/feature/reports_book/presentation/widgets/load_pdf_by_link.dart';

class ReportPreviewWidget extends StatelessWidget {
  final Report report;
  final ReportContents content;
  final ThemeData theme;
  final File? attachment;

  const ReportPreviewWidget({
    Key? key,
    required this.report,
    required this.content,
    required this.theme,
    this.attachment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getString(context, report.getTypeReport),
          style: LelloTextStyles.bodyBold(theme),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          report.getDate,
          style: LelloTextStyles.subBody(theme),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          child: Text(
            content.content != null && content.content != ""
                ? content.content!
                : getString(context, "reports_no_content"),
            style: LelloTextStyles.body(theme),
          ),
        ),
        if (content.attachmentLink != null || content.attachmentFile != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Text(
                getString(context, 'reports_attached_file'),
                style: LelloTextStyles.bodyBold(theme),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10.0,
              ),
              if (content.attachmentType != null &&
                  content.attachmentLink != null &&
                  content.attachmentType!.contains("application/pdf"))
                InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowPDFWidget(
                          attachmentLink: content.attachmentLink!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/ic_documents.svg",
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                ),
              if (content.attachmentType != null &&
                  content.attachmentLink == null &&
                  content.attachmentType!.contains("application/pdf"))
                InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFScreen(
                            pdfFile: content.attachmentFile!,
                            title: 'PDF Ocorrências'),
                      ),
                    );
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/ic_documents.svg",
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                ),
              if (content.attachmentType != null &&
                  content.attachmentLink != null &&
                  content.attachmentType!.contains("image"))
                Container(
                  height: 100,
                  width: 100,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return DetailScreenLink(
                            attachmentLink: content.attachmentLink!,
                            theme: theme,
                          );
                        },
                      ));
                    },
                    child: Hero(
                      tag: 'imageHero',
                      child: CachedNetworkImage(
                        imageUrl: content.attachmentLink!,
                        placeholder: (context, url) =>
                            new Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => new Center(
                          child: Text(
                            getString(context, "unable_to_load"),
                            style: LelloTextStyles.subBody(theme),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (content.attachmentType != null &&
                  content.attachmentLink == null &&
                  content.attachmentType!.contains("image"))
                Container(
                  height: 100,
                  width: 100,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return DetailScreenFile(
                            attachmentFile: content.attachmentFile!,
                          );
                        },
                      ));
                    },
                    child: Hero(
                      tag: 'imageHero',
                      child: Image.file(
                        content.attachmentFile!,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        SizedBox(height: 20.0),
        Text(
          getString(context, "reports_public"),
          style: LelloTextStyles.subtitleBold(theme),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: 10.0,
        ),
        content.public == false
            ? Text(
                getString(context, "no"),
                style: LelloTextStyles.subtitle(theme),
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                getString(context, "yes"),
                style: LelloTextStyles.subtitle(theme),
                overflow: TextOverflow.ellipsis,
              ),
      ],
    );
  }
}

class DetailScreenLink extends StatelessWidget {
  final String attachmentLink;
  final ThemeData theme;
  const DetailScreenLink({
    Key? key,
    required this.attachmentLink,
    required this.theme,
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
            child: CachedNetworkImage(
              imageUrl: attachmentLink,
              placeholder: (context, url) =>
                  new Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => new Center(
                child: Center(
                  child: Text(
                    getString(context, "unable_to_load"),
                    style: LelloTextStyles.subBody(theme),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
