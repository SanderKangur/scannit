import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannit/data/allergens_entity.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/info_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../loading.dart';

class ShowAllergens extends StatefulWidget {
  ShowAllergens(this.index, this.color);

  final int index;
  final Color color;

  @override
  _ShowAllergensState createState() => _ShowAllergensState();
}

class _ShowAllergensState extends State<ShowAllergens> {
  List<String> _choices = [];

  @override
  void initState() {
    super.initState();
    _loadChoices();
  }

  @override
  Widget build(BuildContext context) {
    //print(Constants.userTypes.values.elementAt(widget.index));

    Allergens allergens = new Allergens(Constants.allergens.chooseByCategory(Constants.categories.categories.elementAt(widget.index).id));
    print("SHOW ALLERGENS: " + allergens.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Choose allergens"),
        backgroundColor: widget.color,
      ),
      body: ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: allergens.allergens.length,
            itemBuilder: (context, index) {
              Allergen tmp = allergens.allergens.elementAt(index);
              return new Card(
                /// Create the allergens with checkboxes
                child: new CheckboxListTile(
                    activeColor: const Color(0xff596275),
                    title: new Text(tmp.name),
                    controlAffinity:
                    ListTileControlAffinity.leading,
                    value: _choices.contains(tmp.id),
                    onChanged: (bool val) {
                      itemChange(val, tmp.category, tmp.id);
                    }),
              );
            },
            separatorBuilder: (context, index) =>
            const SizedBox(height: 16.0),
        ),
    );
  }

  _loadChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _choices = (prefs.getStringList('choices') ?? []);
    });
  }

  _updateAllergen(String id, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _choices = (prefs.getStringList('choices') ?? []);
      if(val)
        _choices.add(id);
      else
        _choices.remove(id);
      prefs.setStringList('choices', _choices);
    });

    print("CHOICES: " + _choices.toString());
  }

  void itemChange(bool val, String type, String allergen) async {
    setState(() {
      _updateAllergen(allergen, val);
    });

    /*  if (allergen == "Select all")
        Constants.userTypes[type].updateAll((key, value) => val);
      else
        Constants.userTypes[type][allergen] = val;
    });

    await InfoRepo(uid: Constants.userId).updateTypes();

    if (val)
      Constants.userAllergens
          .add(allergen.toLowerCase().replaceAll("[,.:\n]", ""));
    else
      Constants.userAllergens
          .remove(allergen.toLowerCase().replaceAll("[,.:\n]", ""));*/
  }
}