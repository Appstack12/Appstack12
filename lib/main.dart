import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:closing_deal/Loginpage/loginpage.dart';
import 'package:closing_deal/constants/colors.dart';
import 'package:closing_deal/constants/images.dart';
import 'package:closing_deal/homepage/homepage.dart';
import 'package:closing_deal/otppage/otppage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'dashboard/dashboard.dart';
import 'profiledetailspage/profiledetailspage.dart';
import 'seedetailspage/seedetailspage.dart';
import 'uploadagentproperty/uploadagentpropert.dart';
import 'uploadagentproperty/uploadvedio.dart';
import 'userdetailspage/userdetailspage.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, Orientation, DeviceType) {
        return GetMaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: AnimatedSplashScreen(
                duration: 3000,
                splash: Images.LOGO,
                nextScreen: LoginPage(),
                splashTransition: SplashTransition.fadeTransition,
                // pageTransitionType: PageTransitionType.scale,
                backgroundColor: cWhiteColor));
      },
    );
  }
}
