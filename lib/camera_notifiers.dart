import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CameraNotifier with ChangeNotifier {
  bool _isCameraOpen = false;
  bool get isCameraOpen => _isCameraOpen;

  // CameraDescription _cameraDescription;
  // CameraDescription get cameraDescription => _cameraDescription;

  CameraController _controller;
  CameraController get controller => _controller;

  Future<void> _initializeControllerFuture;
  Future<void> get initializeControllerFuture => _initializeControllerFuture;

  void openCamera() async {
    print("Will Open Camera");

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    //_cameraDescription = cameras.first;

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      cameras.first,
      // Define the resolution to use.
      ResolutionPreset.max,
    );
    print("controller assigned");

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    notifyListeners();
  }

  @override
  void dispose() {
    print("Disposing camera controller along with camera notifier");
    _controller.dispose();
    super.dispose();
  }
}
