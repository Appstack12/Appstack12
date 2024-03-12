import 'package:fit_for_life/color_codes/index.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPress,
    required this.label,
    this.showLoader = false,
    this.width = 280,
    this.topLeftBorderRadius = 60,
    this.topRightBorderRadius = 60,
    this.bottomLeftBorderRadius = 60,
    this.bottomRightBorderRadius = 60,
    this.paddingVertical = 12,
    this.color = ColorCodes.green,
    this.fontSize = 22,
    this.disabled = false,
  });

  final void Function() onPress;
  final String label;
  final bool showLoader;
  final double width;
  final double topLeftBorderRadius;
  final double topRightBorderRadius;
  final double bottomLeftBorderRadius;
  final double bottomRightBorderRadius;
  final double paddingVertical;
  final Color color;
  final double fontSize;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    if (showLoader) {
      return const Center(
        child: CircularProgressIndicator(
          color: ColorCodes.darkGreen,
        ),
      );
    }

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: disabled ? () {} : onPress,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topLeftBorderRadius),
                topRight: Radius.circular(topRightBorderRadius),
                bottomLeft: Radius.circular(bottomLeftBorderRadius),
                bottomRight: Radius.circular(bottomRightBorderRadius),
              ),
            ),
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
              vertical: paddingVertical,
            ),
          ),
          backgroundColor: MaterialStatePropertyAll(color),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: ColorCodes.white.withOpacity(disabled ? 0.5 : 1),
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
