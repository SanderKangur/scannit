// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';

enum Detector {
  text,
}


// Paints rectangles around all the text in the image.
class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.visionText, this.choices);

  final Size absoluteImageSize;
  final VisionText visionText;
  final List<String> choices;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextContainer container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final TextBlock block in visionText.blocks) {
      for (final TextLine line in block.lines) {
        for (final TextElement element in line.elements) {
          choices.forEach((choice) {
            String c = choice.toLowerCase();
            String e = element.text.toLowerCase();
            double threshold = 0;
            if(e.length>5) threshold = 0.6;
            else threshold = 0.8;
            double similarity =e.similarityTo(c);
            //print(element + ": " + similarity.toString());
            if (similarity > threshold || e.contains(c)) {
              paint.color = Colors.red;
              canvas.drawRect(scaleRect(element), paint);
            };
          });
        }
      }
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize == absoluteImageSize || oldDelegate.visionText == visionText;
  }
}