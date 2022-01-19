/* * This widget is what creates the bouncy feel on some buttons and other
 * widgets such as the see all button and the card items in the seeAll screen.
 */

import 'package:flutter/cupertino.dart';

class BouncyPageRoute extends PageRouteBuilder {
  final Widget widget;
  BouncyPageRoute({this.widget})
      : super(
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secAnimation, child) {
            animation =
                CurvedAnimation(parent: animation, curve: Curves.easeInOutCirc);
            return ScaleTransition(
              scale: animation,
              child: child,
              alignment: Alignment.bottomCenter,
            );
          },
          pageBuilder: (context, animation, secAnimation) {
            return widget;
          },
        );
}
