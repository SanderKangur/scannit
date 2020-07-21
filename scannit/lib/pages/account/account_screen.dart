import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';
import 'package:scannit/data/database.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/user.dart';
import 'package:scannit/pages/account/info_list.dart';
import 'package:scannit/pages/dialogs/dialog_util.dart';


class AccountScreen extends StatefulWidget {
  AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>{

  @override
  Widget build(BuildContext context) {

    print("hello account");
    User user = Provider.of<User>(context);
    print(user.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Colors.lightGreen[200],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationLoggedOut(),
              );
            },
          )
        ],
      ),
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
        child: InfoList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen[300],
        child: Icon(Icons.add),
        onPressed: (){
          DialogUtil.showAddIngredientDialog(context);
        },
      )
    );
  }
}