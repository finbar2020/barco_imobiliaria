import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/error_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/controller/comfort_my_request_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_rating_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/partner_info_widget.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/rating_bar_widget.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/request_rating_widgets/rate_request_opinion_widget.dart';
import 'package:shared_features/shared_features.dart';

class ComfortRateRequestPageArgs {
  ComfortMyRequestsController comfortMyRequestsController;
  ComfortRateRequestPageArgs(this.comfortMyRequestsController);
}

class ComfortRateRequestPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const ComfortRateRequestPage({Key? key, required this.appContainer})
      : super(key: key);

  @override
  _ComfortRateRequestPageState createState() => _ComfortRateRequestPageState();
}

class _ComfortRateRequestPageState extends State<ComfortRateRequestPage> {
  // SessionBloc sessionBloc = ApplicationContainer.instance().resolve();
  late ComfortMyRequestsController comfortMyRequestsController;

  double? userRating;
  String? userOpinion;

  final TextEditingController controller = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    comfortMyRequestsController = widget.appContainer
        .resolve<ComfortMyRequestsController>(); // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments
        as ComfortRateRequestPageArgs;
    comfortMyRequestsController = arguments.comfortMyRequestsController;
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        _onPop(comfortMyRequestsController);
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocConsumer(
          listener: (context, state) {
            if (state is SuccessComfortMyRequestsState) {
              Navigator.pushReplacementNamed(
                context,
                SharedApplicationRoute.comfortSuccessRateRequest,
                arguments:
                    ComfortRatingSuccessPageArgs(comfortMyRequestsController),
              );
            }
          },
          bloc: comfortMyRequestsController.comfortMyRequestsBloc,
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(title: "comfort"),
              body: _buidScaffoldBody(
                  context: context,
                  comfortMyRequestsController: comfortMyRequestsController),
            );
          },
        ),
      ),
    );
  }

  Widget _buidScaffoldBody({
    required BuildContext context,
    required ComfortMyRequestsController comfortMyRequestsController,
  }) {
    if (comfortMyRequestsController.comfortMyRequestsBloc.state
        is LoadingComfortMyRequestsState)
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );

    if (comfortMyRequestsController.comfortMyRequestsBloc.state
        is ErrorComfortMyRequestsState)
      return ErrorMessageWidget(
        message: getString(
            context,
            (comfortMyRequestsController.comfortMyRequestsBloc.state
                    as ErrorComfortMyRequestsState)
                .errorMessageKey),
      );

    if (comfortMyRequestsController.comfortMyRequestsBloc.state
        is LoadedRateRequestState)
      return _buildRateBody(
          context: context,
          comfortMyRequestsController: comfortMyRequestsController,
          state: comfortMyRequestsController.comfortMyRequestsBloc.state
              as LoadedRateRequestState);
    return Container();
  }

  Widget _buildRateBody({
    required BuildContext context,
    required ComfortMyRequestsController comfortMyRequestsController,
    required LoadedRateRequestState state,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSnackBar(context, state.flushbarMessage);
    });
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (textFieldFocusNode.hasPrimaryFocus) {
          textFieldFocusNode.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PartnerIntroWidget(
              applicationContainer: widget.appContainer,
              partnerIntro: state.selectedRequest.partner.partnerIntro,
              changeFavoriteStatus:
                  comfortMyRequestsController.changePartnerFavoriteStatus,
            ),
            _buildDescription(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
              child: Text(
                getString(context, "comfort_rate_rating"),
                style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
            ),
            SizedBox(height: Dimens.spacing),
            Center(
              child: RatingBarWidget(
                allowHalfRating: false,
                initValue: userRating ?? 0,
                size: 40,
                setRating: (value) {
                  setState(() {
                    userRating = value;
                  });
                },
              ),
            ),
            SizedBox(height: Dimens.spacingLarge),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
              child: Text(
                getString(context, "comfort_rate_give_your_opinion"),
                style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
            ),
            RateRequestOpinionWidget(
              focusNode: textFieldFocusNode,
              controller: controller,
              hintText: getString(context, 'comfort_rate_write_here'),
            ),
            _sendRatingButton(
              context: context,
              onPressed: _buttonValidate(userRating)
                  ? () => comfortMyRequestsController.reviewRequest(
                      requestId: state.selectedRequest.idRequest,
                      rate: userRating!,
                      comment: controller.text)
                  : null,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getString(context, "comfort_rate_title"),
            style: LelloTextStyles.subtitleBold(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
          SizedBox(height: Dimens.spacing),
          Text(
            getString(context, "comfort_rate_subtitle"),
            style: LelloTextStyles.subtitle(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
        ],
      ),
    );
  }

  Container _sendRatingButton(
      {required BuildContext context, required Function()? onPressed}) {
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: PrimaryButton(
          child: Row(children: [
            Spacer(),
            Text(
              getString(context, "comfort_rate_send"),
            ),
            Spacer(),
          ]),
          onPressed: onPressed),
    );
  }

  void _showSnackBar(BuildContext context, String? textKey) {
    if (textKey == null) {
      return null;
    }
    String text = getString(context, textKey);
    if (text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
      ));
    }
  }

  void _onPop(ComfortMyRequestsController comfortMyRequestsController) async {
    comfortMyRequestsController.backToLoadedMyRequestsState();
  }

  bool _buttonValidate(double? userRating) {
    if (userRating == null) {
      return false;
    }
    if (userRating < 1) {
      return false;
    }
    return true;
  }
}
