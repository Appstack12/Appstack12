import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:overlay_toast_message/overlay_toast_message.dart';

import '../constants/colors.dart';
import '../dashboard/dashboard.dart';

class OtpPage extends StatefulWidget {
  final dynamic argument;
  OtpPage({required this.argument});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  // 2 minutes in seconds

  bool _isLoading = false;
  final FocusNode _otpFocusNode = FocusNode();

  Timer? _timer;
  int _seconds = 10;
  bool _timerCompleted = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer?.cancel();
          _timerCompleted = true;
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _seconds = 10; // Reset the timer duration
      _timerCompleted = false;
    });
    _startTimer(); // Start the timer again
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: cBlackColor,
            size: 25,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Otp Verification',
          style: TextStyle(
            color: cBlackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: cWhiteColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/agent.json',
                        width: MediaQuery.of(context).size.width *
                            0.8, // Adjust the width as needed
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Center(
                        child: Text(
                          'Otp Verification',
                          style: TextStyle(
                            color: cBlackColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Send Otp To ********${widget.argument.toString().substring(widget.argument.toString().length - 2)}', // Display the argument
                              style: TextStyle(
                                color: cBlackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        child: Column(
                          children: [
                            OTPTextField(
                              length: 5,
                              width: MediaQuery.of(context).size.width,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldWidth: 45,
                              fieldStyle: FieldStyle.box,
                              controller: otpController,
                              outlineBorderRadius: 15,
                              style: TextStyle(fontSize: 17),
                              onChanged: (pin) {
                                print("Changed: " + pin);
                              },
                              onCompleted: (pin) {
                                print("Completed: " + pin);
                                if (pin.length != 5) {
                                  OverlayToastMessage.show(
                                    context,
                                    backgroundColor: Colors.red,
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textMessage: 'Enter Correct OTP',
                                  );
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  Future.delayed(Duration(seconds: 1), () {
                                    // Your verification logic here
                                    // For demonstration purposes, I'm navigating to the dashboard directly
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DashBoard(),
                                      ),
                                    );
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      _isLoading
                          ? CircularProgressIndicator(
                              color: cPrimaryColor,
                            )
                          : Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    Future.delayed(Duration(seconds: 1), () {
                                      if (otpController.toString().length !=
                                          5) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        OverlayToastMessage.show(
                                          context,
                                          backgroundColor: Colors.red,
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textMessage: 'Enter Correct OTP',
                                        );
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DashBoard(),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 40,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cPrimaryColor,
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(color: cPrimaryColor),
                                  ),
                                  child: Text(
                                    'Verify OTP',
                                    style: TextStyle(
                                      color: cWhiteColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: _timerCompleted
                            ? () {
                                _resetTimer();
                              }
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 40,
                          ),
                          decoration: BoxDecoration(
                            color: cPrimaryColor,
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(color: cPrimaryColor),
                          ),
                          child: Text(
                            _timerCompleted
                                ? 'Resend otp'
                                : '$_seconds seconds',
                            style: TextStyle(
                              color: cWhiteColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
