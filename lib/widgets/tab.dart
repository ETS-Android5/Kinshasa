/* * This widget is used to build out the tab bar seen in the home screen. 
 * It was created to avoid repetitive code since all three tabs (juice, smoothie
 * , shake) are essentially equal in structure.
 * When called, it requires certain pieces of information. The title of the tab,
 * the number of drinks the selected category of drink has (to be sent to seeAll
 *  screen by the seeAllButton), 
 */

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kinshasa/screens/DetailPage.dart';
import 'package:kinshasa/screens/seeAll.dart';
import 'package:kinshasa/widgets/BouncyPageRoute.dart';
import 'package:kinshasa/widgets/DrinkModel.dart';
import 'package:kinshasa/widgets/seeAllButton.dart';

class BuildTab extends StatefulWidget {
  final int drinkCount;
  final String title;
  final List<Drink> set1;
  final List<Drink> set2;
  final List<Drink> selectedDrinks;
  BuildTab({
    this.drinkCount,
    this.title,
    this.set1,
    this.set2,
    this.selectedDrinks,
  });
  @override
  _BuildTabState createState() => _BuildTabState();
}

class _BuildTabState extends State<BuildTab>
    with AutomaticKeepAliveClientMixin {
  int _current = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(children: <Widget>[
      // Carousel containing the name of the drink and it's image
      Flexible(
        fit: FlexFit.loose,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 450.0,
            initialPage: 0,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: widget.selectedDrinks.map((item) {
            return Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        BouncyPageRoute(
                            widget: DetailPage(
                          title: '${item.drinkName}',
                          imageLink: item.imageLink,
                          nutrients: item.nutrients,
                          procedure: item.procedure,
                          ingredients: item.ingredients,
                        )));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      children: <Widget>[
                        // This is the name of the drink above the drink image
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, top: 40.0),
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25.0)),
                            child: Text(
                              '${item.drinkName}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        // This is the image below the drink name
                        Expanded(
                          child: Image.asset(
                            item.imageLink,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),

      // Dot indicator to show the current item of the carousel
      Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.selectedDrinks.map((url) {
            int index = widget.selectedDrinks.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ),

      // See all button
      SeeAllButton(
          moveToPage: All(
        title: widget.title,
        providerCount: widget.drinkCount,
        set1: widget.set1,
        set2: widget.set2,
      )),
    ])));
  }
}
