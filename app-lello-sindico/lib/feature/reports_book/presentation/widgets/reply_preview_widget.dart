import 'dart:io';

import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';

class ReplyPreviewWidget extends StatefulWidget {
  final Report report;
  final ReportContents content;
  final ThemeData theme;
  final File? attachment;

  const ReplyPreviewWidget({
    Key? key,
    required this.report,
    required this.content,
    required this.theme,
    this.attachment,
  }) : super(key: key);

  @override
  ReplyPreviewWidgetState createState() => ReplyPreviewWidgetState();
}

class ReplyPreviewWidgetState extends State<ReplyPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${getString(context, "reports_subject")}: ${getString(context, widget.report.getTypeReport)}",
          style: LelloTextStyles.subtitleBold(widget.theme),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          widget.content.getDate(),
          style: LelloTextStyles.subBody(widget.theme),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          getString(context, "reports_message"),
          style: LelloTextStyles.subtitleBold(widget.theme),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          widget.content.content != null && widget.content.content != ""
              ? widget.content.content!
              : getString(context, "reports_no_content"),
          style: LelloTextStyles.body(widget.theme),
        ),
        if (widget.content.content != null &&
            widget.content.attachmentFile != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Text(
                getString(context, 'reports_attached_file'),
                style: LelloTextStyles.bodyBold(widget.theme),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 10.0,
              ),
              if (widget.content.attachmentType != null &&
                  widget.content.attachmentType!.contains("application/pdf"))
                _buildImageItem(
                  onPressed: () => setState(() {
                    widget.content.attachmentFile = null;
                  }),
                  theme: widget.theme,
                  imageWidget: InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(
                              pdfFile: widget.content.attachmentFile!,
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
                ),
              if (widget.content.attachmentType != null &&
                  widget.content.attachmentType!.contains("image"))
                _buildImageItem(
                  onPressed: () => setState(() {
                    widget.content.attachmentFile = null;
                  }),
                  theme: widget.theme,
                  imageWidget: SizedBox(
                    height: 100,
                    width: 100,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return DetailScreenFile(
                              attachmentFile: widget.content.attachmentFile!,
                            );
                          },
                        ));
                      },
                      child: Hero(
                        tag: 'imageHero',
                        child: Image.file(
                          widget.content.attachmentFile!,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/ic_attachment_bold.svg",
                      height: 20,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      widget.content.attachmentFile!.path.split('/').last,
                      style: LelloTextStyles.bodyBold(widget.theme),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
      ],
    );
  }

  Widget _buildImageItem(
      {required ThemeData theme,
      required Widget imageWidget,
      required VoidCallback onPressed}) {
    const editBulletSize = 32.0;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Wrap(
        children: <Widget>[
          Stack(
            children: [
              imageWidget,
              Positioned(
                right: 0,
                bottom: 0,
                top: 0 - (editBulletSize * 2),
                child: Container(
                    width: editBulletSize,
                    height: editBulletSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: LelloTheme.palleteOf(theme).background(),
                          width: 3),
                      color: theme.primaryColor,
                    ),
                    child: IconButton(
                        icon: SvgPicture.asset("assets/ic_close.svg",
                            width: 3, height: 12),
                        onPressed: onPressed)),
              ),
            ],
          ),
          SizedBox(width: Dimens.spacingMedium)
        ],
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
