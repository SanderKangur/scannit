import 'package:flutter/material.dart';
import 'package:scannit/constants.dart';
import 'package:translator/translator.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<void> translateElement(String word) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(word, from: 'en', to: 'es');
    setState(() {
      tmp = translation.toString();
    });
  }

  String tmp = "JESUS";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      // Setting floatHeaderSlivers to true is required in order to float
      // the outer slivers over the inner scrollable.
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: const Text('Floating Nested SliverAppBar'),
            floating: true,
            expandedHeight: 50.0,
            forceElevated: innerBoxIsScrolled,
            backgroundColor: const Color(0xff303952),
          ),
        ];
      },
      body: Container(
        child: Text(Constants.userAllergens.toString()),
      )
    ));
  }
}
