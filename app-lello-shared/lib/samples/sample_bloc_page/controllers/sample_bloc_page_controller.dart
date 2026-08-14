import 'package:flutter/material.dart';

import '../bloc/sample_bloc_page_bloc.dart';

class SampleBlocPageController {
  PageController pageController = PageController(initialPage: 0);

  final SampleBlocPageBloc bloc;

  SampleBlocPageController(this.bloc);
}
