
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/categories_entity.dart';
import 'package:scannit/pages/allergens/show_allergens.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<String> colors = [
  "FFf3a683",
  "FFf7d794",
  "FF778beb",
  "FFe77f67",
  "FFcf6a87",
  "FF786fa6",
  "FF546de5",
  "FF63cdda",
  "FF596275",
  "FF574b90",
  "FF303952",
  "FFe66767"
];

class AllergenCategoriesScreen extends StatefulWidget {
  static final String path =
      "scannit/lib/pages/search/allergen_categories.dart";

  @override
  _AllergenCategoriesScreenState createState() =>
      _AllergenCategoriesScreenState();
}

class _AllergenCategoriesScreenState extends State<AllergenCategoriesScreen> {
  final Color secondaryColor = Color(0xff324558);

  List<String> _choices = [];

  @override
  void initState() {
    super.initState();
    _loadChoices();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Theme.of(context).buttonColor,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(
                    "Pick a category",
                    style: TextStyle(color: Color(0xff324558)),
                  ),
                  centerTitle: true,
                  floating: true,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
              ];
            },
            body: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              shrinkWrap: true,
              itemCount: Constants.categories.categories.length,
              itemBuilder: (context, index) {
                return _buildArticleItem(index, context);
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 16.0),
            ),
          )),
    );
  }

  Widget _buildArticleItem(int index, BuildContext context) {
    Color color = Color(int.parse(colors[index], radix: 16));
    final String sample = "assets/splash.png";
    final Category category = Constants.categories.categories.elementAt(index);
    return Stack(
      children: <Widget>[
        RawMaterialButton(
          onPressed: () {
            print("short press");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowAllergens(index, color)),
            ).then((value) => setState(() {
                  _loadChoices();
                }));
          },
          onLongPress: () {
            print("long press");
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: color,
                  width: 5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 80.0,
                  child: Image.asset(
                    'assets/types/' + category.name + '.jpg',
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        category.name,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        Constants.allergens.chosenAllergensString(Constants
                            .allergens
                            .filterChoiceByCategory(category.id, _choices)),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0,
                        ),
                      )
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

  _loadChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _choices = (prefs.getStringList('choices') ?? []);
    });
  }
}
