// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages
import 'dart:ui' as ui;

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/modal/month_picker.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/income/domain/entity/income_share.dart';
import 'package:lello/feature/income/presentation/dasboard/bloc/income_dashboard_state.dart';
import 'package:lello/feature/income/presentation/dasboard/controller/income_dashboard_controller.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

import '../../../domain/entity/income.dart';

class IncomeDashboardPage extends StatefulWidget {
  const IncomeDashboardPage({Key? key}) : super(key: key);

  @override
  IncomeDashboardPageState createState() => IncomeDashboardPageState();
}

class IncomeDashboardPageState extends State<IncomeDashboardPage> {
  bool animate = true;

  final dateFormat = DateFormat.yM();
  final formatCurrency = NumberFormat.currency(symbol: "");
  final IncomeDashboardController controller =
      ApplicationContainer.instance().resolve<IncomeDashboardController>();

  @override
  void initState() {
    controller.getIncomes(period: DateTime.now());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          theme: theme,
          title: getString(context, "income_control"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BlocBuilder(
                      bloc: controller.incomeDashboardBloc,
                      builder: (context, state) {
                        if (state is IncomeDashboardLoadingState) {
                          return SizedBox(
                            height: size.height * 0.8,
                            child: const Center(
                              child: LoadingWidget(),
                            ),
                          );
                        }

                        if (state is IncomeDashboardFailureState) {
                          return Container(
                            padding: EdgeInsets.all(Dimens.spacing),
                            child: Text(
                                getString(context, "income_control_error"),
                                style: LelloTextStyles.error(theme),
                                textAlign: TextAlign.center),
                          );
                        }

                        if (state is IncomeDashboardSuccessState) {
                          final seriesList = _createForecastData(state.income);
                          final halfScreen = size.width / 2;
                          return Column(
                            children: [
                              Text(
                                getString(context, "income_control_billets"),
                                style: LelloTextStyles.title(theme),
                              ),
                              SizedBox(height: Dimens.spacingSmall),
                              Text(
                                  "${getString(context, "income_control_total_value")} : R\$${formatCurrency.format(state.income?.value ?? 0)}",
                                  style: LelloTextStyles.body(theme)),
                              SizedBox(height: Dimens.spacingMedium),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      getString(context, "income_due_period"),
                                      style: LelloTextStyles.subtitleBold(
                                        theme,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final selectedPeriod =
                                          await showMonthPicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                      );
                                      controller.selectedPeriod =
                                          selectedPeriod;
                                      if (selectedPeriod != null) {
                                        await controller.getIncomes(
                                          period: selectedPeriod,
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(Dimens.spacing)
                                          .copyWith(right: 0),
                                      child: Row(children: [
                                        Text(
                                            controller.selectedPeriod != null
                                                ? dateFormat.format(
                                                    controller.selectedPeriod!)
                                                : "-",
                                            style: LelloTextStyles.subtitle(
                                                theme)),
                                        SizedBox(width: Dimens.spacing),
                                        SvgPicture.asset(
                                            "assets/ic_arrow_down_black.svg")
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                              state.income?.shares == null ||
                                      state.income!.shares!.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                          child: Text(
                                              getString(context,
                                                  "income_share_empty"),
                                              textAlign: TextAlign.center)),
                                    )
                                  : SizedBox(
                                      height: 355.0,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: size.width / 2,
                                            child: PieChart(
                                              _createSharesData(
                                                state.income,
                                              ),
                                              animate: animate,
                                              layoutConfig: LayoutConfig(
                                                  leftMarginSpec:
                                                      MarginSpec.defaultSpec,
                                                  topMarginSpec:
                                                      MarginSpec.defaultSpec,
                                                  rightMarginSpec:
                                                      MarginSpec.fixedPixel(
                                                          Dimens.spacingLarge
                                                              .toInt()),
                                                  bottomMarginSpec:
                                                      MarginSpec.defaultSpec),
                                            ),
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: state.income?.shares
                                                      ?.map(
                                                        (e) => Legend(
                                                          title:
                                                              "${(e.share * 100).toStringAsFixed(2)}%",
                                                          description: e.title!,
                                                          color: e.color!,
                                                        ),
                                                      )
                                                      .toList() ??
                                                  [],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                              SecondaryButton(
                                  child: Text(getString(context, "details"),
                                      style: LelloTextStyles.button(theme)!
                                          .copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .text())),
                                  onPressed: () {
                                    if (state.income != null) {
                                      Navigator.of(context).pushNamed(
                                        ApplicationRoute.incomeDetail,
                                        arguments: state.income,
                                      );
                                    }
                                  }),
                              const Divider(),
                              Padding(
                                padding: EdgeInsets.all(Dimens.spacingMedium),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(getString(context, "income_forecast"),
                                        style: LelloTextStyles.subtitleBold(
                                            theme)),
                                    SizedBox(height: Dimens.spacingSmall),
                                    Text(
                                        getString(context,
                                            "income_forecast_description"),
                                        style: LelloTextStyles.body(theme)),
                                    SizedBox(height: Dimens.spacingMedium),
                                    Row(
                                      children: <Widget>[
                                        Legend(
                                          title: getString(context,
                                              "income_forecast_expected"),
                                          description: "",
                                          color: LelloTheme.palleteOf(theme)
                                              .primary(),
                                        ),
                                        SizedBox(width: Dimens.spacingMedium),
                                        Legend(
                                          title: getString(context,
                                              "income_forecast_executed"),
                                          description: "",
                                          color: const ui.Color(0xFF424242),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: halfScreen,
                                      child: BarChart(
                                        seriesList,
                                        animate: animate,
                                        domainAxis: const OrdinalAxisSpec(
                                          renderSpec: SmallTickRendererSpec(
                                            labelRotation: -90,
                                            labelOffsetFromTickPx: -5,
                                            labelAnchor: TickLabelAnchor.before,
                                          ),
                                        ),
                                        defaultRenderer: BarRendererConfig(
                                            groupingType:
                                                BarGroupingType.grouped,
                                            strokeWidthPx: 2.0),
                                      ),
                                    ),
                                    SizedBox(height: Dimens.spacingMedium),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Series<IncomeShare, String>> _createSharesData(Income? income) {
    final data = income?.shares ?? [];

    return [
      Series<IncomeShare, String>(
        id: 'shares',
        colorFn: (IncomeShare share, _) => charts.Color(
            a: share.color!.alpha,
            r: share.color!.red,
            g: share.color!.green,
            b: share.color!.blue),
        domainFn: (IncomeShare share, _) => share.title!,
        measureFn: (IncomeShare share, _) => share.total,
        data: data,
      )
    ];
  }

  List<Series<ForecastItem, String>> _createForecastData(Income? income) {
    final dateFormat = DateFormat.yM();
    final forecastData = income?.forecast
            ?.map((e) => ForecastItem(period: e.period!, value: e.forecast!))
            .toList() ??
        [];
    final valueData = income?.forecast
            ?.map((e) => ForecastItem(period: e.period!, value: e.value!))
            .toList() ??
        [];
    return [
      // Blue bars with a lighter center color.
      Series<ForecastItem, String>(
          id: 'Forecast',
          domainFn: (ForecastItem item, _) => dateFormat.format(item.period),
          measureFn: (ForecastItem item, _) => item.value,
          data: forecastData,
          colorFn: (_, __) => const charts.Color(r: 203, g: 38, b: 64, a: 255)),

      Series<ForecastItem, String>(
        id: 'Value',
        domainFn: (ForecastItem item, _) => dateFormat.format(item.period),
        measureFn: (ForecastItem item, _) => item.value,
        data: valueData,
        colorFn: (_, __) => const charts.Color(r: 66, g: 66, b: 66, a: 255),
      ),
    ];
  }
}

class ForecastItem {
  final DateTime period;
  final double value;
  ForecastItem({
    required this.period,
    required this.value,
  });
}

class Legend extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const Legend({
    Key? key,
    required this.title,
    required this.description,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: Dimens.spacing),
          Text(title, style: LelloTextStyles.subtitleBold(theme)),
        ]),
        SizedBox(height: Dimens.spacingSmall),
        Text(description, style: LelloTextStyles.subBody(theme)),
        SizedBox(height: Dimens.spacingMedium),
      ],
    );
  }
}
