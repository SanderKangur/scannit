import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/allergens_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAllergenDialog extends StatelessWidget {
  AddAllergenDialog();

  final TextEditingController textEditingController = TextEditingController();
  Allergens _allergens = new Allergens([]);

  @override
  Widget build(BuildContext context) {
    //User user = Provider.of<User>(context);
    //print("add ingredient " + user.uid);

    _getAllergens();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
          top: Consts.avatarRadius - Consts.padding,
          bottom: Consts.padding,
          left: Consts.padding,
          right: Consts.padding,
        ),
        margin: EdgeInsets.only(top: Consts.avatarRadius),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              "Lisa allergeen, mida soovid etiketilt tuvastada",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: textEditingController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: 'Kirjuta siia... '),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  onPressed: () async {
                    String text = textEditingController.value.text;
                    String id = "";
                    if (text.isNotEmpty) {
                      id = "A${_allergens.allergens.length+1}";
                      Allergen al = new Allergen(
                          id: id,
                          name: text.replaceAll(new RegExp("[,.:\n]"), ""),
                          category: "C13");
                      await _allergens.allergens.add(al);
                      await _saveAllergens();
                      print("len: " +
                          _allergens.allergens.length.toString() +
                          " added id: " +
                          id);
                    }
                    Navigator.pop(context, id);
                  },
                  child: Text(
                    "Lisa allergeen",
                    style: TextStyle(color: Color(0xff324558)),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(
                    "Sulge",
                    style: TextStyle(color: Color(0xff324558)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getAllergens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> jsonList = prefs.getStringList('allergens') ?? [];
    _allergens.allergens = jsonList.map((json) => Allergen.fromJson(jsonDecode(json))).toList();
  }

  _saveAllergens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = _allergens.allergens.map((allergen) => jsonEncode(allergen.toJson())).toList();
    prefs.setStringList('allergens', jsonList);
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
