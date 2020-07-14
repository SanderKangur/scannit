import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';

class SearchScreen extends StatelessWidget {
  final String name;

  SearchScreen({Key key, @required this.name}) : super(key: key);

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
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment(0, -0.9),
                child: Padding(
                  padding:EdgeInsets.symmetric(
                      horizontal: 10.0
                  ),
                  child:Container(
                    height: 1.0,
                    color: Colors.brown,),
                ),
              ),
              Center(
                  child: FloatingActionButton(
                    onPressed: (){},
                    backgroundColor: Colors.lightGreen[300],
                    child: Icon(Icons.search),
                  )),
            ],
          )
      ),
    );
  }
}