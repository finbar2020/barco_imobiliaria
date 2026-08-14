import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/space/presentation/widget/space_list_widget.dart';

class SpaceListPage extends StatefulWidget {
  const SpaceListPage({Key? key}) : super(key: key);

  @override
  SpaceListPageState createState() => SpaceListPageState();
}

class SpaceListPageState extends State<SpaceListPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            title: getString(context, "space_register"), theme: theme),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: SpaceListWidget(
              onPressed: (space) async {
                await Navigator.of(context)
                    .pushNamed(ApplicationRoute.spaceDetail, arguments: space);
              },
              header: Padding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: Text(getString(context, "space_list_title"),
                    style: LelloTextStyles.title(theme)),
              ),
            ),
          ),
          _buildBottom(theme)
        ]),
      ),
    );
  }

  Widget _buildBottom(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      decoration: BoxDecoration(
          color: LelloTheme.palleteOf(theme).separator(),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: PrimaryButton(
          text: getString(context, "space_list_new"),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(ApplicationRoute.spaceRegistrationOption);
          }),
    );
  }
}
