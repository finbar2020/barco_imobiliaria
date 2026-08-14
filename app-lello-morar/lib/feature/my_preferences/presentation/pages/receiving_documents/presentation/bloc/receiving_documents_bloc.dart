import 'dart:convert';

import 'package:essentials/essentials.dart';
import 'package:flutter/services.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/get_street_types/get_street_types_use_case.dart';
import 'package:morar/feature/my_preferences/presentation/pages/receiving_documents/presentation/bloc/receiving_documents_event.dart';
import 'package:morar/feature/my_preferences/presentation/pages/receiving_documents/presentation/bloc/receiving_documents_state.dart';

import '../../../../../../easy_fix/domain/entity/city_entity.dart';
import '../../../../../../easy_fix/domain/use_case/get_cities_usecase.dart';
import '../../../../../../session/domain/entity/session.dart';
import '../../../../../../session/presentation/bloc/session_bloc.dart';
import '../../../../../domain/entities/access_data_entity.dart';
import '../../../../../domain/entities/personal_data_entity.dart';
import '../../../../../domain/entities/street_type_entity.dart';
import '../../../../../domain/entities/unit_addess_data_entity.dart';
import '../../../../../domain/entities/unit_paperless_data_entity.dart';
import '../../../../../domain/use_cases/get_unit_personal_data/get_unit_personal_data_use_case.dart';
import '../../../../../domain/use_cases/update_unit_personal_data/update_unit_personal_data_use_case.dart';
import '../../../../../model/zero_paper_preference_item_model.dart';

class ReceivingDocumentsBloc
    extends Bloc<ReceivingDocumentsEvent, ReceivingDocumentsState> {
  ReceivingDocumentsBloc(
    this.sessionBloc,
    this._getUnitPersonalDataUseCase,
    this._updateUnitPersonalDataUseCase,
    this.getCitiesUseCase,
    this._getStreetTypesUseCase,
  ) : super(const ReceivingDocumentsLoadingState()) {
    on<ReceivingDocumentsFailureEvent>(_handleFailureEvent);
    on<ReceivingDocumentsLoadingEvent>((event, emit) {
      emit(const ReceivingDocumentsLoadingState());
    });
    on<ReceivingDocumentsLoadedEvent>((event, emit) {
      emit(
        ReceivingDocumentsLoadedState(
          preferences: event.preferences,
          hasChanges: event.hasChanges,
          hasSavedChanges: event.hasSavedChanges,
          accessData: event.accessData,
        ),
      );
    });
  }

  final SessionBloc sessionBloc;
  final GetUnitPersonalDataUseCase _getUnitPersonalDataUseCase;
  final UpdateUnitPersonalDataUseCase _updateUnitPersonalDataUseCase;
  final GetStreetTypesUseCase _getStreetTypesUseCase;
  final GetCitiesUsecase getCitiesUseCase;
  List<String> states = [];
  List<City> cities = [];
  List<StreetTypeEntity> streetTypes = [];
  City? addressCity;
  bool propagateOtherUnits = false;
  StreetTypeEntity? streetType;

  List<ZeroPaperItemModel> initialPreferences = [];

  AccessData? data;
  late final String personalEmail;

  Future init() async {
    states = await getStates();
    personalEmail = sessionBloc.state.session?.me?.email ?? '';
    getStreetTypes();
    getUnitData();
  }

  Future getStreetTypes() async {
    final result = await _getStreetTypesUseCase(dynamic);
    result.fold(
      (error) {},
      (data) {
        streetTypes = data;
      },
    );
  }

  void setStreetType(StreetTypeEntity? streetType) {
    this.streetType = streetType;
  }

  Future<void> getUnitData() async {
    add(const ReceivingDocumentsLoadingEvent());
    final unitId = sessionBloc.state.session?.unity?.notificationContext;
    if (unitId != null) {
      final result = await _getUnitPersonalDataUseCase(int.tryParse(unitId)!);
      result.fold(
        (error) {
          add(
            ReceivingDocumentsFailureEvent(
              error: error.toString(),
            ),
          );
        },
        (data) async {
          this.data = data;
          final condoAddress = await getAddressByCep(
            cep: data.condoAddressData?.zipCode ?? '',
          );

          condoAddress.fold(
            (error) {},
            (info) {
              this.data = data.copyWith(
                condoAddressData: data.condoAddressData?.copyWith(
                  cityName: (info.localidade ?? ''),
                  complement: data.condoAddressData?.complement == 'null'
                      ? ''
                      : data.condoAddressData?.complement,
                ),
              );
              streetType = streetTypes.firstWhereOrNull(
                (element) => element.name == data.unitAddressData.streetType,
              );
            },
          );
          final preferences = getPreference(data.unitPaperlessData);
          initialPreferences = List.from(preferences);
          propagateOtherUnits = data.propagateOtherUnits ?? false;
          add(
            ReceivingDocumentsLoadedEvent(
              preferences: preferences,
              hasChanges: false,
              hasSavedChanges: false,
              accessData: this.data ?? data,
            ),
          );
        },
      );
    }
  }

  List<ZeroPaperItemModel> getPreference(UnitPaperlessDataEntity data) {
    ZeroPaperItemModel createItem(
        bool printed, bool email, ZeroPaperPreferenceTypeEnum type) {
      ZeroPaperPreferenceChoiceEnum choice;
      if (printed && email) {
        choice = ZeroPaperPreferenceChoiceEnum.both;
      } else if (email) {
        choice = ZeroPaperPreferenceChoiceEnum.email;
      } else {
        choice = ZeroPaperPreferenceChoiceEnum.printed;
      }
      return ZeroPaperItemModel(
        choice: choice,
        type: type,
      );
    }

    return [
      createItem(data.printedSlips, data.emailSlips,
          ZeroPaperPreferenceTypeEnum.bankSlip),
      createItem(data.printedStatements, data.emailStatements,
          ZeroPaperPreferenceTypeEnum.statements),
      createItem(data.printedMinutes, data.emailMinutes,
          ZeroPaperPreferenceTypeEnum.minutesAndNotices),
      createItem(data.printedAnnouncements, data.emailAnnouncements,
          ZeroPaperPreferenceTypeEnum.announcements),
    ];
  }

  UnitPaperlessDataEntity preferencesToUnitPaperless(
      List<ZeroPaperItemModel> preferences) {
    bool checkPrintedItem(ZeroPaperPreferenceChoiceEnum choice) {
      return choice == ZeroPaperPreferenceChoiceEnum.printed ||
          choice == ZeroPaperPreferenceChoiceEnum.both;
    }

    bool checkDigitalItem(ZeroPaperPreferenceChoiceEnum choice) {
      return choice == ZeroPaperPreferenceChoiceEnum.email ||
          choice == ZeroPaperPreferenceChoiceEnum.both;
    }

    return UnitPaperlessDataEntity(
      printedSlips: checkPrintedItem(preferences
          .firstWhere(
              (item) => item.type == ZeroPaperPreferenceTypeEnum.bankSlip)
          .choice),
      emailSlips: checkDigitalItem(preferences
          .firstWhere(
              (item) => item.type == ZeroPaperPreferenceTypeEnum.bankSlip)
          .choice),
      printedStatements: checkPrintedItem(preferences
          .firstWhere(
              (item) => item.type == ZeroPaperPreferenceTypeEnum.statements)
          .choice),
      emailStatements: checkDigitalItem(preferences
          .firstWhere(
              (item) => item.type == ZeroPaperPreferenceTypeEnum.statements)
          .choice),
      printedMinutes: checkPrintedItem(preferences
          .firstWhere((item) =>
              item.type == ZeroPaperPreferenceTypeEnum.minutesAndNotices)
          .choice),
      emailMinutes: checkDigitalItem(preferences
          .firstWhere((item) =>
              item.type == ZeroPaperPreferenceTypeEnum.minutesAndNotices)
          .choice),
      printedAnnouncements: checkPrintedItem(preferences
          .firstWhere(
              (item) => item.type == ZeroPaperPreferenceTypeEnum.announcements)
          .choice),
      emailAnnouncements: checkDigitalItem(preferences
          .firstWhere(
              (item) => item.type == ZeroPaperPreferenceTypeEnum.announcements)
          .choice),
    );
  }

  void _handleFailureEvent(ReceivingDocumentsFailureEvent event,
      Emitter<ReceivingDocumentsState> emit) {
    emit(
      ReceivingDocumentsFailureState(error: event.error),
    );
  }

  void updatePreferences(ZeroPaperItemModel item) {
    if (state is ReceivingDocumentsLoadedState) {
      final preferences = (state as ReceivingDocumentsLoadedState).preferences;
      final index =
          preferences.indexWhere((element) => element.type == item.type);
      final currentItem = preferences[index];

      if (currentItem.choice == item.choice) {
        return;
      }

      ZeroPaperPreferenceChoiceEnum newChoice;
      if (currentItem.choice == ZeroPaperPreferenceChoiceEnum.both) {
        newChoice = item.choice == ZeroPaperPreferenceChoiceEnum.email
            ? ZeroPaperPreferenceChoiceEnum.printed
            : ZeroPaperPreferenceChoiceEnum.email;
      } else if (currentItem.choice == ZeroPaperPreferenceChoiceEnum.email) {
        newChoice = item.choice == ZeroPaperPreferenceChoiceEnum.printed
            ? ZeroPaperPreferenceChoiceEnum.both
            : ZeroPaperPreferenceChoiceEnum.printed;
      } else if (currentItem.choice == ZeroPaperPreferenceChoiceEnum.printed) {
        newChoice = item.choice == ZeroPaperPreferenceChoiceEnum.email
            ? ZeroPaperPreferenceChoiceEnum.both
            : ZeroPaperPreferenceChoiceEnum.email;
      } else {
        newChoice = item.choice;
      }

      // Ensure at least one option is selected
      if (newChoice == ZeroPaperPreferenceChoiceEnum.email &&
              currentItem.choice == ZeroPaperPreferenceChoiceEnum.printed ||
          newChoice == ZeroPaperPreferenceChoiceEnum.printed &&
              currentItem.choice == ZeroPaperPreferenceChoiceEnum.email) {
        newChoice = ZeroPaperPreferenceChoiceEnum.both;
      }

      preferences[index] = item.copyWith(choice: newChoice);

      final hasChanges =
          !ListEquality().equals(preferences, initialPreferences);

      final hasSavedChanges = false;

      add(
        ReceivingDocumentsLoadedEvent(
          preferences: preferences,
          hasChanges: hasChanges,
          hasSavedChanges: hasSavedChanges,
          accessData: (state as ReceivingDocumentsLoadedState).accessData,
        ),
      );
    }
  }

  Future<bool> saveChanges({String? email, AddressDataEntity? address}) async {
    if (state is ReceivingDocumentsLoadedState) {
      final preferences = (state as ReceivingDocumentsLoadedState).preferences;
      final hasChanges = (state as ReceivingDocumentsLoadedState).hasChanges;
      final accessData = (state as ReceivingDocumentsLoadedState).accessData;

      if (hasChanges ||
          (email != null && email.isNotEmpty) ||
          address != null) {
        add(const ReceivingDocumentsLoadingEvent());
        final data = accessData.copyWith(
          personalData: PersonalDataEntity(
            cpf: sessionBloc.state.session?.me?.cpf ?? '',
          ),
          unitContactData: accessData.unitContactData.copyWith(
            correspondenceEmail: email,
          ),
          unitPaperlessData: preferencesToUnitPaperless(preferences),
          unitAddressData: (address ?? accessData.unitAddressData).copyWith(
            streetType: streetType?.name ?? '',
          ),
          propagateOtherUnits: propagateOtherUnits,
        );
        final result = await _updateUnitPersonalDataUseCase(data);
        return result.fold(
          (error) {
            add(
              ReceivingDocumentsFailureEvent(
                error: error.toString(),
              ),
            );
            return false;
          },
          (data) {
            this.data = data;
            final preferences = getPreference(data.unitPaperlessData);
            initialPreferences = List.from(preferences);
            add(
              ReceivingDocumentsLoadedEvent(
                preferences: preferences,
                hasChanges: false,
                hasSavedChanges: false,
                accessData: data,
              ),
            );
            return true;
          },
        );
      }
    }
    return false;
  }

  Future<List<City>> getCities({
    required String uf,
  }) async {
    final result = await getCitiesUseCase(
      GetCitiesParams(condominiumId: session.condominium?.id ?? '', uf: uf),
    );
    return result.fold(
      (failure) {
        this.addressCity = null;
        this.cities = [];
        return [];
      },
      (cities) {
        this.cities = cities;
        this.addressCity = null;
        return cities;
      },
    );
  }

  Future<List<String>> getStates() async {
    final String response =
        await rootBundle.loadString('assets/brazil_states.json');
    final data = await json.decode(response);
    return List.from(data.map((e) => e['sigla']));
  }

  Session get session => sessionBloc.state.session!;

  Future<Either<SearchCepError, ViaCepInfo>> getAddressByCep(
      {required String cep}) async {
    final viaCepSearchCep = ViaCepSearchCep();
    final infoCepJSON = await viaCepSearchCep.searchInfoByCep(
      cep: cep.replaceAll(RegExp('[^0-9]'), ''),
    );
    return infoCepJSON;
  }

  void changePropagateOtherUnits(bool value) {
    if (state is ReceivingDocumentsLoadedState) {
      propagateOtherUnits = value;
      add(
        ReceivingDocumentsLoadedEvent(
          preferences: (state as ReceivingDocumentsLoadedState).preferences,
          hasChanges:
              propagateOtherUnits != (this.data?.propagateOtherUnits ?? false),
          hasSavedChanges: false,
          accessData:
              (state as ReceivingDocumentsLoadedState).accessData.copyWith(
                    propagateOtherUnits: value,
                  ),
        ),
      );
    }
  }
}
