
import 'package:flutter/material.dart';
import 'package:scannit/constants.dart';


import '../../allergens.dart';

class BlogScreen extends StatefulWidget {
  BlogScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<bool> inputs = new List<bool>();
  Map<String, bool> allergens = Constants.userTypes['meat'];

  @override
  void initState() {
    setState(() {
      allergens.putIfAbsent("Select all", () => false);
      //allergens.addAll(Constants.userTypes['meat']);
      /*List<String> test = AllergensString.allergensString[3].split(new RegExp("(?<!^)(?=[A-Z])"));
      test.sort();
      allergens.putIfAbsent("Select all", () => false);
      test.forEach((element) { allergens.putIfAbsent(element, () => false);});*/
    });
  }

  void itemChange(bool val, String type, String allergen) {
    setState(() {
      if (allergen == "Select all")
        Constants.userTypes[type].updateAll((key, value) => val);
      else
        Constants.userTypes[type][allergen] = val;
    });
    print(allergen + " " + Constants.userTypes[type][allergen].toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: NestedScrollView(
            // Setting floatHeaderSlivers to true is required in order to float
            // the outer slivers over the inner scrollable.
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: const Text('Allergens'),
                  floating: true,
                  expandedHeight: 50.0,
                  forceElevated: innerBoxIsScrolled,
                  backgroundColor: const Color(0xff303952),
                ),
              ];
            },
            body: ListView.builder(
                itemCount: Constants.userTypes.length,
                itemBuilder: (BuildContext context, int index) {
                  String type = Constants.userTypes.keys.elementAt(index);
                  return new ExpansionTile(
                    /// Create the main allergen types
                      key: new PageStorageKey<int>(1),
                      title: new Text(type),
                      children: Constants.userTypes[type].entries.map((e) =>
                          new Card(
                            /// Create the allergens with checkboxes
                            child: new CheckboxListTile(
                                activeColor: const Color(0xff596275),
                                title: new Text(e.key),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: e.value,
                                onChanged: (bool val) {
                                  itemChange(val, type, e.key);
                                }
                            ),
                          )
                     ).toList()
                  );
            })
        )
    );
  }
}
