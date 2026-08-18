import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/presentation/failure_message.dart';
import 'package:lello/core/widget/verify_app_and_biometric_statu.dart';
import 'package:lello/feature/access_management/domain/entity/access_control_enum.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/access_management/presentation/widgets/access_management_link_dialog.dart';
import 'package:lello/feature/access_management/presentation/widgets/access_management_sms_dialog.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_bloc.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_event.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_state.dart';
import 'package:lello/feature/unit/presentation/bloc/vehicles/vehicles_bloc.dart';
import 'package:lello/feature/unit/presentation/controllers/unit_details_controller.dart';
import 'package:lello/feature/unit/presentation/page/unit_detail_invite_failed_page.dart';
import 'package:lello/feature/unit/presentation/page/unit_detail_invite_success_page.dart';
import 'package:lello/feature/unit/presentation/page/unit_detail_link_success_page.dart';
import 'package:lello/feature/unit/presentation/widget/unit_list_item.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class UnitDetailPage extends StatefulWidget {
  const UnitDetailPage({Key? key}) : super(key: key);

  @override
  _UnitDetailPageState createState() => _UnitDetailPageState();
}

class _UnitDetailPageState extends State<UnitDetailPage> {
  final UnitDetailBloc bloc = ApplicationContainer.instance().resolve();
  final UnitDetailsController controller =
      ApplicationContainer.instance().resolve<UnitDetailsController>();
  var loaded = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Unit unit = ModalRoute.of(context)!.settings.arguments as Unit;
    if (!loaded) {
      bloc.beginLoad(unit.condominiumId!, unit.id!);
      loaded = true;
    }

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          theme: theme,
          title: "${getString(context, "units_unit")} ${unit.title}",
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: Dimens.spacingLarge),
          child: BlocConsumer<UnitDetailBloc, UnitDetailState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is UnitDetailSendInviteSmsSuccessState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnitDetailInviteSuccessPage(
                      state: state,
                    ),
                  ),
                );
              } else if (state is UnitDetailSendInviteLinkSuccessState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnitDetailLinkSuccessPage(
                      state: state,
                    ),
                  ),
                );
              } else if (state is UnitDetailSendInviteFailedState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UnitDetailInviteErrorPage(),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is UnitDetailLoadingState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: LoadingWidget(),
                  ),
                );
              }
              if (state is UnitDetailLoadFailedState) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Text(FailureMessage.get(context, state.error),
                      style: LelloTextStyles.error(theme),
                      textAlign: TextAlign.center),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(Dimens.spacingMedium),
                        child: UnitListItem(unit: unit, isDetails: true),
                      ),
                      Padding(
                        padding: EdgeInsets.all(Dimens.spacingMedium),
                        child: Text(getString(context, "residents_title"),
                            style: LelloTextStyles.title(theme)),
                      ),
                      ResidentList(
                        bloc: bloc,
                        data: state.residents,
                      ),
                    ],
                  ),
                  const Divider(),
                  VehicleList(unit: unit),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ResidentList extends StatelessWidget {
  final List<Resident> data;
  final UnitDetailBloc bloc;
  const ResidentList({
    Key? key,
    required this.data,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UnitDetailsController controller =
        ApplicationContainer.instance().resolve<UnitDetailsController>();
    final theme = Theme.of(context);
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final Resident item = data[index];
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.spacingMedium,
            vertical: Dimens.spacingSmall,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name ?? "",
                        style: LelloTextStyles.bodyBold(theme)),
                    if (item.access(context) != null)
                      SizedBox(height: Dimens.spacingSmall),
                    if (item.access(context) != null)
                      Text(item.access(context)!,
                          style: LelloTextStyles.subBody(theme)),
                    SizedBox(height: Dimens.spacingSmall),
                    Text(
                      "${getString(context, "cpf")}: ${formatCpfToSecurityText(item.cpf)}",
                      style: LelloTextStyles.subBody(theme),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              VerifyAppAndBiometricStatus(
                useApp: item.useApp == true,
                hasBiometric: controller.hasBiometrics &&
                    item.accessControlBiometricStatus != null &&
                    item.accessControlBiometricStatus !=
                        AccessControlBiometricStatus.unavailable,
                hasBiometricRegistered: item.accessControlBiometricStatus ==
                    AccessControlBiometricStatus.registered,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => item.mobilePhone != null
                        ? AccessManagementSmsDialog(
                            phone: item.mobilePhone ?? "",
                            name: item.name ?? "",
                            sendSms: () {
                              Navigator.pop(context);
                              bloc.add(UnitDetailSendInviteEvent(
                                type: AccessManagementInviteForwardType.sms,
                                phone: item.mobilePhone ?? "",
                                cpf: item.cpf ?? "",
                                name: item.name ?? "",
                                email: item.email ?? "",
                              ));
                            },
                            sendLink: () {
                              Navigator.pop(context);
                              bloc.add(UnitDetailSendInviteEvent(
                                type: AccessManagementInviteForwardType.link,
                                phone: item.mobilePhone ?? "",
                                cpf: item.cpf ?? "",
                                name: item.name ?? "",
                                email: item.email ?? "",
                              ));
                            })
                        : AccessManagementLinkDialog(sendLink: () {
                            Navigator.pop(context);
                            bloc.add(UnitDetailSendInviteEvent(
                              type: AccessManagementInviteForwardType.link,
                              phone: item.mobilePhone ?? "",
                              cpf: item.cpf ?? "",
                              name: item.name ?? "",
                              email: item.email ?? "",
                            ));
                          }),
                  );
                },
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(color: theme.dividerColor);
      },
      itemCount: data.length,
    );
  }
}

class VehicleList extends StatelessWidget {
  final Unit unit;
  final UnitDetailsController controller =
      ApplicationContainer.instance().resolve<UnitDetailsController>();
  final VehiclesBloc vehiclesBloc =
      ApplicationContainer.instance().resolve<VehiclesBloc>();
  VehicleList({
    Key? key,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Veículos',
            style: LelloTextStyles.title(theme),
          ),
          SizedBox(height: Dimens.spacing),
          FutureBuilder(
            future: controller.pipeline(unit),
            builder: (context, snapshot) {
              return BlocBuilder(
                  bloc: vehiclesBloc,
                  builder: (context, state) {
                    if (state is VehiclesLoadingState) {
                      return const Center(
                        child: LoadingWidget(),
                      );
                    }
                    if (state is VehiclesFailureState) {
                      return Padding(
                        padding: EdgeInsets.all(Dimens.spacingMedium),
                        child: Text(
                          'Falha ao buscar os veículos',
                          style: LelloTextStyles.error(theme),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    if (state is VehiclesSuccessState) {
                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.vehicles.length,
                        itemBuilder: (context, index) {
                          final vehicle = state.vehicles[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimens.spacingSmall,
                              vertical: Dimens.spacing,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Tipo: ',
                                        style: LelloTextStyles.bodyBold(theme)),
                                    Text(vehicle.type,
                                        style: LelloTextStyles.body(theme)),
                                  ],
                                ),
                                SizedBox(height: Dimens.spacingXSmall),
                                if (vehicle.identificationNumber != null)
                                  Row(
                                    children: [
                                      Text('Placa: ',
                                          style:
                                              LelloTextStyles.bodyBold(theme)),
                                      Text(vehicle.identificationNumber!,
                                          style: LelloTextStyles.body(theme)),
                                    ],
                                  ),
                                SizedBox(height: Dimens.spacingXSmall),
                                if (vehicle.model != null)
                                  Row(
                                    children: [
                                      Text('Modelo: ',
                                          style:
                                              LelloTextStyles.bodyBold(theme)),
                                      Text(vehicle.model!,
                                          style: LelloTextStyles.body(theme)),
                                    ],
                                  ),
                                SizedBox(height: Dimens.spacingXSmall),
                                if (vehicle.color != null)
                                  Row(
                                    children: [
                                      Text('Cor: ',
                                          style:
                                              LelloTextStyles.bodyBold(theme)),
                                      Text(vehicle.color!,
                                          style: LelloTextStyles.body(theme)),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(color: theme.dividerColor);
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  });
            },
          )
        ],
      ),
    );
  }
}

String formatCpfToSecurityText(String? cpf) {
  if (cpf == null) return "-";
  var digits = cpf.replaceAll(RegExp(r'[\.\-]'), '');
  if (digits.length != 11) return digits;
  return "${digits.substring(0, 3)}.${"XXX"}.${"XXX"}-${digits.substring(9, 11)}";
}
