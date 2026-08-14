part of shared_features;

class RegistrationPicture extends StatefulWidget {
  final RegistrationStore store;
  final Validator validator;
  final bool isGeneric;
  final AppOriginEnum? appOriginEnum;

  const RegistrationPicture({
    Key? key,
    required this.store,
    required this.validator,
    this.isGeneric = false,
    this.appOriginEnum,
  }) : super(key: key);

  @override
  _RegistrationPictureState createState() => _RegistrationPictureState();
}

class _RegistrationPictureState extends State<RegistrationPicture> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    if (widget.isGeneric) {
      theme = LelloTheme.viverDefaultTheme;
    } else if (widget.appOriginEnum == AppOriginEnum.employee) {
      theme = LelloTheme.carimbeira;
    } else {
      theme = LelloTheme.lelloDefaultTheme;
    }
    final pallete = LelloTheme.palleteOf(theme);
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(getString(context, "registration_picture_title"),
                style: LelloTextStyles.title(theme)),
            SizedBox(height: Dimens.spacingLarge),
            Visibility(
              visible: widget.store.profilePicture == null,
              child: SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildButtons(theme, getString(context, "camera"),
                        "assets/ic_camera.svg", () {
                      widget.store.chooseImage(source: ImageSource.camera);
                    }),
                    Container(
                      margin: EdgeInsets.all(Dimens.spacing),
                      width: 2,
                      color: pallete.separator(),
                    ),
                    _buildButtons(theme, getString(context, "gallery"),
                        "assets/ic_upload.svg", () {
                      widget.store.chooseImage(source: ImageSource.gallery);
                    }),
                  ],
                ),
              ),
              replacement: _buildPreview(theme),
            ),
            SizedBox(height: Dimens.spacingLarge),
            PrimaryButton(
              buttonColor: theme.primaryColor,
              text: getString(context, "finish"),
              onPressed: () {
                next(false);
              },
            ),
            SizedBox(height: Dimens.spacing),
            TertiaryButton(
                text: getString(context, "do_this_later"),
                style: TextStyle(color: theme.primaryColor),
                onPressed: () {
                  next(true);
                })
          ]),
    );
  }

  Widget _buildPreview(ThemeData theme) {
    if (widget.store.profilePicture == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: FileImage(widget.store.profilePicture!),
              ),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacingMedium),
        SecondaryButton(
            text: getString(context, "edit"),
            onPressed: widget.store.profilePicture == null
                ? () {}
                : () {
                    widget.store.profilePicture = null;
                  })
      ],
    );
  }

  Widget _buildButtons(
      ThemeData theme, String title, String image, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        children: [
          SvgPicture.asset(image, width: 80, height: 80),
          SizedBox(height: Dimens.spacingLarge),
          Text(title, style: LelloTextStyles.bodyBold(theme))
        ],
      ),
    );
  }

  void next(bool clear) {
    if (clear) {
      widget.store.profilePicture = null;
    }

    widget.store.register();
  }
}
