import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_proposals/widgets/agreements_approve_proposal_bottom_sheet.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_proposals/widgets/agreements_disapprove_aproposal_bottom_sheet.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_introduction_details_card.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_quote_details.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../bloc/agreements_state.dart';
import '../../controllers/agreements_controller.dart';

class AgreementsProposalsCardDetailsPage extends StatelessWidget {
  const AgreementsProposalsCardDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<AgreementsController>();
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: BlocConsumer<AgreementsBloc, AgreementsState>(
        listener: (context, state) {
          if (state is AgreementsApprovalPostedState) {
            Navigator.pushNamed(
                context, ApplicationRoute.agreementsStatusChangedSuccess,
                arguments: [state.approved]);
          }
        },
        bloc: controller.agreementsBloc,
        builder: (context, state) {
          if (state is AgreementsSendingState) {
            return Scaffold(
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(
                        height: Dimens.spacingLarge,
                      ),
                      Text(getString(context, 'agreements_updating'))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: PrimaryAppBar(
                  title: getString(context, "agreements_proposals"),
                  theme: theme,
                  ),
              body: Column(
                children: [
                  IntroductionDetailsCard(
                      theme: theme, agreement: controller.agreement!),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.agreement!.quotes.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return AgreementsQuoteDetails(
                          theme: theme,
                          index: index + 1,
                          quote: controller.agreement!.quotes[index],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimens.spacingLarge),
                    child: const Divider(height: 2),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            text: getString(
                                context, "agreements_proposals_approve"),
                            onPressed: () {
                              Modal.showBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) =>
                                    AgreementsApproveProposalBottomSheet(
                                  agreementId: controller.agreement!.id ?? "",
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: Dimens.spacing),
                        SizedBox(
                          height: 54.0,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: Dimens.spacingSmall),
                                Text(
                                  getString(context,
                                      "agreements_proposals_disapprove"),
                                  overflow: TextOverflow.ellipsis,
                                  style: LelloTextStyles.button(theme)!
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Modal.showBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) =>
                                    AgreementsDisapproveProposalBottomSheet(
                                  agreementId: controller.agreement!.id ?? "",
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
