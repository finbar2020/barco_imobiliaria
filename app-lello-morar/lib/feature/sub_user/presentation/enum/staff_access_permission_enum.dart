import 'package:essentials/app_localization.dart';
import 'package:flutter/cupertino.dart';

enum StaffAccessTypePermissionEnum {
  reserveFreeCommonAreas,
  accessInvoices,
  consultAccountStatements,
  consultDocuments,
  makePaymentAgreements,
  reservePaidCommonAreas,
  moveInReservation,
  inviteOtherResidents,
  mailArrivalNotification,
  consultVisitorScheduling,
  authorizeVisitorEntry,
  incidentReporting,
  vehicleRegistration,
}

enum StaffAccessRole {
  adultResident,
  tenant,
  administrator,
  realEstate,
  minorResident,
  worksManager,
}

extension StaffAccessPermissionEnumExtension on StaffAccessTypePermissionEnum {
  String labelOf(BuildContext context) {
    switch (this) {
      case StaffAccessTypePermissionEnum.reserveFreeCommonAreas:
        return getString(context, 'reserve_free_common_areas');
      case StaffAccessTypePermissionEnum.accessInvoices:
        return getString(context, 'access_invoices');
      case StaffAccessTypePermissionEnum.consultAccountStatements:
        return getString(context, 'consult_account_statements');
      case StaffAccessTypePermissionEnum.consultDocuments:
        return getString(context, 'consult_documents');
      case StaffAccessTypePermissionEnum.makePaymentAgreements:
        return getString(context, 'make_payment_agreements');
      case StaffAccessTypePermissionEnum.reservePaidCommonAreas:
        return getString(context, 'reserve_paid_common_areas');
      case StaffAccessTypePermissionEnum.moveInReservation:
        return getString(context, 'move_in_reservation');
      case StaffAccessTypePermissionEnum.inviteOtherResidents:
        return getString(context, 'invite_other_residents');
      case StaffAccessTypePermissionEnum.mailArrivalNotification:
        return getString(context, 'mail_arrival_notification');
      case StaffAccessTypePermissionEnum.consultVisitorScheduling:
        return getString(context, 'consult_visitor_scheduling');
      case StaffAccessTypePermissionEnum.authorizeVisitorEntry:
        return getString(context, 'authorize_visitor_entry');
      case StaffAccessTypePermissionEnum.incidentReporting:
        return getString(context, 'incident_reporting');
      case StaffAccessTypePermissionEnum.vehicleRegistration:
        return getString(context, 'vehicle_registration');
    }
  }
}

extension StaffAccessRoleExtension on StaffAccessRole {
  String labelOf(BuildContext context) {
    switch (this) {
      case StaffAccessRole.adultResident:
        return getString(context, 'adult_resident');
      case StaffAccessRole.tenant:
        return getString(context, 'tenant');
      case StaffAccessRole.administrator:
        return getString(context, 'administrator');
      case StaffAccessRole.realEstate:
        return getString(context, 'real_estate');
      case StaffAccessRole.minorResident:
        return getString(context, 'minor_resident');
      case StaffAccessRole.worksManager:
        return getString(context, 'works_manager');
    }
  }
}

class AccessPermission {
  final StaffAccessTypePermissionEnum type;
  final Set<StaffAccessRole> allowedRoles;

  const AccessPermission({
    required this.type,
    required this.allowedRoles,
  });

  bool isAllowed(StaffAccessRole role) {
    return allowedRoles.contains(role);
  }
}

final Map<StaffAccessTypePermissionEnum, AccessPermission> accessPermissions = {
  StaffAccessTypePermissionEnum.reserveFreeCommonAreas: const AccessPermission(
    type: StaffAccessTypePermissionEnum.reserveFreeCommonAreas,
    allowedRoles: {
      StaffAccessRole.adultResident,
      StaffAccessRole.tenant,
      StaffAccessRole.administrator,
      StaffAccessRole.minorResident,
      StaffAccessRole.worksManager
    },
  ),
  StaffAccessTypePermissionEnum.accessInvoices: const AccessPermission(
    type: StaffAccessTypePermissionEnum.accessInvoices,
    allowedRoles: {
      StaffAccessRole.adultResident,
      StaffAccessRole.tenant,
      StaffAccessRole.administrator,
      StaffAccessRole.realEstate
    },
  ),
  StaffAccessTypePermissionEnum.consultAccountStatements:
      const AccessPermission(
    type: StaffAccessTypePermissionEnum.consultAccountStatements,
    allowedRoles: {
      StaffAccessRole.adultResident,
      StaffAccessRole.tenant,
      StaffAccessRole.administrator
    },
  ),
  StaffAccessTypePermissionEnum.consultDocuments: const AccessPermission(
    type: StaffAccessTypePermissionEnum.consultDocuments,
    allowedRoles: {
      StaffAccessRole.adultResident,
      StaffAccessRole.tenant,
      StaffAccessRole.administrator
    },
  ),
  StaffAccessTypePermissionEnum.makePaymentAgreements: const AccessPermission(
    type: StaffAccessTypePermissionEnum.makePaymentAgreements,
    allowedRoles: {
      StaffAccessRole.adultResident,
      StaffAccessRole.tenant,
      StaffAccessRole.administrator
    },
  ),
  StaffAccessTypePermissionEnum.reservePaidCommonAreas: const AccessPermission(
    type: StaffAccessTypePermissionEnum.reservePaidCommonAreas,
    allowedRoles: {
      StaffAccessRole.adultResident,
      StaffAccessRole.tenant,
      StaffAccessRole.administrator,
      StaffAccessRole.worksManager
    },
  ),
  StaffAccessTypePermissionEnum.moveInReservation: const AccessPermission(
    type: StaffAccessTypePermissionEnum.moveInReservation,
    allowedRoles: {
      StaffAccessRole.adultResident,
      StaffAccessRole.tenant,
      StaffAccessRole.administrator
    },
  ),
  StaffAccessTypePermissionEnum.inviteOtherResidents: const AccessPermission(
    type: StaffAccessTypePermissionEnum.inviteOtherResidents,
    allowedRoles: {StaffAccessRole.adultResident, StaffAccessRole.tenant},
  ),
  StaffAccessTypePermissionEnum.mailArrivalNotification: const AccessPermission(
    type: StaffAccessTypePermissionEnum.mailArrivalNotification,
    allowedRoles: {StaffAccessRole.adultResident, StaffAccessRole.tenant},
  ),
  StaffAccessTypePermissionEnum.consultVisitorScheduling:
      const AccessPermission(
    type: StaffAccessTypePermissionEnum.consultVisitorScheduling,
    allowedRoles: {StaffAccessRole.adultResident, StaffAccessRole.tenant},
  ),
  StaffAccessTypePermissionEnum.authorizeVisitorEntry: const AccessPermission(
    type: StaffAccessTypePermissionEnum.authorizeVisitorEntry,
    allowedRoles: {
      StaffAccessRole.adultResident,
      StaffAccessRole.tenant,
      StaffAccessRole.worksManager
    },
  ),
  StaffAccessTypePermissionEnum.incidentReporting: const AccessPermission(
    type: StaffAccessTypePermissionEnum.incidentReporting,
    allowedRoles: {StaffAccessRole.adultResident, StaffAccessRole.tenant},
  ),
  StaffAccessTypePermissionEnum.vehicleRegistration: const AccessPermission(
    type: StaffAccessTypePermissionEnum.vehicleRegistration,
    allowedRoles: {StaffAccessRole.adultResident, StaffAccessRole.tenant},
  ),
};
