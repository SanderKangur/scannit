import 'package:flutter/material.dart';

class BlogScreen extends StatefulWidget {
  BlogScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.3,
                    0.6,
                  ],
                  colors: [Colors.lightGreen[100], Colors.white
                  ]
              )
          ),
          child: Align(
            alignment: Alignment(0, -0.9),
            child: Padding(
              padding:EdgeInsets.symmetric(
                  horizontal: 10.0
              ),
              child:Container(
                height: 1.0,
                color: Colors.brown,),
            ),
          )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}