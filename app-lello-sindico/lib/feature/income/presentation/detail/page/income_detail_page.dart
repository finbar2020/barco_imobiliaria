import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';
import 'package:lello/feature/income/domain/entity/income.dart';
import 'package:lello/feature/income/domain/entity/income_forecast.dart';
import 'package:lello/feature/income/presentation/billets/detail/controller/billets_details_controller.dart';

class IncomeDetailPage extends StatefulWidget {
  const IncomeDetailPage({Key? key}) : super(key: key);

  @override
  IncomeDetailPageState createState() => IncomeDetailPageState();
}

class IncomeDetailPageState extends State<IncomeDetailPage> {
  final BilletsDetailsController billetsDetailsController =
      ApplicationContainer.instance().resolve<BilletsDetailsController>();

  final dateFormat = DateFormat.yM();
  final formatCurrency = NumberFormat.currency(symbol: "R\$");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Income income = ModalRoute.of(context)!.settings.arguments as Income;
    return Theme(
      data: theme,
      child: Scaffold(
          appBar: PrimaryAppBar(
              theme: theme, title: dateFormat.format(income.period!)),
          body: _buildList(theme, income)),
    );
  }

  Widget _buildList(ThemeData theme, Income income) {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index == 0) return _buildSummary(theme, income);
        if (index == 1) {
          return Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: income.pendingBillets?.isNotEmpty == true
                ? Text(
                    getString(context, "income_unpaid_monthly_billets"),
                    style: LelloTextStyles.subtitleBold(theme),
                  )
                : const Center(
                    child: Text('Não há boletos pendentes desta emissão')),
          );
        }
        return _buildItem(theme, income.pendingBillets![index - 2]);
      },
      separatorBuilder: (context, index) =>
          index > 0 ? const Divider() : Container(),
      itemCount: income.pendingBillets!.length + 2,
    );
  }

  Widget _buildItem(ThemeData theme, Billet billet) {
    return ListTile(
      title: Text(
          "${getString(context, "income_billet_item_title_prefix")}  ${billet.unit?.title ?? ""}",
          style: LelloTextStyles.bodyBold(theme)),
      subtitle:
          Text(billet.unit?.group ?? "", style: LelloTextStyles.subBody(theme)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(formatCurrency.format(billet.value),
                    style: LelloTextStyles.subBody(theme)),
                SvgPicture.asset("assets/ic_arrow_right.svg", width: 6)
              ],
            ),
          )
        ],
      ),
      onTap: () {
        final Income income =
            ModalRoute.of(context)!.settings.arguments as Income;
        billetsDetailsController.selectedUnit = billet.unit;
        billetsDetailsController.selectedDateTime = income.period;
        Navigator.of(context).pushNamed(ApplicationRoute.billetDetail,
            arguments: {"unit": billet.unit, "period": income.period});
      },
    );
  }

  Widget _buildSummary(ThemeData theme, Income income) {
    final forecast = income.forecast
        ?.cast<IncomeForecast?>()
        .firstWhere((e) => e?.period == income.period, orElse: () => null);
    if (forecast == null) return Container();
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getString(context, "income_forecast_expected"),
                  style: LelloTextStyles.bodyBold(theme)),
              Text(formatCurrency.format(forecast.forecast)),
            ],
          ),
          SizedBox(width: Dimens.spacingMedium),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getString(context, "income_forecast_executed"),
                  style: LelloTextStyles.bodyBold(theme)),
              Text(formatCurrency.format(forecast.value)),
            ],
          )
        ],
      ),
    );
  }
}
