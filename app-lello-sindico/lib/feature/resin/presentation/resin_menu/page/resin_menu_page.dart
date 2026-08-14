import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resin/presentation/resin_menu/controller/resin_menu_controller.dart';
import 'package:lello/feature/resin/presentation/resin_menu/widgets/resin_menu_widget.dart';

class ResinMenuPage extends StatefulWidget {
  const ResinMenuPage({Key? key}) : super(key: key);

  @override
  State<ResinMenuPage> createState() => _ResinMenuPageState();
}

class _ResinMenuPageState extends State<ResinMenuPage> {
  ResinMenuController controller = ApplicationContainer.instance().resolve();

  @override
  void initState() {
    controller.menuGetParams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocProvider.value(
        value: controller.bloc,
        child: Scaffold(
          appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            title: getString(context, "resin_title_app_bar"),
            theme: theme,
          ),
          body: ResinMenuWidget(controller: controller),
        ));
  }
}
