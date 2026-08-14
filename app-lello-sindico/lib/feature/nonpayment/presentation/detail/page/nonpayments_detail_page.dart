import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_detail.dart';
import 'package:lello/feature/nonpayment/presentation/bloc/nonpayments_bloc.dart';
import 'package:lello/feature/nonpayment/presentation/detail/widgets/nonpayments_detail_hearder_widget.dart';
import 'package:lello/feature/nonpayment/presentation/detail/widgets/nonpayments_detail_list_widget.dart';
import 'package:lello/feature/nonpayment/presentation/detail/widgets/nonpayments_grid_detail_widget.dart';

class NonPaymentsDetailPageArgs {
  NonPaymentsDetail detail;
  NonPaymentsDetailPageArgs({required this.detail});
}

class NonPaymentsDetailPage extends StatefulWidget {
  const NonPaymentsDetailPage({Key? key}) : super(key: key);

  @override
  NonPaymentsDetailState createState() => NonPaymentsDetailState();
}

class NonPaymentsDetailState extends State<NonPaymentsDetailPage> {
  final NonPaymentsBloc bloc = ApplicationContainer.instance().resolve();
  late NonPaymentsDetail detail;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    NonPaymentsDetailPageArgs args =
        ModalRoute.of(context)?.settings.arguments as NonPaymentsDetailPageArgs;

    detail = args.detail;

    return Theme(
      data: theme,
      child: Scaffold(
          appBar: PrimaryAppBar(
              iconColor: theme.primaryColor,
              theme: theme,
              title: getString(context, "non_payments_title")),
          body: SingleChildScrollView(child: _buildBody(theme))),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DetailHeaderWidget(detail: detail),
        GridDetailWidget(detail: detail),
        const Divider(),
        DetailListWidget(detail: detail),
      ],
    );
  }
}
