import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/resin/presentation/resin_history_advance/page/resin_history_advance_page.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/page/resin_history_refund_page.dart';
import 'package:lello/feature/resin/presentation/resin_menu/bloc/resin_menu_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_menu/bloc/resin_menu_state.dart';
import 'package:lello/feature/resin/presentation/resin_menu/controller/resin_menu_controller.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/page/resin_new_advance_page.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/page/resin_new_refund_page.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/page/resin_send_receipt_page.dart';

class ResinMenuWidget extends StatefulWidget {
  final ResinMenuController controller;
  const ResinMenuWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinMenuWidget> createState() => _ResinMenuWidgetState();
}

class _ResinMenuWidgetState extends State<ResinMenuWidget> {
  late ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return BlocBuilder<ResinMenuBloc, ResinMenuState>(
      bloc: widget.controller.bloc,
      builder: (context, state) {
        if (state is ResinMenuLoadingState) {
          return const Column(
            children: [
              Expanded(child: LoadingWidget()),
            ],
          );
        }

        if (state is ResinMenuErrorState) {
          return ErrorMessageWidget(
              message: getString(context, state.errorMessageKey));
        }

        if (state is ResinMenuLoadedState) {
          var reference = widget.controller.sessionBloc.state.session
                  ?.selectedCondominium?.reference ??
              "";
          return ListView(
            children: [
              _buildListTitle(getString(context, 'resin_refunds')),
              _buildListItem(getString(context, 'resin_refund_history'),
                  "assets/ic_resin_report.svg", onTap: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.historicoReembolsoAcessar(),
                    referenceValue: reference);
                Navigator.pushNamed(
                  context,
                  ApplicationRoute.resinRefundHistory,
                  arguments: ResinHistoryRefundPageArgs(state.params),
                );
              }),
              const Divider(height: 0),
              _buildListItem(
                getString(context, "resin_new_refund"),
                "assets/ic_new_refund.svg",
                onTap: () {
                  ManagerAnalyticsLogEvents.logEvent(
                      event: AnalyticsEventsManager.solicitarReembolsoAcessar(),
                      referenceValue: reference);
                  Navigator.pushNamed(
                    context,
                    ApplicationRoute.resinRefundNew,
                    arguments:
                        ResinNewRefundPageArgs(resinParams: state.params),
                  );
                },
              ),
              _buildListTitle(getString(context, 'resin_advances')),
              _buildListItem(getString(context, "resin_advances_history"),
                  "assets/ic_resin_report.svg", onTap: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event:
                        AnalyticsEventsManager.historicoAdiantamentoAcessar(),
                    referenceValue: reference);
                Navigator.pushNamed(
                  context,
                  ApplicationRoute.resinAdvanceHistory,
                  arguments: ResinHistoryAdvancePageArgs(state.params),
                );
              }),
              const Divider(height: 0),
              _buildListItem(getString(context, "resin_new_advance_request"),
                  "assets/ic_new_advance.svg", onTap: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event:
                        AnalyticsEventsManager.solicitarAdiantamentoAcessar(),
                    referenceValue: reference);
                Navigator.pushNamed(
                  context,
                  ApplicationRoute.resinAdvanceNew,
                  arguments: ResinNewAdvancePageArgs(resinParams: state.params),
                );
              }),
              const Divider(height: 0),
              _buildListItem(getString(context, "resin_sending_receipts"),
                  "assets/ic_sending_vouchers.svg", onTap: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.envioComprovanteAcessar(),
                    referenceValue: reference);
                Navigator.pushNamed(
                  context,
                  ApplicationRoute.resinSendReceipts,
                  arguments:
                      ResinSendReceiptPageArgs(resinParams: state.params),
                );
              }),
            ],
          );
        }

        return Container();
      },
    );
  }

  Widget _buildListTitle(String title) {
    return Container(
      color: LelloTheme.palleteOf(theme).separator(),
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacingMedium, vertical: Dimens.spacing),
      child: Text(
        title,
        style: LelloTextStyles.subtitle(theme)
            ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
      ),
    );
  }

  Widget _buildListItem(String title, String asset, {VoidCallback? onTap}) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(
              horizontal: Dimens.spacingMedium, vertical: Dimens.spacing),
          leading: SvgPicture.asset(asset, width: 24),
          title: Text(
            title,
            style: LelloTextStyles.bodyBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
          )),
    );
  }
}
