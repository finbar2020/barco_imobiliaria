import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/accountability/presentation/bloc/accountabiity_state.dart';
import 'package:morar/feature/accountability/presentation/controllers/accountability_controller.dart';
import 'package:morar/feature/accountability/presentation/page/accountability_info_page.dart';

class AccountabilityPageArgs {
  String? accountabilityNotificationContext;
  AccountabilityPageArgs({this.accountabilityNotificationContext});
}

class AccountabilityPage extends StatefulWidget {
  const AccountabilityPage({Key? key}) : super(key: key);

  @override
  _AccountabilityPageState createState() => _AccountabilityPageState();
}

class _AccountabilityPageState extends State<AccountabilityPage> {
  var _itemSelecionado;
  final AccountabilityController controller =
      ApplicationContainer.instance().resolve<AccountabilityController>();
  AccountabilityPageArgs? arguments;
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  @override
  void initState() {
    super.initState();
    controller.getPeriods();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    arguments =
        ModalRoute.of(context)?.settings.arguments as AccountabilityPageArgs?;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocProvider.value(
          value: controller.bloc,
          child: BlocBuilder(
            bloc: controller.bloc,
            builder: (context, state) {
              return Scaffold(
                appBar: CustomAppBar(title: "accountability_title"),
                body: _scaffoldBody(state as AccountabilityState, theme),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _scaffoldBody(AccountabilityState state, ThemeData theme) {
    if (state is AccountabilityLoadingState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    if (state is AccountabilityInitialState) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  getString(context, "accountability_empty"),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      );
    }
    if (state is AccountabilityLoadedState) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (arguments?.accountabilityNotificationContext?.isNotEmpty == true &&
            mounted) {
          var period = convertPeriodNotificationParameter(
              arguments!.accountabilityNotificationContext!);
          var title = convertPeriodNotificationParameterForTitle(
              arguments!.accountabilityNotificationContext!);
          controller.getAccountabilityController(period);
          Navigator.pushReplacementNamed(
            context,
            ApplicationRoute.accountabilityInfo,
            arguments:
                AccountabilityInfoPageArgs(period: period, selectedDate: title),
          );
          arguments?.accountabilityNotificationContext = null;
        }
      });
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            color: LelloTheme.palleteOf(theme).backgroundDark(),
            width: double.infinity,
            height: Dimens.spacingLarge,
            child: Center(
              child: Text(
                '${controller.sessionBloc.state.session?.condominium?.name ?? ''} - ${controller.sessionBloc.state.session?.unity?.title ?? ''}',
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.body(theme),
              ),
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getString(context, "accountability_choose_period"),
                    style: LelloTextStyles.body(theme),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  _buildDropDown(state.periodos, theme),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              height: 54.0,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  getString(context, "find"),
                  style: LelloTextStyles.button(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).customColor(),
                  ),
                ),
                onPressed: () {
                  if (_itemSelecionado != null) {
                    controller.getAccountabilityController(convertPeriod());
                    Navigator.pushReplacementNamed(
                      context,
                      ApplicationRoute.accountabilityInfo,
                      arguments: AccountabilityInfoPageArgs(
                          period: convertPeriod(),
                          selectedDate: _itemSelecionado),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      );
    }
    if (state is AccountabilityFailureState) {
      return _buildError(state: state);
    }
    return Container();
  }

  DateTime convertPeriod() {
    String mes = _itemSelecionado
        .toString()
        .substring(0, _itemSelecionado.indexOf('-'))
        .trim();
    String ano = _itemSelecionado
        .toString()
        .substring(
            _itemSelecionado.indexOf('-'), _itemSelecionado.toString().length)
        .replaceAll('-', "")
        .trim();
    List<String> meses =
        getString(context, "accountability_month_list").split("|");
    var teste = meses.firstWhere((element) => element == mes);
    int indexMonth = meses.indexOf(teste);
    DateTime periodo = DateTime(int.parse(ano), indexMonth, 1);
    return periodo;
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

  String convertPeriodNotificationParameterForTitle(String period) {
    String mes = period.substring(0, period.indexOf('/')).trim();
    String ano = period
        .substring(period.indexOf('/'), period.length)
        .replaceAll('/', "")
        .trim();
    List<String> meses =
        getString(context, "accountability_month_list").split("|");
    String titleMes = meses[int.parse(mes)];
    String title = "$titleMes - $ano";
    return title;
  }

  Widget _buildDropDown(List<String> periodos, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1.0,
          color: LelloTheme.palleteOf(theme).grey(),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: DropdownButton(
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down),
          underline: SizedBox.shrink(),
          hint: Text(getString(context, "choose_an_option")),
          value: _itemSelecionado,
          items: periodos.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(
                dropDownStringItem,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          onChanged: (value) {
            _dropDownItemSelected(value as String);
          }),
    );
  }

  void _dropDownItemSelected(String novoItem) {
    setState(() {
      this._itemSelecionado = novoItem;
    });
  }

  Column _buildError({required AccountabilityFailureState state}) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: ErrorHandlingWidget(
              reTryFunction: () {
                controller.getPeriods();
              },
              backFunction: () => Navigator.pop(context, true),
              isProduction: env.isProduction,
              error: state.error?.error.toString() ?? "",
              errorCode: state.error?.code.toString() ?? "",
            ),
          ),
        ),
      ],
    );
  }
}
