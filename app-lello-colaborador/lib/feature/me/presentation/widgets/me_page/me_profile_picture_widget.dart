import 'package:colaborador/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class MeProfilePictureWidget extends StatefulWidget {
  final MeBloc meBloc;
  const MeProfilePictureWidget({
    Key? key,
    required this.meBloc,
  }) : super(key: key);

  @override
  State<MeProfilePictureWidget> createState() => _MeProfilePictureWidgetState();
}

class _MeProfilePictureWidgetState extends State<MeProfilePictureWidget> {
  late ThemeData theme;
  final double editBulletSize = 32.0;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return Center(
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          width: 100.0,
          height: 100.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    Modal.showBottomSheet(
                        context: context, builder: (context) => _editImage());
                  });
                },
                child: CustomCachedNetworkImage(
                  link: widget.meBloc.state.me!.pictureLink,
                  errorImageAssetsPath: "assets/user_placeholder.svg",
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0 - (editBulletSize / 2),
          bottom: 0,
          top: 0,
          child: Container(
              width: editBulletSize,
              height: editBulletSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: LelloTheme.palleteOf(theme).background(), width: 3),
                color: LelloTheme.palleteOf(theme).primary(),
              ),
              child:
                  SvgPicture.asset("assets/ic_edit.svg", width: 3, height: 12)),
        ),
      ]),
    );
  }

  Widget _editImage() {
    return Wrap(children: [
      Container(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButtons(
                  getString(context, "camera"), "assets/ic_camera.svg", () {
                widget.meBloc.beginTakePhoto();
                Navigator.of(context).pop();
              }),
              SizedBox(width: Dimens.spacingLarge),
              _buildButtons(
                  getString(context, "gallery"), "assets/ic_upload.svg", () {
                widget.meBloc.beginPickImage();
                Navigator.of(context).pop();
              })
            ],
          )),
    ]);
  }

  Widget _buildButtons(String title, String image, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        children: [
          SvgPicture.asset(image, width: 45, height: 45),
          SizedBox(height: Dimens.spacingLarge),
          Text(title, style: LelloTextStyles.bodyBold(theme))
        ],
      ),
    );
  }
}
