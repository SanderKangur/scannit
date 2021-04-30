import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TutorialScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Text(
                  "2. Skaneeri etikett",
                  style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).accentColor
                  ),
                )
            ),
            SizedBox(height: 16,),
            Container(height: 400,
              child: Image.asset('assets/tutorial/tutorial_scan.jpg',
                  fit: BoxFit.fitHeight),
            )
          ],
        ),
      ),
    );
  }
}