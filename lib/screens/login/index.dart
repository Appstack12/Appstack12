// ignore_for_file: use_build_context_synchronously

import 'package:country_code_picker/country_code_picker.dart';
import 'package:fit_for_life/constants/index.dart';
import 'package:fit_for_life/screens/otp_verification/index.dart';
import 'package:fit_for_life/services/user_services.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:flutter/material.dart';

import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/widgets/button.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userService = UserService();
bool debugMode = false;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key, this.showBackButton = true}) : super(key: key);

  final bool showBackButton;

  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController(text: '');
  String _enteredPhoneNumber = '';
  String _enteredCountryCode = '+91';
  String _enteredEmail = debugMode ? 'test.fit@yopmail.com' : '';
  bool _isAgreeTnC = false;
  bool _isLoading = false;
  bool _isLogin = true;

  void _onGoBack() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
  }

  void _onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = _form.currentState!.validate();
    if (!isValid || !_isAgreeTnC) {
      return;
    }

    _form.currentState!.save();

    final request = {
      "phone_number": _enteredPhoneNumber,
      "email": _enteredEmail,
      "country_code": _enteredCountryCode,
    };
    setState(() {
      _isLoading = true;
    });
    final res = await userService.sendOtp(request);
    if (res.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => OtpVerificationScreen(
            mobileNumber: _enteredPhoneNumber,
            email: _enteredEmail,
            countryCode: _enteredCountryCode,
            isLogin: _isLogin,
          ),
        ),
      );

      _form.currentState!.reset();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildHeaderText() {
    return Text(
      _isLogin ? Strings.login : Strings.signUp,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 30,
        fontWeight: FontWeight.w500,
        color: ColorCodes.lightBlack,
      ),
    );
  }

  Widget _buildHeartImage() {
    return Container(
      margin: const EdgeInsets.only(top: 22),
      alignment: Alignment.topLeft,
      child: Image.asset(
        'assets/images/heart.png',
        width: 180,
        height: 80,
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Text(
      Strings.welcome,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: ColorCodes.lightBlack,
      ),
    );
  }

  Widget _buildProvidePhoneText() {
    return const SizedBox(
      width: 271,
      child: Text(
        Strings.providePhone,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: ColorCodes.lightBlack,
        ),
      ),
    );
  }

  Widget _buildPhoneNumberFormField() {
    return SizedBox(
      width: 266,
      child: Form(
        key: _form,
        child: Column(
          children: [
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              cursorColor: ColorCodes.black,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(),
                labelText: Strings.phoneNumber,
                labelStyle: const TextStyle(
                  color: ColorCodes.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
                prefixIcon: SizedBox(
                  width: 130,
                  child: CountryCodePicker(
                    onChanged: (code) {
                      setState(() {
                        _enteredCountryCode = code.name ?? '';
                      });
                    },
                    initialSelection: _enteredCountryCode,
                    showOnlyCountryWhenClosed: false,
                    showFlagMain: false,
                    alignLeft: true,
                    showDropDownButton: true,
                    textStyle: const TextStyle(
                      color: ColorCodes.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              initialValue: debugMode ? "7904128387" : '',
              validator: (value) {
                String patttern = Constants.mobileRegex;
                RegExp regExp = RegExp(patttern);
                if (value == null || value.trim().isEmpty || !regExp.hasMatch(value)) {
                  return 'Please enter a valid phone number.';
                }
                return null;
              },
              onSaved: (value) {
                _enteredPhoneNumber = value!;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              initialValue: _enteredEmail,
              scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              cursorColor: ColorCodes.black,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(),
                labelText: Strings.email,
                labelStyle: TextStyle(
                  color: ColorCodes.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
                contentPadding: EdgeInsets.only(bottom: 5),
              ),
              validator: (value) {
                String patttern = Constants.emailRegexEx;
                RegExp regExp = RegExp(patttern);
                if (value == null || value.trim().isEmpty || !regExp.hasMatch(value)) {
                  return Strings.validEmail;
                }
                return null;
              },
              onSaved: (value) {
                _enteredEmail = value!;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndPrivacyText() {
    return SizedBox(
      width: 253,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isAgreeTnC = !_isAgreeTnC;
              });
            },
            child: Icon(
              _isAgreeTnC ? Icons.check_box : Icons.check_box_outline_blank,
              color: ColorCodes.lightGrey,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: Strings.continueIndicate,
                    children: [
                      TextSpan(
                        text: ' ${Strings.privacyPolicy}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ColorCodes.grey,
                        ),
                        children: [
                          TextSpan(
                            text: ' ${Strings.and}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: ColorCodes.grey,
                            ),
                            children: [
                              TextSpan(
                                text: ' ${Strings.terms}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: ColorCodes.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: ColorCodes.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 64, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.showBackButton)
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
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 0, bottom: bottom),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderText(),
                            _buildHeartImage(),
                            const SizedBox(height: 16),
                            _buildWelcomeText(),
                            _buildProvidePhoneText(),
                            const SizedBox(height: 28),
                            _buildPhoneNumberFormField(),
                            const SizedBox(height: 35),
                            _buildTermsAndPrivacyText(),
                            const SizedBox(height: 29),
                            Button(
                              onPress: _onSubmit,
                              label: _isLogin ? Strings.login : Strings.signUp,
                            ),
                            const SizedBox(height: 17),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: _isLogin ? 33 : 23),
                                child: RichText(
                                  text: TextSpan(
                                    text: '${!_isLogin ? Strings.alreadyHaveAccount : Strings.dontHaveAccount}? ',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: ColorCodes.grey,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: _isLogin ? Strings.signUpHere : Strings.loginHere,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: ColorCodes.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) const Loader()
        ],
      ),
    );
  }
}
