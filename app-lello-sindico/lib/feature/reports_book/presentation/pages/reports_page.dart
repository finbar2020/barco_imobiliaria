import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_filter.dart';
import 'package:lello/feature/reports_book/domain/entity/report_filters_types_enum.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_bloc.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:lello/feature/reports_book/presentation/controller/report_controller.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_details_report_page.dart';
import 'package:lello/feature/reports_book/presentation/widgets/reports_card_widget.dart';
import 'package:lello/feature/reports_book/presentation/widgets/selected_filters_widget.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/unit/domain/entity/unit_simple.dart';

class ReportsPageArgs {
  String? reportsNotificationContext;
  ReportsPageArgs({this.reportsNotificationContext});
}

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  ReportsPageState createState() => ReportsPageState();
}

class ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
  final ReportController controller =
      ApplicationContainer.instance().resolve<ReportController>();
  final scaffoldState = GlobalKey<ScaffoldState>();

  var themeDark = LelloTheme.dark;
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  ReportFilter filter = ReportFilter();
  DateTime? dateFrom;
  DateTime? dateTo;
  List<UnitSimple> units = [];
  List<String> unitsName = [];
  final List<ReportFilterTypes> _selectedFilters = [];
  bool _selectedDates = false;

  final Validator validator = ApplicationContainer.instance().resolve();

  TextEditingController dateFromController = TextEditingController(text: '');
  TextEditingController dateToController = TextEditingController(text: '');
  final dateFormat = DateFormat.yMd();
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  ReportsPageArgs? arguments;

  @override
  void initState() {
    _selectedFilters.add(ReportFilterTypes.status);
    controller.getReports(filter: filter);
    _scrollController.addListener(_scrollListener);
    super.initState();
    dateFromController.addListener(() {
      _checkDates();
    });

    dateToController.addListener(() {
      _checkDates();
    });
  }

  @override
  void dispose() {
    dateFromController.dispose();
    dateToController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    themeDark = themeDark.copyWith(
      colorScheme: themeDark.colorScheme.copyWith(
        primary: theme.primaryColor,
      ),
      primaryColor: theme.primaryColor,
    );
    final SessionBloc sessionBloc = BlocProvider.of(context);
    arguments = ModalRoute.of(context)!.settings.arguments as ReportsPageArgs?;

    return Theme(
      data: theme,
      child: BlocProvider.value(
        value: controller.reportsBloc,
        child: BlocConsumer(
          bloc: controller.reportsBloc,
          listener: (context, state) {
            if (state is SeeReportDetailsState) {
              controller.getReport(report: state.report);
            }
          },
          builder: (context, state) {
            return Scaffold(
              key: scaffoldState,
              appBar: PrimaryAppBar(
                  title: getString(context, "reports_title"),
                  theme: theme,
                  actions: [
                    IconButton(
                      onPressed: () {
                        scaffoldState.currentState!.openEndDrawer();
                      },
                      icon: SvgPicture.asset(
                        "assets/ic_filter.svg",
                        color: theme.primaryColor,
                      ),
                    )
                  ]),
              body: _reportsBookBody(controller.reportsBloc, theme, context),
              endDrawer: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _buildFilterDrawer(
                    context, sessionBloc, state as ReportsState, theme),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _reportsBookBody(
    ReportsBloc reportsBloc,
    ThemeData theme,
    BuildContext context,
  ) {
    if (reportsBloc.state is ReportsLoadingState) {
      return const Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }

    if (reportsBloc.state is ReportsFailureState) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: ErrorHandlingWidget(
          reTryFunction: () {
            controller.getReports(filter: filter);
          },
          backFunction: () => Navigator.pop(context, true),
          isProduction: env.isProduction,
        ),
      );
    }

    return _buildReports();
  }

  Widget _buildReports() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (arguments?.reportsNotificationContext?.isNotEmpty == true &&
          mounted) {
        var item = controller.reports.cast<Report?>().firstWhere(
            (element) =>
                element?.notificationParameter ==
                    arguments?.reportsNotificationContext ||
                element?.idReport == arguments?.reportsNotificationContext,
            orElse: () => null);
        if (item != null) {
          controller.seeReportDetails(report: item);
          Navigator.pushReplacementNamed(
            context,
            ApplicationRoute.reportDetails,
            arguments: ReportsDetailsReportPageArgs(report: item),
          );
          arguments?.reportsNotificationContext = null;
        }
      }
    });
    return Column(
      children: [
        SelectedFiltersWidget(
          filter: filter,
          filters: _selectedFilters,
          onFilterRemoved: (ReportFilterTypes reportFilterType) {
            switch (reportFilterType) {
              case ReportFilterTypes.period:
                filter.dateFrom = null;
                filter.dateTo = null;
                dateFromController.text = '';
                dateToController.text = '';
                break;
              case ReportFilterTypes.subject:
                filter.type = null;
                break;
              case ReportFilterTypes.status:
                filter.closed = null;
                break;
              case ReportFilterTypes.unit:
                filter.unitId = null;
                filter.unitName = null;
                break;
              case ReportFilterTypes.newReplies:
                filter.showOnlyReplies = false;
                break;
              case ReportFilterTypes.newReports:
                filter.showOnlyNewReports = false;
                break;
              default:
            }
            for (int i = 0; i < _selectedFilters.length; i++) {
              if (_selectedFilters[i] == reportFilterType) {
                _selectedFilters.removeAt(i);
                filter.page = 1;
              }
            }
            controller.getReports(filter: filter);
          },
        ),
        if (controller.reports.isEmpty)
          Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: Center(
              child: Text(
                getString(context, "reports_no_reports"),
                style: LelloTextStyles.body(LelloTheme.light),
              ),
            ),
          ),
        Expanded(
          child: ListView.separated(
            itemCount: (controller.reports.length) +
                (controller.reportsBloc.state is ReportsPagingState ? 1 : 0),
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              if (index == controller.reports.length) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacing),
                  child: const Center(
                    child: LoadingWidget(),
                  ),
                );
              }
              return ReportsCardWidget(
                report: controller.reports[index],
                onTap: () {
                  controller.seeReportDetails(
                      report: controller.reports[index]);
                  Navigator.pushReplacementNamed(
                    context,
                    ApplicationRoute.reportDetails,
                    arguments: ReportsDetailsReportPageArgs(
                        report: controller.reports[index]),
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ),
      ],
    );
  }

  void _scrollListener() {
    final delta = Dimens.spacingXLarge;
    if (controller.reportsBloc.state is! ReportsPagingState &&
        (_scrollController.offset + delta) >=
            _scrollController.position.maxScrollExtent) {
      controller.beginLoadNextPage(filter: filter);
    }
  }

  Widget _buildFilterDrawer(BuildContext context, SessionBloc sessionBloc,
      ReportsState state, ThemeData theme) {
    List<String> types = [
      getString(context, "reports_type_compliment"),
      getString(context, "reports_type_suggestion"),
      getString(context, "reports_type_complaint"),
      getString(context, "reports_type_others"),
    ];

    List<String> status = [
      getString(context, "reports_status_open"),
      getString(context, "reports_status_closed"),
      getString(context, "reports_status_all"),
    ];
    return Drawer(
      child: DismissKeyboard(
        child: Container(
          color: const Color(0xFF2D2D2D),
          child: ListView(
              padding: EdgeInsets.only(top: Dimens.spacingMedium)
                  .copyWith(top: Dimens.spacingXLarge),
              children: [
                ListTile(
                    title: Text(getString(context, "payment_filter_title"),
                        style: LelloTextStyles.title(LelloTheme.dark)),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: SvgPicture.asset("assets/ic_close_white.svg"),
                    )),
                Theme(
                  data: themeDark,
                  child: Container(
                    padding: EdgeInsets.all(Dimens.spacing),
                    color: const Color(0xFF2D2D2D),
                    child: Column(children: [
                      SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(getString(context, "reports_choose_date"),
                                  style: LelloTextStyles.bodyBold(themeDark)),
                              SizedBox(height: Dimens.spacing),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                            getString(
                                                context, "payment_filter_from"),
                                            style: LelloTextStyles.bodyBold(
                                                themeDark)),
                                        SizedBox(height: Dimens.spacing),
                                        PrimaryTextFormField(
                                          onTap: () async {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            final date = await datePicker(
                                              context,
                                              selectedDate: dateFrom,
                                              lastDate: dateTo,
                                            );
                                            setState(() {
                                              dateFrom = date;
                                              dateFromController.text =
                                                  dateFormat.format(date);
                                              filter.dateFrom = dateFrom;
                                            });
                                          },
                                          controller: dateFromController,
                                          action: TextInputAction.next,
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .nextFocus(),
                                          validator: (value) => validator
                                              .validateDate(value ?? "",
                                                  optional: true),
                                          textInputType: TextInputType.number,
                                          formatter: fullDateFormatter(),
                                          hint: filter.dateFrom == null
                                              ? "00/00/0000"
                                              : dateFormat
                                                  .format(filter.dateFrom!),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: Dimens.spacingMedium),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                            getString(
                                                context, "payment_filter_to"),
                                            style: LelloTextStyles.bodyBold(
                                                themeDark)),
                                        SizedBox(height: Dimens.spacing),
                                        PrimaryTextFormField(
                                          onTap: () async {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            final date = await datePicker(
                                              context,
                                              selectedDate: dateTo,
                                              firstDate: dateFrom,
                                            );
                                            setState(() {
                                              dateTo = date;
                                              dateToController.text =
                                                  dateFormat.format(date);
                                              filter.dateTo = dateTo;
                                            });
                                          },
                                          controller: dateToController,
                                          action: TextInputAction.next,
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .nextFocus(),
                                          validator: (value) => validator
                                              .validateDate(value ?? "",
                                                  optional: true),
                                          textInputType: TextInputType.number,
                                          formatter: fullDateFormatter(),
                                          hint: filter.dateTo == null
                                              ? "00/00/0000"
                                              : dateFormat
                                                  .format(filter.dateTo!),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: Dimens.spacingMedium),
                              Text(getString(context, 'reports_subject'),
                                  style: LelloTextStyles.bodyBold(themeDark)),
                              SizedBox(height: Dimens.spacing),
                              DropdownButtonFormField(
                                hint: Text(
                                  filter.type == null
                                      ? ""
                                      : getString(
                                          context,
                                          filter.getTypeReport(),
                                        ),
                                  style: LelloTextStyles.body(themeDark),
                                ),
                                isExpanded: true,
                                items: types
                                    .map(
                                      (value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  filter.setTypeReport(value as String);
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: Dimens.spacingMedium),
                              Text(getString(context, 'reports_status'),
                                  style: LelloTextStyles.bodyBold(themeDark)),
                              SizedBox(height: Dimens.spacing),
                              DropdownButtonFormField(
                                hint: Text(
                                  filter.closed == null
                                      ? ""
                                      : getString(
                                          context,
                                          filter.getStatusReport(),
                                        ),
                                  style: LelloTextStyles.body(themeDark),
                                ),
                                isExpanded: true,
                                items: status
                                    .map((value) => DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  filter.setStatusReport(value as String);
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: Dimens.spacingMedium),
                              Text(getString(context, 'units_unit'),
                                  style: LelloTextStyles.bodyBold(themeDark)),
                              SizedBox(height: Dimens.spacing),
                              DropdownButtonFormField(
                                hint: Text(
                                  filter.getUnidId() ?? "",
                                  style: LelloTextStyles.body(themeDark),
                                ),
                                isExpanded: true,
                                items: controller.units
                                    .map((value) => DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  UnitSimple unidade = controller.allUnits
                                      .firstWhere(
                                          (element) => element.title == value);
                                  filter.unitId = unidade.id;
                                  filter.unitName = unidade.title;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: Dimens.spacingMedium),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: filter.showOnlyNewReports,
                                    activeColor: theme.primaryColor,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        filter.showOnlyNewReports =
                                            !filter.showOnlyNewReports;
                                      });
                                    },
                                  ),
                                  Text(getString(context, "reports_show_new"),
                                      style: LelloTextStyles.body(themeDark)),
                                  SizedBox(height: Dimens.spacingMedium),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: filter.showOnlyReplies,
                                    activeColor: theme.primaryColor,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        filter.showOnlyReplies =
                                            !filter.showOnlyReplies;
                                      });
                                    },
                                  ),
                                  Text(
                                      getString(
                                          context, "reports_show_replies"),
                                      style: LelloTextStyles.body(themeDark)),
                                  SizedBox(height: Dimens.spacing),
                                ],
                              ),
                              SizedBox(height: Dimens.spacingMedium),
                              Theme(
                                data: theme,
                                child: PrimaryButton(
                                  text: getString(context, "find"),
                                  onPressed: () {
                                    if (_selectedDates) {
                                      _addFilterItems(filter: filter);
                                      controller.getReports(filter: filter);
                                      Navigator.pop(context);
                                    } else {
                                      Flushbar(
                                              duration:
                                                  const Duration(seconds: 5),
                                              message: getString(context,
                                                  "report_selected_dates"),
                                              backgroundColor: Colors.white,
                                              messageColor: Colors.black)
                                          .show(context);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: Dimens.spacingMedium),
                              TextButton(
                                style: ButtonStyle(
                                  side: WidgetStateProperty.all(
                                    const BorderSide(color: Colors.white),
                                  ),
                                  backgroundColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  dateFromController.clear();
                                  dateToController.clear();
                                  filter = ReportFilter();
                                  filter.closed = null;
                                  _selectedFilters.clear();
                                  _selectedFilters
                                      .add(ReportFilterTypes.status);
                                  controller.getReports(filter: filter);
                                  Navigator.pop(context);
                                },
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(Dimens.spacingSmall),
                                    child: Text(
                                      getString(
                                          context, "report_clear_filters"),
                                      style: LelloTextStyles.button(theme)!
                                          .copyWith(
                                        color: LelloTheme.palleteOf(theme)
                                            .background(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Future<void> _addFilterItems({required ReportFilter filter}) async {
    final filterItemsMap = {
      if (filter.dateFrom != null && filter.dateTo != null)
        ReportFilterTypes.period,
      if (filter.type != null) ReportFilterTypes.subject,
      if (filter.closed != null) ReportFilterTypes.status,
      if (filter.unitId != null) ReportFilterTypes.unit,
      if (filter.showOnlyNewReports == true) ReportFilterTypes.newReports,
      if (filter.showOnlyReplies == true) ReportFilterTypes.newReplies,
    };
    setState(() {
      filter.page = 1;
      _selectedFilters.addAll(
        filterItemsMap.where(
          (type) => !_selectedFilters.contains(type),
        ),
      );
    });
  }

  void _checkDates() {
    if ((dateFromController.text.isNotEmpty && dateToController.text.isEmpty) ||
        (dateFromController.text.isEmpty && dateToController.text.isNotEmpty)) {
      setState(() {
        _selectedDates = false;
      });
    } else {
      setState(() {
        _selectedDates = true;
      });
    }
  }
}
