/// Custom exception for Maintenance Management API errors
/// Separates error_code from error message for proper handling
class MaintenanceManagementApiException implements Exception {
  final String errorCode;
  final String message;

  MaintenanceManagementApiException(this.errorCode, this.message);

  @override
  String toString() => 'MaintenanceManagementApiException: $errorCode - $message';
}
