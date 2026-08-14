import 'dart:io';
import 'dart:math' as math;
import 'package:essentials/essentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
import 'package:lib_facedetection/src/bloc/debug/debug_bloc.dart';
import 'package:lib_facedetection/src/widgets/animated_face_frame.dart';
import 'package:lib_facedetection/src/widgets/facedetection_state_bloc_builder_widget.dart';

class LiveFeedBody extends StatelessWidget {
  final CameraViewController controller;

  const LiveFeedBody({
    super.key,
    required this.controller,
  });

  Widget _buildCameraPreview(BuildContext context, Size size) {

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: CameraPreview(controller.cameraController),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder(
      bloc: controller.cameraBloc,
      builder: (context, state) {
        if (state is ManualCaptureState) {
          return _buildManualCapture(context, size);
        }
        if (state is LoadingCameraState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SuccessCameraState) {
          return _buildSuccessState(context, size);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildManualCapture(BuildContext context, Size size) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildCameraPreview(context, size),
          Positioned(
            top: 30.0,
            right: 10.0,
            left: 10.0,
            child: FaceDetectionStateBlocBuilder(controller: controller),
          ),
          BlocBuilder<FaceDetectionBloc, FaceDetectionState>(
            bloc: controller.faceBloc,
            builder: (context, state) {
              return _buildFacePainter(context, state,
                  defaultColor: Colors.yellow);
            },
          ),
          Positioned(
            bottom: 30.0,
            right: 10.0,
            left: 10.0,
            child: ManualCaptureButton(
              getFile: controller.getFile,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, Size size) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildCameraPreview(context, size),
          if (controller.isDebug)
            Positioned(
              width: size.width,
              bottom: 10,
              child: BlocBuilder(
                bloc: controller.debugBloc,
                builder: (context, state) {
                  if (state is SendDebugState) {
                    return _buildDebugInfo(state);
                  }
                  return const SizedBox();
                },
              ),
            ),
          Positioned(
            top: 30.0,
            right: 10.0,
            left: 10.0,
            child: FaceDetectionStateBlocBuilder(controller: controller),
          ),
          BlocBuilder<FaceDetectionBloc, FaceDetectionState>(
            bloc: controller.faceBloc,
            builder: (context, state) {
              return _buildFacePainter(context, state,
                  defaultColor: Colors.yellow);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFacePainter(BuildContext context, FaceDetectionState state,
      {required Color defaultColor}) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: AnimatedFaceFrame(
        state: state,
        defaultColor: defaultColor,
        size: kIsWeb
            ? Size(size.height * 0.7, size.height * 0.8)
            : (size.aspectRatio > 1
                ? Size(size.width * 0.4, size.width * 0.7)
                : Size(size.height * 0.7, size.height * 0.6)),
      ),
    );
  }

  Widget _buildDebugInfo(SendDebugState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('X: ${state.face.headEulerAngleX?.toStringAsFixed(5)}',
                style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 4),
            Text('Y: ${state.face.headEulerAngleY?.toStringAsFixed(5)}',
                style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 4),
            Text('Z: ${state.face.headEulerAngleZ?.toStringAsFixed(5)}',
                style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 4),
            Text('Fps: ${state.performace}',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Rotation: ${state.rotation}',
                style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 4),
            Text('Smile: ${state.face.smilingProbability?.toStringAsFixed(5)}',
                style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 4),
            Text(
                'Left Eye: ${state.face.leftEyeOpenProbability?.toStringAsFixed(5)}',
                style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 4),
            Text(
                'Right Eye: ${state.face.rightEyeOpenProbability?.toStringAsFixed(5)}',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}

class FacePainer extends StatelessWidget {
  final Color color;
  const FacePainer({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: CustomPaint(
        size: kIsWeb
            ? Size(size.height * 0.7, size.height * 0.8)
            : (size.aspectRatio > 1
                ? Size(size.width * 0.4, size.width * 0.7)
                : Size(size.height * 0.7, size.height * 0.6)),
        painter: RPSCustomPainter(color: color),
      ),
    );
  }
}
