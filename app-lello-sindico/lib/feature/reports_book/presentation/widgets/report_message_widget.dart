import 'dart:io';

import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/reports_book/presentation/controller/report_controller.dart';

class ReportMessageWidget extends StatefulWidget {
  final ReportContents content;
  final Report report;

  const ReportMessageWidget({
    super.key,
    required this.content,
    required this.report,
  });

  @override
  ReportMessageWidgetState createState() => ReportMessageWidgetState();
}

class ReportMessageWidgetState extends State<ReportMessageWidget> {
  final ReportController reportController =
      ApplicationContainer.instance().resolve<ReportController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController textController = TextEditingController();
    textController.text = reportController.content ?? "";

    return DismissKeyboard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${getString(context, "reports_subject")}: ${getString(context, widget.report.getTypeReport)}",
                    style: LelloTextStyles.subtitleBold(theme),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    widget.content.getDate(),
                    style: LelloTextStyles.subBody(theme),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    getString(context, "reports_message"),
                    style: LelloTextStyles.subtitleBold(theme),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  SizedBox(
                    height: 200.0,
                    child: TextField(
                      controller: textController,
                      maxLength: 700,
                      maxLines: 30,
                      onChanged: (value) {
                        reportController.content = textController.text;
                      },
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                          labelStyle: LelloTextStyles.subtitle(theme),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: getString(context, 'reports_reply_hint')),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    getString(context, "reports_attach_file"),
                    style: LelloTextStyles.subtitleBold(theme),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                reportController.attachmentFile == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                child: SvgPicture.asset(
                                  "assets/ic_photo_bold.svg",
                                  height: 32,
                                ),
                                onTap: () async {
                                  await reportController.chooseImage(
                                      imageSource: ImageSource.gallery,
                                      context: context);
                                  setState(() {});
                                },
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                  getString(context,
                                      "reports_request_pick_image_from_gallery"),
                                  style: LelloTextStyles.bodyBold(theme)),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                child: SvgPicture.asset(
                                  "assets/ic_camera_bold.svg",
                                  height: 32,
                                ),
                                onTap: () async {
                                  await reportController.chooseImage(
                                      imageSource: ImageSource.camera,
                                      context: context);
                                  setState(() {});
                                },
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(getString(context, "reports_camera"),
                                  style: LelloTextStyles.bodyBold(theme)),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                child: SvgPicture.asset(
                                  "assets/ic_attachment_bold.svg",
                                  height: 32,
                                ),
                                onTap: () {
                                  reportController.chooseFile();
                                },
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                  getString(
                                      context, "reports_create_attachment"),
                                  style: LelloTextStyles.bodyBold(theme)),
                            ],
                          ),
                        ],
                      )
                    : _buildImageItem(theme, reportController.attachmentFile!,
                        reportController.attachmentType!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(
      ThemeData theme, File attachment, String attachmentType) {
    const editBulletSize = 32.0;
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Wrap(
        children: <Widget>[
          Stack(
            children: [
              attachmentType.contains("image")
                  ? SizedBox(
                      height: 100,
                      width: 100,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return DetailScreenFile(
                                attachmentFile: reportController
                                    .reportContents!.attachmentFile!,
                              );
                            },
                          ));
                        },
                        child: Hero(
                          tag: 'imageHero',
                          child: Image.file(
                            reportController.attachmentFile!,
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFScreen(
                                pdfFile: reportController.attachmentFile!,
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
                        onPressed: () {
                          setState(() {
                            reportController.attachmentFile = null;
                          });
                        })),
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
    super.key,
    required this.attachmentFile,
  });

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
