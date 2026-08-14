import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval_type.dart';
import 'package:lello/feature/payment/presentation/approval//widget/payment_approval_form.dart';
import 'package:lello/feature/payment/presentation/approval/bloc/payment_approval_bloc.dart';
import 'package:lello/feature/payment/presentation/approval/bloc/payment_approval_state.dart';
import 'package:lello/feature/payment/presentation/approval/page/payment_approval_rejected_page.dart';
import 'package:shared_features/shared_features.dart';

class PaymentApprovalPageArguments {
  Payment? pendency;
  PaymentApproval approval;
  PaymentApprovalPageArguments(
      {required this.pendency, required this.approval});
}

class PaymentApprovalPage extends StatefulWidget {
  const PaymentApprovalPage({super.key});

  @override
  _PaymentApprovalPageState createState() => _PaymentApprovalPageState();
}

class _PaymentApprovalPageState extends State<PaymentApprovalPage> {
  final PaymentApprovalBloc bloc = ApplicationContainer.instance().resolve();
  late PaymentApprovalPageArguments args;
  bool _approvalSet = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_approvalSet) {
      args = ModalRoute.of(context)!.settings.arguments
          as PaymentApprovalPageArguments;
      bloc.setApproval(args.approval);
      _approvalSet = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: getString(context, "payment_approval_title"),
          theme: theme,
        ),
        body: _buildContent(theme),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) => BlocProvider.value(
        value: bloc,
        child: BlocConsumer<PaymentApprovalBloc, PaymentApprovalState>(
            listener: (context, state) {
          if (state is PaymentApprovalSucceededState) {
            Navigator.pushReplacementNamed(
                context, ApplicationRoute.approvePaymentSuccess,
                arguments: state.entity);
          } else if (state is PaymentApprovalRejectedState) {
            Navigator.pushReplacementNamed(
                context, ApplicationRoute.approvePaymentRejected,
                arguments: PaymentApprovalRejectedPageArguments(
                    faliure: state.error,
                    approval: state.entity,
                    pendency: args.pendency));
          }
        }, builder: (context, state) {
          Widget child;
          if (state is PaymentApprovalFormState ||
              state is PaymentApprovalFailedState ||
              state is PaymentApprovalCodeFailedState) {
            child = const PaymentApprovalFormWidget();
          } else if (state is PaymentApprovalRequestingCodeState) {
            child = _buildSendingCodeLoading(theme, state);
          } else if (state is PaymentApprovalValidatingCodeState) {
            child = _buildCodeValidation(theme, state);
          } else if (state is PaymentApprovalProgressState) {
            child = _buildApprovingLoading(theme, state);
          } else {
            child = Container();
          }

          return WillPopScope(
            onWillPop: () async => bloc.revertCodeValidation(),
            child: child,
          );
        }),
      );

  Widget _buildCodeValidation(
      ThemeData theme, PaymentApprovalValidatingCodeState state) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: CodeValidationPage(
          codeRequest: state.request!,
          digits: 4,
          onRestart: () {},
          appContainer: ApplicationContainer.instance(),
          onSuccess: (validation) async {
            if (state.entity != null) bloc.beginSend();
          }),
    );
  }

  Widget _buildApprovingLoading(
      ThemeData theme, PaymentApprovalProgressState state) {
    String title = getLoadingTitle(state);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CircularProgressIndicator(),
        SizedBox(height: Dimens.spacingLarge),
        Text(title, style: LelloTextStyles.title(theme)),
        SizedBox(height: Dimens.spacingSmall),
        Text(getString(context, "please_wait"),
            style: LelloTextStyles.subBody(theme)),
      ],
    ));
  }

  Widget _buildSendingCodeLoading(
          ThemeData theme, PaymentApprovalRequestingCodeState state) =>
      RequestValidationCodeLoading(source: state.source);

  String getLoadingTitle(PaymentApprovalProgressState state) {
    String key = "";
    switch (state.entity?.type) {
      case PaymentApprovalType.approve:
        key = "payment_approval_approving";
        break;
      case PaymentApprovalType.suspend:
        key = "payment_approval_suspending";
        break;
      case PaymentApprovalType.cancel:
        key = "payment_approval_canceling";
        break;
      default:
        key = "payment_approval_approving";
        break;
    }
    return getString(context, key);
  }
}
