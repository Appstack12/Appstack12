// ignore_for_file: use_build_context_synchronously

import 'package:fit_for_life/model/user.dart';
import 'package:fit_for_life/provider/user_provider.dart';
import 'package:fit_for_life/screens/select_location/index.dart';
import 'package:fit_for_life/services/user_services.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:flutter/material.dart';

import 'package:fit_for_life/widgets/button.dart';
import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:numberpicker/numberpicker.dart';

final userService = UserService();

class SelectHeightScreen extends ConsumerStatefulWidget {
  const SelectHeightScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectHeightScreen> createState() {
    return _SelectHeightScreenState();
  }
}

class _SelectHeightScreenState extends ConsumerState<SelectHeightScreen> {
  bool _isLoading = false;
  String _gender = 'Male';
  bool _isFeet = false;
  bool _isPound = true;
  double _enteredHeight = 100;
  double _enteredAgeWeight = 10;
  RulerPickerController? _rulerPickerController;
  double scaleValue = 0;
  double verticalScaleValue = 0;

  num currentValue = 0;

  List<RulerRange> ranges = const [
    RulerRange(begin: 100, end: 230, scale: 0.1),
  ];

  @override
  void initState() {
    super.initState();


    final userData = ref.read(userProvider) as User;
    setState(() {
      _gender = userData.gender;
      _enteredHeight = userData.height;
      _enteredAgeWeight = userData.weight;
      _isFeet = userData.heightUnit == 'feet';
      _isPound = userData.weightUnit == 'lb';
    });

    currentValue = _enteredHeight.toInt();
    _rulerPickerController = RulerPickerController(value: currentValue);
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  void _onSubmit() async {
    Map<String, dynamic> request = {};
    request['height'] = _enteredHeight;
    request['weight'] = _enteredAgeWeight.toString();
    request['gender'] = _gender;
    request['height_unit'] = _isFeet ? 'feet' : 'cm';
    request['weight_unit'] = _isPound ? 'lb' : 'kg';

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
            builder: (ctx) => const SelectLocationScreen(),
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
          builder: (ctx) => const SelectLocationScreen(),
        ),
      );
    }
  }

  Widget _buildHeading(String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: ColorCodes.lightBlack,
          ),
        ),
      ],
    );
  }

  _buildHeightHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeading(Strings.height),
        Row(
          children: [
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                width: 81,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: _isFeet ? ColorCodes.orange : ColorCodes.blackBorder,
                    width: 1,
                  ),
                  color: _isFeet ? ColorCodes.orange : ColorCodes.white,
                ),
                child: Text(
                  '${_enteredHeight.toInt()} ${Strings.cm.toLowerCase()}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _isFeet ? ColorCodes.white : ColorCodes.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 3),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isFeet = false;
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: 63,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: !_isFeet ? ColorCodes.orange : ColorCodes.blackBorder,
                    width: 1,
                  ),
                  color: !_isFeet ? ColorCodes.orange : ColorCodes.white,
                ),
                child: Text(
                  Strings.cm,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: !_isFeet ? ColorCodes.white : ColorCodes.black,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildHeightSlider() {

    return RulerPicker(
      controller: _rulerPickerController,
      // beginValue: _isFeet ? 10 : 100,
      // endValue: _isFeet ? 100 : 190,
      // initValue: _enteredHeight.toInt(),
      onBuildRulerScaleText: (index, rulerScaleValue) => _isFeet
          ? ((rulerScaleValue % 10 == 0) ? rulerScaleValue ~/ 10 : rulerScaleValue).toString()
          : rulerScaleValue.toString(),
      ranges: ranges,
      scaleLineStyleList: const [
        ScaleLineStyle(color: ColorCodes.blackBorder, width: 2, height: 33, scale: 0),
        ScaleLineStyle(color: ColorCodes.blackBorder, width: 1.5, height: 23, scale: 5),
        ScaleLineStyle(color: ColorCodes.blackBorder, width: 1, height: 13, scale: -1)
      ],
      onValueChanged: (value) {
        setState(() {
          if (_isFeet) {
            _enteredHeight = (value / 10).toDouble();
          } else {
            _enteredHeight = value.toDouble();
          }
        });
      },
      width: MediaQuery.of(context).size.width - 60,
      height: 70,
      rulerScaleTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: ColorCodes.lightGrey,
      ),
      marker: Container(
        width: 2,
        height: 33,
        decoration: const BoxDecoration(
          color: ColorCodes.darkGreen,
        ),
      ),
    );
  }

  _buildWeightHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeading(Strings.weight),
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 61,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: _isFeet ? ColorCodes.orange : ColorCodes.blackBorder,
                  width: 1,
                ),
                color: _isFeet ? ColorCodes.orange : ColorCodes.white,
              ),
              child: Text(
                '${_enteredAgeWeight.toInt()} ${_isPound ? Strings.lb.toLowerCase() : Strings.kg.toLowerCase()}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _isFeet ? ColorCodes.white : ColorCodes.black,
                ),
              ),
            ),
            const SizedBox(width: 3),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPound = true;
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: 43,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: _isPound ? ColorCodes.orange : ColorCodes.blackBorder,
                    width: 1,
                  ),
                  color: _isPound ? ColorCodes.orange : ColorCodes.white,
                ),
                child: Text(
                  Strings.lb,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _isPound ? ColorCodes.white : ColorCodes.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 3),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPound = false;
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: 63,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: !_isPound ? ColorCodes.orange : ColorCodes.blackBorder,
                    width: 1,
                  ),
                  color: !_isPound ? ColorCodes.orange : ColorCodes.white,
                ),
                child: Text(
                  Strings.kg,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: !_isPound ? ColorCodes.white : ColorCodes.black,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildWeightSlider() {
    return Column(
      children: [
        Container(
          height: 65,
          alignment: Alignment.center,
          child: NumberPicker(
            itemWidth: MediaQuery.of(context).size.width * 0.17,
            itemHeight: 65,
            value: _enteredAgeWeight.toInt(),
            minValue: 10,
            maxValue: 330,
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
            onChanged: (value) => setState(() => _enteredAgeWeight = value.toDouble()),
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
                  'assets/images/backgroundWithoutLeaf.png',
                  width: width,
                  height: height,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 14),
                          _buildHeading(Strings.gender),
                          const SizedBox(height: 15),
                          Container(
                            height: 47,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorCodes.blackBorder,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(33),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _gender = 'Male';
                                    });
                                  },
                                  child: Container(
                                    height: 47,
                                    width: 107,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(33),
                                      color: _gender == 'Male' ? ColorCodes.darkGreen : ColorCodes.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.male,
                                          size: 30,
                                          color: _gender == 'Male' ? ColorCodes.white : ColorCodes.black,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          Strings.male,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: _gender == 'Male' ? ColorCodes.white : ColorCodes.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _gender = 'Female';
                                    });
                                  },
                                  child: Container(
                                    height: 47,
                                    width: 107,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(33),
                                      color: _gender == 'Female' ? ColorCodes.darkGreen : ColorCodes.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.female,
                                          size: 30,
                                          color: _gender == 'Female' ? ColorCodes.white : ColorCodes.black,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          Strings.female,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: _gender == 'Female' ? ColorCodes.white : ColorCodes.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _gender = 'Other';
                                    });
                                  },
                                  child: Container(
                                    height: 47,
                                    width: 107,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(33),
                                      color: _gender == 'Other' ? ColorCodes.darkGreen : ColorCodes.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/otherGender.png',
                                          height: 24,
                                          width: 24,
                                          color: _gender == 'Other' ? ColorCodes.white : ColorCodes.black,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          Strings.other,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: _gender == 'Other' ? ColorCodes.white : ColorCodes.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 49),
                          _buildHeightHeading(),
                          const SizedBox(height: 31),
                          _buildHeightSlider(),
                          const SizedBox(height: 60),
                          _buildWeightHeading(),
                          const SizedBox(height: 34),
                          _buildWeightSlider(),
                          const SizedBox(height: 50),
                          Container(
                            alignment: Alignment.center,
                            child: Button(
                              onPress: _onSubmit,
                              label: Strings.next,
                            ),
                          ),
                        ],
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
