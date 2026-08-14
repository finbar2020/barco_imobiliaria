import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_filter_sort.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_card.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_filter_drawer.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_month_year.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../bloc/agreements_state.dart';
import '../../controllers/agreements_controller.dart';

class AgreementsProposalsPageArgs {
  String? agreementsNotificationContext;
  AgreementsProposalsPageArgs({
    this.agreementsNotificationContext,
  });
}

class AgreementsProposalsPage extends StatefulWidget {
  const AgreementsProposalsPage({Key? key}) : super(key: key);

  @override
  State<AgreementsProposalsPage> createState() =>
      _AgreementsProposalsPageState();
}

class _AgreementsProposalsPageState extends State<AgreementsProposalsPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();

  final controller =
      ApplicationContainer.instance().resolve<AgreementsController>();
  AgreementsProposalsPageArgs? arguments;
  bool redirect = false;

  @override
  void dispose() {
    controller.searchText = "";
    controller.disposeFilter();
    super.dispose();
  }

  @override
  void initState() {
    controller.sortProposalDateKey =
        AgreementsFilterSortKeys.proposalDateCrescent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    arguments = ModalRoute.of(context)!.settings.arguments
        as AgreementsProposalsPageArgs?;
    return Theme(
      data: theme,
      child: Scaffold(
        key: scaffoldState,
        appBar: PrimaryAppBar(
          title: getString(context, "agreements_proposals"),
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
              isProposal: true,
            ),
          ),
        ),
        body: BlocBuilder<AgreementsBloc, AgreementsState>(
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
              return ErrorMessageWidget(
                message: getString(context, ""),
              );
            }
            if (state is AgreementsSuccessState) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
                if (arguments?.agreementsNotificationContext?.isNotEmpty ==
                        true &&
                    redirect == false &&
                    mounted) {
                  var item = controller.agreementsProposalsFiltered
                      .cast<Agreement?>()
                      .firstWhere(
                          (element) =>
                              element?.notificationParameter ==
                                  arguments?.agreementsNotificationContext ||
                              element?.id ==
                                  arguments?.agreementsNotificationContext,
                          orElse: () => null);
                  if (item != null) {
                    controller.agreement = item;
                    arguments?.agreementsNotificationContext = null;
                    redirect = true;
                    await Navigator.pushNamed(
                      context,
                      ApplicationRoute.agreementsProposalsCardDetails,
                    );
                  }
                }
              });
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
                                    height: 16,
                                    color: theme.primaryColor,
                                    fit: BoxFit.scaleDown),
                                hintText: getString(context,
                                    "agreements_search_by_unit_or_owner")),
                          ),
                        ),
                      ],
                    ),
                  ),
                  controller.agreementsProposalsFiltered.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              getString(context, "agreements_proposals_empty"),
                              style: LelloTextStyles.body(theme)!.copyWith(
                                color: LelloTheme.palleteOf(theme).text(),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount:
                                controller.agreementsProposalsFiltered.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AgreementsMonthYear(
                                      index: index,
                                      agreements: controller
                                          .agreementsProposalsFiltered),
                                  AgreementsCard(
                                    agreement: controller
                                        .agreementsProposalsFiltered[index],
                                    onPressed: () async {
                                      controller.agreement = controller
                                          .agreementsProposalsFiltered[index];
                                      await Navigator.pushNamed(
                                        context,
                                        ApplicationRoute
                                            .agreementsProposalsCardDetails,
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
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
