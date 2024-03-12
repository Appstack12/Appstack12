// ignore_for_file: use_build_context_synchronously

import 'package:fit_for_life/model/user.dart';
import 'package:fit_for_life/provider/user_provider.dart';
import 'package:fit_for_life/screens/select_height/index.dart';
import 'package:fit_for_life/services/user_services.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:fit_for_life/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/widgets/button.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:numberpicker/numberpicker.dart';

final userService = UserService();

class AddProfileScreen extends ConsumerStatefulWidget {
  const AddProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddProfileScreen> createState() {
    return _AddProfileScreenState();
  }
}

class _AddProfileScreenState extends ConsumerState<AddProfileScreen> {
  bool _isLoading = false;
  bool _isImageLoading = false;
  final _form = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  String _enteredFirstName = '';
  String _enteredLastName = '';
  String _selectedImage = '';
  int _enteredAge = 10;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    // final userData = ref.read(userProvider) as User;
    // setState(() {
    //   _enteredFirstName = userData.firstName;
    //   _enteredLastName = userData.lastName;
    //   _selectedImage = userData.image;
    //   _selectedDate = DateFormat('dd/MM/yyyy').parse(userData.dob);
    //   _enteredAge = userData.age;
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  void _onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final userData = ref.read(userProvider) as User;
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    if (_selectedDate != null) {
      Map<String, dynamic> request = {};
      if (_enteredFirstName != userData.firstName || _enteredFirstName == '') {
        request['first_name'] = _enteredFirstName;
      }
      if (_enteredLastName != userData.lastName || _enteredLastName == '') {
        request['last_name'] = _enteredLastName;
      }
      if (_selectedImage != userData.image && _selectedImage.isNotEmpty) {
        request['image_url'] = _selectedImage;
      }
      if (_enteredAge != userData.age) {
        request['age'] = _enteredAge;
      }
      request['date_of_birth'] = DateFormat('dd/MM/yyyy').format(_selectedDate!);

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
              builder: (ctx) => const SelectHeightScreen(),
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
            builder: (ctx) => const SelectHeightScreen(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.selectDob),
          showCloseIcon: true,
          closeIconColor: ColorCodes.white,
          backgroundColor: ColorCodes.red,
        ),
      );
    }
  }

  void _onPickImage(String pickedImage) {
    _selectedImage = pickedImage;
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, now.month, now.day);

    /*final pickedDate = await showMonthYearPicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: now,
    );*/

    final pickedDate = await showMonthPicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: now
    );

    DateTime dob = pickedDate ?? DateTime.now();
    Duration dur = DateTime.now().difference(dob);
    int differenceInYears = (dur.inDays / 365).floor().toInt();
    if (differenceInYears >= 10 && differenceInYears <= 90) {
      setState(() {
        _enteredAge = differenceInYears;
      });
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Widget _buildProfile() {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          UserImagePicker(
            onPickImage: _onPickImage,
            isLoading: (loading) => setState(() {
              _isImageLoading = loading;
            }),
            image: _selectedImage,
          ),
          Image.asset(
            'assets/images/add.png',
            height: 26,
            width: 26,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Text(
      Strings.hereGo,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: ColorCodes.lightBlack,
      ),
    );
  }

  Widget _buildProvideText() {
    return const SizedBox(
      width: 251,
      child: Text(
        Strings.provideName,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: ColorCodes.lightBlack,
        ),
      ),
    );
  }

  Widget _buildFormField() {
    return SizedBox(
      width: 306,
      child: Form(
        key: _form,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _enteredFirstName,
                    scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    cursorColor: ColorCodes.black,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(),
                      labelText: Strings.firstName,
                      labelStyle: TextStyle(
                        color: ColorCodes.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.only(bottom: 5),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty || value.trim().length < 3) {
                        return Strings.validFirst;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredFirstName = value!;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: _enteredLastName,
                    scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    cursorColor: ColorCodes.black,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(),
                      labelText: Strings.lastName,
                      labelStyle: TextStyle(
                        color: ColorCodes.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.only(bottom: 5),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty || value.trim().length < 3) {
                        return Strings.validLast;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredLastName = value!;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDOB() {
    return SizedBox(
      width: 306,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            Strings.dob,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: ColorCodes.lightBlack,
            ),
          ),
          const SizedBox(height: 22),
          GestureDetector(
            onTap: _presentDatePicker,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorCodes.black,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null ? Strings.dobFormat : DateFormat('MM-yyyy').format(_selectedDate!),
                    style: TextStyle(
                      color: _selectedDate == null ? ColorCodes.grey : ColorCodes.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    onPressed: _presentDatePicker,
                    icon: Image.asset(
                      'assets/images/calendar.png',
                      height: 25,
                      width: 25,
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

  Widget _buildAgeSlider() {
    return Column(
      children: [
        Container(
          height: 65,
          alignment: Alignment.center,
          child: NumberPicker(
            itemWidth: MediaQuery.of(context).size.width * 0.175,
            itemHeight: 65,
            value: _enteredAge,
            minValue: 10,
            maxValue: 90,
            selectedTextStyle: const TextStyle(
              color: ColorCodes.darkGreen,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              fontSize: 26,
            ),
            textStyle: const TextStyle(
              color: ColorCodes.mehendiGreen,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 22,
            ),
            axis: Axis.horizontal,
            itemCount: 5,
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorCodes.darkGreen,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            haptics: true,
            onChanged: (value) => setState(() => _enteredAge = value),
          ),
        ),
        const SizedBox(height: 4),
        Image.asset(
          'assets/images/arrowGreen.png',
          width: 15,
          height: 11,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Image.asset(
                  fit: BoxFit.fill,
                  'assets/images/background.png',
                  width: width,
                  height: height,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 46),
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
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 0, bottom: bottom),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfile(),
                              const SizedBox(height: 16),
                              _buildWelcomeText(),
                              _buildProvideText(),
                              const SizedBox(height: 27),
                              _buildFormField(),
                              const SizedBox(height: 32),
                              _buildDOB(),
                              const SizedBox(height: 32),
                              const Text(
                                Strings.age,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.lightBlack,
                                ),
                              ),
                              const SizedBox(height: 30),
                              _buildAgeSlider(),
                              const SizedBox(height: 29),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Button(
                                  onPress: _onSubmit,
                                  label: Strings.finish,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading || _isImageLoading) const Loader(),
      ],
    );
  }
}
