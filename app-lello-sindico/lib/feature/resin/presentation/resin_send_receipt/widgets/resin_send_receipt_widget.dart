import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/bloc/resin_send_receipt_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/bloc/resin_send_receipt_state.dart';
import 'package:lello/feature/resin/presentation/resin_send_receipt/controller/resin_send_receipt_controller.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_send_receipt_list_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_updating_widget.dart';

class ResinSendReceiptWidget extends StatefulWidget {
  final ResinParams params;
  final ResinSendReceiptController controller;
  const ResinSendReceiptWidget({
    Key? key,
    required this.params,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinSendReceiptWidget> createState() => _ResinSendReceiptWidgetState();
}

class _ResinSendReceiptWidgetState extends State<ResinSendReceiptWidget> {
  late ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    ResinSendReceiptBloc bloc = BlocProvider.of(context);

    if (widget.controller.filter.endDate == null) {
      widget.controller.filter.startDate = widget.params.filterStartDate;
      widget.controller.filter.endDate = widget.params.filterEndDate;
    }

    return BlocBuilder<ResinSendReceiptBloc, ResinSendReceiptState>(
      bloc: bloc,
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSnackBar(context, bloc.state.flushbarMessageKey);
          bloc.state.flushbarMessageKey = null;
        });
        if (state is ResinSendReceiptLoadingState) {
          return _buildLoading(context);
        }

        if (state is ResinSendReceiptErrorState) {
          return _buildError(context, state);
        }

        if (state is ResinSendReceiptLoadedState) {
          return _buildSuccess(context, state, bloc);
        }

        return Container();
      },
    );
  }

  Column _buildSuccess(BuildContext context, ResinSendReceiptLoadedState state,
      ResinSendReceiptBloc bloc) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingLarge),
        Text(getString(context, "resin_advances_title"),
            textAlign: TextAlign.center, style: LelloTextStyles.title(theme)),
        SizedBox(height: Dimens.spacingMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Text(
            getString(context, "resin_advances_subtitle"),
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
        ResinSendReceiptListWidget(
          refunds: state.refunds,
          params: widget.params,
        ),
      ],
    );
  }

  Column _buildError(BuildContext context, ResinSendReceiptErrorState state) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingLarge),
        Text(getString(context, "resin_advances_title"),
            textAlign: TextAlign.center, style: LelloTextStyles.title(theme)),
        SizedBox(height: Dimens.spacingMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Text(
            getString(context, "resin_advances_subtitle"),
            textAlign: TextAlign.center,
            style: LelloTextStyles.body(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacingMedium),
        const Divider(height: 0),
        Expanded(
          child: ErrorMessageWidget(
              message: getString(context, state.errorMessageKey)),
        ),
      ],
    );
  }

  Column _buildLoading(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingLarge),
        Text(getString(context, "resin_advances_title"),
            textAlign: TextAlign.center, style: LelloTextStyles.title(theme)),
        SizedBox(height: Dimens.spacingMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Text(
            getString(context, "resin_advances_subtitle"),
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

  Column _buildCancelAdvanceLoading(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingLarge),
        Text(getString(context, "resin_advances_title"),
            textAlign: TextAlign.center, style: LelloTextStyles.title(theme)),
        SizedBox(height: Dimens.spacingMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Text(
            getString(context, "resin_advances_subtitle"),
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
            Text(getString(context, "resin_advances_cancel_loading"),
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
