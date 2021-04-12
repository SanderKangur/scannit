import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/data/allergens_entity.dart';
import 'package:scannit/utils/add_allergen_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class ShowAllergens extends StatefulWidget {
  ShowAllergens(this.index, this.color);

  final int index;
  final Color color;

  @override
  _ShowAllergensState createState() => _ShowAllergensState();
}

class _ShowAllergensState extends State<ShowAllergens> {
  List<String> _choices = [];
  Allergens allergens;

  @override
  void initState() {
    super.initState();
    _loadChoices();
  }

  @override
  Widget build(BuildContext context) {
    //print(Constants.userTypes.values.elementAt(widget.index));
    allergens = new Allergens(Constants.allergens.chooseByCategory(
        Constants.categories.categories.elementAt(widget.index).id));
    print("SHOW ALLERGENS: " + allergens.toString());
    //print("Cat name: " + Constants.categories.categories.elementAt(widget.index).name);

    return Scaffold(
        appBar: AppBar(
          title: Text("Choose allergens"),
          centerTitle: true,
          backgroundColor: widget.color,
        ),
        body: Constants.categories.categories
                    .elementAt(widget.index)
                    .name
                    .compareTo("Custom") ==
                0
            ? bodyCustom()
            : bodyDefault());
  }

  _loadChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _choices = (prefs.getStringList('choices') ?? []);
    });
  }

  _updateChoices(String id, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _choices = (prefs.getStringList('choices') ?? []);
      if (val)
        _choices.add(id);
      else
        _choices.remove(id);
      prefs.setStringList('choices', _choices);
    });

    print("CHOICES: " + _choices.toString());
  }

  Widget bodyDefault() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      itemCount: allergens.allergens.length,
      itemBuilder: (context, index) {
        Allergen tmp = allergens.allergens.elementAt(index);
        return new Card(
          /// Create the allergens with checkboxes
          child: new CheckboxListTile(
              activeColor: const Color(0xff324558),
              title: new Text(tmp.name),
              controlAffinity: ListTileControlAffinity.leading,
              value: _choices.contains(tmp.id),
              onChanged: (bool val) {
                _updateChoices(tmp.id, val);
              }),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 2.0),
    );
  }

  Widget bodyCustom() {
    return ListView(
      children: [
        ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          itemCount: allergens.allergens.length,
          itemBuilder: (context, index) {
            Allergen tmp = allergens.allergens.elementAt(index);
            return Dismissible(
              key: Key(tmp.name),
              onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  _updateChoices(tmp.id, false);
                  Constants.allergens.removeById(tmp.id);
                  allergens.allergens.removeAt(index);
                });
                // Then show a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${tmp.name} removed")));
              },
              background: Container(color: widget.color),
              child: new Card(
                /// Create the allergens with checkboxes
                child: new CheckboxListTile(
                    activeColor: const Color(0xff324558),
                    title: new Text(tmp.name),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _choices.contains(tmp.id),
                    onChanged: (bool val) {
                      _updateChoices(tmp.id, val);
                    }),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 2.0),
        ),
        Card(
          elevation: 10,
          shadowColor: Colors.black,
          margin: const EdgeInsets.all(16.0),
          child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                primary: Color(0xff324558),
              ),
              onPressed: () async {
                String id = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => AddAllergenDialog(),
                );
                if (id != null) {
                  print("ID: " + id.toString());
                  setState(() {
                    for (int i = 180;
                        i < Constants.allergens.allergens.length;
                        i++) {
                      print("AL: " +
                          Constants.allergens.allergens[i].toJson().toString());
                    }
                    ;
                    _updateChoices(id, true);
                  });
                }
              },
              child: Center(
                child: Text("Add new allergen"),
              )),
        )
      ],
    );
  }
}
