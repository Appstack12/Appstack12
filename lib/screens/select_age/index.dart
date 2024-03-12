// ignore_for_file: use_build_context_synchronously

import 'package:fit_for_life/model/user.dart';
import 'package:fit_for_life/provider/user_provider.dart';
import 'package:fit_for_life/screens/select_height/index.dart';
import 'package:fit_for_life/services/user_services.dart';
import 'package:fit_for_life/widgets/button.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:flutter/material.dart';

import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

final userService = UserService();

class SelectAgeScreen extends ConsumerStatefulWidget {
  const SelectAgeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectAgeScreen> createState() {
    return _SelectAgeScreenState();
  }
}

class _SelectAgeScreenState extends ConsumerState<SelectAgeScreen> {
  int _enteredAge = 10;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final userData = ref.read(userProvider) as User;
    setState(() {
      _selectedDate = DateFormat('dd/MM/yyyy').parse(userData.dob);
      _enteredAge = userData.age;
    });
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  void _onSubmit() async {
    final userData = ref.read(userProvider) as User;
    if (_selectedDate != null) {
      Map<String, dynamic> request = {};
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

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: now,
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

  Widget _buildDOB() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
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
                    _selectedDate == null ? Strings.dobFormat : DateFormat('dd-MM-yyyy').format(_selectedDate!),
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
            itemWidth: 75,
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
                  'assets/images/backgroundWithoutLeaf.png',
                  width: width,
                  height: height,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 46, top: 50),
                      child: GestureDetector(
                        onTap: _onGoBack,
                        child: Image.asset(
                          'assets/images/backArrow.png',
                          width: 49,
                          height: 49,
                        ),
                      ),
                    ),
                    const SizedBox(height: 87),
                    _buildDOB(),
                    const SizedBox(height: 84),
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        Strings.age,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: ColorCodes.lightBlack,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildAgeSlider(),
                    const SizedBox(height: 110),
                    Container(
                      alignment: Alignment.center,
                      child: Button(
                        onPress: _onSubmit,
                        label: Strings.next,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_isLoading) const Loader(),
      ],
    );
  }
}
