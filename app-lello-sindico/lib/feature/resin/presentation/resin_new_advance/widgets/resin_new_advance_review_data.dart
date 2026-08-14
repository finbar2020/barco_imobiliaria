import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/feature/resin/domain/entity/resin_advances_steps_enum.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/presentation/resin_create_refund_success_error/page/resin_create_refund_success_error_page.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/bloc/resin_new_advance_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/bloc/resin_new_advance_state.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/controller/resin_new_advance_controller.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_review_data_widget.dart';

class ResinNewAdvanceReviewData extends StatefulWidget {
  final Function(ResinAdvancesStepsEnum step) updateStep;
  final ResinParams resinParams;
  final ResinNewAdvanceController controller;
  const ResinNewAdvanceReviewData({
    Key? key,
    required this.updateStep,
    required this.resinParams,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinNewAdvanceReviewData> createState() =>
      _ResinNewAdvanceReviewDataState();
}

class _ResinNewAdvanceReviewDataState extends State<ResinNewAdvanceReviewData> {
  late ThemeData theme;
  late ResinNewAdvanceBloc resinNewAdvanceBloc;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      _setUpPage();
    }

    return BlocConsumer<ResinNewAdvanceBloc, ResinNewAdvanceState>(
      bloc: resinNewAdvanceBloc,
      listener: (context, state) {
        if (state is ResinNewAdvanceErrorState) {
          Navigator.pushNamed(
            context,
            ApplicationRoute.resinCreateRefundSuccessError,
            arguments: ResinCreateRefundSuccessErrorPageArgs(
              params: widget.resinParams,
              refund: widget.controller.resinRefund,
              isSuccess: false,
            ),
          );
        } else if (state is ResinNewAdvanceSuccessState) {
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
        if (state is ResinNewAdvanceLoadingState)
          return Column(
            children: [
              Expanded(
                child: LoadingWidget(
                  message:
                      getString(context, "resin_review_data_advance_loading"),
                ),
              ),
            ],
          );

        if (state is ResinNewAdvanceErrorState)
          return ErrorMessageWidget(
              message: getString(context, state.errorMessageKey));

        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: StepIndicator(numberOfSteps: 3, currentStep: 2),
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
              widget.updateStep(ResinAdvancesStepsEnum.valueDescription);
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
    resinNewAdvanceBloc = BlocProvider.of(context);
  }
}
