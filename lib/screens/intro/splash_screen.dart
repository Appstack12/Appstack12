
import 'package:fit_for_life/screens/intro/index.dart';
import 'package:flutter/material.dart';

import '../../services/shared_preferences.dart';
import '../bottom_navigation/index.dart';
import '../route/index.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  void navigate() async{
    await Future.delayed(const Duration(seconds: 2));
    final isUserRegistered = await SharedPreference.getString('isUserRegistered');
    final token = await SharedPreference.getString('token');

    if (token.isNotEmpty && isUserRegistered == 'true') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const BottomNavigation()));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (_) => const IntroScreen()));

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image(image: AssetImage('assets/images/heart.png'),width: 200,height: 200,),
          ),
        ],
      ),
    );
  }
}