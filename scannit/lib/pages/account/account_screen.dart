import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/info_repo.dart';
import 'package:scannit/data/user.dart';
import 'package:scannit/data/user_repo.dart';
import 'package:scannit/pages/dialogs/dialog_util.dart';

import '../../constants.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    print('UUID in account' + Constants.userId);

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
                colors: [
              Colors.lightGreen[100],
              Colors.white
            ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Container(
                height: 1.0,
                color: Colors.brown,
              ),
            ),
            StreamBuilder<UserData>(
                stream: UserRepo(uid: Constants.userId)
                    .testUserDataStream(Constants.userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text("No UserData");

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            AuthenticationLoggedOut(),
                          );
                        },
                        elevation: 5.0,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.exit_to_app,
                          size: 30.0,
                          color: Colors.black54,
                        ),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                      )
                    ],
                  );
                }),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30, left: 10),
                  child: Text(
                    "My Allergens",
                    textScaleFactor: 2,
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    DialogUtil.showAddAllergenDialog(context);
                  },
                  elevation: 5.0,
                  fillColor: Colors.white,
                  child: Icon(
                    Icons.edit,
                    size: 20.0,
                    color: Colors.black54,
                  ),
                  padding: EdgeInsets.all(5.0),
                  shape: CircleBorder(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
