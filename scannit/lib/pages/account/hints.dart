import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Hints extends StatefulWidget {
  @override
  _HintsState createState() => _HintsState();
}

class _HintsState extends State<Hints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _resetChoices,
          icon: Icon(CupertinoIcons.delete,
          color: Theme.of(context).accentColor,)
          )
        ],
        title: Text(
          "Juhendid",
          style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).accentColor
          ),
        )
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 50,
            child: Card(
              elevation: 5,
              child: Center(
                  child: Text("Juhend ${index+1}")),
            ),
          );
        },
        separatorBuilder: (context, index) =>
        const SizedBox(height: 16.0),
      ),
    );
  }

  _resetChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isFirstTime', true);
      prefs.setStringList('allergens', []);
    });
  }
}