import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/error_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/controller/comfort_partner_reviews_controller.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/rating_bar_widget.dart';
import 'package:shared_features/shared_features.dart';

class ComfortPartnerReviewsPageArgs {
  ComfortPartner partner;
  String reference;
  String? unit;
  ComfortPartnerReviewsPageArgs({
    required this.reference,
    this.unit,
    required this.partner,
  });
}

class ComfortPartnerReviewsPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const ComfortPartnerReviewsPage({Key? key, required this.appContainer})
      : super(key: key);

  @override
  _ComfortPartnerReviewsPageState createState() =>
      _ComfortPartnerReviewsPageState();
}

class _ComfortPartnerReviewsPageState extends State<ComfortPartnerReviewsPage> {
  late ComfortPartnerReviewsController comfortPartnerReviewsController;
  bool firstLoad = true;

  @override
  void initState() {
    comfortPartnerReviewsController =
        widget.appContainer.resolve<ComfortPartnerReviewsController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments
        as ComfortPartnerReviewsPageArgs;
    _firstPageConfig(arguments);
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocProvider.value(
          value: comfortPartnerReviewsController.comfortPartnerReviewsBloc,
          child: BlocBuilder(
            bloc: comfortPartnerReviewsController.comfortPartnerReviewsBloc,
            builder: (context, state) {
              return Scaffold(
                appBar: CustomAppBar(title: "comfort"),
                body: _buidScaffoldBody(
                    context: context, partner: arguments.partner),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buidScaffoldBody({
    required BuildContext context,
    required ComfortPartner partner,
  }) {
    if (comfortPartnerReviewsController.comfortPartnerReviewsBloc.state
        is LoadingComfortPartnerReviewsState)
      return Column(
        children: [
          Expanded(child: LoadingWidget()),
        ],
      );

    if (comfortPartnerReviewsController.comfortPartnerReviewsBloc.state
        is ErrorComfortPartnerReviewsState)
      return ErrorMessageWidget(
          message: getString(
              context,
              (comfortPartnerReviewsController.comfortPartnerReviewsBloc.state
                      as ErrorComfortPartnerReviewsState)
                  .errorMessageKey));

    if (comfortPartnerReviewsController.comfortPartnerReviewsBloc.state
        is LoadedComfortPartnerReviewsState)
      return _buildPartnerReviewsBody(
        context: context,
        state: comfortPartnerReviewsController.comfortPartnerReviewsBloc.state
            as LoadedComfortPartnerReviewsState,
        partner: partner,
      );
    return Container();
  }

  Widget _buildPartnerReviewsBody({
    required BuildContext context,
    required LoadedComfortPartnerReviewsState state,
    required ComfortPartner partner,
  }) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
            child: CustomCachedNetworkImage(
                applicationContainer: widget.appContainer,
                link: partner.partnerIntro.partnerImageLink),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            partner.partnerIntro.title,
            style: LelloTextStyles.titleSmallBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).grey()),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            partner.ratingFormatted,
            style: LelloTextStyles.headline(theme)
                ?.copyWith(color: theme.primaryColor),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Center(
            child: RatingBarWidget(
              allowHalfRating: true,
              initValue: partner.rating,
            ),
          ),
          SizedBox(height: Dimens.spacing),
          Text(
            getString(context, "comfort_ratings_total")
                .replaceFirst("###", partner.ratingsNumber.toString()),
            style: LelloTextStyles.subtitleBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).grey()),
          ),
          SizedBox(height: Dimens.spacing),
          Expanded(
            child: ListView.separated(
              itemBuilder: ((context, index) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: LelloTextStyles.body(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).text()),
                          children: [
                            TextSpan(
                              text: state.partnerReviews[index].name,
                              style: LelloTextStyles.subtitle(theme)?.copyWith(
                                  color: LelloTheme.palleteOf(theme).text()),
                            ),
                            if (state.partnerReviews[index].name?.isNotEmpty ==
                                    true &&
                                state.partnerReviews[index].formattedDate
                                    .isNotEmpty)
                              TextSpan(text: " - "),
                            TextSpan(
                                text:
                                    state.partnerReviews[index].formattedDate),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                      Row(
                        children: [
                          Text(
                            state.partnerReviews[index].review.toString(),
                            style: LelloTextStyles.body(theme)
                                ?.copyWith(color: theme.primaryColor),
                          ),
                          RatingBarWidget(
                            allowHalfRating: false,
                            initValue: state.partnerReviews[index].review,
                            size: 16.0,
                          ),
                        ],
                      ),
                      if (state.partnerReviews[index].comment != null)
                        Padding(
                          padding: EdgeInsets.only(top: Dimens.spacing),
                          child: Text(
                            state.partnerReviews[index].comment ?? "",
                            style: LelloTextStyles.body(theme)?.copyWith(
                                color: LelloTheme.palleteOf(theme).textLight()),
                          ),
                        ),
                    ],
                  ),
                );
              }),
              separatorBuilder: (context, index) => Divider(),
              itemCount: state.partnerReviews.length,
              scrollDirection: Axis.vertical,
            ),
          )
        ],
      ),
    );
  }

  void _firstPageConfig(ComfortPartnerReviewsPageArgs arguments) {
    if (firstLoad) {
      firstLoad = false;
      comfortPartnerReviewsController.getAllPartnerReviews(
          arguments.partner.id, arguments.partner.partnerIntro.title);
    }
  }
}
