// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_filter_sort.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_card.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_filter_drawer.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_month_year.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../controllers/agreements_controller.dart';

class AgreementsHistoryPage extends StatefulWidget {
  const AgreementsHistoryPage({Key? key}) : super(key: key);

  @override
  AgreementsHistoryPageState createState() => AgreementsHistoryPageState();
}

class AgreementsHistoryPageState extends State<AgreementsHistoryPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();

  final controller =
      ApplicationContainer.instance().resolve<AgreementsController>();

  @override
  void initState() {
    controller.sortDueDateKey = AgreementsFilterSortKeys.dueDateDecrescent;
    super.initState();
  }

  @override
  void dispose() {
    controller.searchText = "";
    controller.disposeFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        key: scaffoldState,
        appBar: PrimaryAppBar(
          title: getString(context, "agreements_history"),
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
          ],
        ),
        endDrawer: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Drawer(
            child: AgreementsFilterDrawer(
              isProposal: false,
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            _onPop(controller.agreementsBloc, context);
            return true;
          },
          child: BlocBuilder<AgreementsBloc, AgreementsState>(
            bloc: controller.agreementsBloc,
            builder: (context, state) {
              if (state is AgreementsLoadingState) {
                return Column(
                  children: const [
                    Expanded(child: LoadingWidget()),
                  ],
                );
              }

              if (state is AgreementsErrorState) {
                return ErrorMessageWidget(message: getString(context, ""));
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                controller.searchText = val;
                              });
                            },
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                suffixIcon: SvgPicture.asset(
                                    "assets/ic_search.svg",
                                    color: theme.primaryColor,
                                    height: 16,
                                    fit: BoxFit.scaleDown),
                                hintText: getString(context,
                                    "agreements_search_by_unit_or_owner")),
                          ),
                        ),
                      ],
                    ),
                  ),
                  HistoryText(
                      text: getString(context, "agreements_number_paid"),
                      style: LelloTextStyles.subtitleBold(theme)!
                          .copyWith(color: LelloTheme.palleteOf(theme).grey()),
                      isTitle: true),
                  HistoryText(
                      text: controller.agreementsHistory!.agreementsPaidTotal,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).success()),
                      isTitle: false),
                  HistoryText(
                      text: getString(context, "agreements_number_canceled"),
                      style: LelloTextStyles.subtitleBold(theme)!
                          .copyWith(color: LelloTheme.palleteOf(theme).grey()),
                      isTitle: true),
                  HistoryText(
                      text: controller
                          .agreementsHistory!.agreementsCancelledTotal,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).accent()),
                      isTitle: false),
                  HistoryText(
                      text: getString(context, "agreements_number_disapproved"),
                      style: LelloTextStyles.subtitleBold(theme)!
                          .copyWith(color: LelloTheme.palleteOf(theme).grey()),
                      isTitle: true),
                  HistoryText(
                      text: controller
                          .agreementsHistory!.agreementsDisapprovedTotal,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).accent()),
                      isTitle: false),
                  const Divider(height: 2.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.agreementsHistoryFiltered.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AgreementsMonthYear(
                              index: index,
                              agreements: controller.agreementsHistoryFiltered,
                            ),
                            AgreementsCard(
                              agreement:
                                  controller.agreementsHistoryFiltered[index],
                              onPressed: () {
                                controller.agreement =
                                    controller.agreementsHistoryFiltered[index];
                                AnalyticsEventsManager
                                    .acordosHistoricoDetalheAcessar();

                                Navigator.pushNamed(
                                  context,
                                  ApplicationRoute.agreementsHistoryCardDetails,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onPop(AgreementsBloc agreementsBloc, BuildContext context) {
    Navigator.pop(context);
  }
}

class HistoryText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final bool isTitle;
  const HistoryText({
    Key? key,
    required this.text,
    required this.style,
    required this.isTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimens.spacingMedium,
        isTitle ? Dimens.spacingSmall : Dimens.spacingXSmall,
        Dimens.spacingMedium,
        isTitle ? Dimens.spacingXSmall : Dimens.spacingSmall,
      ),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
