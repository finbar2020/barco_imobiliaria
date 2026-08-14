import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';

import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/bloc/pay_stub_bloc.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/bloc/pay_stub_state.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/widget/pay_stub_loaded_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';

class PayStubPage extends StatefulWidget {
  const PayStubPage({Key? key}) : super(key: key);

  @override
  State<PayStubPage> createState() => _PayStubPageState();
}

class _PayStubPageState extends State<PayStubPage> {
  PayStubBloc incomeReportBloc = ApplicationContainer.instance().resolve();
  @override
  Widget build(BuildContext context) {
    Environment env = ApplicationContainer.instance().resolve<Environment>();
    return Scaffold(
      appBar: const CustomAppBar(title: "pay_stub_page_app_bar"),
      body: BlocProvider(
        create: (context) => incomeReportBloc,
        child: BlocBuilder(
            bloc: incomeReportBloc,
            builder: (context, state) {
              if (state is PayStubLoadingState) {
                return Column(
                  children: [
                    Expanded(
                        child: LoadingWidget(
                            message: getString(
                                context, "pay_stub_page_loading_message"))),
                  ],
                );
              }
              if (state is PayStubFailedState) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: ErrorHandlingWidget(
                    errorCode: state.errorCode,
                    error: state.errorDescription,
                    reTryFunction: () => incomeReportBloc.getDocumentsInfoList(
                        documentType: DocumentTypeEnum.payStub),
                    backFunction: () => Navigator.pop(context, true),
                    isProduction: env.isProduction,
                  ),
                );
              }
              if (state is PayStubLoadedState) {
                return PayStubLoadedWidget(documentsInfo: state.documentsInfo);
              }
              return Container();
            }),
      ),
    );
  }
}
