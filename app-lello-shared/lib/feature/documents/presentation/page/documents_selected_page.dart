import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/documents/domain/entity/documents.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_state.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_controller.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_selected_info_page.dart';
import 'package:shared_features/feature/documents/presentation/widget/documents_card_widget.dart';

/// Lista de documentos de um tipo (parametrizada). Substitui as telas
/// duplicadas por categoria. Navega para o detalhe via `MaterialPageRoute`.
class DocumentsSelectedPage extends StatefulWidget {
  final DocumentsController controller;

  /// Chave de localização do tipo (ex.: "documents_minutes").
  final String title;

  /// Deep-link opcional: id/parâmetro do documento a abrir automaticamente.
  final String? notificationContext;

  const DocumentsSelectedPage({
    Key? key,
    required this.controller,
    required this.title,
    this.notificationContext,
  }) : super(key: key);

  @override
  State<DocumentsSelectedPage> createState() => _DocumentsSelectedPageState();
}

class _DocumentsSelectedPageState extends State<DocumentsSelectedPage> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isRevalidationSpinnerShown = false;
  bool _didKickoff = false;
  String? _pendingNotificationContext;

  @override
  void initState() {
    super.initState();
    _pendingNotificationContext = widget.notificationContext;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = widget.controller;
    final appBarTitle = widget.title;
    if (!_didKickoff) {
      _didKickoff = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) controller.getDocs(appBarTitle);
      });
    }
    return Theme(
      data: theme,
      child: BlocBuilder(
        bloc: controller.bloc,
        buildWhen: (previous, current) =>
            isListAffectingState(current as DocumentsState),
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: appBarTitle),
            body: _buildScaffoldBody(
                state as DocumentsState, controller, appBarTitle),
          );
        },
      ),
    );
  }

  Widget _buildScaffoldBody(DocumentsState state,
      DocumentsController controller, String appBarTitle) {
    if (state is DocumentsLoadingState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    if (state is DocumentsFailureState) {
      return _buildError(controller: controller);
    }
    if (state is DocumentsEmptyState) {
      return _buildEmpty(controller: controller, appBarTitle: appBarTitle);
    }
    if (state is DocumentsLoadedState) {
      _maybeRunNotificationDeepLink(state, controller, appBarTitle);
      _maybeShowRevalidationSpinner(state.freshness);

      return Column(
        children: [
          if (state.freshness == DocsFreshness.staleFailed)
            _OfflineBanner(lastFetchedAt: state.lastFetchedAt),
          Expanded(
            child: RefreshIndicator(
              key: _refreshKey,
              onRefresh: () => controller.refresh(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: ListView.builder(
                  itemCount: state.documents.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return DocumentsCardWidget(
                      title: state.documents[index].name!,
                      isFirstPage: false,
                      onTap: () {
                        controller.getFile(
                            state.documents[index], appBarTitle);
                        _openDetail(
                            controller, state.documents[index], appBarTitle);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }

  void _openDetail(DocumentsController controller, Documents document,
      String appBarTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentsSelectedInfoPage(
          controller: controller,
          document: document,
          appBarTitle: appBarTitle,
        ),
      ),
    );
  }

  void _maybeRunNotificationDeepLink(DocumentsLoadedState state,
      DocumentsController controller, String appBarTitle) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (_pendingNotificationContext?.isNotEmpty == true && mounted) {
        var item = state.documents.cast<Documents?>().firstWhere(
            (element) =>
                element?.notificationParameter ==
                    _pendingNotificationContext ||
                element?.id == _pendingNotificationContext,
            orElse: () => null);
        if (item != null) {
          controller.getFile(item, appBarTitle);
          _openDetail(controller, item, appBarTitle);
        }
        _pendingNotificationContext = null;
      }
    });
  }

  void _maybeShowRevalidationSpinner(DocsFreshness freshness) {
    if (freshness == DocsFreshness.staleRevalidating &&
        !_isRevalidationSpinnerShown) {
      _isRevalidationSpinnerShown = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) _refreshKey.currentState?.show();
      });
    } else if (freshness != DocsFreshness.staleRevalidating &&
        _isRevalidationSpinnerShown) {
      _isRevalidationSpinnerShown = false;
    }
  }

  Column _buildError({required DocumentsController controller}) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: ErrorHandlingWidget(
              reTryFunction: () {
                controller.refresh();
              },
              backFunction: () => Navigator.pop(context, true),
              isProduction: kReleaseMode,
              error: "",
              errorCode: "",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(
      {required DocumentsController controller,
      required String appBarTitle}) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () => controller.refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 80.0),
            child: Text(
              getString(context, "documents_not_found"),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  final DateTime? lastFetchedAt;
  const _OfflineBanner({Key? key, required this.lastFetchedAt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      color: LelloTheme.palleteOf(theme).warning(),
      child: Row(
        children: [
          Icon(Icons.cloud_off,
              size: 18.0, color: LelloTheme.palleteOf(theme).text()),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _bannerText(context, lastFetchedAt),
              style: LelloTextStyles.subBody(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _bannerText(BuildContext context, DateTime? lastFetchedAt) {
    if (lastFetchedAt == null) {
      return "Sem conexão. Mostrando dados salvos.";
    }
    final diff = DateTime.now().difference(lastFetchedAt);
    final ago = _formatDuration(diff);
    return "Sem conexão. Mostrando dados de $ago atrás.";
  }

  String _formatDuration(Duration d) {
    if (d.inMinutes < 1) return "instantes";
    if (d.inHours < 1) return "${d.inMinutes} min";
    if (d.inDays < 1) return "${d.inHours} h";
    return "${d.inDays} d";
  }
}
