import 'package:closing_deal/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


willpopAlert2(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(50),
        buttonPadding: EdgeInsets.all(50),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text('Are you sure you want to exit?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity(),
                  shape: StadiumBorder(),
                ),
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: cBlackColor),
                ),
              ),
             SizedBox(
              width: 15,
             ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    disabledForegroundColor: cWhiteColor),
                onPressed: () async {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  await dataClear();
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: cBlackColor,
                  ),
                ),
              )
            ],
          )
        ],
      );
    },
  );
}

Future<void> dataClear() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear all stored data
}