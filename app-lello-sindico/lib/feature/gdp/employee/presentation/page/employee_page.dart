import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/verify_app_and_biometric_statu.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/access_management/presentation/widgets/access_management_link_dialog.dart';
import 'package:lello/feature/access_management/presentation/widgets/access_management_sms_dialog.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_bloc.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_event.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_state.dart';
import 'package:lello/feature/gdp/employee/presentation/page/employee_invite_failed_page.dart';
import 'package:lello/feature/gdp/employee/presentation/page/employee_invite_success_page.dart';
import 'package:lello/feature/gdp/employee/presentation/page/employee_link_success_page.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final sessionBloc = ApplicationContainer.instance().resolve<SessionBloc>();
  final EmployeeBloc bloc = ApplicationContainer.instance().resolve();
  final dateFormat = DateFormat.yMd();
  final currencyFormat = NumberFormat.currency(symbol: "R\$");

  var loaded = false;
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
    return BlocConsumer<EmployeeBloc, EmployeeState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is EmployeeSendInviteSmsSuccessState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeInviteSuccessPage(
                state: state,
              ),
            ),
          );
        } else if (state is EmployeeSendInviteLinkSuccessState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeLinkSuccessPage(
                state: state,
              ),
            ),
          );
        } else if (state is EmployeeSendInviteFailedState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmployeeInviteErrorPage(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is EmployeeLoadingState) {
          return const Center(child: LoadingWidget());
        }
        return ListView(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          children: [
            Text(getString(context, "gdp_employee_data"),
                style: LelloTextStyles.title(theme)),
            SizedBox(height: Dimens.spacingMedium),
            VerifyAppAndBiometricStatus(
              useApp: state.data?.useApp == true,
              hasBiometric: (sessionBloc.state.session?.selectedCondominium
                          ?.useFacialBiometric ??
                      false) &&
                  state.data?.condoHasBiometric == true,
              hasBiometricRegistered: state.data?.userHasBiometric == true,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => state.data?.phone != null
                      ? AccessManagementSmsDialog(
                          phone: state.data?.phone ?? "",
                          name: state.data?.name ?? "",
                          sendSms: () {
                            Navigator.pop(context);
                            bloc.add(EmployeeSendInviteEvent(
                              employee: state.data!,
                              type: AccessManagementInviteForwardType.sms,
                            ));
                          },
                          sendLink: () {
                            Navigator.pop(context);
                            bloc.add(EmployeeSendInviteEvent(
                              employee: state.data!,
                              type: AccessManagementInviteForwardType.link,
                            ));
                          })
                      : AccessManagementLinkDialog(sendLink: () {
                          Navigator.pop(context);
                          bloc.add(EmployeeSendInviteEvent(
                            employee: state.data!,
                            type: AccessManagementInviteForwardType.link,
                          ));
                        }),
                );
              },
            ),
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
    const width = 120.0;
    return Row(
      children: [
        Container(
            width: width,
            height: width * 4 / 3,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                    state.data?.hiringDate != null
                        ? dateFormat.format(state.data!.hiringDate!)
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
                      onPressed: state.data?.phone?.isNotEmpty != true
                          ? () {}
                          : () async {
                              await Launch.tel(context, "${state.data?.phone}");
                            },
                      child: SvgPicture.asset("assets/ic_call.svg"),
                    ),
                  ),
                  SizedBox(width: Dimens.spacing),
                  Expanded(
                    child: SecondaryButton(
                      onPressed: state.data?.phone?.isNotEmpty != true
                          ? () {}
                          : () async {
                              await Launch.sms(context, "${state.data?.phone}");
                            },
                      child: SvgPicture.asset("assets/ic_sms.svg"),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
