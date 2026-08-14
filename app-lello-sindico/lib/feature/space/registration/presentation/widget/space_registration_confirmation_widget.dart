import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/presentation/failure_message.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_state.dart';
import 'package:lello/feature/space/registration/presentation/widget/space_detail_widget.dart';

class SpaceRegistrationConfirmationWidget extends StatefulWidget {
  final bool shrinkList;

  const SpaceRegistrationConfirmationWidget({Key? key, this.shrinkList = false})
      : super(key: key);

  @override
  _SpaceRegistrationConfirmationWidgetState createState() =>
      _SpaceRegistrationConfirmationWidgetState();
}

class _SpaceRegistrationConfirmationWidgetState
    extends State<SpaceRegistrationConfirmationWidget> {
  late SpaceRegistrationBloc bloc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bloc = BlocProvider.of(context);
    return _buildForm(theme);
  }

  Widget _buildHeader(ThemeData theme, SpaceRegistrationState state) {
    final failure =
        state is SpaceRegistrationRegisterFailedState ? state.error : null;
    final error = failure != null ? FailureMessage.get(context, failure) : null;
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingLarge),
      child: Column(
        children: [
          Visibility(
            visible: error?.isNotEmpty == true,
            child: Padding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: Text(
                  error ?? "",
                  style: LelloTextStyles.error(theme),
                  textAlign: TextAlign.center,
                )),
          ),
          Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Text(
                  getString(context, "register_payment_confirmation_title"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme))),
          StepIndicator(numberOfSteps: 5, currentStep: 5),
        ],
      ),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return BlocBuilder<SpaceRegistrationBloc, SpaceRegistrationState>(
      bloc: bloc,
      builder: (context, state) => ListView(
        shrinkWrap: widget.shrinkList,
        physics: widget.shrinkList ? NeverScrollableScrollPhysics() : null,
        children: [
          _buildHeader(theme, state),
          SpaceDetailWidget(
              onEditRequested: (step) {
                bloc.goToStep(step);
              },
              shrinkList: true,
              space: state.data),
          Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PrimaryButton(
                  onPressed: () {
                    bloc.nextStep();
                  },
                  text: getString(context, "confirm"),
                ),
                SizedBox(height: Dimens.spacing),
                SecondaryButton(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  text: getString(context, "back"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
