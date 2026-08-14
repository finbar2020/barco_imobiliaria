import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_bloc.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_state.dart';
import 'package:shared_features/shared_features.dart';

class PayslipSelectionPageArgs {
  PayslipSelectionBloc payslipSelectionBloc;
  PayslipSelectionPageArgs(this.payslipSelectionBloc);
}

class PayslipSelectionPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const PayslipSelectionPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  _PayslipSelectionPageState createState() => _PayslipSelectionPageState();
}

class _PayslipSelectionPageState extends State<PayslipSelectionPage> {
  // final PayslipSelectionBloc bloc = ApplicationContainer.instance().resolve();
  late PayslipSelectionBloc bloc;
  final dateFormat = DateFormat.yMd();
  ScrollController? controller;
  var loaded = false;

  @override
  void initState() {
    super.initState();
    bloc = widget.appContainer.resolve();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    final Map? arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    if (!loaded && arguments != null) {
      bloc.beginLoad(arguments['entity'].id, arguments['selectedMonth']);
      loaded = true;
    }

    return Theme(
        data: theme,
        child: Scaffold(
          appBar: PrimaryAppBar(
              theme: theme, title: getString(context, 'gdp_payslip_title')),
          body: BlocBuilder(
              bloc: bloc,
              builder: (context, state) {
                if (state is PayslipLoadedState)
                  return _buildList(theme, state);
                if (state is PayslipFileDownloadedState) {
                  renderPdf(context, state, bloc);
                }
                if (state is PayslipLoadingState)
                  return Center(child: CircularProgressIndicator());
                if (state is PayslipLoadFailedState)
                  return Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: Text(FailureMessage.get(context, state.error) ?? "",
                        style: LelloTextStyles.error(theme),
                        textAlign: TextAlign.center),
                  );
                return Container();
              }),
        ));
  }

  String _formatDate(DateTime? date) {
    return date != null ? dateFormat.format(date) : '-';
  }

  Widget _buildList(ThemeData theme, PayslipLoadedState state) {
    if (state.data.length == 0) {
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
              child: Center(
                child: CircularProgressIndicator(),
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
          PDFScreen(pdfFile: value, title: 'gdp_payslip_title'),
    ),
  );
  bloc.resetState();
}

Future<File> viewFile(PayslipFileDownloadedState state) async {
  Uint8List bytes = base64.decode(state.payslipFile.data ?? "");
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = File("$dir/" + state.payslipFile.name!);
  await file.writeAsBytes(bytes);
  return file;
}
