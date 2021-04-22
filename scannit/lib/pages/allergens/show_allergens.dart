import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/data/allergens_entity.dart';
import 'package:scannit/data/categories_entity.dart';
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
  Allergens _allergens = new Allergens([]);
  Allergens allergensByCat;

  @override
  void initState() {
    super.initState();
    _loadChoices();
    _getAllergens();
  }

  @override
  Widget build(BuildContext context) {
    //print(Constants.userTypes.values.elementAt(widget.index));
    allergensByCat = Allergens(_allergens.chooseByCategory(Constants.categories.categories.elementAt(widget.index).id));
    print("SHOW ALLERGENS: " + allergensByCat.allergens.toString());
    //print("Cat name: " + Constants.categories.categories.elementAt(widget.index).id);

    return Scaffold(
        appBar: AppBar(
          title: Text("${Constants.categories.categories.elementAt(widget.index).name} allergeenid"),
          centerTitle: true,
          backgroundColor: widget.color,
        ),
        body: _buildChild()
    );
  }

  _loadChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _choices = (prefs.getStringList('choices') ?? []);
    });
  }

  _getAllergens() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<dynamic> jsonList = prefs.getStringList('allergens') ?? [];

    _allergens.allergens = jsonList.map((json) => Allergen.fromJson(jsonDecode(json))).toList();
  }

  _saveAllergens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = _allergens.allergens.map((allergen) => jsonEncode(allergen.toJson())).toList();
    prefs.setStringList('allergens', jsonList);
  }

  _updateChoices(String id, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (val){
        if(!_choices.contains(id)) _choices.add(id);
      }
      else
        _choices.remove(id);
      prefs.setStringList('choices', _choices);
    });

    //print("CHOICES: " + _choices.toString());
  }

  Widget _bodyDefault() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      itemCount: allergensByCat.allergens.length,
      itemBuilder: (context, index) {
        Allergen tmp = allergensByCat.allergens.elementAt(index);
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

  Widget _bodyCustom() {
    return ListView(
      children: [
        ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          itemCount: allergensByCat.allergens.length,
          itemBuilder: (context, index) {
            Allergen tmp = allergensByCat.allergens.elementAt(index);
            return Dismissible(
              key: Key(tmp.name),
              onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  _updateChoices(tmp.id, false);
                  allergensByCat.removeById(tmp.id);
                  _allergens.removeById(tmp.id);
                  _saveAllergens();
                });
                // Then show a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${tmp.name} eemaldatud")));
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
                        i < _allergens.allergens.length;
                        i++) {
                      print("AL: " +
                          _allergens.allergens[i].toJson().toString());
                    }
                    ;
                    _updateChoices(id, true);
                    _getAllergens();
                  });
                }
              },
              child: Center(
                child: Text("Lisa uus allergeen"),
              )),
        )
      ],
    );
  }

  Widget _bodyMain(){

    List<Category> subCats = Constants.categories.getSubCategories();

    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      itemCount: subCats.length,
      itemBuilder: (context, index) {
        Category tmp = subCats.elementAt(index);
        bool check = _checkSubAllergens(tmp.id);
        return new Card(
          /// Create the allergens with checkboxes
          child: new CheckboxListTile(
              activeColor: const Color(0xff324558),
              title: new Text(tmp.name),
              controlAffinity: ListTileControlAffinity.leading,
              value: check,
              onChanged: (bool val) {
                _allergens.allergens.forEach((element) {
                  if(element.category.split(", ").contains(tmp.id)){
                    _updateChoices(element.id, val);
                    print("CHECK: " + element.id + " " + val.toString() + " " + tmp.id);
                  }
                });
                setState(() {
                });
              }),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 2.0),
    );
  }

  bool _checkSubAllergens(String catId) {
    for(int i = 0; i<_allergens.allergens.length; i++){
      if(_allergens.allergens[i].category.split(", ").contains(catId)){
        if(!_choices.contains(_allergens.allergens[i].id)) return false;
      }
    }
    return true;
  }

  Widget _buildChild() {
    switch (Constants.categories.categories
        .elementAt(widget.index)
        .id) {
      case 'C1':
        return _bodyMain();
        break;
      case 'C13':
        return _bodyCustom();
        break;
      default:
        return _bodyDefault();
        break;
    }
  }
}
