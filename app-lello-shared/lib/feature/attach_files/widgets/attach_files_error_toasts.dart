import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AttachFilesErrorToasts {
  /// Exibe um erro para arquivos criptografados
  static void showEncryptedFileError({
    required BuildContext context,
    required String fileName,
    required String fileExtension,
  }) {
    final theme = Theme.of(context);
    toastification.show(
        context: context,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(fileName,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
            Text(fileExtension,
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(width: Dimens.spacingXSmall),
            Text(
              getString(context, "payments_rejected_file"),
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ),
        description: Text(
          getString(context, "payments_protected_file_error"),
          style: theme.textTheme.bodyMedium,
        ),
        type: ToastificationType.error,
        dragToClose: false,
        showIcon: false,
        alignment: Alignment.topCenter,
        style: ToastificationStyle.minimal);
  }

  /// Exibe um erro para arquivos que excedem o tamanho máximo permitido
  static void showFileTooLargeError({
    required BuildContext context,
    required String fileName,
    required String fileExtension,
    required int maxSizeMB,
  }) {
    final theme = Theme.of(context);
    toastification.show(
        context: context,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                fileName,
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(fileExtension,
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(width: Dimens.spacingXSmall),
            Text(getString(context, "payments_rejected_file"),
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold))
          ],
        ),
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(context, "payments_files_size_error"),
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              getString(context, "payments_max_file_size"),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        type: ToastificationType.error,
        dragToClose: false,
        showIcon: false,
        alignment: Alignment.topCenter,
        style: ToastificationStyle.minimal);
  }

  /// Exibe um erro para arquivos que excedem o tamanho máximo permitido
  static void showUnsupportedFormatError({
    required BuildContext context,
    required String fileName,
    required String fileExtension,
  }) {
    final theme = Theme.of(context);
    toastification.show(
        context: context,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                fileName,
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(fileExtension,
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(width: Dimens.spacingXSmall),
            Text(getString(context, 'payments_rejected_file'),
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold))
          ],
        ),
        description: Text(getString(context, 'payments_file_type_error'),
            style: theme.textTheme.bodyMedium),
        type: ToastificationType.error,
        dragToClose: false,
        showIcon: false,
        alignment: Alignment.topCenter,
        style: ToastificationStyle.minimal);
  }

  /// Exibe um erro genérico para arquivos
  static void showGenericFileError({
    required BuildContext context,
    required String errorMessage,
  }) {
    toastification.show(
        context: context,
        title: Text(
          'Erro ao anexar arquivo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        description: Text(
          errorMessage,
          style: TextStyle(color: Colors.black),
        ),
        type: ToastificationType.error,
        dragToClose: false,
        showIcon: false,
        alignment: Alignment.topCenter,
        style: ToastificationStyle.minimal);
  }

  /// Exibe um erro genérico para arquivos
  static void showGenericError({
    required BuildContext context,
    required String errorTitle,
    required String errorMessage,
    Duration? autoCloseDuration,
  }) {
    toastification.show(
      context: context,
      title: Text(
        errorTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        errorMessage,
        style: TextStyle(color: Colors.black),
      ),
      type: ToastificationType.error,
      dragToClose: false,
      showIcon: false,
      alignment: Alignment.topCenter,
      style: ToastificationStyle.minimal,
      autoCloseDuration: autoCloseDuration,
    );
  }
}
