import 'package:closing_deal/constants/colors.dart';
import 'package:closing_deal/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../dashboard/dashboard.dart';
import '../homepage/homepage.dart';

class UploadSucessfulyPage extends StatefulWidget {
  const UploadSucessfulyPage({super.key});

  @override
  State<UploadSucessfulyPage> createState() => _UploadSucessfulyPageState();
}

class _UploadSucessfulyPageState extends State<UploadSucessfulyPage> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController Username = TextEditingController();
  final TextEditingController Emailadress = TextEditingController();
  String? _selectedValue;
  final TextEditingController _controller = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cWhiteColor,
        bottomOpacity: 0.4,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Image.asset(
          Images.LOGO,
          height: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Center(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Lottie.asset('assets/lottie/uploassucesfully.json')),
              ),
              SizedBox(
                height: 20.h,
              ),
              _isLoading
                  ? CircularProgressIndicator(
                      color: cPrimaryColor,
                    )
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                // Form is valid, proceed with submission

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DashBoard()),
                                );
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
                              'Done',
                              style: TextStyle(
                                  color: cWhiteColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
