import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';

class ScheduleVacationPage extends StatefulWidget {
  const ScheduleVacationPage({super.key});

  @override
  ScheduleVacationPageState createState() => ScheduleVacationPageState();
}

class ScheduleVacationPageState extends State<ScheduleVacationPage> {
  final ScheduleVacationBloc bloc = ApplicationContainer.instance().resolve();
  final Validator _validator = ApplicationContainer.instance().resolve();
  final dateFormat = DateFormat.yMd();
  var loaded = false;
  Vacation vacation = Vacation();
  var period = 0;
  var numberOfDays = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      ApplicationRoute.gdpScheduleVacationSucceeded,
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
