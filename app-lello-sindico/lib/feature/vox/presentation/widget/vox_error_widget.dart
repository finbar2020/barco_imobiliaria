import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';

/// Estado de erro padronizado das telas do vox: encapsula o
/// [ErrorHandlingWidget] padrão do app (com "tentar novamente"/"voltar" e o
/// detalhamento do erro fora de produção). Resolve o [Environment] do DI.
class VoxErrorWidget extends StatelessWidget {
  final Failure? error;
  final VoidCallback onRetry;
  final VoidCallback onBack;
  final bool showBackButton;

  VoxErrorWidget({
    Key? key,
    required this.error,
    required this.onRetry,
    required this.onBack,
    this.showBackButton = true,
  }) : super(key: key);

  final Environment _env =
      ApplicationContainer.instance().resolve<Environment>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: ErrorHandlingWidget(
        isProduction: _env.isProduction,
        showBackButton: showBackButton,
        reTryFunction: onRetry,
        backFunction: onBack,
        error: error?.error.toString() ?? "",
        errorCode: error?.code.toString() ?? "",
      ),
    );
  }
}
