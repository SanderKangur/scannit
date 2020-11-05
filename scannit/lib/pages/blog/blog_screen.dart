import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:scannit/allergens.dart';

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
    // TODO: implement initState
    setState(() {
      List<String> test = nuts.split(new RegExp("\\s+"));
      test.sort();
      test.forEach((element) { allergens.putIfAbsent(element, () => false);});
      print(test);
    });


  }

  void ItemChange(bool val, String key){
    setState(() {
      
      if(key == "") allergens.updateAll((key, value) => val);
      else allergens[key] = val;
    });
    print(key + " " + allergens[key].toString());
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Checked Listview'),
        backgroundColor: Colors.lightGreen,
      ),
      body: new ListView.builder(
          itemCount: allergens.length,
          itemBuilder: (BuildContext context, int index) {
            String key = allergens.keys.elementAt(index);
            return  Card(
              child: new CheckboxListTile(
                activeColor: Colors.lightGreen,
                value: allergens[key],
                title: new Text(key),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool val) {
                  ItemChange(val, key);
                }
              ),
            );
          }
      ),
    );
  }
}