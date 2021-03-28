import 'package:flutter/material.dart';
import 'package:scannit/data/info_entity.dart';

class InfoTile extends StatelessWidget {
  final Info info;

  InfoTile({this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.yellow,
          ),
          title: Text("lmao"),
          subtitle: Text("info.allergens[0]"),
        ),
      ),
    );
  }
}
