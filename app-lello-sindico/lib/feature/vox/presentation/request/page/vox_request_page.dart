import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/core/widget/success_page.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/vox/domain/entity/document_mode.dart';
import 'package:lello/feature/vox/domain/entity/document_step.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';
import 'package:lello/feature/vox/presentation/request/bloc/vox_request_bloc.dart';
import 'package:lello/feature/vox/presentation/request/bloc/vox_request_event.dart';
import 'package:lello/feature/vox/presentation/request/bloc/vox_request_state.dart';
import 'package:lello/feature/vox/presentation/request/widget/vox_data_step.dart';
import 'package:lello/feature/vox/presentation/request/widget/vox_review_step.dart';
import 'package:lello/feature/vox/presentation/request/widget/vox_text_step.dart';
import 'package:lello/feature/vox/presentation/widget/vox_error_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

/// Página única do wizard de solicitação (advertência/multa/comunicado).
/// Hospeda os passos via `state.step` e padroniza os estados (loading/erro/
/// enviando/sucesso). O [VoxRequestBloc] é provido pelo chamador (rota/DI).
class VoxRequestPage extends StatelessWidget {
  const VoxRequestPage({Key? key}) : super(key: key);

  static const _steps = [
    DocumentStep.data,
    DocumentStep.text,
    DocumentStep.review,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<VoxRequestBloc, VoxRequestState>(
      builder: (context, state) {
        final bloc = context.read<VoxRequestBloc>();
        // Sucesso ocupa a tela inteira (padrão: fundo verde, sem app bar).
        if (state.status == VoxRequestStatus.success) {
          return _successPage(context, state, bloc);
        }
        return WillPopScope(
          // Durante o envio, bloqueia todos os caminhos de voltar (gesto, botão
          // físico e a seta do app bar — que usa Navigator.maybePop).
          onWillPop: () async =>
              state.status == VoxRequestStatus.submitting ? false : bloc.goBack(),
          child: Scaffold(
            appBar: PrimaryAppBar(
              title: _title(state.type, bloc.mode),
              theme: theme,
              iconColor: theme.primaryColor,
            ),
            body: _body(context, state, bloc),
          ),
        );
      },
    );
  }

  Widget _body(
      BuildContext context, VoxRequestState state, VoxRequestBloc bloc) {
    switch (state.status) {
      case VoxRequestStatus.loading:
        return const Center(child: LoadingWidget());
      case VoxRequestStatus.success:
        // Tratado em build() como tela cheia (sem app bar).
        return const SizedBox.shrink();
      case VoxRequestStatus.failure:
        return VoxErrorWidget(
          error: state.error,
          onRetry: () => bloc.add(const VoxStartedEvent()),
          onBack: () => Navigator.of(context).pop(),
        );
      case VoxRequestStatus.ready:
      case VoxRequestStatus.submitting:
        return _wizard(context, state, bloc);
    }
  }

  Widget _wizard(
      BuildContext context, VoxRequestState state, VoxRequestBloc bloc) {
    final submitting = state.status == VoxRequestStatus.submitting;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(Dimens.spacing),
          child: StepIndicator(
            numberOfSteps: _steps.length,
            currentStep: _steps.indexOf(state.step),
          ),
        ),
        Expanded(child: _stepBody(context, state, bloc)),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacing),
            child: Row(
              children: [
                if (state.step != DocumentStep.data) ...[
                  Expanded(
                    child: SecondaryButton(
                      text: "Voltar",
                      onPressed: submitting ? null : () => bloc.goBack(),
                    ),
                  ),
                  SizedBox(width: Dimens.spacing),
                ],
                Expanded(
                  child: PrimaryButton(
                    text: submitting
                        ? null
                        : (state.step == DocumentStep.review
                            ? "Enviar"
                            : "Avançar"),
                    onPressed: (submitting || !_canAdvance(state, bloc.mode))
                        ? null
                        : () {
                            if (state.step == DocumentStep.review) {
                              bloc.add(const VoxSubmittedEvent());
                            } else {
                              bloc.goNext();
                            }
                          },
                    child: submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepBody(
      BuildContext context, VoxRequestState state, VoxRequestBloc bloc) {
    void onChanged() => bloc.add(const VoxFieldChangedEvent());
    switch (state.step) {
      case DocumentStep.data:
        return VoxDataStep(
          type: state.type,
          mode: bloc.mode,
          request: state.request,
          reasons: state.reasons,
          templates: state.templates,
          onChanged: onChanged,
        );
      case DocumentStep.text:
        final isRequest = bloc.mode == DocumentMode.request;
        return VoxTextStep(
          request: state.request,
          onChanged: onChanged,
          plainText: isRequest,
          showAttachments: isRequest,
        );
      case DocumentStep.review:
        return VoxReviewStep(
          request: state.request,
          plainText: bloc.mode == DocumentMode.request,
        );
    }
  }

  /// Habilita o "Avançar"/"Enviar" só quando o passo está preenchido.
  bool _canAdvance(VoxRequestState state, DocumentMode mode) {
    switch (state.step) {
      case DocumentStep.data:
        return _dataValid(state, mode);
      case DocumentStep.text:
        final content = state.request.content ?? "";
        return content.replaceAll(RegExp(r'<[^>]*>'), '').trim().isNotEmpty;
      case DocumentStep.review:
        return true;
    }
  }

  bool _dataValid(VoxRequestState state, DocumentMode mode) {
    final request = state.request;
    final type = state.type;
    if (type.hasReasons && (request.reason ?? "").isEmpty) return false;
    if (type.hasValue && (request.value ?? "").trim().isEmpty) return false;
    if (type.hasTitle && (request.title ?? "").trim().isEmpty) return false;
    if (type.hasRecipientTypeSelector) {
      if (request.recipientType == null) return false;
      if (request.recipientType != RecipientType.all &&
          request.recipientListMap.isEmpty) return false;
    } else if (request.recipientListMap.isEmpty) {
      return false;
    }
    // Solicitação: ao menos uma forma de distribuição deve estar marcada.
    if (mode == DocumentMode.request &&
        request.flagEmailDistribution != true &&
        request.flagPrintDistribution != true) {
      return false;
    }
    return true;
  }

  Widget _successPage(
      BuildContext context, VoxRequestState state, VoxRequestBloc bloc) {
    final sessionBloc = ApplicationContainer.instance().resolve<SessionBloc>();
    final condominium = sessionBloc.state.session?.selectedCondominium;
    return SuccessPage(
      title: _successTitle(state.type, bloc.mode),
      subtitle: (condominium != null && condominium.name != null)
          ? "${condominium.name} - ${condominium.reference}"
          : null,
      buttonText: "Concluir",
      onPressed: () => Navigator.of(context).pop(true),
    );
  }

  /// Mensagem de sucesso por modo/tipo (mantém a concordância em português).
  String _successTitle(DocumentType type, DocumentMode mode) {
    if (mode == DocumentMode.create) {
      switch (type) {
        case DocumentType.warning:
          return "Advertência criada com sucesso!";
        case DocumentType.fine:
          return "Multa criada com sucesso!";
        case DocumentType.announcement:
          return "Comunicado criado com sucesso!";
      }
    }
    return "Solicitação enviada com sucesso!";
  }

  String _title(DocumentType type, DocumentMode mode) {
    final verb = mode == DocumentMode.create ? "Criar" : "Solicitar";
    switch (type) {
      case DocumentType.warning:
        return "$verb advertência";
      case DocumentType.fine:
        return "$verb multa";
      case DocumentType.announcement:
        return "$verb comunicado";
    }
  }
}
