import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

import '../bloc/sample_bloc_page_bloc.dart';
import '../bloc/sample_bloc_page_state.dart';
import '../controllers/sample_bloc_page_controller.dart';

class SampleBlocPageWidget extends StatefulWidget {
  const SampleBlocPageWidget({
    super.key,
  });

  @override
  State<SampleBlocPageWidget> createState() => _SampleBlocPageWidgetState();
}

class _SampleBlocPageWidgetState extends State<SampleBlocPageWidget> {
  final SampleBlocPageController controller =
      SampleBlocPageController(SampleBlocPageBloc());
  // Replace the following line with the following code
  // final SampleBlocPageController controller =
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
          if (state is SampleBlocPageEmptyState) {
            // do something
          } else if (state is SampleBlocPageLoadingState) {
            // do something
          } else if (state is SampleBlocPageSuccessState) {
            // do something
          } else if (state is SampleBlocPageFailureState) {
            // do something
          }
        },
        builder: (context, state) {
          if (state is SampleBlocPageEmptyState) {
            return _buildEmptyWidget();
          } else if (state is SampleBlocPageLoadingState) {
            return _buildLoadingWidget();
          } else if (state is SampleBlocPageSuccessState) {
            return _buildSuccessWidget(state);
          } else if (state is SampleBlocPageFailureState) {
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

  Widget _buildSuccessWidget(SampleBlocPageSuccessState state) {
    return Container();
  }

  Widget _buildFailureWidget(SampleBlocPageFailureState state) {
    return Container();
  }
}
