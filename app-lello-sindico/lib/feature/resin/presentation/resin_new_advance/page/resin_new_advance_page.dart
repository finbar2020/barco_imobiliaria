import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resin/domain/entity/resin_advances_steps_enum.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/controller/resin_new_advance_controller.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/widgets/resin_new_advance_bank_accounts.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/widgets/resin_new_advance_review_data.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/widgets/resin_new_advance_value_description.dart';

class ResinNewAdvancePageArgs {
  ResinParams resinParams;
  ResinRefund? refund;

  ResinNewAdvancePageArgs({
    required this.resinParams,
    this.refund,
  });
}

class ResinNewAdvancePage extends StatefulWidget {
  const ResinNewAdvancePage({Key? key}) : super(key: key);

  @override
  State<ResinNewAdvancePage> createState() => _ResinNewAdvancePageState();
}

class _ResinNewAdvancePageState extends State<ResinNewAdvancePage> {
  ResinNewAdvanceController controller =
      ApplicationContainer.instance().resolve();

  late ResinParams resinParams;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ResinNewAdvancePageArgs args =
        ModalRoute.of(context)?.settings.arguments as ResinNewAdvancePageArgs;
    resinParams = args.resinParams;
    controller.setUpBloc(args.refund);

    return BlocProvider.value(
      value: controller.bloc,
      child: WillPopScope(
        onWillPop: () async => _onPop(),
        child: Scaffold(
          appBar: PrimaryAppBar(
            title: getString(context, "resin_advances"),
            theme: theme,
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (controller.currentStep) {
      case ResinAdvancesStepsEnum.bankAccount:
        controller.resinRefund = ResinRefund(
            value: 0.00,
            receipts: [],
            status: ResinRefundStatus.sended,
            type: ResinRefundType.advance,
            requesterId: controller.sessionBloc.state.session?.me?.id ?? "",
            requestDate: DateTime.now(),
            requester: controller.sessionBloc.state.session?.me?.name ?? "");
        return ResinNewAdvanceBankAccounts(
            updateStep: updateStep, controller: controller);
      case ResinAdvancesStepsEnum.valueDescription:
        return ResinNewAdvanceValueDescription(
            updateStep: updateStep,
            resinParams: resinParams,
            controller: controller);
      case ResinAdvancesStepsEnum.reviewData:
        return ResinNewAdvanceReviewData(
            updateStep: updateStep,
            resinParams: resinParams,
            controller: controller);
    }
  }

  void updateStep(ResinAdvancesStepsEnum step) {
    setState(() {
      controller.changeStep(step);
    });
  }

  bool _onPop() {
    switch (controller.currentStep) {
      case ResinAdvancesStepsEnum.bankAccount:
        return true;
      case ResinAdvancesStepsEnum.valueDescription:
        updateStep(ResinAdvancesStepsEnum.bankAccount);
        return false;
      case ResinAdvancesStepsEnum.reviewData:
        updateStep(ResinAdvancesStepsEnum.valueDescription);
        return false;
    }
  }
}
