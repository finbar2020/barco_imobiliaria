import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/core/widgets/error_message_widget.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';

class AgreementsMadeCardDetailsPage extends StatefulWidget {
  const AgreementsMadeCardDetailsPage({Key? key}) : super(key: key);

  @override
  State<AgreementsMadeCardDetailsPage> createState() =>
      _AgreementsMadeCardDetailsPageState();
}

class _AgreementsMadeCardDetailsPageState
    extends State<AgreementsMadeCardDetailsPage> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List;
    AgreementsBloc agreementsBloc = arguments[0];
    final theme = LelloTheme.light;
    return Theme(
      data: theme,
      child: BlocBuilder<AgreementsBloc, AgreementsState>(
        bloc: agreementsBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PrimaryAppBar(
                title: getString(context, "agreements_in_progress_title"),
                theme: theme,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: theme.primaryColor,
                      onPressed: () {
                        // agreementsBloc.backToHistoryPage();
                        // Navigator.pushReplacementNamed(
                        //     context, ApplicationRoute.agreementsHistory,
                        //     arguments: [agreementsBloc]);
                      }),
                )),
            body:
                _agreementsMadeCardDetailsBody(context: context, state: state),
          );
        },
      ),
    );
  }

  Widget _agreementsMadeCardDetailsBody(
      {required BuildContext context, required AgreementsState state}) {
    if (state is AgreementsLoadingState) return LoadingWidget();

    if (state is AgreementsErrorState)
      return ErrorMessageWidget(
          message: getString(context, state.errorMessageKey));

    // if (state is AgreementsDetailsLoadedState)
    //   return _showMadeCardDetailsWidget(state: state, context: context);
    return Container();
  }

  // Widget _showMadeCardDetailsWidget(
  //     {required AgreementsDetailsLoadedState state,
  //     required BuildContext context}) {
  //   final theme = LelloTheme.light;
  //   return Column(
  //     children: [
  //       IntroductionDetailsCard(theme: theme, agreement: state.agreement),
  //       Expanded(
  //         flex: 11,
  //         child: ListView.builder(
  //           itemCount: state.agreement.quotas?.length ?? 0,
  //           scrollDirection: Axis.vertical,
  //           shrinkWrap: true,
  //           itemBuilder: (BuildContext context, int index) {
  //             return AgreementsDetails(
  //               theme: theme,
  //               index: index + 1,
  //               quota: state.agreement.quotas![index],
  //             );
  //           },
  //         ),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.symmetric(horizontal: Dimens.spacingLarge),
  //         child: Divider(height: 2),
  //       ),
  //       Expanded(
  //           flex: 5,
  //           child: PaymentDetailsCard(
  //               installments: state.agreement.installments!)),
  //     ],
  //   );
  // }
}
