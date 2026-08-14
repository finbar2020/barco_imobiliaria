import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_step.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_state.dart';
import 'package:lello/feature/space/registration/presentation/widget/space_registration_charging_widget.dart';
import 'package:lello/feature/space/registration/presentation/widget/space_registration_confirmation_widget.dart';
import 'package:lello/feature/space/registration/presentation/widget/space_registration_data_widget.dart';
import 'package:lello/feature/space/registration/presentation/widget/space_registration_registering_widget.dart';
import 'package:lello/feature/space/registration/presentation/widget/space_registration_rules_widget.dart';
import 'package:lello/feature/space/registration/presentation/widget/space_registration_usage_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class SpaceDetailPage extends StatefulWidget {
  const SpaceDetailPage({Key? key}) : super(key: key);

  @override
  SpaceDetailPageState createState() => SpaceDetailPageState();
}

class SpaceDetailPageState extends State<SpaceDetailPage> {
  final SpaceRegistrationBloc bloc = ApplicationContainer.instance().resolve();
  var setUp = false;

  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Space space = ModalRoute.of(context)!.settings.arguments as Space;
    if (!setUp) {
      bloc.setup(space);
      setUp = true;
    }
    return Theme(
        data: theme,
        child: Scaffold(
            appBar: PrimaryAppBar(
                title: getString(context, "space_registration_title"),
                theme: theme),
            body: BlocProvider.value(
              value: bloc,
              child: BlocConsumer(
                bloc: bloc,
                listener: (context, state) {
                  if (state is SpaceRegistrationInitialState) {
                    _scrollController.jumpTo(0);
                  }
                  if (state is SpaceRegistrationRegisteredState) {
                    pushNamedAndPopUntil(
                        context,
                        ApplicationRoute.spaceRegistrationSuccess,
                        ModalRoute.withName(ApplicationRoute.spaceList));
                  }
                },
                builder: (context, state) =>
                    _buildBody(theme, state as SpaceRegistrationState),
              ),
            )));
  }

  Widget _buildBody(ThemeData theme, SpaceRegistrationState state) {
    if (state is SpaceRegistrationRegisteringState) {
      return const Center(child: LoadingWidget());
    }
    return WillPopScope(
      onWillPop: () async {
        return bloc.previousStep();
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
            children: [_buildHeader(theme, state), _buildForm(theme, state)]),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, SpaceRegistrationState state) {
    if (state.step == SpaceRegistrationStep.confirmation) return Container();
    return Container(
      decoration: BoxDecoration(
          color: LelloTheme.palleteOf(theme).separator(),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SvgPicture.asset("assets/ic_unit.svg"),
        title: Text(getString(context, "condominium"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(state.condominium?.name ?? "-",
            style: LelloTextStyles.subBody(theme)),
      ),
    );
  }

  Widget _buildForm(ThemeData theme, SpaceRegistrationState state) {
    if (state is SpaceRegistrationLoadingState) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: const Center(child: LoadingWidget()),
      );
    }
    switch (state.step!) {
      case SpaceRegistrationStep.data:
        return const SpaceRegistrationDataWidget(shrinkList: true);
      case SpaceRegistrationStep.rules:
        return const SpaceRegistrationRulesWidget(shrinkList: true);
      case SpaceRegistrationStep.usage:
        return const SpaceRegistrationUsageWidget(shrinkList: true);
      case SpaceRegistrationStep.charges:
        return const SpaceRegistrationChargingWidget(shrinkList: true);
      case SpaceRegistrationStep.confirmation:
        return const SpaceRegistrationConfirmationWidget(shrinkList: true);
      case SpaceRegistrationStep.registration:
        return SpaceRegistrationRegisteringWidget();
    }
  }
}
