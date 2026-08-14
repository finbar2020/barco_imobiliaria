import 'package:colaborador/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

class LoginTabletEmployeesStepWidget extends StatefulWidget {
  final List<EmployeeInfo> employees;
  final Function(LoginTabletSteps newStep) changeStep;
  final Function(EmployeeInfo employeeInfo) onEmployeeSelected;
  const LoginTabletEmployeesStepWidget({
    Key? key,
    required this.employees,
    required this.changeStep,
    required this.onEmployeeSelected,
  }) : super(key: key);

  @override
  State<LoginTabletEmployeesStepWidget> createState() =>
      _LoginTabletEmployeesStepWidgetState();
}

class _LoginTabletEmployeesStepWidgetState
    extends State<LoginTabletEmployeesStepWidget> {
  late List<EmployeeInfo> filteredEmployees;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredEmployees = widget.employees;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        widget.changeStep(LoginTabletSteps.condominiumName);
        return false;
      },
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () =>
                      widget.changeStep(LoginTabletSteps.condominiumName),
                  child: Icon(Icons.arrow_back_ios_rounded,
                      color: LelloTheme.palleteOf(theme).hubText()),
                ),
                Expanded(
                  child: Text(
                    getString(context, "login_tablet_select_profile"),
                    style: LelloTextStyles.title(theme),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimens.spacingLarge),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: searchController,
              decoration: InputDecoration(
                labelText: getString(context, "search_by_name"),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          _filterEmployees(query: '');
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              onChanged: (value) {
                _filterEmployees(query: value);
                setState(() {});
              },
            ),
            SizedBox(height: Dimens.spacing),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEmployees.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () =>
                        widget.onEmployeeSelected(filteredEmployees[index]),
                    child: Card(
                      color: LelloTheme.palleteOf(theme).greyCard(),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: EdgeInsets.all(Dimens.spacingSmall),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10000.0),
                                child: CustomCachedNetworkImage(
                                  link: filteredEmployees[index].pictureLink,
                                  errorImageAssetsPath:
                                      "assets/user_placeholder.svg",
                                  isAnonymous: true,
                                ),
                              ),
                            ),
                            SizedBox(width: Dimens.spacing),
                            Expanded(
                              flex: 11,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          getString(context,
                                              "login_tablet_sign_name"),
                                          style: LelloTextStyles.bodyBold(theme)
                                              ?.copyWith(
                                            color: LelloTheme.palleteOf(theme)
                                                .hubText(),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          filteredEmployees[index]
                                              .nameFormatted,
                                          style: LelloTextStyles.body(theme)
                                              ?.copyWith(
                                            color: LelloTheme.palleteOf(theme)
                                                .hubText(),
                                          ),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: Dimens.spacing),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          getString(
                                              context, "login_tablet_sign_cpf"),
                                          style: LelloTextStyles.bodyBold(theme)
                                              ?.copyWith(
                                            color: LelloTheme.palleteOf(theme)
                                                .hubText(),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          filteredEmployees[index].cpfFormatted,
                                          style: LelloTextStyles.body(theme)
                                              ?.copyWith(
                                            color: LelloTheme.palleteOf(theme)
                                                .hubText(),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: LelloTheme.palleteOf(theme).hubText(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getString(context, "login_tablet_dont_find_name"),
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                  maxLines: 2,
                  textScaleFactor: 1.0,
                  overflow: TextOverflow.ellipsis,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, SharedApplicationRoute.registration,
                        arguments: ApplicationContainer.instance());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: Dimens.spacing),
                    child: Text(
                      ' ${getString(context, "login_tablet_register")}',
                      style: LelloTextStyles.bodyBold(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).accent(),
                      ),
                      maxLines: 2,
                      textScaleFactor: 1.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _filterEmployees({required String query}) {
    final results = widget.employees.where((employee) {
      return employee.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredEmployees = results;
    });
  }
}
