import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannit/data/database.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/user.dart';
import 'package:scannit/pages/account/info_tile.dart';


class InfoList extends StatefulWidget {
  @override
  _InfoListState createState() => _InfoListState();
}

class _InfoListState extends State<InfoList> {
  @override
  Widget build(BuildContext context) {

    final lists = Provider.of<List<Info>>(context);
    //User user = Provider.of<User>(context);

    if(lists == null) print("GGGGG");


    return ListView.builder(
      itemCount: lists.length,
      itemBuilder: (context, index) {
        return InfoTile(info: lists[index]);
      },
    );
  }

  Widget getTextWidgets(List<String> strings)
  {
    return new Row(children: strings.map((item) => new Text(item)).toList());
  }
}