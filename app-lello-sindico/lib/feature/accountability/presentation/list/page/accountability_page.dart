// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';

import 'package:lello/feature/accountability/presentation/list/bloc/accountability_state.dart';
import 'package:lello/feature/accountability/presentation/list/controller/accountability_controller.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

import '../../../domain/entity/accountability_periods.dart';

class AccountabilityPageArgs {
  String? accountabilityNotificationContext;
  AccountabilityPageArgs({this.accountabilityNotificationContext});
}

class AccountabilityPage extends StatefulWidget {
  const AccountabilityPage({super.key});

  @override
  _AccountabilityPageState createState() => _AccountabilityPageState();
}

class _AccountabilityPageState extends State<AccountabilityPage> {
  final AccountabilityController controller =
      ApplicationContainer.instance().resolve<AccountabilityController>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  var isLoaded = false;
  AccountabilityPageArgs? arguments;
  bool redirect = false;

  @override
  void initState() {
    super.initState();
    controller.getAccountabilityPeriods();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!isLoaded) {
      isLoaded = true;
    }
    arguments =
        ModalRoute.of(context)!.settings.arguments as AccountabilityPageArgs?;
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            title: getString(context, "accountability_title"), theme: theme),
        body: BlocBuilder(
          bloc: controller.bloc,
          builder: (BuildContext context, state) {
            if (state is AccountabilityPeriodsLoadingState) {
              return const Center(child: LoadingWidget());
            }
            if (state is AccountabilityPeriodsEmptyState) {
              return const AccountabilityBodyEmpty();
            }
        
            if (state is AccountabilityPeriodsFailedState) {
              return Padding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: ErrorHandlingWidget(
                  reTryFunction: () {
                    controller.getAccountabilityPeriods();
                  },
                  backFunction: () => Navigator.pop(context, true),
                  isProduction: env.isProduction,
                  error: state.error.error.toString(),
                  errorCode: state.error.code.toString(),
                ),
              );
            }
            if (state is AccountabilityPeriodsLoadedState) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                if (arguments
                            ?.accountabilityNotificationContext?.isNotEmpty ==
                        true &&
                    redirect == false &&
                    mounted) {
                  DateTime periodConverted =
                      convertPeriodNotificationParameter(
                          arguments!.accountabilityNotificationContext!);
                  var period =
                      state.period.cast<AccountabilityPeriods?>().firstWhere(
                            (element) => element?.period == periodConverted,
                            orElse: () => null,
                          );
                  if (period != null) {
                    Navigator.of(context).pushNamed(
                      ApplicationRoute.accountabilityDetail,
                      arguments: period,
                    );
                    redirect = true;
                  }
        
                  arguments?.accountabilityNotificationContext = null;
                }
              });
              return AccountabilityBody(
                periods: state.period,
                accountabilityNotificationContext:
                    arguments?.accountabilityNotificationContext,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  DateTime convertPeriodNotificationParameter(String period) {
    String mes = period.substring(0, period.indexOf('/')).trim();
    String ano = period
        .substring(period.indexOf('/'), period.length)
        .replaceAll('/', "")
        .trim();
    DateTime periodo = DateTime(int.parse(ano), int.parse(mes), 1);
    return periodo;
  }
}

class AccountabilityBody extends StatefulWidget {
  final List<AccountabilityPeriods> periods;
  final String? accountabilityNotificationContext;
  const AccountabilityBody({
    Key? key,
    this.accountabilityNotificationContext,
    required this.periods,
  }) : super(key: key);

  @override
  State<AccountabilityBody> createState() => _AccountabilityBodyState();
}

class _AccountabilityBodyState extends State<AccountabilityBody> {
  DateTime? selectedMonth;

  final format = DateFormat("MMMM - yyyy");
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SessionBloc sessionBloc = BlocProvider.of<SessionBloc>(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(getString(context, "accountability_choose_period"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacing),
          DropdownButtonFormField(
            hint: Text(getString(context, 'gdp_quick_fix_select'),
                style: LelloTextStyles.body(theme)),
            items: widget.periods
                .map((e) => DropdownMenuItem(
                    value: e.period,
                    child: Text(
                      "${format.format(e.period).capitalize!}${e.isAproved ? "" : (" - ${getString(context, "accountability_pending").toUpperCase()}")}",
                      style: LelloTextStyles.bodyBold(theme),
                    )))
                .toList(),
            onChanged: (DateTime? value) {
              setState(() {
                selectedMonth = value!;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: Text(
              getString(context, "accountability_caption_subtitle"),
              style: LelloTextStyles.subtitle(theme)!
                  .copyWith(color: theme.colorScheme.secondary),
            ),
          ),
          SizedBox(height: Dimens.spacingLarge),
          PrimaryButton(
            buttonColor: selectedMonth != null
                ? theme.primaryColor
                : LelloTheme.palleteOf(theme).grey(),
            text: getString(context, "find"),
            onPressed: () {
              if (selectedMonth != null) {
                Navigator.of(context).pushNamed(
                  ApplicationRoute.accountabilityDetail,
                  arguments: widget.periods.firstWhere(
                    (element) => element.period == selectedMonth,
                  ),
                );
              }
            },
          ),
          SizedBox(height: Dimens.spacingSmall),
          CircuitBreakerWidget(
            appContainer: ApplicationContainer.instance(),
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ?? "",
            applicationRbac: ApplicationRbac.sindicoPpcDuvidasRead,
            rbacEnabled:
                sessionBloc.checkRback(ApplicationRbac.sindicoPpcDuvidasRead),
            child: SecondaryButton(
              buttonBorderColor: theme.primaryColor,
              text: getString(context, "question_main_my_question"),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ApplicationRoute.accountabilityQuestionListPage,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class AccountabilityBodyEmpty extends StatelessWidget {
  const AccountabilityBodyEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            getString(context, "accountability_choose_period"),
            style: LelloTextStyles.bodyBold(theme)!.merge(
              TextStyle(color: theme.disabledColor),
            ),
          ),
          SizedBox(height: Dimens.spacing),
          IgnorePointer(
            child: DropdownButtonFormField<int>(
              hint: Text(
                getString(context, 'gdp_quick_fix_select'),
                style: LelloTextStyles.body(theme)!.merge(
                  TextStyle(color: theme.disabledColor),
                ),
              ),
              items: const [],
              onChanged: (value) {},
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: theme.disabledColor,
              ),
              SizedBox(width: Dimens.spacingSmall),
              Flexible(
                child: Text(
                  getString(context, 'accounttability_not_avaliable'),
                  style: LelloTextStyles.body(theme)!.merge(
                    TextStyle(color: theme.disabledColor),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimens.spacingSmall),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Text(
                getString(context, "accountability_caption_empty_subtitle"),
                style: LelloTextStyles.subtitle(theme),
              ),
            ),
          ),
          SizedBox(height: Dimens.spacingLarge),
          IgnorePointer(
            child: PrimaryButton(
              text: getString(context, "find"),
              onPressed: () {},
              buttonColor: LelloTheme.palleteOf(theme).grey(),
            ),
          ),
        ],
      ),
    );
  }
}
