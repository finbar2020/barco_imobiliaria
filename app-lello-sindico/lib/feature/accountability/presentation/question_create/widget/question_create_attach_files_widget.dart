import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/accountability/presentation/question_create/controller/question_create_controller.dart';
import 'package:path/path.dart';

class QuestionCreateAttachFilesWidget extends StatefulWidget {
  @override
  State<QuestionCreateAttachFilesWidget> createState() =>
      _QuestionCreateAttachFilesWidgetState();
}

class _QuestionCreateAttachFilesWidgetState
    extends State<QuestionCreateAttachFilesWidget> {
  final QuestionCreateController controller =
      ApplicationContainer.instance().resolve<QuestionCreateController>();
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          getString(context, "reports_attach_file"),
          style: LelloTextStyles.bodyBold(theme),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: Dimens.spacingMedium),
        Builder(
          builder: (context) {
            final files = controller.doubtSelected!.attachmentsFiles;
            if (files.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: Dimens.spacingMedium),
              child: Column(
                children: List.generate(
                  files.length,
                  (index) {
                    final file = files[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset("assets/ic_clips.svg"),
                            SizedBox(width: Dimens.spacingXSmall),
                            Expanded(
                              child: Text(
                                "${index + 1} - ${basename(file.path)}",
                                style: LelloTextStyles.bodyBold(theme),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: LelloTheme.palleteOf(theme)
                                        .background(),
                                    width: 3),
                                color: theme.primaryColor,
                              ),
                              child: IconButton(
                                  icon: SvgPicture.asset("assets/ic_close.svg",
                                      width: 3, height: 12),
                                  onPressed: () {
                                    controller.removeFile(index: index);
                                    setState(() {});
                                  }),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
        //TODO Insert List Attachment
        Row(
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
                    await controller.chooseImage(context,
                        source: ImageSource.gallery);
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                    getString(
                        context, "reports_request_pick_image_from_gallery"),
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
                    await controller.chooseImage(context,
                        source: ImageSource.camera);
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
                  onTap: () async {
                    await controller.chooseFile();
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(getString(context, "reports_create_attachment"),
                    style: LelloTextStyles.bodyBold(theme)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
