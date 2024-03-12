import 'package:fit_for_life/screens/bottom_navigation/index.dart';
import 'package:fit_for_life/screens/intro/index.dart';
import 'package:fit_for_life/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteScreen extends ConsumerStatefulWidget {
  const RouteScreen({
    super.key,
  });

  @override
  ConsumerState<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends ConsumerState<RouteScreen> {
  Widget _initialRoute = const IntroScreen();

  @override
  void initState() {
    super.initState();
    setInitialRoute();
  }

  void setInitialRoute() async {
    final isUserRegistered = await SharedPreference.getString('isUserRegistered');
    final token = await SharedPreference.getString('token');

    if (token.isNotEmpty && isUserRegistered == 'true') {
      setState(() {
        _initialRoute = const BottomNavigation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _initialRoute;
  }
}
