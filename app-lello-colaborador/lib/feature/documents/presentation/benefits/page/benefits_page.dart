import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';

import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/presentation/benefits/bloc/benefits_bloc.dart';
import 'package:colaborador/feature/documents/presentation/benefits/bloc/benefits_state.dart';
import 'package:colaborador/feature/documents/presentation/benefits/widget/benefits_loaded_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';

class BenefitsPage extends StatefulWidget {
  const BenefitsPage({Key? key}) : super(key: key);

  @override
  State<BenefitsPage> createState() => _BenefitsPageState();
}

class _BenefitsPageState extends State<BenefitsPage> {
  BenefitsBloc incomeReportBloc = ApplicationContainer.instance().resolve();
  @override
  Widget build(BuildContext context) {
    Environment env = ApplicationContainer.instance().resolve<Environment>();
    return Scaffold(
      appBar: const CustomAppBar(title: "benefits_page_app_bar"),
      body: BlocProvider(
        create: (context) => incomeReportBloc,
        child: BlocBuilder(
            bloc: incomeReportBloc,
            builder: (context, state) {
              if (state is BenefitsLoadingState) {
                return Column(
                  children: [
                    Expanded(
                      child: LoadingWidget(
                        message:
                            getString(context, "benefits_page_loading_message"),
                      ),
                    ),
                  ],
                );
              }
              if (state is BenefitsFailedState) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: ErrorHandlingWidget(
                    errorCode: state.errorCode,
                    error: state.errorDescription,
                    reTryFunction: () => incomeReportBloc.getDocumentsInfoList(
                        documentType: DocumentTypeEnum.protocolBenefits),
                    backFunction: () => Navigator.pop(context, true),
                    isProduction: env.isProduction,
                  ),
                );
              }
              if (state is BenefitsLoadedState) {
                return BenefitsLoadedWidget(documentsInfo: state.documentsInfo);
              }
              return Container();
            }),
      ),
    );
  }
}
