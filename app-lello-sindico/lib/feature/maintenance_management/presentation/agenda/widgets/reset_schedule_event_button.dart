import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/schedule_events_bloc.dart';
import '../bloc/schedule_events_event.dart';
import '../bloc/schedule_events_state.dart';

/// Widget que fornece um botão para resetar um schedule event específico
/// Exemplo de uso:
/// ```dart
/// ResetScheduleEventButton(
///   scheduleEventId: 'EVENT_123',
///   onResetSuccess: () {
///     // Ação após sucesso (ex: mostrar snackbar, navegar de volta)
///     ScaffoldMessenger.of(context).showSnackBar(
///       const SnackBar(content: Text('Schedule event resetado com sucesso!')),
///     );
///   },
///   onResetError: (message) {
///     // Ação após erro (ex: mostrar dialog de erro)
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text('Erro: $message')),
///     );
///   },
/// )
/// ```
class ResetScheduleEventButton extends StatelessWidget {
  final String scheduleEventId;
  final VoidCallback? onResetSuccess;
  final Function(String message)? onResetError;
  final String? buttonText;
  final IconData? icon;
  final ButtonStyle? buttonStyle;

  const ResetScheduleEventButton({
    Key? key,
    required this.scheduleEventId,
    this.onResetSuccess,
    this.onResetError,
    this.buttonText,
    this.icon,
    this.buttonStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleEventsBloc, ScheduleEventsState>(
      listenWhen: (previous, current) {
        // Só escuta mudanças relacionadas ao reset
        return current is ResetScheduleEventSuccessState ||
            current is ResetScheduleEventErrorState;
      },
      listener: (context, state) {
        if (state is ResetScheduleEventSuccessState) {
          onResetSuccess?.call();
        } else if (state is ResetScheduleEventErrorState) {
          onResetError?.call(state.message);
        }
      },
      child: BlocBuilder<ScheduleEventsBloc, ScheduleEventsState>(
        buildWhen: (previous, current) {
          // Só reconstrói quando o estado de reset muda
          return current is ResetScheduleEventLoadingState ||
              current is ResetScheduleEventSuccessState ||
              current is ResetScheduleEventErrorState;
        },
        builder: (context, state) {
          final isLoading = state is ResetScheduleEventLoadingState;

          return ElevatedButton.icon(
            onPressed: isLoading ? null : () => _onResetPressed(context),
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(icon ?? Icons.refresh),
            label: Text(
              isLoading ? 'Resetando...' : (buttonText ?? 'Resetar'),
            ),
            style: buttonStyle ??
                ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                ),
          );
        },
      ),
    );
  }

  void _onResetPressed(BuildContext context) {
    // Mostra dialog de confirmação antes de resetar
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar Reset'),
        content: const Text(
          'Tem certeza que deseja resetar este schedule event? '
          'Esta ação reiniciará o estado do evento agendado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Dispara o evento de reset no BLoC
              context.read<ScheduleEventsBloc>().add(
                    ResetScheduleEventEvent(scheduleEventId: scheduleEventId),
                  );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Resetar'),
          ),
        ],
      ),
    );
  }
}

/// Versão simplificada do botão para uso em listas ou cards
class CompactResetScheduleEventButton extends StatelessWidget {
  final String scheduleEventId;
  final VoidCallback? onResetSuccess;
  final Function(String message)? onResetError;

  const CompactResetScheduleEventButton({
    Key? key,
    required this.scheduleEventId,
    this.onResetSuccess,
    this.onResetError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleEventsBloc, ScheduleEventsState>(
      listenWhen: (previous, current) {
        return current is ResetScheduleEventSuccessState ||
            current is ResetScheduleEventErrorState;
      },
      listener: (context, state) {
        if (state is ResetScheduleEventSuccessState) {
          onResetSuccess?.call();
        } else if (state is ResetScheduleEventErrorState) {
          onResetError?.call(state.message);
        }
      },
      child: BlocBuilder<ScheduleEventsBloc, ScheduleEventsState>(
        buildWhen: (previous, current) {
          return current is ResetScheduleEventLoadingState;
        },
        builder: (context, state) {
          final isLoading = state is ResetScheduleEventLoadingState;

          return IconButton(
            onPressed: isLoading ? null : () => _onResetPressed(context),
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh, color: Colors.orange),
            tooltip: 'Resetar schedule event',
          );
        },
      ),
    );
  }

  void _onResetPressed(BuildContext context) {
    context.read<ScheduleEventsBloc>().add(
          ResetScheduleEventEvent(scheduleEventId: scheduleEventId),
        );
  }
}
