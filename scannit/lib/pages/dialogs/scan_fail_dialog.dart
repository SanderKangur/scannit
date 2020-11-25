import 'package:flutter/material.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/info_entity.dart';
import 'package:scannit/data/info_repo.dart';
import 'package:scannit/pages/loading.dart';

class ScanFailDialog extends StatelessWidget {
  ScanFailDialog();

  @override
  Widget build(BuildContext context) {
    //User user = Provider.of<User>(context);
    //print("add ingredient " + user.uid);

    return StreamBuilder<Info>(
        stream: InfoRepo(uid: Constants.userId).infoStream(Constants.userId),
        builder: (context, snapshot) {
          print(snapshot.hasData);
          if (snapshot.hasData) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Consts.padding),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.only(
                  top: Consts.avatarRadius - Consts.padding,
                  bottom: Consts.padding,
                  left: Consts.padding,
                  right: Consts.padding,
                ),
                margin: EdgeInsets.only(top: Consts.avatarRadius),
                decoration: new BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(Consts.padding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Text(
                      "SCAN FAILED",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "YOU WILL DIE!!!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // To close the dialog
                      },
                      child: Text(
                        "CLOSE",
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else
            return LoadingIndicator();
        });
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
