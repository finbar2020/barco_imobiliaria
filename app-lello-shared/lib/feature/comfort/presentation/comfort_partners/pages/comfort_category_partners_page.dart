import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_partner_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partners_list_view_horizontal_scrolling.dart';
import 'package:shared_features/shared_features.dart';

class ComfortCategoryPartnersPage extends StatelessWidget {
  final ComfortPartnerCategory category;
  final ComfortPartnersController comfortPartnersController;
  final SharedApplicationContainer appContainer;
  final AppOriginEnum appOriginEnum;
  final String reference;
  final String? unit;

  const ComfortCategoryPartnersPage({
    Key? key,
    required this.category,
    required this.comfortPartnersController,
    required this.appContainer,
    required this.appOriginEnum,
    required this.reference,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final partners =
        comfortPartnersController.partnersList(category: category);
    return Scaffold(
      appBar: CustomAppBar(title: "comfort"),
      body: BlocConsumer<ComfortPartnersBloc, ComfortPartnersState>(
        bloc: comfortPartnersController.comfortPartnersBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is! LoadedComfortPartnersState) {
            return Column(
              children: [
                Expanded(child: LoadingWidget()),
              ],
            );
          }

          if (state is ErrorComfortPartnersState) {
            return Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: ErrorHandlingWidget(
                reTryFunction: () {
                  comfortPartnersController.getAllPartners(
                      ComfortPageOriginEnum.comfortPageTryAgain);
                },
                backFunction: () => Navigator.maybePop(context),
                isProduction: true,
              ),
            );
          }

          return SingleChildScrollView(
            child: ComfortPartnersListViewHorizontalScrolling(
              applicationContainer: appContainer,
              partners: partners,
              onPressed: (ComfortPartner partner) {
                comfortPartnersController.goToPartnerDetailsPage(
                    partner, ComfortPageOriginEnum.coupon);
                Navigator.pushNamed(
                    context, SharedApplicationRoute.comfortPartner,
                    arguments: ComfortPartnerPageArgs(
                      applicationContainer: appContainer,
                      comfortPartnersController: comfortPartnersController,
                      reference: reference,
                      unit: unit,
                      appOriginEnum: appOriginEnum,
                    ));
              },
              backPressed: () => Navigator.maybePop(context),
              initializeAnalyticsTimer: () =>
                  comfortPartnersController.comfortCategoryAnalyticsTimerStart(
                category,
                debugEventIdentifier: "comfort_category_partners_page",
              ),
              stopAnalyticsTimer: () =>
                  comfortPartnersController.comfortCategoryAnalyticsStopTimer(),
              onCategoryDispose: (cat) =>
                  comfortPartnersController.analyticsComfortCategoryPageBack(cat),
            ),
          );
        },
      ),
    );
  }
}
