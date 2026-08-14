// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_access_management_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$StaffAccessManagementApi extends StaffAccessManagementApi {
  _$StaffAccessManagementApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = StaffAccessManagementApi;

  @override
  Future<Response<dynamic>> getBuildingManagerUsers(
    String? condominiumId,
    String? condoUserManageType,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/staff-access');
    final Map<String, dynamic> $params = <String, dynamic>{
      'condo_user_manage_type': condoUserManageType
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deactivateUser(
    String condominiumId,
    UpdateNonManagerUserModel model,
  ) {
    final Uri $url = Uri.parse('/condominiums/${condominiumId}/staff-access');
    final $body = model;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postUser(
    BuildingManagerUserModel model,
    String condominiumId,
  ) {
    final Uri $url = Uri.parse(
        '/condominiums/${condominiumId}/staff-access/add-new-profile');
    final $body = model;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> putUser(
    BuildingManagerUserModel model,
    String condominiumId,
  ) {
    final Uri $url =
        Uri.parse('/condominiums/${condominiumId}/staff-access/edit-profile');
    final $body = model;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
