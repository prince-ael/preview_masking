import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;

class CameraNotifier with ChangeNotifier {
  bool _isCameraOpen = false;
  bool get isCameraOpen => _isCameraOpen;

  // CameraDescription _cameraDescription;
  // CameraDescription get cameraDescription => _cameraDescription;

  CameraController _controller;
  CameraController get controller => _controller;

  Future<void> _initializeControllerFuture;
  Future<void> get initializeControllerFuture => _initializeControllerFuture;

  String _photoPath;
  String get photoPath => _photoPath;

  double _screenWidth;
  set screenWidth(double sw) {
    _screenWidth = sw;
  }

  void openCamera() async {
    print("Will Open Camera");

    // Obtain a list of the available cameras on the device.
    _photoPath = null;
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    //_cameraDescription = cameras.first;

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      cameras.first,
      // Define the resolution to use.
      ResolutionPreset.max,
      enableAudio: true,
    );
    print("controller assigned");

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    notifyListeners();
  }

  void capturePhoto() async {
    if (_photoPath != null) {
      _resizeImage();
    } else {
      try {
        // Ensure that the camera is initialized.
        await _initializeControllerFuture;

        // Construct the path where the image should be saved using the path
        // package.
        final path = join(
          // Store the picture in the temp directory.
          // Find the temp directory using the `path_provider` plugin.

          (await getTemporaryDirectory()).path,
          '${DateTime.now()}.png',
        );

        // Attempt to take a picture and log where it's been saved.
        await _controller.takePicture(path);
        _photoPath = path;
      } catch (e) {
        // If an error occurs, log the error to the console.
        _photoPath = null;
        print(e);
      }
    }
    notifyListeners();
  }

  void _resizeImage() async {
    File capturedImgFile = File(_photoPath);
    Img.Image capImage = Img.decodeImage(capturedImgFile.readAsBytesSync());
    Img.Image resizedImage = Img.copyResize(
      capImage,
      width: 600,
      //width: _screenWidth.round(),
    );
    Img.Image croppedImage = Img.copyCrop(resizedImage, 0, 0, 600, 600);

    final externalStoragePath = join(
      (await getExternalStorageDirectory()).path,
      '${DateTime.now()}.jpg',
    );
    print("externalStoragePath: $externalStoragePath");
    File resizedImageFile = File(externalStoragePath);
    bool fileExists = await resizedImageFile.exists();
    if (!fileExists) {
      resizedImageFile.createSync();
      resizedImageFile.writeAsBytesSync(
        Img.encodeJpg(croppedImage, quality: 65),
      );
    }
    _photoPath = externalStoragePath;
    closeCamera();
  }

  void _releaseCameraResource() {
    _controller.dispose();
    _controller = null;
    _initializeControllerFuture = null;
  }

  void closeCamera() {
    _releaseCameraResource();
    notifyListeners();
  }

  @override
  void dispose() {
    print("Disposing camera controller along with camera notifier");
    _releaseCameraResource();
    super.dispose();
  }
}
