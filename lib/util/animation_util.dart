import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wall/application.dart';

class AnimationUtil {
  static void showFavoriteAnimation(BuildContext context, Offset offset, {double size = 30, Key? key}) {
    print(offset);
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return Material(
              key: key,
              type: MaterialType.transparency,
              child: Center(
                  child: Stack(children: [
                Positioned(
                    child: Container(
                        alignment: Alignment.center,
                        width: 200,
                        height: 100,
                        child: const FlareActor(
                          "assets/flrs/firework1.flr",
                          alignment: Alignment.center,
                          animation: "Play",
                          fit: BoxFit.fitWidth,
                        )),
                    left: -(200 - offset.dx - 30) / 2,
                    top: offset.dy - 85)
              ])));
        });
  }
}
