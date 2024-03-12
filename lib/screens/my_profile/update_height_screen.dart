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


class UpdateHeightScreen extends ConsumerStatefulWidget {
  final basicInfo;
  const UpdateHeightScreen({Key? key,required this.basicInfo}) : super(key: key);

  @override
  ConsumerState<UpdateHeightScreen> createState() {
    return _UpdateHeightScreenState();
  }
}

class _UpdateHeightScreenState extends ConsumerState<UpdateHeightScreen> {
  bool _isLoading = false;
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

    setState(() {
      _enteredHeight = 40;
      _enteredAgeWeight = 50;
       _isFeet =  false;
       _isPound =  false;
    });

    currentValue = _enteredHeight.toInt();
    _rulerPickerController = RulerPickerController(value: currentValue);
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  void _onSubmit() async {
    Map<String, dynamic> request = {};
    var h = _isFeet ? 'feet' : 'cm';
    var w = _isPound ? 'lb' : 'kg';
    request['height'] = _enteredHeight.toString()+" "+h.toString();
    request['weight'] = _enteredAgeWeight.toString()+" "+w;

    Navigator.pop(context,request);

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
                              label: "Update",
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
