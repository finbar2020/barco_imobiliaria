import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_state.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/controllers/change_address_controller.dart';

import '../../../../../core/widgets/loading_widget.dart';
import '../widgets/change_address_form.dart';

class ChangeAddressPage extends StatefulWidget {
  const ChangeAddressPage({super.key});

  @override
  State<ChangeAddressPage> createState() => _ChangeAddressPageState();
}

class _ChangeAddressPageState extends State<ChangeAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final controller =
      ApplicationContainer.instance().resolve<ChangeAddressController>();

  @override
  void initState() {
    controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final env = ApplicationContainer.instance().resolve<Environment>();
    final validator = ApplicationContainer.instance().resolve<Validator>();
    validator.context = context;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "update_address_title",
      ),
      body: BlocConsumer(
        bloc: controller.bloc,
        listener: (context, state) {
          if (state is ChangeAddressFailureState) {
            Navigator.pushNamed(
              context,
              ApplicationRoute.changeAddressFailure,
            );
          }
          if (state is ChangeAddressSuccessState) {
            Navigator.pushNamed(
              context,
              ApplicationRoute.changeAddressSuccess,
            );
          }
        },
        builder: (context, state) {
          if (state is ChangeAddressFailureState) {
            return Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: ErrorHandlingWidget(
                reTryFunction: () {},
                backFunction: () => Navigator.pop(context, true),
                isProduction: env.isProduction,
                error: state.failure.error.toString(),
                errorCode: state.failure.code.toString(),
              ),
            );
          }
          if (state is ChangeAddressLoadingState) {
            return Center(child: LoadingWidget());
          }
          if (state is ChangeAddressLoadedState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: Dimens.spacing),
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    color: LelloTheme.palleteOf(theme).backgroundDark(),
                    width: double.infinity,
                    height: Dimens.spacingLarge,
                    child: Center(
                      child: Text(
                        '${controller.session.condominium?.name ?? ''} - ${controller.session.unity?.title ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        style: LelloTextStyles.body(theme),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getString(context, "update_unit_data_title"),
                          style: LelloTextStyles.titleSmallBold(theme),
                        ),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          getString(context, "update_address_subtitle"),
                          style: LelloTextStyles.subtitle(theme),
                          textAlign: TextAlign.justify,
                          textWidthBasis: TextWidthBasis.longestLine,
                        ),
                        SizedBox(height: Dimens.spacingLarge),
                        ChangeAddressForm(formKey: _formKey),
                        SizedBox(height: Dimens.spacingXLarge),
                        PrimaryButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.updateAddress(
                                condominiumId:
                                    controller.session.condominium!.id!,
                                unit: controller.updatedUnit,
                              );
                            }
                          },
                          text: getString(context, "save"),
                        ),
                        SizedBox(height: Dimens.spacingLarge),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
