/* * This widget recreates the usual app bar but with an exception. It gives the
 * app bar a frosted glass effect. So when an item scrolls behind this widget, a
 * blurry see through effect is created. This widget can be seen in action in 
 * the seeAll screen.
 */

import 'dart:ui';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FrostedAppBar extends StatefulWidget {
  @override
  _FrostedAppBarState createState() => _FrostedAppBarState();
  double height;
  Widget title;
  Widget leading;
  List<Widget> actions;
  Color color;
  double blurStrengthX;
  double blurStrengthY;

  FrostedAppBar(
      {this.height,
      this.title,
      this.leading,
      this.actions,
      this.blurStrengthX,
      this.blurStrengthY,
      this.color});
}

class _FrostedAppBarState extends State<FrostedAppBar> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: widget.blurStrengthX ?? 12,
            sigmaY: widget.blurStrengthY ?? 12),
        child: Container(
          color: widget.color,
          alignment: Alignment.center,
          width: screenSize.width,
          height: widget.height ?? kToolbarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 0.0),
                child: Container(
                  color: Colors.transparent,
                  child: widget.leading,
                ),
              ),
              Expanded(
                  child:
                      Align(alignment: Alignment.center, child: widget.title)),
              Row(children: widget.actions ?? [])
            ],
          ),
        ),
      ),
    );
  }
}
