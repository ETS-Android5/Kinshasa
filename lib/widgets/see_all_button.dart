import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';

class SeeAllButton extends StatelessWidget {
  final Widget moveToPage;
  SeeAllButton({this.moveToPage});
  @override
  Widget build(BuildContext context) {
    return Bounce(
      onPressed: () {
        Navigator.of(context).push(BouncyPageRoute(widget: moveToPage));
      },
      duration: Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
        child: Center(
          child: Material(
            color: Colors.red[400],
            borderRadius: BorderRadius.circular(30.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 70.0, vertical: 18.0),
              child: Text(
                'see all',
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
