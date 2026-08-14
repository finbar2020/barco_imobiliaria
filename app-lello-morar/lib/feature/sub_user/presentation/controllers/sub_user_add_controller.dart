import 'package:essentials/essentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/presentation/stores/sub_user_store.dart';

import '../../../session/domain/entity/session.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entity/sub_user_role.dart';
import '../bloc/sub_user_add_bloc.dart';

class SubUserAddController {
  final SubUserStore _store;

  SubUserAddController(this._store);

  List<SubUser> contacts = [];

  List<SubUserRole> roles = [];

  SubUser? userSelected;

  SubUser? creationUser;

  List<SubUser> subUsers = [];

  String searchText = "";

  String ddd = "";
  String phone = "";
  DateTime? selectedExpirationDate;

  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final cpfCnpjController = TextEditingController();
  final expirationDateController = TextEditingController();

  var billetByEmailCounter = 0;

  SubUserRole? itemSelecionado;

  void setItemSelecionado(SubUserRole? value) {
    itemSelecionado = value;
  }

  void changeExpirationDate(DateTime? date) {
    selectedExpirationDate = date;
    if (date != null) {
      expirationDateController.text = DateFormat('dd/MM/yyyy').format(date);
    } else {
      expirationDateController.clear();
    }
  }

  Future<void> getSubUsers() async {
    subUsers = await _store.getSubUsers();
    billetByEmailCounter =
        subUsers.where((element) => element.flagBoletoEmail == true).length;
  }

  Future<void> getContacts() async =>
      contacts = await _store.getContacts(contacts: contacts);

  List<SubUser> get filteredContacts {
    return contacts.where((element) {
      String contactName = element.name ?? "";
      return contactName
          .toLowerCase()
          .trim()
          .contains(searchText.toLowerCase().trim());
    }).toList();
  }

  Future<void> getRoles({SubUser? user}) async {
    roles = await _store.getRoles(subUser: user ?? userSelected ?? SubUser());
    roles.removeWhere((element) => element.role == 'morar.proprietario');
    if (user?.role == 'morar.morador' || user?.role == 'morar.inquilino') {
      roles.retainWhere((item) =>
          item.role == 'morar.morador' || item.role == 'morar.parcial');
    }
  }

  String? initialDDD({required String initialValue}) {
    var initial = initialValue.trim();
    initial = initial.replaceAll(" ", "").replaceAll("-", "");
    if (initial.isNotEmpty) {
      if (initial.startsWith("+55") && initial.length > 4)
        return initial.substring(3, 5);
      if (initial.startsWith("(") && initial.length > 4)
        return initial.substring(1, 3);
      if (initial.length == 11 || initial.length == 12) initial.substring(0, 2);
      if (initial.length > 9) return initial.substring(0, 2);
    }
    return null;
  }

  String? initialPhone({required String initialValue}) {
    var initial = initialValue.trim();
    initial = initial.replaceAll(" ", "").replaceAll("-", "");
    if (initial.isNotEmpty) {
      if (initial.startsWith("+55") && initial.length > 4)
        return initial.substring(5).trim();
      if (initial.startsWith("(")) {
        if (initial.length > 5) {
          return initial.substring(4).trim();
        }
      } else {
        if (initial.length == 11 || initial.length == 12)
          return initial.substring(2, initial.length);
        if (initial.length > 9)
          return initial.substring(2, initial.length);
        else
          return initial;
      }
    }
    return null;
  }

  String getPhone() {
    String val = "";
    if (ddd.isNotEmpty) {
      val = "($ddd)";
    }
    if (phone.isNotEmpty) {
      val += phone;
    }
    return val;
  }

  bool allRequiresFieldsFilled() {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        cpfCnpjController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        itemSelecionado != null &&
        (billetByEmailCounter < 3 ||
            (creationUser?.flagBoletoEmail ?? false) == false);
  }

  set mainUser(SubUser user) => _store.mainUser = user;

  SubUserAddBloc get bloc => _store.addBloc;

  bool get useFacialBiometric =>
      _store.sessionBloc.state.session!.condominium!.useFacialBiometric;

  String get biometricImageLink => session.me?.biometriaImageLink ?? "";

  Session get session => _store.sessionBloc.state.session!;

  SessionBloc get sessionBloc => _store.sessionBloc;

  SubUser get mainUser => _store.mainUser;
}
