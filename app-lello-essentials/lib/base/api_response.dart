class ApiResponse {
  bool success;
  String? message;
  dynamic data;
  String? errorCode;

  ApiResponse({
    this.success = false,
    this.message,
    this.data,
    this.errorCode,
  });
}
