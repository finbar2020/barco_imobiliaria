import 'package:chopper/chopper.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_add_manual_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_occurrence_request_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';

part 'timesheet_api.chopper.dart';

@ChopperApi()
abstract class TimesheetApi extends ChopperService {
  ///Novo endpoint para busca do resumo do mês do ponto digital,
  /// irá retornar um [TimesheetMonthResumeModel] com os dados para serem apresentados em tela
  @GET(path: '/timesheet/month_resume')
  Future<Response> getMonthResume(
      @Query('dataReferencia') String dataReferencia);

  ///Novo endpoint para busca das marcações do dia,
  /// irá retornar uma lista de [DayAppointmentsModel] com os dados para serem apresentados em tela
  @GET(path: '/timesheet/appointments')
  Future<Response> getDayAppointments(
      @Query('dataReferencia') String dataReferencia);

  ///Novo endpoint para busca da listagem de detalhes de ocorrencias (Atrasos, Faltas e Horas Extras),
  /// irá retornar uma lista de [TimesheetOccurrenceModel] com os dados para serem apresentados em tela
  @GET(path: '/timesheet/occurrence')
  Future<Response> getOccurrenceDetail(
    @Query('dataReferencia') String dataReferencia,
    @Query('tipo') String tipo,
  );

  /// Novo endpoint para busca da listagem de detalhes de ocorrencias agrupadas,
  /// irá retornar uma lista de [TimesheetOccurrenceModel] com os dados para serem apresentados em tela
  @GET(path: '/timesheet/occurrence/grouped')
  Future<Response> getGroupedOccurrence(
    @Query('dataReferencia') String dataReferencia,
    @Query('tipo') String tipo,
  );

  ///Novo endpoint para enviar ações de (Atrasos e Fatas)
  @POST(path: '/timesheet/occurrence/action')
  Future<Response> postAction(
    @Body() List<TimesheetOccurrenceRequestModel> models,
  );

  ///Novo endpoint para busca da listagem de detalhes de ocorrencias (Férias),
  /// irá retornar uma lista de [TimesheetOccurrenceVacationModel] com os dados para serem apresentados em tela
  @GET(path: '/timesheet/occurrence/vacation')
  Future<Response> getOccurrenceVacation(
    @Query('dataReferencia') String dataReferencia,
  );

  ///Novo endpoint para busca do recibo de férias,
  /// irá retornar um pdf
  @GET(path: '/timesheet/occurrence/vacation/receipt')
  Future<Response> getVacationReceipt(
    @Query('archiveName') String archiveName,
  );

  ///Novo endpoint para busca da listagem de Atestados,
  /// irá retornar uma lista de [TimesheetOccurrenceCertificateModel] com os dados para serem apresentados em tela
  @GET(path: '/timesheet/occurrence/certificate')
  Future<Response> getOccurrenceCertificate(
    @Query('dataReferencia') String dataReferencia,
  );

  ///Novo endpoint para enviar ações
  @POST(path: '/timesheet/appointments/add_manual')
  Future<Response> postAddManualAppointment(
    @Body() List<TimesheetAddManualModel> models,
  );

  @GET(path: '/timesheet/appointments/manual')
  Future<Response> getManualAppointments(
    @Query('numCra') String numCra,
    @Query('date') DateTime dataReferencia,
  );

  @GET(path: '/timesheet/occurrence/timesheet')
  Future<Response> getTimesheet(
    @Query('dataReferencia') String dataReferencia,
  );

  @GET(path: '/condominiums/{condo_id}/employees/working')
  Future<Response> getListEmployees(
    @Path('condo_id') String id,
  );

  @GET(path: '/timesheet/ByDateAndNumcra')
  Future<Response> getTimesheetEmployeeDetail(
    @Query('numCra') String numCra,
    @Query('date') DateTime dataReferencia,
  );

  @PUT(path: '/timesheet/signatureOrNotify')
  Future<Response> putSignatureOrNotify(
    @Body() TimesheetSignatureRequestModel signature,
  );

  @GET(path: '/timesheet/pointMirror')
  Future<Response> getPointMirrorList(
    @Query('dataReferencia') DateTime dataReferencia,
  );

  @GET(path: '/timesheet/checkInData')
  Future<Response> getCheckInData(
    @Query('numCra') String numCra,
    @Query('date') DateTime dataReferencia,
  );

  @GET(path: "timesheet/references/{id}/periods")
  Future<Response> getTimesheetPeriods(
    @Path("id") String id,
  );

  static TimesheetApi create(ChopperClient client) {
    return _$TimesheetApi(client);
  }
}
