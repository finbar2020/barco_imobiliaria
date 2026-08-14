part of shared_features;

class AttachFilesBottomSheet {
  static Future<List<File>> show({
    required BuildContext context,
    required SharedApplicationContainer appContainer,
    bool showAttachment = true,
    bool showCamera = true,
    bool showGallery = true,
    int? maxHeight,
    int? maxWidth,
    int? maxFileSizePermitted,
    bool allowMultiple = false,
    List<CropAspectRatioPreset> aspectRatioPresets = const [
      CropAspectRatioPreset.square
    ],
    CropStyle cropStyle = CropStyle.rectangle,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      builder: (context) {
        return AttachFilesWidget(
          appContainer: appContainer,
          showAttachment: showAttachment,
          showCamera: showCamera,
          showGallery: showGallery,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          aspectRatioPresets: aspectRatioPresets,
          cropStyle: cropStyle,
          maxFileSizePermitted: maxFileSizePermitted,
          allowMultiple: allowMultiple,
        );
      },
    ).then((value) {
      if (value is List<File>) {
        return value;
      }
      return [];
    });
  }
}
