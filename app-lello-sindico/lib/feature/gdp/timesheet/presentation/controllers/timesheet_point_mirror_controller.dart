import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_action_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_point_mirror/get_point_mirror.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/put_signature_notify/post_signature_notify.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_point_mirror/timesheet_point_mirror_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_point_mirror/timesheet_point_mirror_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class TimesheetPointMirrorController {
  final SessionBloc sessionBloc;
  final GetPointMirror getPointMirror;
  final PutSignatureNotify putSignatureOrNotify;
  final TimesheetPointMirrorBloc bloc;

  TimesheetPointMirrorController({
    required this.sessionBloc,
    required this.getPointMirror,
    required this.putSignatureOrNotify,
    required this.bloc,
  });

  List<TimesheetEntity> points = [];
  List<bool> employesSelecteds = [];
  List<String> individualAction = [];
  DateTime selectDate = DateTime.now();
  String? selectedValue;

  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  Future<void> getPointMirrorList(DateTime date) async {
    bloc.add(TimesheetPointMirrorLoadingEvent());

    selectDate = date;

    final result = await getPointMirror.call(GetPointMirrorParam(date: date));

    result.fold(
      (err) => bloc.add(TimesheetPointMirrorFailedEvent()),
      (data) {
        points = data;
        generateListCheckbox(points);
        bloc.add(TimesheetPointMirrorLoadedEvent(
          list: points,
        ));
      },
    );
  }

  Future saveActions() async {
    bloc.add(TimesheetPointMirrorLoadingEvent());
    List<TimesheetSignatureModel> models = generateListForSave();

    final result = await putSignatureOrNotify.call(PutSignatureNotifyParam(
        model: TimesheetSignatureRequestModel(signaturesRequest: models)));
    result.fold(
      (err) => bloc.add(TimesheetPointMirrorLoadedEvent(
        list: points,
        saveFailed: true,
      )),
      (data) {
        getPointMirror
            .call(GetPointMirrorParam(date: selectDate))
            .then((value) => {
                  value.fold(
                    (err) => bloc.add(TimesheetPointMirrorFailedEvent()),
                    (data) {
                      points = data;
                      generateListCheckbox(points);
                      bloc.add(TimesheetPointMirrorLoadedEvent(
                        list: points,
                        saveSuccess: true,
                      ));
                    },
                  )
                });
      },
    );
  }

  generateListCheckbox(List list) {
    employesSelecteds = List.generate(list.length, (index) => false);
    individualAction = List.generate(list.length, (index) => '');
  }

  List<TimesheetSignatureModel> generateListForSave() {
    List<TimesheetSignatureModel> selecteds = [];
    if (selectedValue != null) {
      List<int> listCollaborators = [];
      List.generate(employesSelecteds.length, (index) {
        if (employesSelecteds[index]) {
          listCollaborators
              .add(employesSelecteds.indexOf(employesSelecteds[index]));
        }
        if (selectedValue!.contains("Notificar")) {
          List.generate(listCollaborators.length, (index) {
            selecteds.add(TimesheetSignatureModel(
              notify: true,
              numCra: points[listCollaborators[index]].numCra,
            ));
          });
        } else {
          List.generate(listCollaborators.length, (index) {
            selecteds.add(TimesheetSignatureModel(
              id: points[listCollaborators[index]].signatureId,
              approvedFlag: true,
            ));
          });
        }
      });
    } else {
      for (int i = 0; i < individualAction.length; i++) {
        var employee = points[i];
        var action = individualAction[i];
        if (action.contains("Notificar")) {
          selecteds.add(TimesheetSignatureModel(
            notify: true,
            numCra: employee.numCra,
          ));
        } else if (action.contains("Assinar")) {
          selecteds.add(TimesheetSignatureModel(
            id: employee.signatureId,
            approvedFlag: true,
          ));
        }
      }
    }
    return selecteds;
  }

  bool isNotify(TimesheetActionEnum action) {
    return action == TimesheetActionEnum.notify;
  }

  bool showNotifyDropdown() {
    int count = points.length;
    int notify = points
        .where((element) => element.action == TimesheetActionEnum.notify)
        .toList()
        .length;
    return count == notify;
  }

  bool showSignatureDropdown() {
    int count = points.length;
    int signature = points
        .where((element) => element.action == TimesheetActionEnum.sign)
        .toList()
        .length;
    return count == signature;
  }

  bool get showMassActionOption =>
      showNotifyDropdown() || showSignatureDropdown();

  void dispose() {
    points = [];
    employesSelecteds = [];
    individualAction = [];
  }
}
