import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/access_management/presentation/bloc/access_management_state.dart';
import 'package:lello/feature/access_management/presentation/controller/access_management_controller.dart';
import 'package:lello/feature/access_management/presentation/pages/access_management_error_page.dart';
import 'package:lello/feature/access_management/presentation/pages/access_management_service_off_page.dart';
import 'package:lello/feature/access_management/presentation/pages/access_management_service_on_page.dart';

class AccessManagementPage extends StatefulWidget {
  const AccessManagementPage({Key? key}) : super(key: key);

  @override
  State<AccessManagementPage> createState() => _AccessManagementPageState();
}

class _AccessManagementPageState extends State<AccessManagementPage> {
  final AccessManagementController controller =
      ApplicationContainer.instance().resolve<AccessManagementController>();
  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: getString(context, "access_management_title"),
          theme: theme,
        ),
        body: BlocConsumer(
          bloc: controller.accessManagementBloc,
          listener: (context, state) {
            if (state is AccessManagementServiceOnState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccessManagerServiceOnPage(
                    bloc: controller.accessManagementBloc,
                    onTap: () async {
                      await controller.registerFacial();
                    },
                  ),
                ),
              );
            } else if (state is AccessManagementServiceOffState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccessManagerServiceOffPage(),
                ),
              );
            } else if (state is AccessManagementErrorState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccessManagementErrorPage(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AccessManagementLoadingState) {
              return Column(
                children: const [
                  Expanded(
                    child: LoadingWidget(),
                  ),
                ],
              );
            }
            return ListView(
              children: [
                _buildListItem(
                    getString(context, "access_management_biometric"),
                    "assets/ic_person.svg",
                    theme, onTap: () async {
                  await controller.checkService();
                }),
                _buildListItem(
                    getString(
                        context, "access_management_send_invite_employee"),
                    "assets/ic_team.svg",
                    theme, onTap: () {
                  Navigator.of(context)
                      .pushNamed(ApplicationRoute.gdpEmployeeList);
                }),
                _buildListItem(
                    getString(
                        context, "access_management_send_invite_resident"),
                    "assets/ic_building_home.svg",
                    theme, onTap: () {
                  Navigator.of(context).pushNamed(ApplicationRoute.units);
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildListItem(String title, String asset, ThemeData theme,
      {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.only(
          left: Dimens.spacingLarge,
          right: Dimens.spacingLarge,
          top: Dimens.spacingSmall,
          bottom: Dimens.spacingSmall),
      leading: SvgPicture.asset(asset, width: 24),
      title: Text(
        title,
        style: LelloTextStyles.bodyBold(theme),
      ),
    );
  }
}
