import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/widgets/otp_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OTPInput extends StatelessWidget {
  const OTPInput({
    super.key,
    this.length = 4,
    required this.onOTPSubmit,
    required this.onResendOtp,
  });

  final int length;
  final void Function(String verificationCode) onOTPSubmit;
  final void Function() onResendOtp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OtpTextField(
            numberOfFields: length,
            focusedBorderColor: ColorCodes.black,
            showFieldAsBox: true,
            borderWidth: 1,
            fieldWidth: 40,
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            borderRadius: BorderRadius.zero,
            cursorColor: ColorCodes.black,
            mainAxisAlignment: MainAxisAlignment.start,
            margin: const EdgeInsets.only(right: 6),
            onSubmit: (String verificationCode) =>
                onOTPSubmit(verificationCode)),
        const SizedBox(height: 31),
        OtpTimer(
          durationInSeconds: 20,
          onResendOtp: onResendOtp,
        )
      ],
    );
  }
}
