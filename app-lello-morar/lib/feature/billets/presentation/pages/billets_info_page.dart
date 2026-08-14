import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/app_review/app_review.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';
import 'package:morar/feature/billets/domain/entity/billet_status_enum.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_state.dart';
import 'package:morar/feature/billets/presentation/controllers/billets_controller.dart';
import 'package:morar/feature/billets/presentation/widgets/billet_info_intro_widget.dart';
import 'package:morar/feature/billets/presentation/widgets/billet_pending_details_widget.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class BilletsInfoPage extends StatefulWidget {
  const BilletsInfoPage({Key? key}) : super(key: key);

  @override
  _BilletsInfoPageState createState() => _BilletsInfoPageState();
}

class _BilletsInfoPageState extends State<BilletsInfoPage> {
  bool showReviewAppDialog = false;

  late SessionBloc sessionBloc;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments;
    final BilletsController controller = arguments as BilletsController;

    final theme = Theme.of(context);
    sessionBloc = BlocProvider.of(context);

    return Theme(
      data: theme,
      child: BlocBuilder(
        bloc: controller.bloc,
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              controller.getBillets();
              return _onWillPop(context);
            },
            child: Scaffold(
              appBar: WhiteAppBar(
                  title: getString(context, "income_control_billets"),
                  onPressed: () {
                    _onWillPop(context);
                    controller.getBillets();
                    Navigator.pop(context);
                  }),
              body:
                  _buildBody(context, theme, state as BilletsState, controller),
            ),
          );
        },
      ),
    );
  }

  bool _onWillPop(BuildContext context) {
    if (showReviewAppDialog) {
      AppReview.call(context: context);
    }
    return true;
  }

  Widget _buildBody(BuildContext context, ThemeData theme, BilletsState state,
      BilletsController controller) {
    if (state is BilletsLoadingState || state is BilletsLoadedState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }

    if (state is BilletsFailureState) {
      return _buildError(state.errorMessageKey);
    }

    if (state is BilletsShowInfoState) {
      Billet billet = state.billet;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BilletInfoIntroWidget(
                billet: state.billet,
                condominiumName:
                    "${controller.sessionBloc.state.session?.condominium?.name ?? ''} - ${controller.sessionBloc.state.session?.unity?.title ?? ''}",
              ),
              Divider(height: 2.0),
              if (state.billet.founds.isNotEmpty)
                BilletFoundsListWidget(founds: state.billet.founds),
              Divider(height: 2.0),
              SizedBox(height: Dimens.spacingLarge),
              if ([BilletStatusEnum.pendente, BilletStatusEnum.baixado]
                  .contains(billet.situation))
                BilletPendingDetailsWidget(
                    billet: billet,
                    copyBarcodeFunction: clipboardText,
                    pdf: state.pdf,
                    fileName: state.fileName),
              SizedBox(height: Dimens.spacingLarge),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Column _buildError(String errorMessageKey) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                getString(context, errorMessageKey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void clipboardText(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      _registerAnalyticsEventBarCode();
      return Flushbar(
        duration: Duration(seconds: 1),
        message: getString(context, "billet_copied_barcode"),
      )..show(context).then((value) => showReviewAppDialog = true);
    });
  }

  void _registerAnalyticsEventBarCode() {
    String reference = sessionBloc.state.session?.condominium?.reference ?? "";
    String unit = sessionBloc.state.session?.unity?.title ?? "";
    OwnerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsOwner.boletosCopiarCodigoDeBarras(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: unit,
      referenceValue: reference,
    );
  }
}
