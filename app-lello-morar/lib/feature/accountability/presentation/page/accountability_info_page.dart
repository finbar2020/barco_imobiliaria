import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/accountability/presentation/bloc/accountabiity_state.dart';
import 'package:morar/feature/accountability/presentation/controllers/accountability_controller.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_page/accountability_period_group_list_widget.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_page/accountability_period_summary_widget.dart';

class AccountabilityInfoPageArgs {
  String selectedDate;
  DateTime period;
  AccountabilityInfoPageArgs({
    required this.selectedDate,
    required this.period,
  });
}

class AccountabilityInfoPage extends StatefulWidget {
  const AccountabilityInfoPage({Key? key}) : super(key: key);

  @override
  _AccountabilityInfoPageState createState() => _AccountabilityInfoPageState();
}

class _AccountabilityInfoPageState extends State<AccountabilityInfoPage> {
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final AccountabilityController controller =
      ApplicationContainer.instance().resolve<AccountabilityController>();
  @override
  Widget build(BuildContext context) {
    AccountabilityInfoPageArgs arguments = ModalRoute.of(context)
        ?.settings
        .arguments as AccountabilityInfoPageArgs;

    return BlocBuilder(
      bloc: controller.bloc,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.accountability,
            );
            return false;
          },
          child: Scaffold(
            appBar: CustomAppBar(title: "accountability_title"),
            body: _buildBody(context, arguments.selectedDate,
                controller.bloc.state, arguments.period),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, String title,
      AccountabilityState state, DateTime period) {
    if (state is AccountabilityLoadingState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    if (state is AccountabilityFailureState) {
      return Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: ErrorHandlingWidget(
                reTryFunction: () {
                  controller.getAccountabilityController(period);
                },
                backFunction: () => Navigator.pop(context, true),
                isProduction: env.isProduction,
                error: state.error?.error.toString() ?? "",
                errorCode: state.error?.code.toString() ?? "",
                textReturnButton: "back_to_the_previous_page",
              ),
            ),
          ),
        ],
      );
    }

    if (state is AccountabilityPeriodsLoadedState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AccountabilityPeriodGroupListWidget(
              title: title,
              groupedEntries: state.accountability.groupedEntries,
            ),
          ),
          AccountabilityPeriodSummaryWidget(
              accountability: state.accountability),
        ],
      );
    }
    return Container();
  }
}
