
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
  Map<String, bool> allergens = {};

  @override
  void initState() {
    setState(() {
      allergens.putIfAbsent("Select all", () => false);
      allergens.addAll(Constants.userTypes['meat']);
      /*List<String> test = AllergensString.allergensString[3].split(new RegExp("(?<!^)(?=[A-Z])"));
      test.sort();
      allergens.putIfAbsent("Select all", () => false);
      test.forEach((element) { allergens.putIfAbsent(element, () => false);});*/
    });
  }

  void itemChange(bool val, String key) {
    setState(() {
      if (key == "Select all")
        allergens.updateAll((key, value) => val);
      else
        allergens[key] = val;
    });
    print(key + " " + allergens[key].toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Checked Listview'),
        backgroundColor: Colors.lightGreen,
      ),
      body: new ListView.builder(
          itemCount: allergens.length,
          itemBuilder: (BuildContext context, int index) {
            String key = allergens.keys.elementAt(index);
            return Card(
              child: new CheckboxListTile(
                  activeColor: Colors.lightGreen,
                  value: allergens[key],
                  title: new Text(key),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool val) {
                    itemChange(val, key);
                  }),
            );
          }),
    );
  }
}
