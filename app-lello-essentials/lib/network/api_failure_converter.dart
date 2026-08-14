import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'api_failure.dart';

class ApiFailureConverter extends JsonConverter {
  @override
  FutureOr<Response> convertError<BodyType, InnerType>(Response response) {
    try {
      final failure = ApiFailure.fromJson(jsonDecode(response.body));
      return response.copyWith(bodyError: failure);
    } catch (_) {
      return response;
    }
  }
}
