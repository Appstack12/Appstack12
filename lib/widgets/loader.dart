import 'package:fit_for_life/color_codes/index.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    this.color = ColorCodes.darkGreen,
    this.bgColor = ColorCodes.black,
    this.opacity = 0.25,
  });

  final Color color;
  final Color bgColor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: opacity,
          child: ModalBarrier(
            dismissible: false,
            color: bgColor,
          ),
        ),
        Center(
          child: CircularProgressIndicator(
            color: color,
          ),
        ),
      ],
    );
  }
}
