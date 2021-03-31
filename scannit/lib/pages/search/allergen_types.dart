import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/pages/search/show_allergens.dart';


final List<String> colors = [
  "FFf3a683", "FFf7d794", "FF778beb", "FFe77f67", "FFcf6a87", "FF786fa6",
  "FF546de5", "FF63cdda", "FF596275", "FF574b90", "FF303952", "FFe66767"
];


class AllergenTypesScreen extends StatelessWidget {
  static final String path = "scannit/lib/pages/search/allergen_types.dart";
  final Color primaryColor = Color(0xffFD6592);
  final Color bgColor = Color(0xffF9E0E3);
  final Color secondaryColor = Color(0xff324558);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        initialIndex: 0,
        length: 1,
        child: Theme(
          data: ThemeData(
            primaryColor: primaryColor,
            appBarTheme: AppBarTheme(
              color: Colors.white,
              textTheme: TextTheme(
                headline6: TextStyle(
                  color: secondaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: IconThemeData(color: secondaryColor),
              actionsIconTheme: IconThemeData(
                color: secondaryColor,
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: Theme.of(context).buttonColor,
            body: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: Constants.userTypes.length,
              itemBuilder: (context, index) {
                return _buildArticleItem(index, context);
              },
              separatorBuilder: (context, index) =>
              const SizedBox(height: 16.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleItem(int index, BuildContext context) {
    Color color = Color(int.parse(colors[index], radix: 16));
    final String sample = "assets/splash.png";
    return Stack(
      children: <Widget>[
        RawMaterialButton(
          onPressed: () {
            print("short press");
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShowAllergens(index, color)
              )
            );
          },
          onLongPress: () {
            print("long press");
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: color,
                  width: 5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 80.0,
                  child: Image.asset('assets/types/' + Constants.userTypes.keys.elementAt(index) + '.jpg',
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        Constants.userTypes.keys.elementAt(index),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}