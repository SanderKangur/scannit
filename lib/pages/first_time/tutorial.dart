import 'package:flutter/material.dart';
import 'package:scannit/pages/first_time/tutorial_allergens.dart';
import 'package:flutter/cupertino.dart';
import 'package:scannit/pages/first_time/tutorial_end.dart';
import 'package:scannit/pages/first_time/tutorial_hints.dart';
import 'package:scannit/pages/first_time/tutorial_scan.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'tutorial_hello.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final controller = PageController(viewportFraction: 1.0);
  List<Widget> _screens = [TutorialHello(), TutorialAllergens(), TutorialScan(), TutorialHints(), TutorialEnd()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 32,
              ),
              Expanded(
                flex: 7,
                child: PageView.builder(
                  controller: controller,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Theme.of(context).accentColor,
                            width: 7,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: _screens[index],
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 5,
                    effect: ScaleEffect(
                      activeDotColor: Theme.of(context).accentColor
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}