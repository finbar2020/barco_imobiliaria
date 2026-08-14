import 'dart:io';

import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/reports_book/presentation/widgets/load_pdf_by_link.dart';

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
        report.getNewMessageWidget(context, theme),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          getString(context, report.getTypeReport),
          style: LelloTextStyles.bodyBold(theme),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          report.getDate(),
          style: LelloTextStyles.subBody(theme),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 10.0,
        ),
        if (report.residentsName != null)
          Text(
            "Condômino: ${report.residentsName}",
            style: LelloTextStyles.bodyBold(theme),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(
          height: 5.0,
        ),
        if (report.unit?.name != null)
          Text(
            "Unidade: ${report.unit!.name}",
            style: LelloTextStyles.bodyBold(theme),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          content.content != null && content.content != ""
              ? content.content!
              : getString(context, "reports_no_content"),
          style: LelloTextStyles.body(theme),
        ),
        if (content.content != null &&
            (content.attachmentLink != null || content.attachmentFile != null))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Text(
                getString(context, 'reports_attached_file'),
                style: LelloTextStyles.bodyBold(theme),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
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
                  child: SizedBox(
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
                  child: SizedBox(
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
                SizedBox(
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
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Center(
                          child: Text(
                            "Não foi possível carregar",
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
                SizedBox(
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
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Center(
                child: Center(
                  child: Text(
                    "Não foi possível carregar",
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
