import 'package:creator_hub/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras[isFrontCamera ? 1 : 0],
      ResolutionPreset.max,
    );
    await _controller.initialize();
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  void _switchCamera() {
    setState(() async {
      isFrontCamera = !isFrontCamera;
      await _controller.dispose();
      _initializeCamera();
    });
  }

  @override
  Future<void> dispose() async {
    await _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creator Hub'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1 / _controller.value.aspectRatio,
          child: CameraPreview(_controller),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _switchCamera,
            child: const Icon(Icons.switch_camera),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            child: Icon(
              _controller.value.isRecordingVideo
                  ? Icons.stop
                  : Icons.video_camera_back,
            ),
            onPressed: () async {
              setState(() async {
                if (_controller.value.isRecordingVideo) {
                  XFile file = await _controller.stopVideoRecording();
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerWidget(
                        videoFile: file,
                      ),
                    ),
                  );
                } else {
                  _controller.startVideoRecording();
                }
              });
            },
          ),
          // Add more FloatingActionButton widgets as needed
        ],
      ),
    );
  }
}
      //         Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      //           Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceAround,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: <Widget>[
      //                 SizedBox(
      //                   child: IconButton(
      //                     onPressed: () async => _switchCamera(),
      //                     icon: const Icon(Icons.cameraswitch),
      //                     iconSize: 30,
      //                   ),
      //                 ),
      //                 IconButton(
      //                   onPressed: () async {
      //                     if (!_controller.value.isInitialized) {
      //                       return;
      //                     } else if (_controller.value.isRecordingVideo) {
      //                       XFile file = await _controller.stopVideoRecording();
      //                       if (!mounted) return;
      //                       Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                           builder: (context) => VideoPlayerWidget(
      //                             videoFile: file,
      //                           ),
      //                         ),
      //                       );
      //                     } else {
      //                       try {
      //                         await _controller.setFlashMode(FlashMode.auto);
      //                         await _controller.startVideoRecording();
      //                       } on CameraException catch (e) {
      //                         if (!mounted) return;
      //                         showErrorDialog(context, e.toString());
      //                         return;
      //                       }
      //                     }
      //                   },
      //                   icon: _controller.value.isRecordingVideo
      //                       ? Icon(
      //                           Icons.stop_circle,
      //                         )
      //                       : Icon(
      //                           Icons.video_camera_front_rounded,
      //                         ),
      //                 ),
      //                 IconButton(
      //                   onPressed: () async {
      //                     await _controller.pauseVideoRecording();
      //                   },
      //                   icon: const Icon(Icons.pause_circle),
      //                 )
      //               ])
      //         ])
      //         // Add your recording controls here.
      //       ],
      //     ),
//     );
//   }
// }
