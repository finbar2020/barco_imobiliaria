import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../ui/app_theme.dart';
import '../../ui/dimens.dart';
import 'file_methods.dart';

class FileIcon extends StatelessWidget {
  final File file;
  final VoidCallback? deleteFile;
  final double? imageIconSize;
  final canDownloadFile;
  const FileIcon({
    Key? key,
    required this.file,
    this.deleteFile,
    this.imageIconSize,
    this.canDownloadFile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editBulletSize = 32.0;
    ThemeData theme = Theme.of(context);
    return Wrap(
      children: <Widget>[
        Stack(
          children: [
            InkWell(
              onTap: () async {
                FileMethods.viewFile(context, file,
                    canDownload: canDownloadFile);
              },
              child: FileMethods.imageBody(
                context,
                file,
                imageIconSize: imageIconSize,
              ),
            ),
            if (deleteFile != null)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                    width: editBulletSize,
                    height: editBulletSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: LelloTheme.palleteOf(theme).background(),
                          width: 3),
                      color: LelloTheme.palleteOf(theme).primary(),
                    ),
                    child: IconButton(
                        icon: SvgPicture.asset("assets/ic_close.svg",
                            width: 3, height: 12),
                        onPressed: deleteFile)),
              ),
          ],
        ),
        SizedBox(width: Dimens.spacingMedium)
      ],
    );
  }
}
