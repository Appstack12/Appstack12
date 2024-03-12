import 'package:closing_deal/constants/colors.dart';
import 'package:closing_deal/constants/images.dart';
import 'package:closing_deal/constants/navigation.dart';
import 'package:closing_deal/otppage/otppage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phonenumber = TextEditingController();
  bool _isLoading = false;

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor:cSecondryColor,
      //   bottomOpacity: 2,
      //   title: Image.asset(Images.LOGO,height: 25
      //   ,),
      // ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Image.asset(
                    Images.LOGO,
                    height: 40,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 70),
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
                              'Login',
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
                                Text(
                                  'Enter AgentCode',
                                  style: TextStyle(
                                      color: cBlackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: phonenumber,
                                  maxLength: 10,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter phone number';
                                    } else if (value.length < 10) {
                                      return 'Please enter a valid phone number';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Enter AgentCode',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: cBlackColor, // Border color
                                          width: 2.0, // Border widt
                                        ),
                                      )),
                                ),
                              ],
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
                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                            // Form is valid, proceed with submission
                                            String phoneNumber =
                                                phonenumber.text;
                                            print(
                                                'Phone number submitted: $phoneNumber');
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => OtpPage(
                                                      argument: phoneNumber)),
                                            );
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 40),
                                        decoration: BoxDecoration(
                                          color: cPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          border:
                                              Border.all(color: cPrimaryColor),
                                        ),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              color: cWhiteColor,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 40,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
