import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/domain/entity/resin_refunds_steps_enum.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/controller/resin_new_refund_controller.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/widgets/resin_new_refund_bank_accounts.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/widgets/resin_new_refund_receipts.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/widgets/resin_new_refund_review_data.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/widgets/resin_new_refund_value_description.dart';

class ResinNewRefundPageArgs {
  ResinParams resinParams;
  ResinRefund? refund;
  ResinNewRefundPageArgs({
    required this.resinParams,
    this.refund,
  });
}

class ResinNewRefundPage extends StatefulWidget {
  const ResinNewRefundPage({Key? key}) : super(key: key);

  @override
  State<ResinNewRefundPage> createState() => _ResinNewRefundPageState();
}

class _ResinNewRefundPageState extends State<ResinNewRefundPage> {
  ResinNewRefundController controller =
      ApplicationContainer.instance().resolve();

  late ResinParams resinParams;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ResinNewRefundPageArgs args =
        ModalRoute.of(context)?.settings.arguments as ResinNewRefundPageArgs;
    resinParams = args.resinParams;
    controller.setUpBloc(args.refund);

    return BlocProvider.value(
      value: controller.bloc,
      child: WillPopScope(
        onWillPop: () async => _onPop(),
        child: Scaffold(
          appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            title: getString(context, "resin_refunds"),
            theme: theme,
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (controller.currentStep) {
      case ResinRefundsStepsEnum.bankAccount:
        controller.resinRefund = ResinRefund(
            value: 0.00,
            receipts: [],
            status: ResinRefundStatus.sended,
            type: ResinRefundType.refund,
            requesterId: controller.sessionBloc.state.session?.me?.id ?? "",
            requestDate: DateTime.now(),
            requester: controller.sessionBloc.state.session?.me?.name ?? "");
        return ResinNewRefundBankAccounts(
          updateStep: updateStep,
          controller: controller,
        );
      case ResinRefundsStepsEnum.valueDescription:
        return ResinNewRefundValueDescription(
          updateStep: updateStep,
          resinParams: resinParams,
          controller: controller,
        );
      case ResinRefundsStepsEnum.receipts:
        return ResinNewRefundReceipts(
          updateStep: updateStep,
          resinParams: resinParams,
          controller: controller,
        );
      case ResinRefundsStepsEnum.reviewData:
        return ResinNewRefundReviewData(
          updateStep: updateStep,
          resinParams: resinParams,
          controller: controller,
        );
    }
  }

  void updateStep(ResinRefundsStepsEnum step) {
    setState(() {
      controller.changeStep(step);
    });
  }

  bool _onPop() {
    switch (controller.currentStep) {
      case ResinRefundsStepsEnum.bankAccount:
        return true;
      case ResinRefundsStepsEnum.valueDescription:
        updateStep(ResinRefundsStepsEnum.bankAccount);
        return false;
      case ResinRefundsStepsEnum.receipts:
        updateStep(ResinRefundsStepsEnum.valueDescription);
        return false;
      case ResinRefundsStepsEnum.reviewData:
        updateStep(ResinRefundsStepsEnum.receipts);
        return false;
    }
  }
}
