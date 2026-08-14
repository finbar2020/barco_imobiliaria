import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';

import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/presentation/document_file/page/document_file_page.dart';
import 'package:colaborador/feature/documents/presentation/income_report/bloc/income_report_bloc.dart';
import 'package:colaborador/feature/documents/presentation/income_report/bloc/income_report_state.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';

class IncomeReportPage extends StatefulWidget {
  const IncomeReportPage({Key? key}) : super(key: key);

  @override
  State<IncomeReportPage> createState() => _IncomeReportPageState();
}

class _IncomeReportPageState extends State<IncomeReportPage> {
  IncomeReportBloc incomeReportBloc = ApplicationContainer.instance().resolve();
  @override
  Widget build(BuildContext context) {
    Environment env = ApplicationContainer.instance().resolve<Environment>();
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(title: "documents_page_income_report"),
      body: BlocProvider(
        create: (context) => incomeReportBloc,
        child: BlocBuilder(
            bloc: incomeReportBloc,
            builder: (context, state) {
              if (state is IncomeReportLoadingState) {
                return Column(
                  children: [
                    Expanded(
                        child: LoadingWidget(
                            message: getString(
                                context, "income_report_loading_message"))),
                  ],
                );
              }
              if (state is IncomeReportFailedState) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: ErrorHandlingWidget(
                    errorCode: state.errorCode,
                    error: state.errorDescription,
                    reTryFunction: () => incomeReportBloc.getDocumentsInfoList(
                        documentType: DocumentTypeEnum.incomeReport),
                    backFunction: () => Navigator.pop(context, true),
                    isProduction: env.isProduction,
                  ),
                );
              }
              if (state is IncomeReportLoadedState) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(Dimens.spacingMedium),
                      child: Text(
                        getString(context, "income_report_description"),
                        style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).hubText()),
                      ),
                    ),
                    if (state.documentsInfo.isEmpty)
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimens.spacingMedium),
                        child: Text(
                          getString(context, "income_report_empty"),
                          style: LelloTextStyles.subtitle(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).hubText()),
                        ),
                      )),
                    if (state.documentsInfo.isNotEmpty)
                      Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      ApplicationRoute.documentFilePage,
                                      arguments: DocumentFilePageArgs(
                                          state.documentsInfo[index].name));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(Dimens.spacingMedium),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _getTileName(context,
                                              state.documentsInfo[index]),
                                          style: LelloTextStyles.subtitle(theme)
                                              ?.copyWith(
                                                  color: LelloTheme.palleteOf(
                                                          theme)
                                                      .hubText()),
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        size: 32.0,
                                        color: LelloTheme.palleteOf(theme)
                                            .hubText(),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1.0),
                            itemCount: state.documentsInfo.length),
                      ),
                    Container(),
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }

  String _getTileName(BuildContext context, DocumentInfo documentInfo) {
    String intro = getString(context, "income_report_list_tile_name");
    String year = documentInfo.documentProcessingDate.year.toString();
    return "$intro $year";
  }
}
