import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_state.dart';
import 'package:morar/feature/vehicles/presentation/controllers/vehicle_controller.dart';
import 'package:morar/feature/vehicles/presentation/widgets/vehicle_widget.dart';

class VehiclePage extends StatefulWidget {
  @override
  _VehiclePageState createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  VehicleController controller =
      ApplicationContainer.instance().resolve<VehicleController>();
  @override
  void initState() {
    super.initState();
    controller.getVehicle();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: controller.vehicleBloc,
      child: Scaffold(
        bottomNavigationBar: GestureDetector(
          onTap: () {
            OwnerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsOwner.veiculoAcessarAdicionarNovoVeiculo(),
              userId: controller.sessionBloc.state.session?.me?.id ?? "",
              unitValue: controller.sessionBloc.state.session!.unity?.title
                      .toString() ??
                  "",
              referenceValue: controller
                      .sessionBloc.state.session!.condominium?.reference
                      ?.toString() ??
                  "",
            );
            Navigator.pushReplacementNamed(
                context, ApplicationRoute.newVehiclePage);
          },
          child: Container(
            color: LelloTheme.palleteOf(theme).customColor(),
            width: MediaQuery.of(context).size.width,
            height: 84,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: LelloTheme.palleteOf(theme).textAccent(),
                ),
                SizedBox(
                  width: 9,
                ),
                Text(
                  getString(context, "me_vehicles_add"),
                  style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).textAccent()),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: LelloTheme.palleteOf(theme).customColor(),
        appBar: WhiteAppBar(
          isGetString: true,
          title: "me_vehicles_title",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: BlocBuilder(
          bloc: controller.vehicleBloc,
          builder: (context, state) {
            if (state is VehicleIsEmptyState ||
                state is VehicleLoadingDataInProgressState) {
              return Column(
                children: [
                  Expanded(
                    child: LoadingWidget(),
                  ),
                ],
              );
            }
            if (state is VehicleLoadingFailedState) {
              return Padding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: ErrorHandlingWidget(
                  reTryFunction: () {
                    controller.getVehicle();
                  },
                  backFunction: () => Navigator.pop(context, true),
                  isProduction: env.isProduction,
                  error: "",
                  errorCode: "",
                ),
              );
            }
            if (state is VehicleIsLoadedDataState) {
              if (state.vehicle.isEmpty) {
                return Center(
                    child: Text(getString(context, "me_vehicles_empty")));
              }
              return SingleChildScrollView(
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
                          '${state.session.condominium?.name ?? ''} - ${state.session.unity?.title ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.body(theme),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                          height: 8,
                        ),
                        shrinkWrap: true,
                        itemCount: state.vehicle.length,
                        itemBuilder: (BuildContext context, int index) {
                          var vehicleList = state.vehicle[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, ApplicationRoute.editVehiclePage,
                                  arguments: vehicleList);
                            },
                            child: VehicleContainer(
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: Dimens.spacingMedium,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              alignment: Alignment.centerLeft,
                                              child: SvgPicture.asset(
                                                vehicleList.setSvgIcon(),
                                                color:
                                                    theme.colorScheme.onSurface,
                                                height: 40,
                                                width: 40,
                                              ),
                                            ),
                                            Text(
                                              "${vehicleList.type?[0].toUpperCase()}${vehicleList.type?.substring(1).toLowerCase()}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color:
                                                    LelloTheme.palleteOf(theme)
                                                        .text(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: Dimens.spacingLarge),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              if (vehicleList.showPlateInfo())
                                                Text(
                                                  "${vehicleList.identificationNumber ?? getString(context, "me_vehicles_no_plate")}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .text(),
                                                  ),
                                                ),
                                              SizedBox(
                                                  height: Dimens.spacingSmall),
                                              Text(
                                                vehicleList.getCor(context, vehicleList.color) ?? "",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: LelloTheme.palleteOf(
                                                          theme)
                                                      .text(),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: Dimens.spacingSmall),
                                              if (vehicleList.creator?.type !=
                                                  null)
                                                Flexible(
                                                  child: Text(
                                                    vehicleList.descriptionText(
                                                        context),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.bodyMedium
                                                        ?.copyWith(
                                                      color:
                                                          LelloTheme.palleteOf(
                                                                  theme)
                                                              .purpleText(),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
                child: Center(
              child: CircularProgressIndicator(),
            ));
          },
        ),
      ),
    );
  }
}
