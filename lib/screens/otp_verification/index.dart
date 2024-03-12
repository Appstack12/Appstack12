// ignore_for_file: use_build_context_synchronously

import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/provider/user_provider.dart';
import 'package:fit_for_life/screens/add_profile/index.dart';
import 'package:fit_for_life/screens/bottom_navigation/index.dart';
import 'package:fit_for_life/services/shared_preferences.dart';
import 'package:fit_for_life/services/user_services.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:fit_for_life/widgets/otp_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_for_life/strings/index.dart';

final userService = UserService();

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.mobileNumber,
    required this.email,
    required this.countryCode,
    required this.isLogin,
  });

  final String mobileNumber;
  final String email;
  final String countryCode;
  final bool isLogin;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _OtpVerificationScreenState();
  }
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  bool _isLoading = false;

  void _onGoBack() {
    Navigator.pop(context);
  }

  bool isUserRegistered(user) {
    final checkFalseyValue = ['', null, 0, false];

    return (!checkFalseyValue.contains(user['first_name']) &&
        !checkFalseyValue.contains(user['last_name']) &&
        !checkFalseyValue.contains(user['gender']) &&
        !checkFalseyValue.contains(user['location']) &&
        !checkFalseyValue.contains(user['address']) &&
        !checkFalseyValue.contains(user['email']) &&
        !checkFalseyValue.contains(user['date_of_birth']) &&
        !checkFalseyValue.contains(user['age']) &&
        !checkFalseyValue.contains(user['height']) &&
        !checkFalseyValue.contains(user['weight']) &&
        // !checkFalseyValue.contains(user['health_issue']) &&
        // !checkFalseyValue.contains(user['any_medication']) &&
        !checkFalseyValue.contains(user['veg_nonveg']) &&
        !checkFalseyValue.contains(user['profession'])) ;
        // &&
        // !checkFalseyValue.contains(user['help']));
  }

  onOTPSubmit(String verificationCode) async {
    final request = {
      'otp': int.tryParse(verificationCode),
      "phone_number": widget.mobileNumber,
      "email": widget.email,
      "country_code": widget.countryCode,
    };

    final res = await userService.verifyOtp(request);

    if (res.isNotEmpty) {
      final user = res['data'];
      print("useruser ${user}");
      await ref.read(userProvider.notifier).onSaveUserData(user);

      await SharedPreference.setString('token', res['data']['token']);
      if (widget.isLogin && isUserRegistered(user)) {
        await SharedPreference.setString('isUserRegistered', 'true');

        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const BottomNavigation();
            },
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => const AddProfileScreen(),
          ),
        );
      }
    }
  }

  void _onResendOtp() async {
    setState(() {
      _isLoading = true;
    });

    final request = {
      "phone_number": widget.mobileNumber,
      "email": widget.email,
      "country_code": widget.countryCode,
    };
    final res = await userService.sendOtp(request);
    if (res.isNotEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.otpSent),
          showCloseIcon: true,
          closeIconColor: ColorCodes.white,
          backgroundColor: ColorCodes.green,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 64),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _onGoBack,
                        child: Image.asset(
                          'assets/images/backArrow.png',
                          width: 49,
                          height: 49,
                        ),
                      ),
                      Image.asset(
                        'assets/images/patternBg.png',
                        width: 254,
                        height: 112,
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/heart.png',
                      width: 180,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    Strings.verification,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: ColorCodes.lightBlack,
                    ),
                  ),
                  const SizedBox(
                    width: 271,
                    child: Text(
                      Strings.sentSms,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: ColorCodes.lightBlack,
                      ),
                    ),
                  ),
                  const SizedBox(height: 38),
                  OTPInput(
                    onOTPSubmit: onOTPSubmit,
                    length: 6,
                    onResendOtp: _onResendOtp,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) const Loader()
      ],
    );
  }
}
