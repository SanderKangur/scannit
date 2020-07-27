import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';
import 'package:scannit/data/database.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/user.dart';
import 'package:scannit/pages/account/info_list.dart';
import 'package:scannit/pages/account/info_tile.dart';
import 'package:scannit/pages/dialogs/dialog_util.dart';
import 'package:scannit/pages/loading.dart';

import '../../constants.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    print("hello account");
    print('UUID in account' + Constants.userId);

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
                  colors: [
                Colors.lightGreen[100],
                Colors.white
              ])),
          child: StreamBuilder<Info>(
            stream: DatabaseService(uid: Constants.userId).testInfoStream(Constants.userId),
            builder: (context, snapshot){
              if (!snapshot.hasData) return Text("No data");

                return Container(
                  child: ListView.builder(
                    itemCount: snapshot.data.allergens.length,
                    itemBuilder: (context, index) {
                      return Text(snapshot.data.allergens[index]);
                    },
                  ),
                );
              }
            ),
        ),
          /*FutureBuilder(
              builder: (context, projectSnap) {
                if (projectSnap.connectionState == ConnectionState.none &&
                    projectSnap.hasData == null) {
                  //print('project snapshot data is: ${projectSnap.data}');
                  return LoadingIndicator();
                }
                if(projectSnap.connectionState == ConnectionState.done ) {
                  print('DATA:' + projectSnap.data.name);
                  return Container(
                      child: ListView.builder(
                        itemCount: projectSnap.data.allergens.length,
                        itemBuilder: (context, index) {
                          return Text(projectSnap.data.allergens[index]);
                        },
                      ),
                  );//(projectSnap.data.allergens[0])));
                }
                else
                      return LoadingIndicator();

              },
              future: new DatabaseService().testInfo(Constants.userId)),
        ),*/
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightGreen[300],
          child: Icon(Icons.add),
          onPressed: () {
            DialogUtil.showAddIngredientDialog(context);
          },
        ));
  }
}
