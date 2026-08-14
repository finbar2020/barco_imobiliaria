import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';

class ReportMessageWidget extends StatefulWidget {
  final ThemeData theme;
  final ReportContents content;
  final ReportsController controller;
  final Report report;

  const ReportMessageWidget({
    Key? key,
    required this.theme,
    required this.content,
    required this.controller,
    required this.report,
  }) : super(key: key);

  @override
  _ReportMessageWidgetState createState() => _ReportMessageWidgetState();
}

class _ReportMessageWidgetState extends State<ReportMessageWidget> {
  bool publicEvent = true;
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    controller.text = widget.content.content ?? "";
    final theme = Theme.of(context);

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
                    getString(context, "reports_message"),
                    style: LelloTextStyles.subtitleBold(widget.theme),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Container(
                    height: 200.0,
                    child: TextField(
                      controller: controller,
                      maxLength: 700,
                      maxLines: 30,
                      onChanged: (value) {
                        widget.content.content = value;
                      },
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                          labelStyle: LelloTextStyles.subtitle(widget.theme),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: LelloTheme.palleteOf(theme).customColor(),
                          hintText: getString(context, 'reports_write_here')),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.report.idReport == null)
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          getString(context, "reports_public"),
                          style: LelloTextStyles.subtitleBold(widget.theme),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: Dimens.spacingSmall),
                        Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          padding: const EdgeInsets.all(15.0),
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          preferBelow: false,
                          showDuration: Duration(seconds: 5),
                          child: Icon(Icons.info_outline),
                          textStyle: LelloTextStyles.subtitle(widget.theme)!
                              .copyWith(color: Colors.white),
                          message: getString(context, "reports_public_tooltip"),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimens.spacing),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              publicEvent = true;
                            });
                            widget.content.public = true;
                          },
                          child: Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                      color: publicEvent
                                          ? LelloTheme.palleteOf(theme)
                                              .primary()
                                          : Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      border: Border.all(
                                          color: publicEvent
                                              ? LelloTheme.palleteOf(theme)
                                                  .primary()
                                              : LelloTheme.palleteOf(theme)
                                                  .hubText())),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: Dimens.spacingSmall),
                              Text(
                                getString(context, "yes"),
                                style: LelloTextStyles.subtitle(theme),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Dimens.spacing),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  publicEvent = false;
                                });
                                widget.content.public = false;
                              },
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                          color: publicEvent
                                              ? Colors.white
                                              : LelloTheme.palleteOf(theme)
                                                  .primary(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          border: Border.all(
                                              color: publicEvent
                                                  ? LelloTheme.palleteOf(theme)
                                                      .hubText()
                                                  : LelloTheme.palleteOf(theme)
                                                      .primary())),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Dimens.spacingSmall),
                                  Text(
                                    getString(context, "no"),
                                    style: LelloTextStyles.subtitle(theme),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      getString(context, "reports_attach_file"),
                      style: LelloTextStyles.subtitleBold(widget.theme),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  widget.content.attachmentFile == null
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
                                  onTap: () {
                                    widget.controller.beginPickImage(
                                        source: ImageSource.gallery,
                                        report: widget.report,
                                        content: widget.content);
                                  },
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                    getString(context,
                                        "reports_request_pick_image_from_gallery"),
                                    style:
                                        LelloTextStyles.bodyBold(widget.theme)),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  child: SvgPicture.asset(
                                    "assets/ic_camera_bold.svg",
                                    height: 32,
                                  ),
                                  onTap: () {
                                    widget.controller.beginPickImage(
                                        source: ImageSource.camera,
                                        report: widget.report,
                                        content: widget.content);
                                  },
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(getString(context, "reports_camera"),
                                    style:
                                        LelloTextStyles.bodyBold(widget.theme)),
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
                                    widget.controller.beginTakeFile(
                                        newReport: widget.report,
                                        content: widget.content);
                                  },
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                    getString(
                                        context, "reports_create_attachment"),
                                    style:
                                        LelloTextStyles.bodyBold(widget.theme)),
                              ],
                            ),
                          ],
                        )
                      : _buildImageItem(
                          widget.theme,
                          widget.content.attachmentFile!,
                          widget.content.attachmentType!),
                ],
              ),
            ),
            //Check is is a reply or new report
            if (widget.report.idReport != null)
              Padding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: PrimaryButton(
                  child: Text(
                    getString(context, "send"),
                    style: LelloTextStyles.button(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    ),
                  ),
                  onPressed: () {
                    if (widget.content.content != null &&
                        widget.content.content?.trim() != "") {
                      widget.controller
                          .sendReplyReport(widget.report, widget.content);
                    } else {
                      Flushbar(
                        message: getString(
                            context, "reports_empty_content_flushbar"),
                        duration: Duration(seconds: 5),
                      )..show(context);
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(
      ThemeData theme, File attachment, String attachmentType) {
    final editBulletSize = 32.0;
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Wrap(
        children: <Widget>[
          Stack(children: [
            attachmentType.contains("image")
                ? Container(
                    width: 100.0,
                    height: 100.0,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: FileImage(attachment)))),
                  )
                : Container(
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
                          widget.content.attachmentFile = null;
                        });
                      })),
            ),
          ]),
          SizedBox(width: Dimens.spacingMedium)
        ],
      ),
    );
  }
}
