import 'package:flutter/material.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/domain/use_case/find_spupplier/find_spupplier.dart';
import 'package:lello/feature/payment/domain/use_case/get_spupplier/get_spupplier.dart';
import 'package:lello/feature/payment/presentation/widget/payment_search_supplier/bloc/payment_search_supplier_bloc.dart';
import 'package:lello/feature/payment/presentation/widget/payment_search_supplier/bloc/payment_search_supplier_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class PaymentSearchSupplierController {
  PageController pageController = PageController(initialPage: 0);

  final PaymentSearchSupplierListBloc bloc;
  final SessionBloc _sessionBloc;
  final FindSupplier _findSupplier;
  final GetSupplier _getSupplier;

  PaymentSearchSupplierController(
      this.bloc, this._sessionBloc, this._findSupplier, this._getSupplier);

  List<SupplierDataEntity> suppliers = [];

  String? documentFilter;
  bool get docEmpty =>
      (documentFilter == null || documentFilter?.isEmpty == true);
  String? nameFilter;
  bool get nameEmpty => (nameFilter == null || nameFilter?.isEmpty == true);

  SupplierDataEntity? selectedSupplier;

  Future<List<SupplierDataEntity>> fetchValues() async {
    if (docEmpty && nameEmpty) {
      return [];
    }

    final result = await _findSupplier(FindSupplierParam(
        condominiumId: condominiumId,
        name: nameFilter?.isNotEmpty == true ? nameFilter : null,
        document: documentFilter?.isNotEmpty == true ? documentFilter : null));
    return result.fold(
      (err) => suppliers,
      (items) {
        suppliers = items;
        return items;
      },
    );
  }

  Future<SupplierDataEntity?> getSupplier(int? id) async {
    if (id == null) {
      return null;
    }

    bloc.add(PaymentSearchSupplierLoadingEvent());

    final result = await _getSupplier(
        GetSupplierParam(condominiumId: condominiumId, id: id.toString()));
    return result.fold((err) {
      bloc.add(PaymentSearchSupplierFailureEvent(error: err));
      return null;
    }, (supplier) {
      bloc.add(PaymentSearchSupplierSuccessEvent(supplier: supplier));
      return supplier;
    });
  }

  String get condominiumId =>
      _sessionBloc.state.session!.selectedCondominium!.id;
}
