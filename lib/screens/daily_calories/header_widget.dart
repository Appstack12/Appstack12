import 'dart:math';

import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/model/daily_calorie_tracker.dart';
import 'package:fit_for_life/provider/daily_calorie_provider.dart';
import 'package:fit_for_life/screens/calorie_stats/index.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class HeaderWidget extends ConsumerStatefulWidget {
  const HeaderWidget({
    super.key,
    required this.goBack,
    required this.calorieData,
    required this.date,
    required this.onPreviousDate,
    required this.onNextDate,
    required this.enableNextButton,
    required this.enablePreviousButton,
  });

  final void Function() goBack;
  final DailyCalorieTracker calorieData;
  final String date;
  final void Function() onPreviousDate;
  final void Function() onNextDate;
  final bool enableNextButton;
  final bool enablePreviousButton;

  @override
  ConsumerState<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends ConsumerState<HeaderWidget> {
  Widget _buildStat() {
    final data = ref.read(dailyCalorieProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            for (int i = 0; i < (data.calorieBreakdown ?? []).length; i++)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: (data.calorieBreakdown ?? []).length - 1 != i ? ColorCodes.white : ColorCodes.transparent,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.calorieBreakdown![i].label,
                      style: const TextStyle(
                        color: ColorCodes.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      (data.calorieBreakdown![i].value).toString(),
                      style: const TextStyle(
                        color: ColorCodes.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const CalorieStatsScreen(
                showBackIcon: true,
              ),
            ),
          ),
          child: Image.asset(
            'assets/images/statsWithBg.png',
            height: 40,
            width: 40,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double calorieMeter = ((widget.calorieData.caloriesUsed ?? 0) /
            (widget.calorieData.totalCalories != 0 ? widget.calorieData.totalCalories : 1)) *
        100;

    return Stack(
      children: [
        Container(
          color: ColorCodes.normalGreen,
          child: Image.asset(
            'assets/images/calorieBg.png',
            height: 442,
            width: width,
            fit: BoxFit.fitWidth,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 22, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: Text(
                      Strings.calorieCounter,
                      style: TextStyle(
                        color: ColorCodes.white,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: widget.enablePreviousButton ? widget.onPreviousDate : () {},
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: widget.enablePreviousButton ? ColorCodes.white : ColorCodes.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        DateFormat('dd MMM').format(DateTime.tryParse(widget.date) ?? DateTime.now()),
                        style: const TextStyle(
                          color: ColorCodes.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.enableNextButton ? widget.onNextDate : () {},
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: widget.enableNextButton ? ColorCodes.white : ColorCodes.white.withOpacity(0.5),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 39),
              CircularStepProgressIndicator(
                totalSteps: 130,
                currentStep: calorieMeter.toInt(),
                stepSize: 15,
                selectedColor: ColorCodes.lightYellow,
                unselectedColor: ColorCodes.white,
                padding: pi / 50,
                width: 196,
                height: 196,
                selectedStepSize: 15,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        Strings.eaten,
                        style: TextStyle(
                          color: ColorCodes.white,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        widget.calorieData.caloriesUsed.toString(),
                        style: const TextStyle(
                          color: ColorCodes.white,
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 70,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: ColorCodes.white,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        widget.calorieData.totalCalories.toString(),
                        style: const TextStyle(
                          color: ColorCodes.white,
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        '${Strings.total} ${Strings.kcal}',
                        style: TextStyle(
                          color: ColorCodes.white,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.only(left: 4, right: 14, top: 16, bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorCodes.blur.withOpacity(0.7),
                  border: Border.all(
                    color: ColorCodes.lightOrange,
                    width: 1,
                  ),
                ),
                child: _buildStat(),
              )
            ],
          ),
        ),
      ],
    );
  }
}
