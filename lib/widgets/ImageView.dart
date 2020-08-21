/* * This widget allows us to be able to see a full sized version of a drink's 
 * image. This widget can be seen in action in the Detail screen by simply tapping
 * on the image.
 */

import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String image;
  ImageView(this.image);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(child: Image.asset(image))),
    );
  }
}
