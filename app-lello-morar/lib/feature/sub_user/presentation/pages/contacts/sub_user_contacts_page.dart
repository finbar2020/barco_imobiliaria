import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_add_controller.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_bottom_button.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_contacts_card_widget.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

import '../../bloc/sub_user_add_bloc.dart';

class SubUserContactsPage extends StatefulWidget {
  const SubUserContactsPage({Key? key}) : super(key: key);

  @override
  _SubUserContactsPageState createState() => _SubUserContactsPageState();
}

class _SubUserContactsPageState extends State<SubUserContactsPage> {
  final controller =
      ApplicationContainer.instance().resolve<SubUserAddController>();
  late SessionBloc sessionBloc;

  @override
  void initState() {
    controller.getContacts();
    controller.getRoles(user: controller.mainUser);
    sessionBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  void dispose() {
    controller.contacts = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme,
      child: BlocBuilder(
        bloc: controller.bloc,
        builder: (context, state) {
          if (state is SubUserAddErrorState) {
            return Column(
              children: [
                SizedBox(
                  height: Dimens.spacing,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: getString(context, "find"),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimens.spacingLarge,
                ),
                Expanded(
                  child: Container(
                    color: LelloTheme.palleteOf(theme).text().withOpacity(0.04),
                    child: Center(
                      child: Text(getString(context, "resident_not_found"),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ],
            );
          }
          if (state is SubUserAddLoadingState) {
            return Column(
              children: [
                SizedBox(
                  height: Dimens.spacing,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: getString(context, "find"),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimens.spacingLarge,
                ),
                Expanded(
                  child: Container(
                    color: LelloTheme.palleteOf(theme).text().withOpacity(0.04),
                    child: Center(
                      child: LoadingWidget(),
                    ),
                  ),
                ),
              ],
            );
          }
          if (state is SubUserAddSuccessState) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: Dimens.spacingMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23.0),
                    child: Text(
                      getString(context, "resident_select_contact"),
                      style: LelloTextStyles.subtitleBold(theme),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.spacing,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23.0),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          controller.searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: getString(context, "find"),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      controller.searchText = "";
                                    });
                                  },
                                  child: Icon(Icons.cancel)),
                              SizedBox(width: 8),
                              Icon(Icons.search),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.spacingLarge,
                  ),
                  Expanded(
                    child: Container(
                      color:
                          LelloTheme.palleteOf(theme).text().withOpacity(0.04),
                      child: Container(
                        child: controller.filteredContacts.length > 0
                            ? ListView.builder(
                                itemCount: controller.filteredContacts.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () async {
                                      final filtered =
                                          controller.filteredContacts[index];
                                      await controller.getRoles(
                                        user: filtered,
                                      );
                                      controller.userSelected = filtered;
                                      controller.nameController.text =
                                          filtered.name ?? "";
                                      controller.emailController.text =
                                          filtered.email ?? "";
                                      controller.cpfCnpjController.text =
                                          filtered.cpf ?? "";
                                      controller.phoneController.text =
                                          filtered.phone ?? "";
                                      Navigator.pop(context);
                                    },
                                    child: SubUserContactsCardWidget(
                                      sessionBloc: controller.sessionBloc,
                                      model: controller.filteredContacts[index],
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                    getString(context, "resident_not_found"),
                                    textAlign: TextAlign.center),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
