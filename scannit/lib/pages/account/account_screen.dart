import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';
import 'package:scannit/data/info_repo.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/user.dart';
import 'package:scannit/data/user_repo.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              StreamBuilder<UserData>(
                  stream: UserRepo(uid: Constants.userId).testUserDataStream(Constants.userId),
                  builder: (context, snapshot){
                    if (!snapshot.hasData) return Text("No UserData");

                    return Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 50),
                            child: Center(
                              child: CircleAvatar(
                                radius: 80.0,
                                backgroundColor: Colors.white,
                                child: Text(snapshot.data.name[0],
                                  textScaleFactor: 5,
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ),
                            ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(snapshot.data.name,
                            textScaleFactor: 3,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    );
                  }
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 10),
                child: Text("My Allergens",
                  textScaleFactor: 2,
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              StreamBuilder<Info>(
                stream: InfoRepo(uid: Constants.userId).testInfoStream(Constants.userId),
                builder: (context, snapshot){
                  if (!snapshot.hasData) return Text("No data");

                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        child: ListView.builder(
                          itemCount: snapshot.data.allergens.length,
                          itemBuilder: (context, index) {
                            return Text(snapshot.data.allergens[index],
                              textScaleFactor: 1.5,
                              style: TextStyle(color: Colors.black45),);
                          },
                        ),
                      ),
                    );
                  }
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightGreen[300],
          child: Icon(Icons.add),
          onPressed: () {
            DialogUtil.showAddIngredientDialog(context);
          },
        ));
  }
}
