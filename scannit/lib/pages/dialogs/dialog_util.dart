import 'package:flutter/material.dart';
import 'package:scannit/pages/dialogs/add_ingredinet_dialog.dart';

class DialogUtil {

  static void showAddIngredientDialog(BuildContext context) {
    Future.delayed(Duration.zero, () {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AddIngredientDialog(),
      );
    });
  }
}
