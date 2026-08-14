import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_analysis/widgets/agreements_analysis_finished.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_analysis/widgets/agreements_analysis_refused.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../controllers/agreements_controller.dart';

class AgreementsAnalysisPage extends StatefulWidget {
  const AgreementsAnalysisPage({Key? key}) : super(key: key);

  @override
  AgreementsAnalysisPageState createState() => AgreementsAnalysisPageState();
}

class AgreementsAnalysisPageState extends State<AgreementsAnalysisPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<AgreementsController>();
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: getString(context, "agreements_analysis"),
          theme: theme,
          tabs: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              decoration: BoxDecoration(
                color: LelloTheme.palleteOf(theme).backgroundDark(),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(-12),
                  topRight: Radius.circular(-12),
                ),
              ),
              child: TabBar(
                labelColor: theme.primaryColor,
                labelStyle: LelloTextStyles.subBody(theme),
                unselectedLabelColor: LelloTheme.palleteOf(theme).secondary(),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: theme.primaryColor),
                ),
                controller: tabController,
                tabs: [
                  Tab(
                    text: getString(context, "agreements_analysis_finished")
                        .toUpperCase(),
                  ),
                  Tab(
                    text: getString(context, "agreements_analysis_refused")
                        .toUpperCase(),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocBuilder<AgreementsBloc, AgreementsState>(
          bloc: controller.agreementsBloc,
          builder: (context, state) {
            if (state is AgreementsLoadingState) {
              return Column(
                children: const [
                  Expanded(child: LoadingWidget()),
                ],
              );
            }

            if (state is AgreementsErrorState) {
              return ErrorMessageWidget(
                  message: getString(context, "agreements_analysis_error"));
            }

            return TabBarView(
              controller: tabController,
              children: [
                AgreementsAnalysisFinishedWidget(
                  agreementsFinished:
                      controller.agreementsAnalysis!.reportApproved,
                  currentPeriod: controller.agreementsAnalysis!.fromDate,
                  onTap: (fromDate) async {
                    await controller.getAnalysis(fromDate: fromDate);
                    setState(() {});
                  },
                ),
                AgreementsAnalysisRefusedWidget(
                  agreementsRefused:
                      controller.agreementsAnalysis!.reportReproved,
                  currentPeriod: controller.agreementsAnalysis!.fromDate,
                  onTap: (fromDate) async {
                    await controller.getAnalysis(fromDate: fromDate);
                    setState(() {});
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
