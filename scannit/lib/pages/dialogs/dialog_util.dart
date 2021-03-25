import 'package:flutter/material.dart';
import 'package:scannit/pages/dialogs/add_allergen_dialog.dart';
import 'package:scannit/pages/dialogs/scan_fail_dialog.dart';
import 'package:scannit/pages/dialogs/scan_success_dialog.dart';
import 'package:scannit/pages/dialogs/scan_warning_dialog.dart';

class DialogUtil {
  static void showAddAllergenDialog(BuildContext context) {
    Future.delayed(Duration.zero, () {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AddAllergenDialog(),
      );
    });
  }

  static void showScanSuccessDialog(BuildContext context) {
    Future.delayed(Duration.zero, () {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ScanSuccessDialog(),
      );
    });
  }

  static void showScanFailDialog(BuildContext context, String foundAllergens) {
    Future.delayed(Duration.zero, () {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ScanFailDialog(foundAllergens),
      );
    });
  }

  static void showScanWarningDialog(BuildContext context) {
    Future.delayed(Duration.zero, () {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ScanWarningDialog(),
      );
    });
  }
}
