import 'package:colaborador/core/dependency/application_container.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';

class ComfortRouteWrapperPage extends StatelessWidget {
  const ComfortRouteWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "comfort"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ComfortPage(
          appContainer: ApplicationContainer.instance(),
          appOriginEnum: AppOriginEnum.employee,
          embedded: true,
          backFunction: () => Navigator.maybePop(context),
        ),
      ),
    );
  }
}
