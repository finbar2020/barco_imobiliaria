import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../core/dependency/application_container.dart';
import '../../../core/navigation/application_rbac.dart';
import '../../../core/navigation/application_route.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../me/domain/entity/me.dart';
import '../../me/presentation/bloc/me_state.dart';
import '../../me/presentation/controllers/me_controller.dart';
import '../../me/presentation/widgets/me_page/me_profile_picture_widget.dart';

class MyPreferencesPage extends StatefulWidget {
  const MyPreferencesPage({Key? key}) : super(key: key);

  @override
  State<MyPreferencesPage> createState() => _MyPreferencesPageState();
}

class _MyPreferencesPageState extends State<MyPreferencesPage> {
  bool _showInfoContainer = true;
  final MeController controller =
      ApplicationContainer.instance().resolve<MeController>();

  @override
  void initState() {
    super.initState();
    controller.meLoad();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme,
      child: BlocProvider.value(
        value: controller.bloc,
        child: BlocConsumer(
            bloc: controller.bloc,
            builder: (context, state) => Scaffold(
                  appBar: CustomAppBar(
                    title: "my_preferences",
                  ),
                  body: state is MeLoadedState
                      ? _buildContent(
                          theme,
                          context,
                          state.me,
                        )
                      : Padding(
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                ),
            listener: (context, state) {}),
      ),
    );
  }

  Widget _buildContent(
    ThemeData theme,
    BuildContext context,
    Me? me,
  ) =>
      Container(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(Dimens.spacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      MeProfilePictureWidget(
                        controller: controller,
                        showEditButton: false,
                      ),
                      SizedBox(width: Dimens.spacing),
                      Expanded(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            me?.name ?? "",
                            style: LelloTextStyles.subtitleBold(theme),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: Dimens.spacingSmall),
                          Row(
                            children: [
                              Text(
                                'CPF\n${me?.cpf ?? ""}',
                                style: LelloTextStyles.caption(theme),
                              ),
                              SizedBox(width: Dimens.spacingLarge),
                              Text(
                                'Telefone\n${me?.phone?.isEmpty == true ? "Não informado" : me?.phone}',
                                style: LelloTextStyles.caption(theme),
                              ),
                            ],
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            'Email\n${me?.email ?? ""}',
                            style: LelloTextStyles.caption(theme),
                          ),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(height: Dimens.spacing),
                  PrimaryButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ApplicationRoute.me);
                    },
                    text: 'Meus dados',
                  )
                ],
              ),
            ),
            const Divider(height: 0, thickness: 1),
            if (controller.sessionBloc.checkRback(
                    ApplicationRbac.morarPreferenciasMinhaContaFull) ==
                true) ...[
              _buildListTile(
                assetPath: "assets/ic_carta.svg",
                title: getString(context, "receipt_of_documents"),
                onTap: () {
                  Navigator.pushNamed(
                      context, ApplicationRoute.receivingDocuments);
                },
              ),
              const Divider(height: 0, thickness: 1)
            ],
            if (controller.sessionBloc.checkRback(
                    ApplicationRbac.morarPreferenciasMinhaContaFull) ==
                true) ...[
              _buildListTile(
                assetPath: "assets/ic_aos_cuidados.svg",
                title: getString(context, "in_care"),
                onTap: () {
                  Navigator.pushNamed(context, ApplicationRoute.inCare);
                },
              ),
              const Divider(height: 0, thickness: 1)
            ],
            if (controller.sessionBloc.checkRback(
                        ApplicationRbac.morarPreferenciasMinhaContaFull) ==
                    true ||
                controller.sessionBloc
                        .checkRback(ApplicationRbac.morarMoradores) ==
                    true) ...[
              _buildListTile(
                assetPath: "assets/residents.svg",
                title: getString(context, "condominium_hub_residents"),
                onTap: () {
                  Navigator.pushNamed(context, ApplicationRoute.subUser);
                },
              ),
              const Divider(height: 0, thickness: 1)
            ],
          ],
        ),
      );

  Widget _buildListTile({
    required String assetPath,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      leading: SvgPicture.asset(assetPath),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
