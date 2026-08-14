import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/bloc/residents_event.dart';

import '../../session/presentation/bloc/session_bloc.dart';
import '../bloc/residents_bloc.dart';
import '../bloc/residents_state.dart';
import '../domain/entity/resident.dart';
import '../domain/use_case/list_residents.dart';

class ResidentsController {
  final ResidentsBloc residentsBloc;
  final SessionBloc sessionBloc;
  final ListResidents useCaseListResidents;
  List<Resident> residents = [];
  List<String> blocks = [];
  String query = "";
  bool loadedCache = false;
  bool loadAll = false;
  String? pendingSearch;
  bool donePaging = false;

  ResidentsController(
      {required this.residentsBloc,
      required this.sessionBloc,
      required this.useCaseListResidents});

  Future<void> getResidents({required bool hasLoadAll}) async {
    if (hasLoadAll) {
      loadAll = true;
    } else {
      loadAll = false;
    }
    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";
    if (!loadedCache) {
      final cache = await useCaseListResidents.call(ListResidentsParam(
          condominiumId: condominiumId,
          lastResidentId: null,
          query: query,
          origin: DataOrigin.local,
          loadAll: loadAll));
      if (cache is Success<List<Resident>>) {
        residents = cache.getOrElse(() => []);
      }
      loadedCache = true;
    }

    residentsBloc.add(ResidentsLoadingEvent());

    final result = await useCaseListResidents.call(ListResidentsParam(
        condominiumId: condominiumId,
        lastResidentId: null,
        query: query,
        origin: DataOrigin.remote,
        loadAll: loadAll));

    result.fold(
        (err) => residentsBloc.add(ResidentsLoadFailedEvent(failure: err)),
        (data) {
      residents = data;
      donePaging = data.isEmpty;
      blocks = goupBlocks(data);
      residentsBloc.add(
        ResidentsLoadedEvent(
            data: data,
            query: query,
            blocks: goupBlocks(data),
            donePaging: data.isEmpty),
      );
    });

    _handlePendingSearch(query);
  }

  Future<void> searchResident() async {
    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    residentsBloc.add(ResidentsSearchingEvent());

    final result = await useCaseListResidents.call(ListResidentsParam(
        condominiumId: condominiumId,
        lastResidentId: null,
        query: query,
        origin: DataOrigin.remote,
        loadAll: loadAll));

    result.fold(
        (err) => residentsBloc.add(ResidentsLoadFailedEvent(failure: err)),
        (data) {
      residents.clear();
      residents = data;
      residentsBloc.add(
        ResidentsLoadedEvent(
            data: data,
            query: query,
            blocks: goupBlocks(data),
            donePaging: data.isEmpty),
      );
    });

    _handlePendingSearch(query);
  }

  Future<void> nextPage() async {
    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";
    final lastResidentId = residents.isNotEmpty ? residents.last.id : "";

    residentsBloc.add(ResidentsPagingEvent());

    final result = await useCaseListResidents.call(ListResidentsParam(
        condominiumId: condominiumId,
        lastResidentId: lastResidentId,
        query: query,
        origin: DataOrigin.remote,
        loadAll: loadAll));

    result.fold(
        (err) => residentsBloc.add(ResidentsPageFailedEvent(failure: err)),
        (res) {
      Set<String> uniqueResidentInfo = Set<String>();
      for (var resident in residents) {
        uniqueResidentInfo.add('${resident.name}');
      }
      for (var resident in res) {
        String residentInfo = '${resident.name}';
        if (!uniqueResidentInfo.contains(residentInfo)) {
          residents.add(resident);
          uniqueResidentInfo.add(residentInfo);
        }
      }
      residentsBloc.add(
        ResidentsLoadedEvent(
          data: residents,
          query: query,
          blocks: goupBlocks(residents),
          donePaging: residents.isEmpty,
        ),
      );
    });

    _handlePendingSearch(query);
  }

  List<String> goupBlocks(List<Resident> data) {
    return data
        .map((resident) => resident.unit!.group!)
        .toList()
        .toSet()
        .toList();
  }

  void _handlePendingSearch(String query) {
    if (pendingSearch != null) {
      beginSearch(force: true);
      if (pendingSearch == query) pendingSearch = null;
    }
  }

  void beginSearch({bool force = false}) {
    if (!force &&
        (residentsBloc.state is ResidentsSearchingState ||
            residentsBloc.state is ResidentsLoadingState ||
            residentsBloc.state is ResidentsPagingState)) {
      pendingSearch = query;
    } else {
      searchResident();
    }
  }

  void beginRefresh() {
    if (residentsBloc.state is! ResidentsLoadingState &&
        residentsBloc.state is! ResidentsSearchingState &&
        residentsBloc.state is! ResidentsPagingState) {
      getResidents(hasLoadAll: loadAll);
    }
  }

  void beginLoadNextPage() {
    final current = residentsBloc.state;
    if (current is! ResidentsSearchingState &&
        current is! ResidentsLoadingState &&
        current is! ResidentsPagingState) {
      if (current is ResidentsLoadedState && current.donePaging!) return;
      nextPage();
    }
  }

  void dispose() {
    residents.clear();
    blocks.clear();
    query = '';
  }
}
