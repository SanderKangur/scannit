
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/allergens_entity.dart';
import 'package:scannit/data/categories_entity.dart';
import 'package:scannit/pages/allergens/show_allergens.dart';
import 'package:scannit/utils/add_allergen_dialog.dart';
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
  "FFe66767",
  "FFf5cd79",

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
  TextEditingController controller = new TextEditingController();

  List<String> _choices = [];
  Allergens _allergens = new Allergens([]);
  Allergens _searchResult = new Allergens([]);

  @override
  void initState() {
    super.initState();
    _loadChoices();
    _getAllergens();
  }

  @override
  Widget build(BuildContext context) {
    _getAllergens();
    return Container(
      child: Scaffold(
          backgroundColor: Theme.of(context).buttonColor,
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading: new Icon(
                    Icons.search,
                    color:  Theme.of(context).accentColor,),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Otsi...', border: InputBorder.none,),
                    onChanged: onSearchTextChanged,
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: new Icon(
                          Icons.cancel,
                          color: Theme.of(context).accentColor),
                        onPressed: () {
                        FocusScope.of(context).unfocus();
                        controller.clear();
                        onSearchTextChanged('');
                      },
                    ),
                  ],
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
            body: controller.text.isNotEmpty
                ? _searchResult.allergens.length != 0

            ///Search view///
                ? ListView.separated(
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
            ) : Column(
                  children: [
                    SizedBox(height: 26,),
                    Text(
                      "Allergeeni ei leitud andmebaasist!",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "Lisa allergeen andmebaasi: ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Card(
                    child: new CheckboxListTile(
                        activeColor: const Color(0xff324558),
                        title: new Text(controller.text),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: false,
                        onChanged: (bool val) async {
                          String text = controller.text;
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
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${controller.text} lisatud")));
                          controller.clear();
                          _updateChoices(id, true);
                          _getAllergens();
                        }),
            ),

              ///Normal view///
                    ),
                  ],
                ) : ListView(
                  children: [
                    SizedBox(height: 12,),
                    ExpansionTile(
                      /// Create the main allergen types
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white70,
                        collapsedTextColor: Colors.blueGrey,
                        title: Center(
                          child: Text(
                            "Valitud allergeene: ${_choices.length}",
                            style: TextStyle(
                                fontSize: 24
                            ),
                          ),
                        ),
                        children: [SizedBox(
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              itemCount: _allergens.getNames(_choices).length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index){
                                return Card(
                                  child: CheckboxListTile(
                                      activeColor: const Color(0xff596275),
                                      title: Text(_allergens.getNames(_choices)[index]),
                                      controlAffinity: ListTileControlAffinity.leading,
                                      value: true,
                                      onChanged: (bool val) {
                                        _updateChoices(_choices[index], val);
                                      }),
                                );
                              }
                          ),
                        )]
                    ),
                    ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    itemCount: 13,
                    itemBuilder: (context, index) {
                      return _buildArticleItem(index, context);
                    },
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 16.0),
              ),
                  ],
                ),
          ),
          //floatingActionButton: _addAllergenButton()
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

  Widget _buildArticleItem(int index, BuildContext context) {
    Color color = Color(int.parse(colors[index], radix: 16));
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
                  _getAllergens();
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
                    'assets/types/' + category.id + '.jpg',
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
                      Text(index == 0 ? _checkSubCategories() :
                        Constants.listToString(_allergens
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

  Widget _addAllergenButton(){
    return FloatingActionButton(
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
            };
            _updateChoices(id, true);
            _getAllergens();
          });
        }
      },
      child: Icon(Icons.add),
    );
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

  _checkSubCategories() {
    List<String> list = [];
    Constants.categories.getSubCategories().forEach((element) {
      if(_checkSubAllergens(element.id)) list.add(element.name);
    });
    return Constants.listToString(list);
  }

  bool _checkSubAllergens(String catId){
    for(int i = 0; i<_allergens.allergens.length; i++){
      if(_allergens.allergens[i].category.split(", ").contains(catId)){
        if(!_choices.contains(_allergens.allergens[i].id)) return false;
      }
    }
    return true;
  }
}
