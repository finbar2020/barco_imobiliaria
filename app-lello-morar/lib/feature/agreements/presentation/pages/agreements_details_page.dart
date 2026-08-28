import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_quotas.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AgreementsDetailsPage extends StatelessWidget {
  const AgreementsDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AgreementCreated agreement = AgreementCreated();
    var arguments = ModalRoute.of(context)!.settings.arguments as List;
    AgreementsBloc bloc = arguments[0];
    agreement = arguments[1];
    final theme = LelloTheme.light;
    final SessionBloc sessionBloc = BlocProvider.of(context);
    return WillPopScope(
      onWillPop: () async {
        bloc.goToAgreements(agreement, reload: false);
        Navigator.popUntil(
          context,
          ModalRoute.withName(ApplicationRoute.agreements),
        );
        return true;
      },
      child: Scaffold(
        appBar: WhiteAppBar(
          title: "agreements_in_progress_title",
          isGetString: true,
          onPressed: () {
            bloc.goToAgreements(agreement, reload: false);
            Navigator.popUntil(
              context,
              ModalRoute.withName(ApplicationRoute.agreements),
            );
          },
        ),
        body: BlocBuilder<AgreementsBloc, AgreementsState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is AgreementsLoadingState)
              return Center(child: LoadingWidget());
            if (state is AgreementsErrorState)
              return Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                    height: 60.0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          getString(context, state.errorMessageKey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            if (state is AgreementDetailLoadedState)
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: LelloTheme.palleteOf(theme).textLightest(),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${sessionBloc.state.session!.unity!.title!} - ${state.agreement.unitOwner}"),
                            SizedBox(height: Dimens.spacing),
                            Text(getString(
                                context, "agreements_payment_method")),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(
                            state.agreement.quotes.length,
                            (index) => _buildQuotaInfo(
                                  context,
                                  theme,
                                  state.agreement,
                                  state.agreement.quotes[index],
                                  index,
                                )),
                        SizedBox(height: Dimens.spacingMedium),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.spacingMedium),
                          child: Divider(height: 2),
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.spacingMedium),
                          child: Text(
                            getString(context, "agreements_installments"),
                            style:
                                LelloTextStyles.titleSmallBold(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).hubText(),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimens.spacing),
                        ...List.generate(
                            state.agreement.installments.length,
                            (index) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.spacingMedium),
                                  child: Column(
                                    children: [
                                      _buildInstallmentInfo(
                                        state,
                                        context,
                                        theme,
                                        state.agreement.installments[index],
                                        index,
                                      ),
                                      SizedBox(height: Dimens.spacingSmall),
                                    ],
                                  ),
                                )),
                        SizedBox(height: Dimens.spacing),
                      ],
                    ),
                  ],
                ),
              );
            return Container();
          },
        ),
      ),
    );
  }

  Row _buildInstallmentInfo(
    AgreementDetailLoadedState state,
    BuildContext context,
    ThemeData theme,
    AgreementInstallment installment,
    int index,
  ) {
    return Row(
      children: [
        Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
              color: installment.getStatusColor(theme),
              borderRadius: BorderRadius.circular(25.0)),
        ),
        SizedBox(width: Dimens.spacingSmall),
        Text(
          "${getString(context, "agreements_installments").replaceAll("s", "")} ${index + 1} - ${installment.getStatusInfo(context)}",
          style: LelloTextStyles.caption(theme)?.copyWith(
            color: installment.getStatusColor(theme),
          ),
        ),
      ],
    );
  }

  Widget _buidComponent(
      {required String title,
      required String subtitle,
      required ThemeData theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Dimens.spacingSmall,
        ),
        Text(
          title.toUpperCase(),
          style: LelloTextStyles.body(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).grey(),
          ),
        ),
        SizedBox(
          height: Dimens.spacingXSmall,
        ),
        Text(
          subtitle,
          style: LelloTextStyles.body(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).text(),
          ),
        ),
        SizedBox(
          height: Dimens.spacingSmall,
        ),
      ],
    );
  }

  Widget _buildQuotaInfo(
    BuildContext context,
    ThemeData theme,
    Agreement agreement,
    AgreementQuota quota,
    int index,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          Dimens.spacingMedium, Dimens.spacingMedium, Dimens.spacingMedium, 0),
      width: double.infinity,
      color: LelloTheme.palleteOf(theme).background(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${getString(context, "agreements_quota")} ${index + 1} -  ${quota.date}",
            style: LelloTextStyles.titleSmall(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).grey(),
            ),
          ),
          SizedBox(
            height: Dimens.spacingSmall,
          ),
          _buidComponent(
            title: getString(context, "agreements_original_value"),
            subtitle: quota.origin,
            theme: theme,
          ),
          _buidComponent(
            title: getString(context, "agreements_fines_taxes"),
            subtitle: quota.fee,
            theme: theme,
          ),
          _buidComponent(
            title: getString(context, "agreements_total_value"),
            subtitle: quota.total,
            theme: theme,
          ),
          _buidComponent(
            title: getString(context, "agreements_payment_type"),
            subtitle: agreement.method(context),
            theme: theme,
          ),
          _buidComponent(
            title: getString(context, "agreements_installment"),
            subtitle: agreement.newValue,
            theme: theme,
          ),
          _buidComponent(
            title: getString(context, "agreements_new_expiration"),
            subtitle: agreement.newExpiration,
            theme: theme,
          ),
          if (agreement.quotes.length > 1)
            SizedBox(
              height: Dimens.spacingSmall,
            ),
          if (agreement.quotes.length > 1) Divider(height: 1),
        ],
      ),
    );
  }
}
