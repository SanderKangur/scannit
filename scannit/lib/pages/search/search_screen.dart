import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';

class SearchScreen extends StatelessWidget {

  SearchScreen({Key key}) : super(key: key);

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
                  colors: [Colors.lightGreen[200], Colors.white
                  ]
              )
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child:Container(
                  height: 1.0,
                  color: Colors.brown,
                ),
              ),
              Expanded(
                child: Container(
                    child: FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: Colors.lightGreen[300],
                      child: Icon(Icons.search),
                    )),
              ),
            ],
          )
      ),
    );
  }
}