import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/error_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_my_favorites/comfort_disfavor_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_partner_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_my_favorites/favorite_partner_card.dart';
import 'package:shared_features/shared_features.dart';

class ComfortMyFavoritesPageArgs {
  ComfortPartnersController comfortPartnersController;
  AppOriginEnum appOriginEnum;
  ComfortMyFavoritesPageArgs(
      this.comfortPartnersController, this.appOriginEnum);
}

class ComfortMyFavoritesPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const ComfortMyFavoritesPage({Key? key, required this.appContainer})
      : super(key: key);

  @override
  _ComfortMyFavoritesPageState createState() => _ComfortMyFavoritesPageState();
}

class _ComfortMyFavoritesPageState extends State<ComfortMyFavoritesPage> {
  // SessionBloc sessionBloc = ApplicationContainer.instance().resolve();

  late ComfortPartnersController comfortPartnersController;
  late AppOriginEnum appOriginEnum;

  @override
  void initState() {
    comfortPartnersController = widget.appContainer.resolve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments
        as ComfortMyFavoritesPageArgs;
    ComfortPartnersController comfortPartnersController =
        arguments.comfortPartnersController;
    appOriginEnum = arguments.appOriginEnum;
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        _onPop();
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocConsumer(
          listener: ((context, state) {
            if (state is SuccessComfortPartnersState) {
              Navigator.pushNamed(
                context,
                SharedApplicationRoute.comfortDisfavorSuccess,
                arguments: ComfortDisfavorSuccessPageArgs(
                    comfortPartnersController, state.selectedPartner),
              );
            }
          }),
          bloc: comfortPartnersController.comfortPartnersBloc,
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(title: "comfort"),
              body: _buidScaffoldBody(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buidScaffoldBody(BuildContext context) {
    if (comfortPartnersController.comfortPartnersBloc.state
        is LoadingComfortPartnersState)
      return Column(
        children: [
          Expanded(child: LoadingWidget()),
        ],
      );

    if (comfortPartnersController.comfortPartnersBloc.state
        is ErrorComfortPartnersState)
      return ErrorMessageWidget(
          message: getString(
              context,
              (comfortPartnersController.comfortPartnersBloc.state
                      as ErrorComfortPartnersState)
                  .errorMessageKey));

    if (comfortPartnersController.comfortPartnersBloc.state
        is LoadedComfortPartnersState)
      return _buildMyFavoritesBody(
          context: context,
          state: (comfortPartnersController.comfortPartnersBloc.state
              as LoadedComfortPartnersState));
    return Container();
  }

  Widget _buildMyFavoritesBody({
    required BuildContext context,
    required LoadedComfortPartnersState state,
  }) {
    ThemeData theme = Theme.of(context);
    final Orientation orientation = MediaQuery.of(context).orientation;
    List<ComfortPartner> favoritePartners = comfortPartnersController
        .allPartnersList
        .where((element) => element.partnerIntro.favorite)
        .toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSnackBar(context, state.flushbarMessage);
    });

    return favoritePartners.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  getString(context, "comfort_my_favorites_empty"),
                  style: LelloTextStyles.subtitle(theme)
                      ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: Text(
                  getString(context, "comfort_my_favorites"),
                  style: LelloTextStyles.subtitleBold(theme)
                      ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
              ),
              Expanded(
                child: GridView.count(
                  primary: false,
                  childAspectRatio:
                      orientation == Orientation.landscape ? 2 : 0.75,
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
                  crossAxisSpacing: Dimens.spacingMedium,
                  mainAxisSpacing: Dimens.spacingMedium,
                  crossAxisCount: 2,
                  children: List<FavoritePartnerCard>.generate(
                    favoritePartners.length,
                    (int index) => FavoritePartnerCard(
                        applicationContainer: widget.appContainer,
                        partner: favoritePartners[index],
                        onPartnerSelectFunction: onPartnerSelected,
                        disfavorPartnerFunction:
                            comfortPartnersController.disfavorPartner),
                  ),
                ),
              ),
            ],
          );
  }

  void onPartnerSelected(ComfortPartner partner) {
    comfortPartnersController.goToPartnerDetailsPage(partner, ComfortPageOriginEnum.myFavoritesPage);
    Navigator.pushNamed(context, SharedApplicationRoute.comfortPartner,
        arguments: ComfortPartnerPageArgs(
          applicationContainer: widget.appContainer,
          appOriginEnum: appOriginEnum,
          comfortPartnersController: comfortPartnersController,
          reference: "",
        ));
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

  void _onPop() async {
    comfortPartnersController.backToLoadedComfortPartnersState(ComfortPageOriginEnum.myFavoritesPage);
  }
}
