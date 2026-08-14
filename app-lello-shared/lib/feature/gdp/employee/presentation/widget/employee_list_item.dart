import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';

class EmployeeListItem extends StatelessWidget {
  final Employee? employee;
  final Function(Employee)? onPressed;
  final dateFormat = DateFormat.yMd();

  EmployeeListItem({Key? key, this.employee, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        if (onPressed != null) {
          onPressed!(employee!);
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: Text(getString(context, "gdp_id"),
                  style: LelloTextStyles.bodyBold(theme)),
              subtitle: Text(employee?.id ?? "-",
                  style: LelloTextStyles.subBody(theme)),
              trailing: SvgPicture.asset("assets/ic_arrow_right.svg"),
            ),
            ListTile(
              title: Text(getString(context, "gdp_name"),
                  style: LelloTextStyles.bodyBold(theme)),
              subtitle: Text(employee?.name ?? "-",
                  style: LelloTextStyles.subBody(theme)),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(getString(context, "gdp_dob"),
                        style: LelloTextStyles.bodyBold(theme)),
                    subtitle: Text(
                        employee?.dob != null
                            ? dateFormat.format(employee!.dob!)
                            : "-",
                        style: LelloTextStyles.subBody(theme)),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(getString(context, "gdp_role"),
                        style: LelloTextStyles.bodyBold(theme)),
                    subtitle: Text(employee?.role ?? "-",
                        style: LelloTextStyles.subBody(theme)),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(getString(context, "gdp_hiring_date"),
                        style: LelloTextStyles.bodyBold(theme)),
                    subtitle: Text(
                        employee?.hiringDate != null
                            ? dateFormat.format(employee!.hiringDate!)
                            : "-",
                        style: LelloTextStyles.subBody(theme)),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(getString(context, "gdp_status"),
                        style: LelloTextStyles.bodyBold(theme)),
                    subtitle: Text(employee?.status ?? "-",
                        style: LelloTextStyles.subBody(theme)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
