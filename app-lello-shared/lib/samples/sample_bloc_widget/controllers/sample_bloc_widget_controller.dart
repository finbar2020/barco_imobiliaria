import 'package:flutter/material.dart';

import '../bloc/sample_bloc_widget_bloc.dart';

class SampleBlocWidgetController {
  PageController pageController = PageController(initialPage: 0);

  final SampleBlocWidgetBloc bloc;

  SampleBlocWidgetController(this.bloc);
}
