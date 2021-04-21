import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraController _cameraController;
  List<CameraDescription> cameras;
  bool _isRecording = false;

  @override
  void initState() {
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      _cameraController = CameraController(cameras[0], ResolutionPreset.high);
      _cameraController.initialize().then((value) {
        setState(() {});
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _cameraController != null
                ? Positioned(
                    height: MediaQuery.of(context).size.height,
                    child: CameraPreview(_cameraController))
                : Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                child: _isRecording
                    ? Text('Stop Recording')
                    : Text('Start Recording'),
                onPressed: () async {
                  if (_isRecording) {
                    await _cameraController.stopVideoRecording().then((value) {
                      setState(() {
                        _isRecording = false;
                      });
                    });
                  } else {
                    await _cameraController.startVideoRecording().then((value) {
                      setState(() {
                        _isRecording = true;
                      });
                    }).onError((error, stackTrace) {
                      print(error);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
