import 'package:colaborador/feature/me/domain/enum/device_type_allowed_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

enum DigitalTimesheetStatusEnum {
  notActivated,
  notRequested,
  pending,
  approved,
  declined,
  removed,
}

extension DigitalTimesheetStatusEnumExtension on DigitalTimesheetStatusEnum {
  bool get isNotActivated => this == DigitalTimesheetStatusEnum.notActivated;
  bool get isNotRequested => this == DigitalTimesheetStatusEnum.notRequested;
  bool get isPending => this == DigitalTimesheetStatusEnum.pending;
  bool get isApproved => this == DigitalTimesheetStatusEnum.approved;
  bool get isDeclined => this == DigitalTimesheetStatusEnum.declined;
  bool get isRemoved => this == DigitalTimesheetStatusEnum.removed;
}

class DigitalTimesheetStatus {
  static Color color(
      DigitalTimesheetStatusEnum statusEnum, SessionBloc sessionBloc) {
    if (sessionBloc.getSession!.condominium.isDigitalPointBlockedByLeave) {
      return LightPallete().grey();
    }
    if (((!sessionBloc.getSession!.me.isTabletSession!) &&
        sessionBloc.getSession!.condominium.deviceTypeEnum.isOnlyTablet)) {
      return LightPallete().grey();
    }
    if ((sessionBloc.getSession!.me.isTabletSession!) &&
        sessionBloc.getSession!.condominium.deviceTypeEnum.isOnlyPhone) {
      return LightPallete().grey();
    }
    switch (statusEnum) {
      case (DigitalTimesheetStatusEnum.approved):
        return const Color(0xFF42B883);
      case (DigitalTimesheetStatusEnum.pending):
        return const Color(0xFF979797);
      case (DigitalTimesheetStatusEnum.notRequested):
        return const Color(0xFF922885);
      case (DigitalTimesheetStatusEnum.declined):
        return const Color(0xFF922885);
      case (DigitalTimesheetStatusEnum.notActivated):
        return const Color(0xFFCB2640);
      case (DigitalTimesheetStatusEnum.removed):
        return const Color(0xFF922885);
    }
  }

  static String text({
    required BuildContext context,
    required DigitalTimesheetStatusEnum statusEnum,
    required SessionBloc sessionBloc,
  }) {
    if (sessionBloc.getSession!.condominium.isDigitalPointBlockedByLeave) {
      return sessionBloc.getSession!.condominium.workLeaveDescription;
    }
    if (((!sessionBloc.getSession!.me.isTabletSession!) &&
        sessionBloc.getSession!.condominium.deviceTypeEnum.isOnlyTablet)) {
      return getString(context, "home_page_register_point_blocked");
    }
    if ((sessionBloc.getSession!.me.isTabletSession!) &&
        sessionBloc.getSession!.condominium.deviceTypeEnum.isOnlyPhone) {
      return getString(context, "home_page_register_point_blocked");
    }

    switch (statusEnum) {
      case (DigitalTimesheetStatusEnum.approved):
        return getString(context, "home_page_register_point");

      case (DigitalTimesheetStatusEnum.pending):
        return getString(context, "home_page_register_waiting_release");

      case (DigitalTimesheetStatusEnum.notRequested):
        return getString(context, "home_page_release_digital_point");

      case (DigitalTimesheetStatusEnum.declined):
        return getString(context, "home_page_release_digital_point");

      case (DigitalTimesheetStatusEnum.notActivated):
        return getString(context, "home_page_register_know_digital_point");

      case (DigitalTimesheetStatusEnum.removed):
        return getString(context, "home_page_release_digital_point");
    }
  }
}
