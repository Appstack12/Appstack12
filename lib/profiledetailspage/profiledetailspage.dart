import 'dart:io';

import 'package:closing_deal/Loginpage/loginpage.dart';
import 'package:closing_deal/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../constants/images.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  @override
  SharedPreferences? _prefs;
  File? _image;
  String? img;

  Future<void> _saveImagePath(String imagePath) async {
    await _prefs?.setString('imagePath', imagePath);
    setState(() {
      img = imagePath;
    });
  }
  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    img = _prefs?.getString('imagePath') ?? '';
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
    @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipPath(
                clipper: BottomCurveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: cPrimaryColor,
                    border: Border.all(color: cPrimaryColor),
                  ),
                ),
              ),
              Positioned(
                left: 7,
                top: 22,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: cBlackColor,
                      size: 25,
                    )),
              ),
              Positioned(
                left: 32.w,
                top: 24.h,
                child: Center(
                  child: Container(
                    width: 115,
                    height: 115,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                Images.BUILDING,
                                fit: BoxFit.cover,
                              )),
                  ),
                ),
              ),
              Positioned(
                left: 57.w,
                top: 32.h,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Choose from Gallery'),
                                onTap: () {
                                  getImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Take a Picture'),
                                onTap: () {
                                  getImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: cWhiteColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Icon(
                        Icons.edit,
                        color: cBlackColor,
                        size: 25,
                      )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: cBlackColor,
              size: 35,
            ),
            title: Text(
              'Gopichand',
              style: TextStyle(
                  color: cBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          ListTile(
            leading: Icon(
              Icons.email,
              color: cBlackColor,
              size: 35,
            ),
            title: Text(
              'gopichand@gmail.com',
              style: TextStyle(
                  color: cBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          SizedBox(
            height: 7,
          ),
          ListTile(
            leading: Icon(
              Icons.numbers,
              color: cBlackColor,
              size: 35,
            ),
            title: Text(
              '9912198002',
              style: TextStyle(
                  color: cBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Logout Confirmation'),
                    content: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        ); // Close the dialog
                      },
                      leading: Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: 35,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            },
            leading: Icon(
              Icons.logout,
              color: cBlackColor,
              size: 35,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                  color: cBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
