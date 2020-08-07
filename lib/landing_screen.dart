import 'package:camera/camera.dart';
import 'package:camera_preview_overlay/camera_button.dart';
import 'package:camera_preview_overlay/camera_notifiers.dart';
import 'package:camera_preview_overlay/circle_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() {
    return _LandingScreenState();
  }
}

class _LandingScreenState extends State<LandingScreen> {
  Function onAttemptCapture;
  Function onCancelPhoto;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color(0xff1B5E20)));
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    final notifier = Provider.of<CameraNotifier>(context, listen: false);
    onAttemptCapture = notifier.capturePhoto;
    onCancelPhoto = notifier.closeCamera;

    return Selector<CameraNotifier, List<dynamic>>(
      selector: (context, notifier) => [
        notifier.controller,
        notifier.initializeControllerFuture,
      ],
      builder: (context, camUtils, _) {
        if (camUtils[0] == null && camUtils[1] == null) {
          return _closedView(notifier.openCamera);
        } else {
          print("FutureBuilder");

          return _camPreview(camUtils[1], camUtils[0]);
        }
      },
    );
  }

  Widget _camPreview(
      Future<void> initializeControllerFuture, CameraController controller) {
    return FutureBuilder<void>(
      future: initializeControllerFuture,
      builder: (context, snapshot) {
        print("FutureBuilder");
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Stack(
            children: <Widget>[
              CameraPreview(controller),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _square(),
                  _overlay(),
                ],
              )
            ],
          );
        } else {
          // Otherwise, display a loading indicator.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _overlay() {
    return Expanded(
      child: Container(
        color: Colors.white.withAlpha(222),
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 34.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _cancelButton(),
              _cameraButton(),
              CircularButtonIB(
                onTapped: () {
                  print("Unknown");
                },
                icon: Icons.center_focus_weak,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _square() {
    double screenWidth = MediaQuery.of(context).size.width;
    double ovalWidth = (screenWidth * 0.46);
    double ovalHeight = (screenWidth * 0.60);
    return Container(
      height: screenWidth,
      width: screenWidth,
      alignment: Alignment.center,
      //color: Colors.white,
      child: Align(
        child: Container(
          height: ovalHeight,
          width: ovalWidth,
          decoration: BoxDecoration(
            //shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withAlpha(222), width: 2.0),
            borderRadius:
                new BorderRadius.all(Radius.elliptical(ovalWidth, ovalHeight)),
          ),
        ),
      ),
    );
  }

  Widget _cameraButton() {
    return Selector<CameraNotifier, String>(
      selector: (context, notifier) => notifier.photoPath,
      builder: (context, path, _) {
        return CameraButton(
          onTapped: onAttemptCapture,
          isCapturedSuccessfully: path != null,
        );
      },
    );
  }

  Widget _cancelButton() {
    return Selector<CameraNotifier, String>(
      selector: (context, notifier) => notifier.photoPath,
      builder: (context, path, _) {
        return path != null
            ? CircularButtonIB(
                onTapped: onCancelPhoto,
                icon: Icons.clear,
              )
            : SizedBox();
      },
    );
  }

  Widget _closedView(Function openCamera) {
    return Center(
      child: FlatButton(
        color: Colors.blueAccent,
        textColor: Colors.white,
        onPressed: openCamera,
        child: Text("Open Camera"),
      ),
    );
  }
}
