import 'package:flutter/material.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/allergens_entity.dart';

class AddAllergenDialog extends StatelessWidget {
  AddAllergenDialog();

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //User user = Provider.of<User>(context);
    //print("add ingredient " + user.uid);
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
          color: Colors.white,
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
              "Add allergen",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              "Please add item, that you would like to blacklist",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(hintText: 'Enter here allergen. '),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(
                    "CLOSE",
                    style: TextStyle(color: Color(0xff324558)),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    String text = textEditingController.value.text;
                    String id = "";
                    print("TEXT" + text);
                    if (text.isNotEmpty) {
                      id = "A${Constants.allergens.allergens.length}";
                      Allergen al = new Allergen(
                          id: id,
                          name: text.replaceAll(new RegExp("[,.:\n]"), ""),
                          category: Constants.categories.getId("Custom"));
                      await Constants.allergens.allergens.add(al);
                      print("len: " +
                          Constants.allergens.allergens.length.toString() +
                          " added id: " +
                          id);
                    }
                    Navigator.pop(context, id);
                  },
                  child: Text(
                    "ADD ALLERGEN",
                    style: TextStyle(color: Color(0xff324558)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
