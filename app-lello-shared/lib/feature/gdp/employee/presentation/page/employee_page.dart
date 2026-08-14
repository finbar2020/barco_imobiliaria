import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/employee/employee_bloc.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/employee/employee_state.dart';
import 'package:shared_features/shared_features.dart';

class EmployeePageArgs {
  EmployeeBloc bloc;
  EmployeePageArgs(this.bloc);
}

class EmployeePage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const EmployeePage({Key? key, required this.appContainer}) : super(key: key);
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  // final EmployeeBloc bloc = ApplicationContainer.instance().resolve();
  final dateFormat = DateFormat.yMd();
  final currencyFormat = new NumberFormat.currency(symbol: "R\$");
  late EmployeeBloc bloc;

  var loaded = false;

  @override
  void initState() {
    bloc = widget.appContainer.resolve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!loaded) {
      Employee employee =
          ModalRoute.of(context)!.settings.arguments as Employee;
      bloc.beginLoad(employee.id!);
      loaded = true;
    }
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            theme: theme, title: getString(context, "gdp_employee_detail")),
        body: _buildBody(theme),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is EmployeeLoadingState)
          return Center(child: CircularProgressIndicator());
        return ListView(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          children: [
            Text(getString(context, "gdp_employee_data"),
                style: LelloTextStyles.title(theme)),
            SizedBox(height: Dimens.spacingMedium),
            _buildProfilePicture(theme, state),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(getString(context, "gdp_name"),
                  style: LelloTextStyles.bodyBold(theme)),
              subtitle: Text(state.data?.name ?? "-",
                  style: LelloTextStyles.subBody(theme)),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(getString(context, "gdp_address"),
                  style: LelloTextStyles.bodyBold(theme)),
              subtitle: Text(state.data?.address?.address ?? "-",
                  style: LelloTextStyles.subBody(theme)),
            ),
            _buildAddress(theme, state),
            _buildPhone(theme, state),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(getString(context, "gdp_dob"),
                  style: LelloTextStyles.bodyBold(theme)),
              subtitle: Text(
                  state.data?.dob != null
                      ? dateFormat.format(state.data!.dob!)
                      : "-",
                  style: LelloTextStyles.subBody(theme)),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(getString(context, "gdp_role"),
                  style: LelloTextStyles.bodyBold(theme)),
              subtitle: Text(state.data?.role ?? "-",
                  style: LelloTextStyles.subBody(theme)),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(getString(context, "gdp_status"),
                  style: LelloTextStyles.bodyBold(theme)),
              subtitle: Text(state.data?.status?.toUpperCase() ?? "-",
                  style: LelloTextStyles.subBody(theme)),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(getString(context, "gdp_schooling"),
                  style: LelloTextStyles.bodyBold(theme)),
              subtitle: Text(state.data?.schooling ?? "-",
                  style: LelloTextStyles.subBody(theme)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddress(ThemeData theme, EmployeeState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(getString(context, "gdp_address_number"),
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Text(state.data?.address?.number ?? "-",
                style: LelloTextStyles.subBody(theme)),
          ),
        ),
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(getString(context, "gdp_address_complement"),
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Text(state.data?.address?.complement ?? "-",
                style: LelloTextStyles.subBody(theme)),
          ),
        ),
      ],
    );
  }

  Widget _buildPhone(ThemeData theme, EmployeeState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(getString(context, "gdp_phone"),
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Text(state.data?.phone ?? "-",
                style: LelloTextStyles.subBody(theme)),
          ),
        ),
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(getString(context, "gdp_phone_2"),
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Text(state.data?.phone2 ?? "-",
                style: LelloTextStyles.subBody(theme)),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePicture(ThemeData theme, EmployeeState state) {
    final width = 120.0;
    return Row(
      children: [
        Container(
            width: width,
            height: width * 4 / 3,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: LelloTheme.palleteOf(theme).separator(),
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(state.data?.picture ?? "")))),
        SizedBox(width: Dimens.spacingMedium),
        Expanded(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(getString(context, "gdp_hiring_date"),
                    style: LelloTextStyles.bodyBold(theme)),
                subtitle: Text(
                    state.data?.dob != null
                        ? dateFormat.format(state.data!.dob!)
                        : "-",
                    style: LelloTextStyles.subBody(theme)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(getString(context, "gdp_salary"),
                    style: LelloTextStyles.bodyBold(theme)),
                subtitle: Text(currencyFormat.format(state.data?.salary ?? 0),
                    style: LelloTextStyles.subBody(theme)),
              ),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      onPressed: state.data?.phone?.isNotEmpty != true
                          ? () {}
                          : () async {
                              await Launch.tel(context, "${state.data?.phone}");
                            },
                    ),
                  ),
                  SizedBox(width: Dimens.spacing),
                  Expanded(
                    child: SecondaryButton(
                      child: Icon(
                        Icons.sms_rounded,
                        color: Colors.black,
                      ),
                      onPressed: state.data?.phone?.isNotEmpty != true
                          ? () {}
                          : () async {
                              await Launch.sms(context, "${state.data?.phone}");
                            },
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
