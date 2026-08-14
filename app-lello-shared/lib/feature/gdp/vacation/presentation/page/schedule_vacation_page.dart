import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';
import 'package:shared_features/shared_features.dart';

class ScheduleVacationPageArgs {
  ScheduleVacationBloc scheduleVacationBloc;
  ScheduleVacationPageArgs(this.scheduleVacationBloc);
}

class ScheduleVacationPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const ScheduleVacationPage({Key? key, required this.appContainer})
      : super(key: key);
  @override
  _ScheduleVacationPageState createState() => _ScheduleVacationPageState();
}

class _ScheduleVacationPageState extends State<ScheduleVacationPage> {
  // final ScheduleVacationBloc bloc = ApplicationContainer.instance().resolve();
  // final Validator _validator = ApplicationContainer.instance().resolve();
  late ScheduleVacationBloc bloc;
  late Validator _validator;
  final dateFormat = DateFormat.yMd();
  var loaded = false;
  Vacation vacation = new Vacation();
  var period = 0;
  var numberOfDays = 0;

  @override
  void initState() {
    bloc = widget.appContainer.resolve();
    _validator = widget.appContainer.resolve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    vacation = ModalRoute.of(context)!.settings.arguments as Vacation;

    return Theme(
        data: theme,
        child: Scaffold(
            appBar: PrimaryAppBar(
                theme: theme,
                title: getString(context, 'gdp_vacation_schedule_page_title')),
            body: BlocListener(
              bloc: bloc,
              child: _buildContent(theme, vacation),
              listener: (BuildContext context, state) {
                if (state is ScheduleVacationLoadedState) {
                  Navigator.of(context).pushNamed(
                      SharedApplicationRoute.gdpScheduleVacationSucceeded,
                      arguments: vacation);
                }
              },
            )));
  }

  String formatDate(DateTime date) {
    return dateFormat.format(date);
  }

  Widget _buildHeader(ThemeData theme, Employee employee) {
    return AltSection(
        child: ListTile(
            title: Text(getString(context, 'gdp_vacation_schedule_employee'),
                style: LelloTextStyles.bodyBold(theme)),
            subtitle:
                Text(employee.name!, style: LelloTextStyles.body(theme))));
  }

  Widget _buildContent(ThemeData theme, Vacation vacation) {
    final employee = vacation.employee;

    return DismissKeyboard(
      child: ListView(
        children: [
          _buildHeader(theme, employee!),
          _buildFormItem(theme,
              title: getString(context, "gdp_vacation_schedule_vacation_time"),
              field: PrimaryTextFormField(
                  onChanged: (value) {
                    setState(() {
                      period = int.parse(value);
                    });
                  },
                  validator: (value) => _validator.validateRequired(value),
                  textInputType: TextInputType.number,
                  hint: "Defina a quantidade de periodos")),
          _buildFormItem(theme,
              title:
                  getString(context, "gdp_vacation_schedule_vacation_period"),
              field: PrimaryTextFormField(
                  onChanged: (value) {
                    setState(() {
                      numberOfDays = int.parse(value);
                    });
                  },
                  validator: (value) => _validator.validateRequired(value),
                  textInputType: TextInputType.number,
                  hint: "Defina a quantidade de periodos")),
          Padding(
            padding: EdgeInsets.all(Dimens.spacing),
            child: PrimaryButton(
              text: getString(context, 'gdp_vacation_schedule_save'),
              onPressed: () {
                // bloc.createScheduledVacation(vacation.reference!,
                //     employee.id!, period, numberOfDays);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimens.spacingXSmall, horizontal: Dimens.spacing),
            child: SecondaryButton(
              text: getString(context, 'gdp_vacation_schedule_cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFormItem(ThemeData theme, {String? title, Widget? field}) {
    return ListTile(
      contentPadding: EdgeInsets.all(Dimens.spacingMedium).copyWith(bottom: 0),
      title: Text(
        title ?? "",
        style: LelloTextStyles.bodyBold(theme),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: Dimens.spacingSmall),
        child: field ?? Container(),
      ),
    );
  }
}
