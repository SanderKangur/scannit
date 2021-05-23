import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Center(
        child: SpinKitDualRing(
          color: Color(0xff303952),
          size: 50.0,
        ),
      );
}
