import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refunds_steps_enum.dart';
import 'package:lello/feature/resin/presentation/resin_create_refund_success_error/page/resin_create_refund_success_error_page.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/bloc/resin_new_refund_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/bloc/resin_new_refund_state.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/controller/resin_new_refund_controller.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_review_data_widget.dart';

class ResinNewRefundReviewData extends StatefulWidget {
  final Function(ResinRefundsStepsEnum step) updateStep;
  final ResinParams resinParams;
  final ResinNewRefundController controller;
  const ResinNewRefundReviewData({
    Key? key,
    required this.updateStep,
    required this.resinParams,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinNewRefundReviewData> createState() =>
      _ResinNewRefundReviewDataState();
}

class _ResinNewRefundReviewDataState extends State<ResinNewRefundReviewData> {
  late ThemeData theme;
  late ResinNewRefundBloc resinNewRefundBloc;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      _setUpPage();
    }

    return BlocConsumer<ResinNewRefundBloc, ResinNewRefundState>(
      bloc: resinNewRefundBloc,
      listener: (context, state) {
        if (state is ResinNewRefundErrorState) {
          Navigator.pushNamed(
            context,
            ApplicationRoute.resinCreateRefundSuccessError,
            arguments: ResinCreateRefundSuccessErrorPageArgs(
              params: widget.resinParams,
              refund: widget.controller.resinRefund,
              isSuccess: false,
            ),
          );
        } else if (state is ResinNewRefundSuccessState) {
          Navigator.pushReplacementNamed(
            context,
            ApplicationRoute.resinCreateRefundSuccessError,
            arguments: ResinCreateRefundSuccessErrorPageArgs(
              params: widget.resinParams,
              refund: state.refund,
              isSuccess: true,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ResinNewRefundLoadingState)
          return Column(
            children: [
              Expanded(
                child: LoadingWidget(
                  message:
                      getString(context, "resin_review_data_refund_loading"),
                ),
              ),
            ],
          );

        if (state is ResinNewRefundErrorState)
          return ErrorMessageWidget(
              message: getString(context, state.errorMessageKey));

        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: StepIndicator(numberOfSteps: 4, currentStep: 3),
            ),
            Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Text(
                getString(context, "resin_review_data_intro"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
            ),
            Divider(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResinReviewDataWidget(
                      refund: widget.controller.resinRefund,
                    ),
                    _buildButtons(context),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        children: [
          PrimaryButton(
            onPressed: () {
              widget.controller.postRefund(widget.controller.resinRefund);
            },
            text: getString(context, "resin_review_data_finish"),
          ),
          SizedBox(height: Dimens.spacingMedium),
          SecondaryButton(
            onPressed: () {
              widget.updateStep(ResinRefundsStepsEnum.receipts);
            },
            buttonBorderColor: Colors.white,
            child: Text(getString(context, "back")),
          ),
        ],
      ),
    );
  }

  void _setUpPage() {
    firstBuild = false;
    theme = Theme.of(context);
    resinNewRefundBloc = BlocProvider.of(context);
  }
}
