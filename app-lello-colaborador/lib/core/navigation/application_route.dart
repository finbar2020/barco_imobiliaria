class ApplicationRoute {
  //static final home = "/home";
  static const me = "/me";
  static const meSuccess = "/me_success";

  //face
  static const faceDetectionView = "/face-detection";
  static const faceRegisterSuccess = "/send_file_success";
  static const faceRegisterError = "/send_file_error";
  static const faceRequestSuccess = "/request_file_success";
  static const faceRequestError = "/request_file_error";
  static const faceLocationTimeoutError = "/location_timeout_error";

  //sick note
  static const sickNote = "/sick-note";
  static const sickNoteRegisterSuccess = "/send_sick_note_success";
  static const sickNoteRegisterError = "/send_sick_note_error";

  //timesheet
  static const timesheet = "/timesheet";
  static const timesheetDetail = "/timesheet_detail";
  static const timesheetInfo = "/timesheet_info";

  //manual timesheet
  static const manualTimesheet = "/manual_timesheet";
  static const manualTimesheetRegisterSuccess =
      "/send_manual_timesheet_success";
  static const manualTimesheetRegisterError = "/send_manual_timesheet_error";

  //proof
  static const proof = "/proof";

  //documents
  static const incomeReportList = "/report_incomes_list";
  static const payStubList = "/pay_stub_list";
  static const benefitsList = "/benefits_list";
  static const vacationList = "/vacation_list";
  static const documentFilePage = "/document_file_page";

  //employee Referral
  static const employeeReferral = "/employee_referral";
  static const employeeReferralRegisterSuccess = "/employee_referral_success";
  static const employeeReferralRegisterError = "/employee_referral_error";

  static const permissionNotification = '/permission_notification';

  static const preferencesNotification = '/preferences_notification';

  static const preferencesHome = '/preferences_home';
  static const comfortEmbedded = '/comfort_embedded';
}
