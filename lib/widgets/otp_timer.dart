import 'dart:async';
import 'package:fit_for_life/color_codes/index.dart';
import 'package:flutter/material.dart';
import 'package:fit_for_life/strings/index.dart';

class OtpTimer extends StatefulWidget {
  const OtpTimer({
    super.key,
    required this.durationInSeconds,
    required this.onResendOtp,
  });

  final int durationInSeconds;
  final void Function() onResendOtp;

  @override
  State<OtpTimer> createState() {
    return _OtpTimerState();
  }
}

class _OtpTimerState extends State<OtpTimer> {
  late Timer _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = widget.durationInSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    String minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    String sec = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$sec';
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingSeconds == 0) {
      return TextButton(
        onPressed: () {
          _startTimer();
          widget.onResendOtp();
        },
        child: const Text(
          Strings.resendCode,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: ColorCodes.black,
          ),
        ),
      );
    }

    return Text(
      '${Strings.resendCode}  ${_formatTime(_remainingSeconds)}',
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
          color: ColorCodes.grey),
    );
  }
}
