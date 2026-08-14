import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';

import 'package:lello/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_bloc.dart';
import 'package:lello/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_state.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class PayslipSelectionPage extends StatefulWidget {
  const PayslipSelectionPage({super.key});

  @override
  PayslipSelectionPageState createState() => PayslipSelectionPageState();
}

class PayslipSelectionPageState extends State<PayslipSelectionPage> {
  final PayslipSelectionBloc bloc = ApplicationContainer.instance().resolve();
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final dateFormat = DateFormat.yMd();
  ScrollController? controller;
  var loaded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Map? arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    if (!loaded && arguments != null) {
      bloc.beginLoad(arguments['entity'].id, arguments['selectedMonth']);
      loaded = true;
    }

    return Theme(
        data: theme,
        child: Scaffold(
          appBar: PrimaryAppBar(
              iconColor: theme.primaryColor,
              theme: theme,
              title: getString(context, 'gdp_payslip_title')),
          body: BlocBuilder(
              bloc: bloc,
              builder: (context, state) {
                if (state is PayslipLoadedState) {
                  return _buildList(theme, state);
                }
                if (state is PayslipFileDownloadedState) {
                  renderPdf(context, state, bloc);
                }
                if (state is PayslipLoadingState) {
                  return const Center(child: LoadingWidget());
                }
                if (state is PayslipLoadFailedState) {
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: ErrorHandlingWidget(
                      reTryFunction: () {
                        if (!loaded && arguments != null) {
                          bloc.beginLoad(arguments['entity'].id,
                              arguments['selectedMonth']);
                        }
                      },
                      backFunction: () => Navigator.pop(context, true),
                      isProduction: env.isProduction,
                      error: state.error.error.toString(),
                      errorCode: state.error.code.toString(),
                      textReturnButton: "back_to_the_previous_page",
                    ),
                  );
                }
                return Container();
              }),
        ));
  }

  String _formatDate(DateTime? date) {
    return date != null ? dateFormat.format(date) : '-';
  }

  Widget _buildList(ThemeData theme, PayslipLoadedState state) {
    if (state.data.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Text(getString(context, "gdp_payslip_error_no_file"),
            style: LelloTextStyles.error(theme), textAlign: TextAlign.center),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) {
          if (index == state.data.length) {
            return Padding(
              padding: EdgeInsets.all(Dimens.spacing),
              child: const Center(
                child: LoadingWidget(),
              ),
            );
          }
          final entity = state.data[index];
          return ListTile(
            contentPadding: EdgeInsets.all(Dimens.spacingMedium),
            title: Text(entity.description ?? "",
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Text(_formatDate(entity.processingDate),
                style: LelloTextStyles.subBody(theme)),
            onTap: () async {
              bloc.beginDownloadFile(entity.name!, state.numeroCadastro!);
            },
            // Navigator.of(context).pushNamed(
            //   ApplicationRoute.gdpPayslipDownload,
            //   arguments: {
            //     'nameFile': entity.name,
            //     'registrationNumber': state.numeroCadastro
            //   },
            // );

            trailing: SvgPicture.asset("assets/ic_arrow_right.svg", width: 6),
          );
        },
        controller: controller,
        separatorBuilder: (context, index) => Container(
            color: LelloTheme.palleteOf(theme).separator(), height: 1),
        itemCount: state.data.length);
  }
}

Future<void> renderPdf(context, PayslipFileDownloadedState state,
    PayslipSelectionBloc bloc) async {
  File value = await viewFile(state);

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          PDFScreen(pdfFile: value, title: getString(context, 'gdp_payslip_title')),
    ),
  );
  bloc.resetState();
}

Future<File> viewFile(PayslipFileDownloadedState state) async {
  Uint8List bytes = base64.decode(state.payslipFile.data ?? "");
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = File("$dir/${state.payslipFile.name!}");
  await file.writeAsBytes(bytes);
  return file;
}
