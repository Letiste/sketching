import 'package:flutter/material.dart';

class MyPaint extends Paint {
  MyPaint({required Color color, required double strokeWidth, required BlendMode blendMode})
      : super() {
    style = PaintingStyle.stroke;
    strokeCap = StrokeCap.round;
    this.color = color;
    this.strokeWidth = strokeWidth;
    this.blendMode = blendMode;
  }

  factory MyPaint.fromJson(Map<String, dynamic> json) {
    return MyPaint(
      color: Color(json['color']),
      strokeWidth: json['strokeWidth'],
      blendMode: BlendMode.values[json['blendMode']],
    );
  }

  Map<String, dynamic> toJson() =>
      {'color': color.value, 'strokeWidth': strokeWidth, 'blendMode': blendMode.index};
}
