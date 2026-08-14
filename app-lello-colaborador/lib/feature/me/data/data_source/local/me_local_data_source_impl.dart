import 'package:colaborador/core/database/lello_database/condominium/condominium_dao.dart';
import 'package:colaborador/core/database/lello_database/condominium_employee_schedule/condominium_employee_schedule_dao.dart';
import 'package:colaborador/core/database/lello_database/lello_database.dart';
import 'package:colaborador/core/database/lello_database/me/me_dao.dart';
import 'package:colaborador/feature/me/data/data_source/local/me_local_data_source.dart';
import 'package:colaborador/feature/me/data/model/condominium_model.dart';
import 'package:colaborador/feature/me/data/model/geographic_coordinates_model.dart';
import 'package:colaborador/feature/me/data/model/me_model.dart';
import 'package:colaborador/feature/me/data/model/work_shift_details_model.dart';
import 'package:drift/drift.dart';

class MeLocalDataSourceImpl extends MeLocalDataSource {
  final MeDao meDao;
  final CondominiumDao condominiumDao;
  final CondominiumEmployeeScheduleDao condominiumEmployeeScheduleDao;

  MeLocalDataSourceImpl({
    required this.meDao,
    required this.condominiumDao,
    required this.condominiumEmployeeScheduleDao,
  });

  @override
  Future<MeModel?> save(MeModel? model) async {
    await meDao.clear();
    await condominiumDao.clear();
    if (model == null) {
      return model;
    }

    final meTableCompanion = MeTableCompanion(
      id: Value(model.id),
      name: Value(model.name),
      email: Value(model.email),
      cpf: Value(model.cpf),
      phone: Value(model.phone),
      picture: Value(model.picture),
      pictureHash: Value(model.pictureHash),
      updated: Value(DateTime.now()),
    );

    await meDao.insert(meTableCompanion);

    List<CondominiumTableCompanion?> condominiumTableCompanionList =
        model.condominiums.map((e) {
      return CondominiumTableCompanion(
        id: Value(e.id),
        meId: Value(model.id),
        reference: Value(e.reference),
        name: Value(e.name),
        jobPosition: Value(e.jobPosition),
        workShift: Value(e.workShift),
        digitalTimesheetStatus: Value(e.digitalTimesheetStatus),
        usesDigitalTimesheet: Value(e.usesDigitalTimesheet),
        shouldIgnoreDigitalPoint: Value(e.shouldIgnoreDigitalPoint),
        workLeaveDescription: Value(e.workLeaveDescription),
        latitude: Value(e.geographicCoordinates?.latitude),
        longitude: Value(e.geographicCoordinates?.longitude),
      );
    }).toList();

    await Future.forEach(
        condominiumTableCompanionList.cast<CondominiumTableCompanion>(),
        (CondominiumTableCompanion element) async =>
            await condominiumDao.insert(element));

    var listEmployeeSchedule = model.condominiums
        .map((e) => e.workShiftDetails)
        .expand((i) => i)
        .toList();

    List<CondominiumEmployeeScheduleTableCompanion?>
        listEmployeeScheduleTableCompanionList = listEmployeeSchedule.map((e) {
      return CondominiumEmployeeScheduleTableCompanion(
          reference: Value(e.reference),
          date: Value(e.date),
          badageNumber: Value(e.badageNumber),
          entry1: Value(e.entry1),
          out1: Value(e.out1),
          entry2: Value(e.entry2),
          out2: Value(e.out2),
          isDayOff: Value(e.isDayOff));
    }).toList();

    await condominiumEmployeeScheduleDao.insert(
        listEmployeeScheduleTableCompanionList
            .cast<CondominiumEmployeeScheduleTableCompanion>());

    return model;
  }

  @override
  Future<MeModel?> select() async {
    final meData = await meDao.get();
    if (meData == null) {
      return null;
    }
    final condos = await condominiumDao.list(meData.id);

    final MeModel result = MeModel()
      ..id = meData.id
      ..name = meData.name ?? ""
      ..email = meData.email ?? ""
      ..cpf = meData.cpf!
      ..phone = meData.phone ?? ""
      ..picture = meData.picture
      ..pictureHash = meData.pictureHash
      ..condominiums = (await Future.wait(condos.map(
        (e) async => CondominiumModel(
            id: e.id,
            name: e.name ?? "",
            reference: e.reference,
            jobPosition: e.jobPosition ?? "",
            workShift: e.workShift ?? "",
            shouldIgnoreDigitalPoint: e.shouldIgnoreDigitalPoint ?? false,
            workLeaveDescription: e.workLeaveDescription ?? "",
            digitalTimesheetStatus: e.digitalTimesheetStatus,
            usesDigitalTimesheet: e.usesDigitalTimesheet ?? false,
            geographicCoordinates: GeographicCoordinatesModel(
              latitude: e.latitude ?? "",
              longitude: e.longitude ?? "",
            ),
            workShiftDetails:
                (await condominiumEmployeeScheduleDao.list(e.reference))
                    .map((e) => WorkShiftDetailsModel(
                          reference: e.reference,
                          date: e.date,
                          badageNumber: e.badageNumber,
                          entry1: e.entry1,
                          out1: e.out1,
                          entry2: e.entry2,
                          out2: e.out2,
                          isDayOff: e.isDayOff,
                        ))
                    .toList()),
      )))
          .toList();

    return result;
  }
}
