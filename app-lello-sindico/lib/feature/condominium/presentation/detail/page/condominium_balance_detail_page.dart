import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_debits.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';
import 'package:lello/feature/condominium/presentation/detail/bloc/condominium_balance_detail_bloc.dart';
import 'package:lello/feature/condominium/presentation/detail/bloc/condominium_balance_detail_state.dart';
import 'package:lello/feature/condominium/presentation/detail/widget/condominium_balance_detail_filter.dart';

class CondominiumBalanceDetailPage extends StatefulWidget {
  const CondominiumBalanceDetailPage({Key? key}) : super(key: key);

  @override
  CondominiumBalanceDetailState createState() =>
      CondominiumBalanceDetailState();
}

class CondominiumBalanceDetailState
    extends State<CondominiumBalanceDetailPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final currencyFormat = NumberFormat.currency(symbol: "R\$");
  final _dateFormat = DateFormat.yMd();

  BalanceDetailBloc bloc = ApplicationContainer.instance().resolve();
  late Completer<void> _refreshCompleter;
  late ScrollController controller;
  final _indicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer(
      listener: (context, state) {
        if (state is BalanceDetailLoadingState) {
          _indicatorKey.currentState?.show();
        } else {
          _refreshCompleter.complete();
          _refreshCompleter = Completer<void>();
          if (state is BalanceDetailLoadedState) {
            if (state.remoteFail) {
              Flushbar(
                message: getString(context, "condominium_balance_failed"),
                duration: const Duration(seconds: 4),
              ).show(context);
            }
          }
        }
      },
      bloc: bloc,
      builder: (context, state) => Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).backgroundDark(),
        key: scaffoldState,
        endDrawer: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: _buildFilterDrawer(state as BalanceDetailState)),
        appBar: PrimaryAppBar(
            theme: theme,
            title:
                getString(context, "condominium_balance_detail_account_title"),
            actions: [
              (state is BalanceDetailLoadingState)
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        scaffoldState.currentState!.openEndDrawer();
                      },
                      icon: SvgPicture.asset(
                        "assets/ic_filter.svg",
                        color: theme.primaryColor,
                      ),
                    )
            ]),
        body: (state is BalanceDetailLoadingState)
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(theme, state),
      ),
    );
  }

  Widget _buildFilterDrawer(BalanceDetailState state) {
    return Drawer(
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
              BalanceDetailFilterWidget(
                entity: state.filter ?? CondominiumBalanceDetailFilter(),
                onApply: (filter) {
                  Navigator.of(context).pop();
                  bloc.beginRefresh(filter);
                },
                onClose: () {
                  Navigator.of(context).pop();
                },
              ),
            ]),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, BalanceDetailState state) {
    return RefreshIndicator(
      key: _indicatorKey,
      onRefresh: () async {
        bloc.beginRefresh(state.filter!);
        return _refreshCompleter.future;
      },
      child: state is BalanceDetailLoadFailedState
          ? Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Center(
                child: Text(
                  getString(context, "condominium_balance_failed"),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildHeader(theme, state.data),
                  ListView.separated(
                      itemBuilder: (context, index) {
                        final entity = state.data!.debits![index];
                        return _buildItem(theme, index, entity);
                      },
                      itemCount: state.data?.debits!.length ?? 0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                              color: LelloTheme.palleteOf(theme).separator())),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(ThemeData theme, CondominiumBalanceDetail? detail) {
    if (detail == null) return Container();
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(Dimens.spacingMedium).copyWith(bottom: 0),
            decoration: BoxDecoration(
                color: LelloTheme.palleteOf(theme).separator(),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                )),
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 2,
              mainAxisSpacing: Dimens.spacingXSmall,
              crossAxisSpacing: Dimens.spacingXSmall,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                Divider(
                  color: LelloTheme.palleteOf(theme).separator(),
                ),
                _buildTitleAndSubTitle(
                    theme,
                    getString(context, "condominium_balance_detail_debit"),
                    currencyFormat.format(detail.credits),
                    usingSpacingBottom: false),
                _buildTitleAndSubTitle(
                    theme,
                    getString(context, "condominium_balance_detail_credit"),
                    currencyFormat.format(detail.debit),
                    usingSpacingBottom: false),
                Text(getString(context, "condominium_balance_detail_previous"),
                    style: LelloTextStyles.bodyBold(theme)),
                const Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Text(currencyFormat.format(detail.previousBalance),
                    style: LelloTextStyles.bodyBold(theme)),
                Text(getString(context, "condominium_balance_detail"),
                    style: LelloTextStyles.bodyBold(theme)),
                const Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Text(currencyFormat.format(detail.balance),
                    style: LelloTextStyles.bodyBold(theme))
              ],
            )),
      ],
    );
  }

  Widget _buildItem(ThemeData theme, int index, Debits? entity) {
    return Padding(
      padding:
          EdgeInsets.all(Dimens.spacingMedium).copyWith(top: 0.0, bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                    contentPadding: const EdgeInsets.all(0.0),
                    title: Text(
                        getString(context,
                            "condominium_balance_detail_account_balance"),
                        style: LelloTextStyles.bodyBold(theme)),
                    subtitle: Text(entity?.id ?? "",
                        style: LelloTextStyles.body(theme))),
              ),
              entity?.period != null
                  ? Expanded(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0.0),
                        title: Text(
                            getString(
                                context, "condominium_balance_detail_date"),
                            style: LelloTextStyles.bodyBold(theme)),
                        subtitle: Text(_dateFormat.format(entity!.period!),
                            style: LelloTextStyles.body(theme)),
                      ),
                    )
                  : Container(),
            ],
          ),
          _buildTitleAndSubTitle(
              theme,
              getString(context, "condominium_balance_detail_name"),
              entity!.name),
          Row(
            children: <Widget>[
              Flexible(
                  child: _buildTitleAndSubTitle(
                      theme,
                      getString(
                          context, "condominium_balance_detail_credit_word"),
                      currencyFormat.format(entity.credits))),
              Flexible(
                  child: _buildTitleAndSubTitle(
                      theme,
                      getString(
                          context, "condominium_balance_detail_debit_word"),
                      currencyFormat.format(entity.debit))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTitleAndSubTitle(
      ThemeData theme, String? title, String? subTitle,
      {bool usingSpacingBottom = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(title ?? "", style: LelloTextStyles.bodyBold(theme)),
        Text(subTitle ?? "", style: LelloTextStyles.body(theme)),
        usingSpacingBottom == true
            ? SizedBox(height: Dimens.spacingMedium)
            : Container()
      ],
    );
  }
}
