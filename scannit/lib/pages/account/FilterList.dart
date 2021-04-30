import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/data/allergens_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterList extends StatefulWidget {
  @override
  _FilterListState createState() => new _FilterListState();
}

class _FilterListState extends State<FilterList> {
  TextEditingController controller = new TextEditingController();

  Allergens _allergens = new Allergens([]);
  Allergens _searchResult = new Allergens([]);
  List<String> _choices = [];


  @override
  void initState() {
    super.initState();
    _loadChoices();
    _getAllergens();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
        elevation: 0.0,
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).accentColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },),
                ),
              ),
            ),
          ),
          new Expanded(
            child: _searchResult.allergens.length != 0 || controller.text.isNotEmpty
                ? new ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              itemCount: _searchResult.allergens.length,
              itemBuilder: (context, index) {
                Allergen tmp = _searchResult.allergens.elementAt(index);
                return new Card(
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
            ) : Text("da")
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.allergens.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _allergens.allergens.forEach((allergen) {
      if (allergen.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.allergens.add(allergen);
    });

    setState(() {});
  }

  _getAllergens() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<dynamic> jsonList = prefs.getStringList('allergens') ?? [];

    _allergens.allergens = jsonList.map((json) => Allergen.fromJson(jsonDecode(json))).toList();
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
      if (val){
        if(!_choices.contains(id)) _choices.add(id);
      }
      else
        _choices.remove(id);
      prefs.setStringList('choices', _choices);
    });

    //print("CHOICES: " + _choices.toString());
  }
}