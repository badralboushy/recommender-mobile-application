import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class SpinnerWidget extends StatelessWidget {
  double? Size ;
  SpinnerWidget(this.Size);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitRipple(
        color: Colors.lightBlueAccent,
        size: Size,
    //    controller: AnimationController(duration: const Duration(milliseconds: 1200)),

      )
    );
  }
}
