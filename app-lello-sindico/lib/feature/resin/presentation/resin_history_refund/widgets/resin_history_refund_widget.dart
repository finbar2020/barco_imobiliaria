import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/loading_widget.dart';

import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/bloc/resin_history_refund_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/bloc/resin_history_refund_state.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/controller/resin_history_refund_controller.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/page/resin_new_refund_page.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_history_list_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_updating_widget.dart';

class ResinHistoryRefundWidget extends StatefulWidget {
  final ResinParams resinParams;
  final ResinHistoryRefundController controller;
  const ResinHistoryRefundWidget({
    Key? key,
    required this.resinParams,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinHistoryRefundWidget> createState() =>
      _ResinHistoryRefundWidgetState();
}

class _ResinHistoryRefundWidgetState extends State<ResinHistoryRefundWidget> {
  late ThemeData theme;
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return BlocConsumer<ResinHistoryRefundBloc, ResinHistoryRefundState>(
      bloc: widget.controller.bloc,
      listener: (context, state) {
        if (state is ResinRefundDetailsLoadedState) {
          Navigator.pushNamed(
            context,
            ApplicationRoute.resinRefundNew,
            arguments: ResinNewRefundPageArgs(
              resinParams: widget.resinParams,
              refund: state.refund,
            ),
          ).then((value) => widget.controller.historyGetParams());
        }
      },
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSnackBar(
              context, widget.controller.bloc.state.flushbarMessageKey);
          widget.controller.bloc.state.flushbarMessageKey = null;
        });
        if (state is ResinDeleteHistoryRefundLoadingState) {
          return _buildCancelRefundLoading(context);
        }
        if (state is ResinHistoryRefundLoadingState) {
          return _buildLoading(context);
        }

        if (state is ResinHistoryRefundErrorState) {
          return Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: ErrorHandlingWidget(
              reTryFunction: () {
                widget.controller.historyGetParams();
              },
              backFunction: () => Navigator.pop(context, true),
              isProduction: env.isProduction,
              error: "",
              errorCode: "",
              textReturnButton: "back_to_the_previous_page",
            ),
          );
        }

        if (state is ResinHistoryRefundLoadedState) {
          return _buildSuccess(context, state);
        }

        return Container();
      },
    );
  }

  Column _buildSuccess(
    BuildContext context,
    ResinHistoryRefundLoadedState state,
  ) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingLarge),
        Text(getString(context, "resin_refund_title"),
            textAlign: TextAlign.center, style: LelloTextStyles.title(theme)),
        SizedBox(height: Dimens.spacingMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Text(
            getString(context, "resin_refund_subtitle"),
            textAlign: TextAlign.center,
            style: LelloTextStyles.body(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacingMedium),
        if (state.loadingRemote)
          Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(
                  vertical: Dimens.spacingXSmall,
                  horizontal: Dimens.spacingMedium),
              child: const ResinUpdatingWidget()),
        const Divider(height: 0),
        ResinHistoryListWidget(
          refunds: state.refunds,
          editRefund: (ResinRefund refund) {
            widget.controller.getRefundDetails(refund.id);
          },
          cancelRefund: (ResinRefund refund) {
            widget.controller.cancelRefund(refund.id!);
          },
        ),
        SizedBox(height: Dimens.spacingSmall),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
          child: PrimaryButton(
            text: getString(context, "resin_refund_new_btn"),
            onPressed: () {
              Navigator.pushNamed(
                context,
                ApplicationRoute.resinRefundNew,
                arguments:
                    ResinNewRefundPageArgs(resinParams: widget.resinParams),
              );
            },
          ),
        ),
      ],
    );
  }

  Column _buildLoading(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingLarge),
        Text(getString(context, "resin_refund_title"),
            textAlign: TextAlign.center, style: LelloTextStyles.title(theme)),
        SizedBox(height: Dimens.spacingMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Text(
            getString(context, "resin_refund_subtitle"),
            textAlign: TextAlign.center,
            style: LelloTextStyles.body(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacingMedium),
        const Divider(height: 0),
        const Expanded(child: LoadingWidget()),
      ],
    );
  }

  Column _buildCancelRefundLoading(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingLarge),
        Text(getString(context, "resin_refund_title"),
            textAlign: TextAlign.center, style: LelloTextStyles.title(theme)),
        SizedBox(height: Dimens.spacingMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Text(
            getString(context, "resin_refund_subtitle"),
            textAlign: TextAlign.center,
            style: LelloTextStyles.body(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacingMedium),
        const Divider(height: 0),
        Expanded(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: LoadingWidget()),
            SizedBox(height: Dimens.spacing),
            Text(getString(context, "resin_refund_cancel_loading"),
                style: LelloTextStyles.body(theme)),
          ],
        )),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String? textKey) {
    if (textKey == null) {
      return;
    }
    String text = getString(context, textKey);
    if (text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
      ));
    }
  }
}
