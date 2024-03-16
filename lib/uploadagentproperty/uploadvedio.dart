import 'dart:io';

import 'package:camera/camera.dart';
import 'package:closing_deal/main.dart';
import 'package:closing_deal/uploadagentproperty/uploadvedio.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'uploadvedio.dart';

class VedioRecording extends StatefulWidget {
  const VedioRecording({super.key});

  @override
  State<VedioRecording> createState() => _VedioRecordingState();
}

String? path;

class _VedioRecordingState extends State<VedioRecording> {
  CameraController? controller;
  late Future<void> initializeControllerFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CameraController(cameras![0], ResolutionPreset.ultraHigh);

    initializeControllerFuture = controller!.initialize();
  }

  Future<String?> _recordVideo() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoPath = '${appDirectory.path}/video.mp4';

    try {
      await controller!.startVideoRecording();
      await Future.delayed(
          Duration(seconds: 5)); // Simulate recording for 5 seconds
      await controller!.stopVideoRecording();
    } catch (e) {
      print('Error recording video: $e');
      return null;
    }

    return videoPath;
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeControllerFuture,
        // ignore: non_constant_identifier_names
        builder: (context, Snapshot) {
          if (Snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: CameraPreview(controller!),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: controller!.value.isRecordingVideo
                        ? RawMaterialButton(onPressed: () async {
                            try {
                              await initializeControllerFuture;

                              // path = join(
                              //     (await getApplicationDocumentsDirectory().path)
                              //     );
                              setState(() {});
                            } catch (e) {
                              print(e);
                            }
                          })
                        : null),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
