import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/data/info_repo.dart';

import '../../constants.dart';

class ShowAllergens extends StatefulWidget {
  ShowAllergens(this.index, this.color);

  final int index;
  final Color color;

  @override
  _ShowAllergensState createState() => _ShowAllergensState();
}

class _ShowAllergensState extends State<ShowAllergens> {


  @override
  Widget build(BuildContext context) {
    print(Constants.userTypes.values.elementAt(widget.index));
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: Constants.userTypes.values.elementAt(widget.index).length,
        itemBuilder: (context, index) {
          MapEntry<String, bool> tmp = Constants.userTypes.values.elementAt(widget.index).entries.elementAt(index);
          return new Card(
            /// Create the allergens with checkboxes
            child: new CheckboxListTile(
                activeColor: const Color(0xff596275),
                title: new Text(tmp.key),
                controlAffinity:
                ListTileControlAffinity.leading,
                value: tmp.value,
                onChanged: (bool val) {
                  itemChange(val, Constants.userTypes.keys.elementAt(widget.index), tmp.key);
                }),
          );
        },
        separatorBuilder: (context, index) =>
        const SizedBox(height: 16.0),
      ),
    );
  }

  void itemChange(bool val, String type, String allergen) async {
    setState(() {
      if (allergen == "Select all")
        Constants.userTypes[type].updateAll((key, value) => val);
      else
        Constants.userTypes[type][allergen] = val;
    });

    await InfoRepo(uid: Constants.userId).updateTypes();

    if (val)
      Constants.userAllergens
          .add(allergen.toLowerCase().replaceAll("[,\.:\n]", ""));
    else
      Constants.userAllergens
          .remove(allergen.toLowerCase().replaceAll("[,\.:\n]", ""));

    print(allergen + " " + Constants.userTypes[type][allergen].toString());
    print("BLOG" + Constants.userAllergens.toString());
  }
}