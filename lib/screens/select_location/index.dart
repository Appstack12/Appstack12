// ignore_for_file: use_build_context_synchronously

import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/model/user.dart';
import 'package:fit_for_life/provider/user_provider.dart';
import 'package:fit_for_life/screens/select_veg_nonveg/index.dart';
import 'package:fit_for_life/services/user_services.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:fit_for_life/widgets/button.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userService = UserService();

class SelectLocationScreen extends ConsumerStatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  ConsumerState<SelectLocationScreen> createState() {
    return _SelectLocationScreenState();
  }
}

class _SelectLocationScreenState extends ConsumerState<SelectLocationScreen> {
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();
  String _enteredAddress = '';

  @override
  void initState() {
    super.initState();

    final userData = ref.read(userProvider) as User;
    setState(() {
      _enteredAddress = userData.address;
    });
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  void _onSubmit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    if (_enteredAddress == '') {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.enterAddress),
          showCloseIcon: true,
          closeIconColor: ColorCodes.white,
          backgroundColor: ColorCodes.red,
        ),
      );
      return;
    }

    final userData = ref.read(userProvider) as User;
    Map<String, dynamic> request = {};
    if (_enteredAddress != userData.address) {
      request['address'] = _enteredAddress;
      request['location'] = _enteredAddress;
    }

    if (request.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      final res = await userService.updateUserDetails(request);
      if (res['status']) {
        await ref.read(userProvider.notifier).onSaveUserData(res['data']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => const SelectVegNonvegScreen(),
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => const SelectVegNonvegScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Image.asset(
                  fit: BoxFit.fill,
                  'assets/images/map.png',
                  width: width,
                  height: height,
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.only(top: 0, bottom: bottom),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: width,
                        height: 104,
                        decoration: const BoxDecoration(
                          color: ColorCodes.darkGreen,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 46),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: _onGoBack,
                                child: Image.asset(
                                  'assets/images/arrowWhite.png',
                                  width: 27,
                                  height: 27,
                                ),
                              ),
                              const SizedBox(width: 33),
                              const Text(
                                '${Strings.whereFrom}?',
                                style: TextStyle(
                                  color: ColorCodes.white,
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 370),
                      Container(
                        width: 307,
                        height: 170,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorCodes.white,
                          border: Border.all(
                            color: ColorCodes.darkGrey,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: ColorCodes.blackWithOpacity,
                              blurStyle: BlurStyle.normal,
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 23,
                            horizontal: 23,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                Strings.currentLocation,
                                style: TextStyle(
                                  color: ColorCodes.lightBlack,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 13),
                              Form(
                                key: _form,
                                child: TextFormField(
                                  initialValue: _enteredAddress,
                                  scrollPadding: EdgeInsets.only(bottom: bottom - 170),
                                  cursorColor: ColorCodes.black,
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(),
                                    labelText: Strings.address,
                                    labelStyle: TextStyle(
                                      color: ColorCodes.black,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter a valid address.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredAddress = value!;
                                  },
                                ),
                              ),
                              // Row(
                              //   children: [
                              //     Image.asset(
                              //       'assets/images/pin.png',
                              //       width: 27,
                              //       height: 27,
                              //     ),
                              //     const SizedBox(width: 6),
                              //     const Text(
                              //       'QHUB, Jubilee Hills, Hydera...',
                              //       style: TextStyle(
                              //         color: ColorCodes.green,
                              //         fontSize: 16,
                              //         fontFamily: 'Poppins',
                              //         fontWeight: FontWeight.w400,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 17),
                      Button(
                        onPress: _onSubmit,
                        label: Strings.next,
                      ),
                    ],
                  ),
                ),
                // ),
              ],
            ),
          ),
        ),
        if (_isLoading) const Loader(),
      ],
    );
  }
}
