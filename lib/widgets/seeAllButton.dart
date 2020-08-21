/* * This widget is seen on the home screen. As the name suggests, when a user
 * is under say, the juice tab, and he clicks on this button, it opens the seeAll
 * screen and displays the full list of juices.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'BouncyPageRoute.dart';

class SeeAllButton extends StatelessWidget {
  final Widget moveToPage;
  SeeAllButton({this.moveToPage});
  @override
  Widget build(BuildContext context) {
    return // view all button to open the list view of all juice
        Bounce(
      onPressed: () {
        Navigator.of(context).push(BouncyPageRoute(widget: moveToPage));
      },
      duration: Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.red[400],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 70.0, vertical: 18.0),
              child: Text(
                'see all',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  //fontWeight: FontWeight.bold,
                  //fontFamily: 'Product Sans'
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
