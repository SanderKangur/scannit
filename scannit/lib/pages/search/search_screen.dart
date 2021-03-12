import 'package:flutter/material.dart';
import 'package:scannit/constants.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key key}) : super(key: key);

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
          body: new ListView.builder(
            itemCount: Constants.userTypes['meat'].length,
            itemBuilder: (BuildContext context, int index) {
              String type = Constants.userTypes['meat'].keys.elementAt(index);
              return Container();
            },
          ),
        )
    );
  }
}