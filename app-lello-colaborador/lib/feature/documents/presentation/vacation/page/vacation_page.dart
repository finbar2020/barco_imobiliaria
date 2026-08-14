import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';

import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/presentation/vacation/bloc/vacation_bloc.dart';
import 'package:colaborador/feature/documents/presentation/vacation/bloc/vacation_state.dart';
import 'package:colaborador/feature/documents/presentation/vacation/widget/vacation_loaded_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';

class VacationPage extends StatefulWidget {
  const VacationPage({Key? key}) : super(key: key);

  @override
  State<VacationPage> createState() => _VacationPageState();
}

class _VacationPageState extends State<VacationPage> {
  VacationBloc incomeReportBloc = ApplicationContainer.instance().resolve();
  @override
  Widget build(BuildContext context) {
    Environment env = ApplicationContainer.instance().resolve<Environment>();
    return Scaffold(
      appBar: const CustomAppBar(title: "vacation_page_app_bar"),
      body: BlocProvider(
        create: (context) => incomeReportBloc,
        child: BlocBuilder(
            bloc: incomeReportBloc,
            builder: (context, state) {
              if (state is VacationLoadingState) {
                return Column(
                  children: [
                    Expanded(
                      child: LoadingWidget(
                        message:
                            getString(context, "vacation_page_loading_message"),
                      ),
                    ),
                  ],
                );
              }
              if (state is VacationFailedState) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: ErrorHandlingWidget(
                    errorCode: state.errorCode,
                    error: state.errorDescription,
                    reTryFunction: () => incomeReportBloc.getDocumentsInfoList(
                        documentType: DocumentTypeEnum.vacationReceipt),
                    backFunction: () => Navigator.pop(context, true),
                    isProduction: env.isProduction,
                  ),
                );
              }
              if (state is VacationLoadedState) {
                return VacationLoadedWidget(documentsInfo: state.documentsInfo);
              }
              return Container();
            }),
      ),
    );
  }
}
