import 'package:flutter/material.dart';

class CircularButtonIB extends StatelessWidget {
  final Function onTapped;
  final IconData icon;

  CircularButtonIB({
    @required this.onTapped,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipBehavior: Clip.antiAlias,
      child: ButtonTheme(
        height: 64.0,
        minWidth: 64.0,
        child: FlatButton(
          onPressed: onTapped,
          color: Colors.white,
          child: Icon(
            this.icon,
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
