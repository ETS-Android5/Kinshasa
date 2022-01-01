import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';

class DrinkDetail extends StatefulWidget {
  final Drink drink;
  DrinkDetail(this.drink);

  @override
  _DrinkDetailState createState() => _DrinkDetailState();
}

class _DrinkDetailState extends State<DrinkDetail> {
  bool showTitle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: showTitle ? 1.0 : 0.0,
        leading: IconButton(
          iconSize: 30.0,
          icon: Icon(CupertinoIcons.back),
          color: Colors.red[400],
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AnimatedOpacity(
          opacity: showTitle ? 1.0 : 0.0,
          duration: Duration(milliseconds: showTitle ? 0 : 0),
          child: Text(
            widget.drink.drinkName,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ),
      body: NotificationListener(
        onNotification: (ScrollUpdateNotification notification) {
          setState(() {
            if (notification.metrics.pixels > 150 && !showTitle) {
              showTitle = true;
            } else if (notification.metrics.pixels < 135 && showTitle) {
              showTitle = false;
            }
          });
          return;
        },
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.asset(
                        widget.drink.imageLink,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${widget.drink.drinkName}',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            DetailSection(
              label: 'Ingredients',
              content: this.widget.drink.ingredients,
            ),
            DetailSection(
              label: 'How to prepare',
              content: this.widget.drink.procedure,
            ),
            DetailSection(
              label: 'Nutrients per serving',
              content: this.widget.drink.nutrients,
            ),
            const SizedBox(height: 20.0),
            AddToFavoritesButton(drink: widget.drink),
          ],
        ),
      ),
    );
  }
}
