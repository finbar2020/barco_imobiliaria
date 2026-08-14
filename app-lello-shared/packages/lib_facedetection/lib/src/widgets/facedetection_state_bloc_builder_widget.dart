import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
import 'debounced_bloc_builder.dart';

class FaceDetectionStateBlocBuilder extends StatelessWidget {
  final CameraViewController controller;

  const FaceDetectionStateBlocBuilder({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Add key to DebouncedBlocBuilder to maintain single instance
    return DebouncedBlocBuilder<FaceDetectionBloc, FaceDetectionState>(
      key: ValueKey(controller.faceBloc),
      bloc: controller.faceBloc,
      debounceDuration: const Duration(
          milliseconds: 500), // Ajuste este valor conforme necessário
      builder: (context, state) {
        switch (state.runtimeType) {
          case FaceEmptyState:
            return const SizedBox();

          case FaceInitialCenterState:
            return CameraInstructions(
              colorOverlay: Colors.orange,
              title: getString(
                context,
                "face_center_position",
              ),
            );

          case FaceMovingRightState:
            return CameraInstructions(
              colorOverlay: Colors.green,
              arrowIcon: const Icon(
                Icons.arrow_circle_right_outlined,
                size: 60.0,
                color: Colors.green,
              ),
              title: getString(
                context,
                "face_detected_move_slowly_right",
              ),
            );
          case FaceMovingLeftState:
            return CameraInstructions(
              colorOverlay: Colors.green,
              arrowIcon: const Icon(
                Icons.arrow_circle_left_outlined,
                size: 60.0,
                color: Colors.green,
              ),
              title: getString(
                context,
                "face_detected_move_slowly_left",
              ),
            );
          case FaceMovingUpState:
            return CameraInstructions(
              colorOverlay: Colors.green,
              arrowIcon: const Icon(
                Icons.arrow_circle_up_outlined,
                size: 60.0,
                color: Colors.green,
              ),
              title: getString(
                context,
                "face_detected_move_slowly_top",
              ),
            );

          case FaceMovingDownState:
            return CameraInstructions(
              colorOverlay: Colors.green,
              arrowIcon: const Icon(
                Icons.arrow_circle_down_outlined,
                size: 60.0,
                color: Colors.green,
              ),
              title: getString(
                context,
                "face_detected_move_slowly_bottom",
              ),
            );

          case FaceMovingSmileState:
            return CameraInstructions(
              colorOverlay: Colors.green,
              arrowIcon: const Icon(
                Icons.sentiment_satisfied_alt_outlined,
                size: 60.0,
                color: Colors.green,
              ),
              title: getString(
                context,
                "face_detected_move_smile",
              ),
            );

          case FaceMovingBlinkState:
            return CameraInstructions(
              colorOverlay: Colors.green,
              arrowIcon: const Icon(
                Icons.remove_red_eye_outlined,
                size: 60.0,
                color: Colors.green,
              ),
              title: getString(
                context,
                "face_detected_move_blink",
              ),
            );

          case FaceAfterCenterState:
            return CameraInstructions(
              colorOverlay: Colors.yellow,
              arrowIcon: const Icon(
                Icons.center_focus_strong_outlined,
                size: 60.0,
                color: Colors.yellow,
              ),
              title: getString(
                context,
                (state as FaceAfterCenterState).text,
              ),
            );

          case FaceDetectedState:
            final int count = (state as FaceDetectedState).count;
            log("count: $count");
            if (count == 0) {
              return CameraInstructions(
                colorOverlay: Colors.green,
                title: getString(context, "face_detected_profile_do_not_move"),
              );
            }
            return CameraInstructions(
              colorOverlay: Colors.green,
              title: "${getString(context, "face_detected_profile")}$count",
            );

          case FaceFailureState:
            return CameraInstructions(
              colorOverlay: Colors.red,
              title: getString(context, "face_center_position"),
            );

          case TakeManualPhotoState:
            return CameraInstructions(
              colorOverlay: Colors.orange,
              title: getString(context, "face_register_manual"),
            );

          default:
            return const SizedBox();
        }
      },
    );
  }
}
