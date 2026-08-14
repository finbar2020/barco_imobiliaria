import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_state.dart';
import 'package:morar/feature/billets/presentation/controllers/billets_controller.dart';
import 'package:morar/feature/billets/presentation/widgets/billets_card_widget.dart';

class BilletsPageArgs {
  String? billetsNotificationContext;
  BilletsPageArgs({this.billetsNotificationContext});
}

class BilletsPage extends StatefulWidget {
  const BilletsPage({Key? key}) : super(key: key);

  @override
  _BilletsPageState createState() => _BilletsPageState();
}

class _BilletsPageState extends State<BilletsPage> {
  final BilletsController controller =
      ApplicationContainer.instance().resolve<BilletsController>();
  BilletsPageArgs? arguments;
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  @override
  void initState() {
    super.initState();
    controller.getBillets();
  }

  @override
  Widget build(BuildContext context) {
    String reference = controller
            .sessionBloc.state.session?.condominium?.reference
            ?.toString() ??
        "";
    final theme = Theme.of(context);
    arguments = ModalRoute.of(context)?.settings.arguments as BilletsPageArgs?;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocProvider.value(
          value: controller.bloc,
          child: BlocBuilder(
            bloc: controller.bloc,
            builder: (context, state) {
              return Scaffold(
                appBar: CustomAppBar(title: "income_control_billets"),
                body: _scaffoldBody(
                    state as BilletsState, theme, controller, reference),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _scaffoldBody(BilletsState state, ThemeData theme,
      BilletsController controller, reference) {
    if (state is BilletsInitialState) {
      return Column(
        children: [
          Expanded(
            child: _buildEmpty(),
          ),
        ],
      );
    }
    if (state is BilletsLoadingState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    if (state is BilletsLoadedState) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (arguments?.billetsNotificationContext?.isNotEmpty == true &&
            mounted) {
          var item = state.billets.cast<Billet?>().firstWhere(
              (element) =>
                  element?.notificationParameter ==
                      arguments?.billetsNotificationContext ||
                  element?.id == arguments?.billetsNotificationContext,
              orElse: () => null);
          if (item != null) {
            controller.showBillet(item);
            Navigator.pushNamed(
              context,
              ApplicationRoute.billetsInfo,
              arguments: controller,
            );
          }
          arguments?.billetsNotificationContext = null;
        }
      });

      return _buildBody(state, theme, controller);
    }
    if (state is BilletsFailureState) {
      return _buildError(state.errorMessageKey);
    }
    return Container();
  }

  Widget _buildBody(
      BilletsLoadedState state, ThemeData theme, BilletsController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            color: LelloTheme.palleteOf(theme).backgroundDark(),
            width: double.infinity,
            height: Dimens.spacingLarge,
            child: Center(
              child: Text(
                '${controller.sessionBloc.state.session?.condominium?.name ?? ''} - ${controller.sessionBloc.state.session?.unity?.title ?? ''}',
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.body(theme),
              ),
            ),
          ),
          SizedBox(height: Dimens.spacing),
          _buildList(state, controller, theme),
          SizedBox(height: Dimens.spacing),
        ],
      ),
    );
  }

  Widget _buildList(
      BilletsLoadedState state, BilletsController controller, ThemeData theme) {
    var listDuplicate =
        state.billets.where((element) => element.isDuplicate == true).toList();
    var listOthers =
        state.billets.where((element) => element.isDuplicate == false).toList();

    if (listDuplicate.isEmpty || listOthers.isEmpty) {
      return _billetList(state.billets);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: Dimens.spacing, bottom: Dimens.spacing),
          child: Text(
            getString(context, "income_control_billets_2_via"),
            style: LelloTextStyles.subtitleBold(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).primary(),
            ),
          ),
        ),
        Divider(height: 3, color: LelloTheme.palleteOf(theme).greyDarker()),
        _billetList(listDuplicate),
        SizedBox(height: Dimens.spacingMedium),
        Padding(
          padding:
              EdgeInsets.only(left: Dimens.spacing, bottom: Dimens.spacing),
          child: Text(getString(context, "income_control_billets_outros"),
              style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).primary(),
              )),
        ),
        Divider(height: 3, color: LelloTheme.palleteOf(theme).greyDarker()),
        _billetList(listOthers)
      ],
    );
  }

  Widget _billetList(List<Billet> billets) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: billets.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 1,
        color: Colors.grey,
      ),
      itemBuilder: (BuildContext context, int index) {
        final billet = billets[index];
        return BilletsCardWidget(
          model: billet,
          onTap: () {
            controller.showBillet(billet);
            Navigator.pushNamed(
              context,
              ApplicationRoute.billetsInfo,
              arguments: controller,
            );
          },
        );
      },
    );
  }

  Column _buildError(String errorMessageKey) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: ErrorHandlingWidget(
              reTryFunction: () {
                controller.getBillets();
              },
              backFunction: () => Navigator.pop(context, true),
              isProduction: env.isProduction,
              error: "",
              errorCode: "",
            ),
          ),
        ),
      ],
    );
  }

  Column _buildEmpty() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                getString(context, "billets_empty"),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
