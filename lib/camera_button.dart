import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  final Function onTapped;
  final bool isCapturedSuccessfully;
  CameraButton({@required this.onTapped, this.isCapturedSuccessfully});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 64.0,
      minWidth: 64.0,
      child: FlatButton(
        onPressed: onTapped,
        color: isCapturedSuccessfully ? Color(0xff1B5E20) : Colors.white,
        child: isCapturedSuccessfully
            ? Icon(Icons.check, color: Colors.white)
            : Icon(Icons.camera_alt, color: Color(0xff1B5E20)),
        shape: CircleBorder(
          side: BorderSide(
            color: Color(0xff1B5E20),
          ),
        ),
      ),
    );
  }
}

// RoundedRectangleBorder(
//           borderRadius: Values.borderRadiusOfFour,
//           side: BorderSide(color: ColorIb.buttonBgColor),
//         )
