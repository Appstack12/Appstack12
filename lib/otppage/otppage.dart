import 'package:closing_deal/Loginpage/loginpage.dart';
import 'package:closing_deal/constants/colors.dart';
import 'package:closing_deal/dashboard/dashboard.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:overlay_toast_message/overlay_toast_message.dart';

class OtpPage extends StatefulWidget {
  final dynamic argument;
  OtpPage({required this.argument});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  OtpFieldController otpController = OtpFieldController();

  bool _isLoading = false;

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
            )),
        centerTitle: true,
        title: Text(
          'Otp Verification',
          style: TextStyle(
              color: cBlackColor, fontSize: 16, fontWeight: FontWeight.w600),
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
                    borderRadius: BorderRadius.circular(30)),
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
                      ]),
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
                            fontWeight: FontWeight.w700),
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Recieved Otp',
                              style: TextStyle(
                                  color: cBlackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Column(
                          children: [
                            OTPTextField(
                              controller: otpController,
                              length: 5,
                              width: MediaQuery.of(context).size.width,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldWidth: 45,
                              fieldStyle: FieldStyle.box,
                              outlineBorderRadius: 15,
                              style: TextStyle(fontSize: 17),
                              onChanged: (pin) {
                                print("Changed: " + pin);
                              },
                              onCompleted: (pin) {
                                print("Completed: " + pin);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
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
                                              fontWeight: FontWeight.w500),
                                          textMessage: 'Enter Correct otp',
                                        );

                                        print('Enter correct otp');
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DashBoard()),
                                        );
                                      }
                                      otpController.clear();
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 40),
                                  decoration: BoxDecoration(
                                    color: cPrimaryColor,
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(color: cPrimaryColor),
                                  ),
                                  child: Text(
                                    'Otp',
                                    style: TextStyle(
                                        color: cWhiteColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 30,
                      )
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
