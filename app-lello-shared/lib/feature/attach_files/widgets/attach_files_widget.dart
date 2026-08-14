part of shared_features;

class AttachFilesWidget extends StatefulWidget {
  final bool showAttachment;
  final bool showCamera;
  final bool showGallery;
  final int? maxHeight;
  final int? maxWidth;
  final List<CropAspectRatioPreset> aspectRatioPresets;
  final CropStyle cropStyle;
  final int? maxFileSizePermitted;
  final bool allowMultiple;
  final SharedApplicationContainer appContainer;

  const AttachFilesWidget({
    Key? key,
    required this.appContainer,
    this.showAttachment = true,
    this.showCamera = true,
    this.showGallery = true,
    this.maxHeight,
    this.maxWidth,
    this.aspectRatioPresets = const [CropAspectRatioPreset.square],
    this.cropStyle = CropStyle.rectangle,
    this.maxFileSizePermitted,
    this.allowMultiple = false,
  }) : super(key: key);

  @override
  State<AttachFilesWidget> createState() => _AttachFilesWidgetState();
}

class _AttachFilesWidgetState extends State<AttachFilesWidget> {
  late ThemeData theme;

  bool _isColaboradorApp() {
    // Verifica se estamos no app colaborador através da cor primária carimbeira (#FFAB66)
    final theme = Theme.of(context);
    return theme.primaryColor.value == 0xFFFFAB66;
  }

  Future<void> _handleCameraPermission(AttachFilesStore store) async {
    // Verifica permissão de câmera antes de tentar usar
    bool hasPermission = await CheckPermissions.camera();
    if (!hasPermission) {
      // Direciona para tela de permissões com tema apropriado
      Navigator.of(context).pushNamed(
        SharedApplicationRoute.accessSettingsPermissionDenied,
        arguments: AcessSettingsPermissionDeniedPageArgs(
          acessSettingsPermissionsDeniedItem:
              AcessSettingsPermissionsDeniedItem(
            item: AcessSettingsPermissionsDeniedItemEnum.cam,
            isColaboradorApp: _isColaboradorApp(),
          ),
        ),
      );
      return;
    }

    store.chooseImage(
      context: context,
      imageSource: ImageSource.camera,
      maxHeight: widget.maxHeight,
      maxWidth: widget.maxWidth,
      aspectRatioPresets: widget.aspectRatioPresets,
      cropStyle: widget.cropStyle,
      maxFileSizePermitted: widget.maxFileSizePermitted,
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.appContainer.resolve<AttachFilesStore>();
    theme = Theme.of(context);
    return BlocConsumer<AttachFilesBloc, AttachFilesState>(
      bloc: store.bloc,
      listener: (context, state) {
        if (state is AttachFilesSuccessState) {
          Navigator.pop(context, state.files);
        } else if (state is AttachFilesEmptyState) {
          _showErrorToast(context,
              errorType: state.errorType,
              fileExtensions: state.fileExtension,
              fileName: state.fileName);
        }
      },
      builder: (context, state) {
        return Wrap(children: [
          Container(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.showAttachment)
                    _buildButton(
                        getString(context, "attachment", defaultText: "Anexo"),
                        "assets/doc_insert.svg", () {
                      store.chooseFile(
                          maxFileSizePermitted: widget.maxFileSizePermitted,
                          allowMultiple: widget.allowMultiple);
                    }),
                  SizedBox(width: Dimens.spacingLarge),
                  if (widget.showCamera)
                    _buildButton(
                        getString(context, "camera", defaultText: "Câmera"),
                        "assets/ic_camera.svg", () async {
                      await _handleCameraPermission(store);
                    }),
                  SizedBox(width: Dimens.spacingLarge),
                  if (widget.showGallery)
                    _buildButton(
                        getString(context, "gallery", defaultText: "Galeria"),
                        "assets/ic_gallery.svg", () {
                      store.chooseImage(
                        context: context,
                        imageSource: ImageSource.gallery,
                        maxHeight: widget.maxHeight,
                        maxWidth: widget.maxWidth,
                        aspectRatioPresets: widget.aspectRatioPresets,
                        cropStyle: widget.cropStyle,
                        maxFileSizePermitted: widget.maxFileSizePermitted,
                      );
                    })
                ],
              )),
        ]);
      },
    );
  }

  Widget _buildButton(String title, String image, VoidCallback onPressed) {
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

  void _showErrorToast(BuildContext context,
      {FileError? errorType, String? fileExtensions, String? fileName}) {
    if (errorType == null) {
      return null;
    }
    switch (errorType) {
      case FileError.protected:
        AttachFilesErrorToasts.showEncryptedFileError(
          context: context,
          fileName: fileName ?? "",
          fileExtension: fileExtensions ?? "",
        );
        break;
      case FileError.size:
        AttachFilesErrorToasts.showFileTooLargeError(
          context: context,
          fileName: fileName ?? "",
          fileExtension: fileExtensions ?? "",
          maxSizeMB: 10,
        );
        break;
      case FileError.unsupportedFormat:
        AttachFilesErrorToasts.showUnsupportedFormatError(
          context: context,
          fileName: fileName ?? "",
          fileExtension: fileExtensions ?? "",
        );
        break;
      case FileError.none:
        break;
    }
  }
}
