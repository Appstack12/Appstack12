import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../color_codes/index.dart';
import '../../strings/index.dart';
import '../../widgets/button.dart';
import '../../widgets/loader.dart';
import '../../widgets/user_image_picker.dart';
import '../select_height/index.dart';

class SelectDobScreen extends StatefulWidget {
  final basicInfo;
  const SelectDobScreen({super.key,required this.basicInfo});

  @override
  State<SelectDobScreen> createState() => _SelectDobScreenState();
}

class _SelectDobScreenState extends State<SelectDobScreen> {
  bool _isLoading = false;
  int _enteredAge = 10;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    setState(() {
      //_selectedDate = DateFormat('dd/MM/yyyy').parse(widget.basicInfo.dobDate);
      _enteredAge = widget.basicInfo.age;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  void _onSubmit() async {
    Navigator.pop(context,{"dob":_selectedDate,"age":_enteredAge});

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
                              const SizedBox(height: 100),
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
        if (_isLoading) const Loader(),
      ],
    );
  }
}


