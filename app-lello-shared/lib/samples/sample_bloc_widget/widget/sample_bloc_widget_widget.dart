import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

import '../bloc/sample_bloc_widget_bloc.dart';
import '../bloc/sample_bloc_widget_state.dart';
import '../controllers/sample_bloc_widget_controller.dart';

class SampleBlocWidgetWidget extends StatefulWidget {
  const SampleBlocWidgetWidget({
    super.key,
  });

  @override
  State<SampleBlocWidgetWidget> createState() => _SampleBlocWidgetWidgetState();
}

class _SampleBlocWidgetWidgetState extends State<SampleBlocWidgetWidget> {
  final SampleBlocWidgetController controller =
      SampleBlocWidgetController(SampleBlocWidgetBloc());
  // Replace the following line with the following code
  // final SampleBlocWidgetController controller =
  //     ApplicationContainer.instance().resolve();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Theme(
      data: theme,
      child: BlocConsumer(
        bloc: controller.bloc,
        listener: (context, state) {
          if (state is SampleBlocWidgetEmptyState) {
            // do something
          } else if (state is SampleBlocWidgetLoadingState) {
            // do something
          } else if (state is SampleBlocWidgetSuccessState) {
            // do something
          } else if (state is SampleBlocWidgetFailureState) {
            // do something
          }
        },
        builder: (context, state) {
          if (state is SampleBlocWidgetEmptyState) {
            return _buildEmptyWidget();
          } else if (state is SampleBlocWidgetLoadingState) {
            return _buildLoadingWidget();
          } else if (state is SampleBlocWidgetSuccessState) {
            return _buildSuccessWidget(state);
          } else if (state is SampleBlocWidgetFailureState) {
            return _buildFailureWidget(state);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container();
  }

  Widget _buildLoadingWidget() {
    return Container();
  }

  Widget _buildSuccessWidget(SampleBlocWidgetSuccessState state) {
    return Container();
  }

  Widget _buildFailureWidget(SampleBlocWidgetFailureState state) {
    return Container();
  }
}
