import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/modal/month_picker.dart';
import 'package:lello/feature/income/presentation/billets/detail/bloc/billets_detail_state.dart';
import 'package:lello/feature/income/presentation/billets/detail/controller/billets_details_controller.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/shared_features.dart';

class BilletDetailPage extends StatefulWidget {
  const BilletDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BilletDetailState();
}

class _BilletDetailState extends State<BilletDetailPage> {
  final BilletsDetailsController controller =
      ApplicationContainer.instance().resolve();
  final currencyFormat = NumberFormat.currency(symbol: "R\$");
  final dateFormat = DateFormat("MMMM - yyyy");
  var loaded = false;

  @override
  void initState() {
    controller.getBillet(
        unit: controller.selectedUnit!, period: controller.selectedDateTime!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMd();
    final periodFormat = DateFormat.yMMMM();
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: PrimaryAppBar(
        theme: theme,
        title: getString(context, "income_monthly_billets"),
        iconColor: theme.primaryColor,
      ),
      body: BlocBuilder(
        bloc: controller.bloc,
        builder: (BuildContext context, state) {
          if (state is BilletsDetailLoadingState) {
            return const Center(child: LoadingWidget());
          }
          if (state is BilletsDetailFailureState) {
            return Text(
              FailureMessage.get(context, state.error)!,
              style: LelloTextStyles.error(theme),
              textAlign: TextAlign.center,
            );
          }
          if (state is BilletsDetailSuccessState) {
            if (state.billet == null) {
              return Padding(
                padding: EdgeInsets.all(Dimens.spacing),
                child: Center(
                  child: Text(
                    getString(context, "income_billet_list_not_found"),
                    style: LelloTextStyles.error(theme),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                            getString(
                                context, "income_billet_item_title_prefix"),
                            style: LelloTextStyles.title(theme)),
                        SizedBox(height: Dimens.spacingMedium),
                        Text(
                          "${getString(context, "income_billet_item_title_prefix")}: ${controller.selectedUnit?.title ?? ""}",
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                        Text(
                          controller.selectedUnit?.group ?? "",
                          style: LelloTextStyles.body(theme),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () async {
                      final newPeriod = await showMonthPicker(
                          context: context,
                          initialDate: controller.selectedDateTime!);
                      if (newPeriod != null) {
                        controller.selectedDateTime = newPeriod;
                        await controller.getBillet(
                          unit: controller.selectedUnit!,
                          period: newPeriod,
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          Dimens.spacingMedium, 0, Dimens.spacingMedium, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              toBeginningOfSentenceCase(periodFormat
                                      .format(controller.selectedDateTime!)) ??
                                  "",
                              style: LelloTextStyles.subtitleBold(theme),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(Dimens.spacing)
                                .copyWith(right: 0),
                            child: SvgPicture.asset(
                              "assets/ic_arrow_down_black.svg",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      GridView.count(
                        padding: EdgeInsets.all(Dimens.spacingMedium),
                        childAspectRatio: 2,
                        crossAxisCount: 2,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  getString(context,
                                      "income_billet_detail_expiration"),
                                  style: LelloTextStyles.bodyBold(theme),
                                  textAlign: TextAlign.left),
                              Text(
                                  dateFormat.format(
                                      state.billet?.period ?? DateTime.now()),
                                  style: LelloTextStyles.body(theme),
                                  textAlign: TextAlign.left),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  getString(
                                      context, "income_billet_detail_expected"),
                                  style: LelloTextStyles.bodyBold(theme),
                                  textAlign: TextAlign.left),
                              Text(
                                  dateFormat.format(
                                      state.billet?.period ?? DateTime.now()),
                                  style: LelloTextStyles.body(theme),
                                  textAlign: TextAlign.left),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                getString(
                                    context, "income_billet_detail_situation"),
                                style: LelloTextStyles.bodyBold(theme),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                state.billet?.situation?.toUpperCase() ?? "",
                                style: LelloTextStyles.body(theme),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  getString(
                                      context, "income_billet_detail_value"),
                                  style: LelloTextStyles.bodyBold(theme),
                                  textAlign: TextAlign.left),
                              Text(
                                  currencyFormat
                                      .format(state.billet?.value ?? 0.0),
                                  style: LelloTextStyles.body(theme),
                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ],
                      ),
                      if (state.billet != null &&
                          state.billet!.founds!.isNotEmpty)
                        const Divider(height: 2.0),
                      if (state.billet != null &&
                          state.billet!.founds!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.spacingMedium),
                          child: BilletFoundsListWidget(
                            founds: state.billet!.founds!,
                          ),
                        ),
                      Visibility(
                        visible: state.billet?.situation == "pendente" &&
                            controller.isDateValid,
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: Builder(
                            builder: (buttonContext) => PrimaryButton(
                              onPressed: () async {
                                if (controller.file != null) {
                                  final box = buttonContext.findRenderObject() as RenderBox?;
                                  final rect = box != null
                                      ? box.localToGlobal(Offset.zero) & box.size
                                      : null;
                                  shareFile(controller.file!, sharePositionOrigin: rect);
                                }
                              },
                              text: getString(context,
                                  "income_billet_detail_share_button_title"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
