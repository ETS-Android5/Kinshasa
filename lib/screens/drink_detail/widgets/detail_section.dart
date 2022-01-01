import 'package:flutter/material.dart';

class DetailSection extends StatelessWidget {
  final String label, content;

  const DetailSection({Key key, @required this.label, @required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 40.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                label,
                style: TextStyle(fontSize: 18.0, color: Colors.grey[700]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Text(
                content,
                style: TextStyle(
                  height: 2.0,
                  fontSize: 17.0,
                  wordSpacing: 0.5,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
