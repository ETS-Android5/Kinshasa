import 'package:flutter/material.dart';
import 'package:kinshasa/screens/see_all.dart';
import 'package:kinshasa/shared/exports.dart';
import 'package:kinshasa/widgets/see_all_button.dart';

class BuildTab extends StatefulWidget {
  final String title;
  final List<Drink> set1;
  final List<Drink> set2;
  final List<Drink> selectedDrinks;
  BuildTab({
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
  int intialIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 450.0,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() => intialIndex = index);
              },
            ),
            items: widget.selectedDrinks.map(
              (drink) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      BouncyPageRoute(widget: DrinkDetail(drink)),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40.0,
                          bottom: 15.0,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 30.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Text(
                            '${drink.drinkName}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Image.asset(drink.imageLink)),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.selectedDrinks.map((url) {
                int index = widget.selectedDrinks.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        intialIndex == index ? Colors.black : Colors.grey[300],
                  ),
                );
              }).toList(),
            ),
          ),
          SeeAllButton(
            moveToPage: All(
              set1: widget.set1,
              set2: widget.set2,
              title: widget.title,
            ),
          ),
        ],
      ),
    );
  }
}
