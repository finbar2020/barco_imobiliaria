import 'package:essentials/essentials.dart' hide Animation;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_collaborator_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments_details_bloc/timesheet_day_appointments_details_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments_details_bloc/timesheet_day_appointments_details_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/day_appointments_details_controller.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';

class DayAppointmentsDetailsPage extends StatefulWidget {
  const DayAppointmentsDetailsPage({
    super.key,
    required this.item,
    required this.dayAppointments,
  });

  final DayAppointmentsEntity item;
  final List<DayAppointmentsEntity> dayAppointments;

  @override
  State<DayAppointmentsDetailsPage> createState() =>
      _DayAppointmentsDetailsPageState();
}

class _DayAppointmentsDetailsPageState extends State<DayAppointmentsDetailsPage>
    with TickerProviderStateMixin {
  DayAppointmentsDetailsController controller = ApplicationContainer.instance()
      .resolve<DayAppointmentsDetailsController>();

  late final MapController _mapController;
  DateTime? _lastShowedTileLoadError;
  static const _showSnackBarDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    controller.setCra(widget.item.collaborator.numCra);
    controller
        .setDate(widget.item.appointments.firstOrNull?.date ?? DateTime.now());
    controller.getDetails();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: PrimaryAppBar(
          iconColor: theme.primaryColor,
          theme: theme,
          title: getString(context, "gdp_timesheet_day_geolocation_appBar"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: Dimens.spacing,
                  left: Dimens.spacing,
                  right: Dimens.spacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          showDuration: const Duration(seconds: 3),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          message: getString(
                              context, "gdp_timesheet_day_geolocation_tooltip"),
                          child: Row(
                            children: [
                              Text(
                                  getString(context,
                                      "gdp_timesheet_day_geolocation_title"),
                                  style: LelloTextStyles.subtitleBold(theme)),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Icon(Icons.info_outline),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: Dimens.spacing),
                    //_buildCardEmployee(theme),
                    DropdownButton(
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        underline: const SizedBox.shrink(),
                        value: controller.selectedCra,
                        items: widget.dayAppointments
                            .map((e) => DropdownMenuItem<String>(
                                value: e.collaborator.numCra,
                                child:
                                    _buildCardEmployee(theme, e.collaborator)))
                            .toList(),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              controller.setCra(value);
                              controller.getDetails();
                            }
                          });
                        })
                  ],
                ),
              ),
              const Divider(thickness: 2),
              SizedBox(height: Dimens.spacing),
              TimesheetDatePicker(
                  selectedDate: controller.selectedDate,
                  onChange: (DateTime newDate) {
                    setState(() {
                      controller.setDate(newDate);
                      controller.getDetails();
                    });
                  }),
              SizedBox(height: Dimens.spacing),
              _buildMap(),
            ],
          ),
        ));
  }

  Widget _buildCardEmployee(ThemeData theme, CollaboratorEntity collaborator) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 42.0,
          width: 42.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10000.0),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: collaborator.photo,
              placeholder: (context, url) => Container(
                padding: const EdgeInsets.all(16.0),
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) =>
                  SvgPicture.asset("assets/user_placeholder.svg", width: 32),
            ),
          ),
        ),
        SizedBox(width: Dimens.spacingSmall),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                capitalizeFirstLetter(collaborator.name).trimRight(),
                style: LelloTextStyles.bodyBold(theme),
              ),
              SizedBox(height: Dimens.spacingXSmall),
              Text(
                  collaborator.jobPosition.isNotEmpty
                      ? collaborator.jobPosition
                      : "-",
                  style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).textLight())),
              SizedBox(height: Dimens.spacingXSmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    final theme = Theme.of(context);
    return BlocConsumer<TimesheetDayAppointmentsDetailsBloc,
        TimesheetDayAppointmentsDetailsState>(
      bloc: controller.bloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is TimesheetDayAppointmentsDetailsLoadingState) {
          return Column(
            children: [
              LoadingWidget(
                message:
                    getString(context, "gdp_timesheet_day_geolocation_loagind"),
              ),
            ],
          );
        } else if (state is TimesheetDayAppointmentsDetailsFailedState) {
          return Column(
            children: [
              SvgPicture.asset("assets/ic_error_request_widget.svg",
                  width: 150, height: 150),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, 'error_handling_widget_title'),
                textAlign: TextAlign.center,
                style: LelloTextStyles.headline(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, 'error_handling_widget_subtitle'),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: LelloTheme.palleteOf(theme).textOpaque(),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(Dimens.spacing),
                  child: Text(
                    getString(context, "error_handling_widget_button_reTry"),
                    style: LelloTextStyles.button(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                ),
                onPressed: () {
                  controller.getDetails();
                },
              )
            ],
          );
        }
        if (state is TimesheetDayAppointmentsDetailsLoadedState) {
          if (state.details.isEmpty ||
              state.details.every((element) => element.checkInDays.isEmpty)) {
            return Text(
                getString(context, "gdp_timesheet_day_geolocation_no_itens"));
          }
          var itens = state.details.firstOrNull?.checkInDays.firstOrNull
                  ?.checkInRecords ??
              [];
          var marks = itens
              .map<LatLng>((e) => LatLng(e.latitude, e.longitude))
              .toList();
          marks.add(LatLng(widget.item.condoLocation.latitude,
              widget.item.condoLocation.longitude));
          return Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Row(
                  children: [
                    const Icon(Icons.apartment),
                    Text(
                      getString(context,
                          "gdp_timesheet_day_geolocation_legend_condo"),
                      style: LelloTextStyles.body(theme)!,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.place,
                      color: Colors.green,
                    ),
                    Text(getString(context,
                        "gdp_timesheet_day_geolocation_legend_inside_marker")),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.place, color: Colors.red),
                    Text(getString(context,
                        "gdp_timesheet_day_geolocation_legend_outside_marker")),
                  ],
                )
              ]),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                      initialZoom: 16,
                      initialCenter: LatLng(widget.item.condoLocation.latitude,
                          widget.item.condoLocation.longitude),
                      initialCameraFit: CameraFit.coordinates(
                          coordinates: marks,
                          maxZoom: 16,
                          padding: EdgeInsets.all(Dimens.spacingXLarge))),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'app.lello.sindico',
                      evictErrorTileStrategy: EvictErrorTileStrategy.none,
                      errorTileCallback: (tile, error, stackTrace) {
                        if (_showErrorSnackBar) {
                          _lastShowedTileLoadError = DateTime.now();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: _showSnackBarDuration,
                              content: Text(
                                error.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                              backgroundColor: Colors.deepOrange,
                            ));
                          });
                        }
                      },
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(widget.item.condoLocation.latitude,
                              widget.item.condoLocation.longitude),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.apartment),
                        ),
                        ...List.generate(
                            itens.length,
                            (index) => Marker(
                                  point: marks[index],
                                  width: 20,
                                  height: 20,
                                  child: Icon(Icons.place,
                                      shadows: const <Shadow>[
                                        Shadow(
                                            color: Colors.black,
                                            blurRadius: 15.0)
                                      ],
                                      color: itens[index].outOfRadius == true
                                          ? Colors.red
                                          : Colors.green),
                                )),
                      ],
                    ),
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: LatLng(widget.item.condoLocation.latitude,
                              widget.item.condoLocation.longitude),
                          color: Colors.red.withOpacity(0.20),
                          useRadiusInMeter: true,
                          radius: 300, // 2000 meters
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimens.spacing),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        getString(context,
                            "gdp_timesheet_day_geolocation_details_title"),
                        style: LelloTextStyles.subtitleBold(theme)),
                    SizedBox(height: Dimens.spacingSmall),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var item = itens[index];
                        return Card(
                          elevation: 2.0,
                          child: InkWell(
                            onTap: () {
                              _animatedMapMove(
                                  LatLng(item.latitude, item.longitude),
                                  item.distance > 1000 ? 12 : 16);
                            },
                            onDoubleTap: () {
                              _animatedMapMove(
                                  LatLng(item.latitude, item.longitude), 16);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.place,
                                      color: item.outOfRadius == true
                                          ? Colors.red
                                          : Colors.green),
                                  Column(
                                    children: [
                                      Text(
                                          getString(context,
                                              "gdp_timesheet_day_geolocation_details_mark"),
                                          style:
                                              LelloTextStyles.bodyBold(theme)),
                                      Text(
                                          DateFormat.Hm()
                                              .format(item.checkInDateTime),
                                          style: LelloTextStyles.body(theme))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                          getString(context,
                                              "gdp_timesheet_day_geolocation_details_distance"),
                                          style:
                                              LelloTextStyles.bodyBold(theme)),
                                      Text("${item.distanceInKilometers}km",
                                          style: LelloTextStyles.body(theme))
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => PhotoScreenLink(
                                                photoLink:
                                                    "/timesheet/checkIn/photo/${item.photoHash}",
                                                theme: theme,
                                              ));
                                    },
                                    child: Text(
                                      getString(context,
                                          "gdp_timesheet_day_geolocation_details_photo"),
                                      style: LelloTextStyles.subtitle(theme)
                                          ?.copyWith(
                                        color: LelloTheme.palleteOf(theme)
                                            .buttonLink(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: itens.length,
                    )
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  bool get _showErrorSnackBar =>
      _lastShowedTileLoadError == null ||
      DateTime.now().difference(_lastShowedTileLoadError!) -
              const Duration(milliseconds: 50) >
          _showSnackBarDuration;

  String capitalizeFirstLetter(String name) {
    String capitalizedString =
        name.trimRight().split(' ').map((word) => word.capitalize).join(' ');
    return capitalizedString;
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // //disabledAnimation
    // _mapController.move(destLocation, destZoom);
    final latTween = Tween<double>(
        begin: _mapController.camera.center.latitude,
        end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.camera.center.longitude,
        end: destLocation.longitude);
    final zoomTween =
        Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}

class TimesheetDatePicker extends StatelessWidget {
  TimesheetDatePicker({
    super.key,
    required this.selectedDate,
    required this.onChange,
  });

  final DateTime selectedDate;
  final Function(DateTime newDate) onChange;

  final List<DateTime> avaliableDates = List.generate(
      7, (index) => DateTime.now().subtract(Duration(days: index)));

  bool get canBack => avaliableDates.any(((element) => DateUtils.isSameDay(
      element, selectedDate.subtract(const Duration(days: 1)))));
  bool get canFoward => avaliableDates.any(((element) =>
      DateUtils.isSameDay(element, selectedDate.add(const Duration(days: 1)))));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Opacity(
          opacity: canBack ? 1 : 0.3,
          child: InkWell(
            onTap: canBack
                ? () {
                    onChange
                        .call(selectedDate.subtract(const Duration(days: 1)));
                  }
                : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacingLarge),
              child: const Icon(Icons.arrow_left, size: 32),
            ),
          ),
        ),
        Text(DateFormat.yMMMMd().format(selectedDate)),
        Opacity(
          opacity: canFoward ? 1 : 0.3,
          child: InkWell(
            onTap: canFoward
                ? () {
                    onChange.call(selectedDate.add(const Duration(days: 1)));
                  }
                : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacingLarge),
              child: const Icon(Icons.arrow_right, size: 32),
            ),
          ),
        ),
      ],
    );
  }
}

class PhotoScreenLink extends StatelessWidget {
  final String photoLink;
  final ThemeData theme;
  const PhotoScreenLink({
    Key? key,
    required this.photoLink,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                      getString(context,
                          "gdp_timesheet_day_geolocation_details_photo_label"),
                      style: LelloTextStyles.titleSmallBold(theme),
                      textAlign: TextAlign.center),
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close))
              ],
            ),
            SizedBox(height: Dimens.spacing),
            Center(
              child: Hero(
                tag: 'imageHero',
                child: CustomCachedNetworkImage(
                  applicationContainer: ApplicationContainer.instance(),
                  link: photoLink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
