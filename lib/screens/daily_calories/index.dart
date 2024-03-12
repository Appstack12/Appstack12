import 'package:accordion/controllers.dart';
import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/model/dish.dart';
import 'package:fit_for_life/model/meal.dart';
import 'package:fit_for_life/provider/daily_calorie_provider.dart';
import 'package:fit_for_life/provider/dish_provider.dart';
import 'package:fit_for_life/screens/breakfast_dish/index.dart';
import 'package:fit_for_life/screens/daily_calories/card_widget.dart';
import 'package:fit_for_life/screens/daily_calories/header_widget.dart';
import 'package:fit_for_life/services/home_service.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accordion/accordion.dart';

final homeService = HomeService();

class DailyCaloriesScreen extends ConsumerStatefulWidget {
  const DailyCaloriesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DailyCaloriesScreenState();
  }
}

class _DailyCaloriesScreenState extends ConsumerState<DailyCaloriesScreen> with WidgetsBindingObserver {
  List<dynamic> dates = [];
  bool _isLoading = false;
  int _selectedDateIndex = 6;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _onGetDailyCaloriesData();
    _setPreviousDates();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onGetDailyCaloriesData();
      _setPreviousDates();
    }
  }

  void _onGetDailyCaloriesData() async {
    setState(() {
      _isLoading = true;
    });

    final res = await homeService.onFetchDailyCaloriesData(
        dates.isEmpty ? DateFormat('yyyy-MM-dd').format(DateTime.now()) : dates[_selectedDateIndex]);
    if (res.isNotEmpty) {
      final calorieData = res['data'];
      print("calorieData $calorieData");
      await ref.read(dailyCalorieProvider.notifier).onSaveDailyCalorieData(calorieData);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _setPreviousDates() {
    final datesArray = [];
    final date = DateTime.now();

    for (var i = 6; i >= 0; i--) {
      final newDate = DateTime(date.year, date.month, date.day - i);
      datesArray.add(DateFormat('yyyy-MM-dd').format(newDate));
    }

    setState(() {
      dates = datesArray;
    });
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  void _onRemoveDish(Meal meal, List<Dish> dishData) async {
    final dishIds = ref.read(dailyCalorieProvider).dishIds ?? [];
    final previousDishIds = [...dishIds];
    previousDishIds.remove(meal.id);

    final data = {
      'dish_ids': previousDishIds,
    };
    setState(() {
      _isLoading = true;
    });

    await homeService.onAddDishes(data);
    _onGetDailyCaloriesData();

    setState(() {
      _isLoading = false;
    });
  }

  void _onAddMeal(String meal) {
    final dishIds = ref.read(dailyCalorieProvider).dishIds;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => BreakfastDish(
          meal: meal,
          dishIds: dishIds ?? [],
        ),
      ),
    ).then((value) {
      _onGetDailyCaloriesData();
      ref.read(dishProvider).clear();
    });
  }

  Widget _buildHeader(String image, String label, String mealType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                image,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: ColorCodes.lightBlack,
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => _onAddMeal(mealType),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 2),
            child: Image.asset(
              'assets/images/addIcon.png',
              width: 28,
              height: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    final data = ref.read(dailyCalorieProvider);

    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2.6,
          child: Accordion(
            headerBorderColor: ColorCodes.transparent,
            headerBorderColorOpened: ColorCodes.borderColor,
            contentBorderWidth: 1,
            headerBorderWidth: 1,
            headerBackgroundColorOpened: ColorCodes.white,
            contentBackgroundColor: Colors.white,
            contentBorderColor: ColorCodes.borderColor,
            headerBorderRadius: 12,
            contentBorderRadius: 12,
            disableScrolling: false,
            scaleWhenAnimating: false,
            openAndCloseAnimation: true,
            headerBackgroundColor: ColorCodes.normalGrey,
            headerPadding: const EdgeInsets.only(
              left: 10,
              top: 10,
              bottom: 10,
            ),
            sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
            sectionClosingHapticFeedback: SectionHapticFeedback.light,
            children: [
              AccordionSection(
                isOpen: false,
                header: _buildHeader(
                  'assets/images/breakfast.gif',
                  Strings.breakfast,
                  Strings.breakfast,
                ),
                content: CardWidget(
                  calorieData: data.breakfast ?? [],
                  onRemoveDish: (Meal meal) => _onRemoveDish(meal, data.breakfast ?? []),
                  selectedDate: _selectedDateIndex,
                ),
              ),
              AccordionSection(
                isOpen: false,
                header: _buildHeader(
                  'assets/images/lunch.gif',
                  Strings.lunch,
                  Strings.lunch,
                ),
                content: CardWidget(
                  calorieData: data.lunch ?? [],
                  onRemoveDish: (Meal meal) => _onRemoveDish(meal, data.lunch ?? []),
                  selectedDate: _selectedDateIndex,
                ),
              ),
              AccordionSection(
                isOpen: false,
                header: _buildHeader(
                  'assets/images/snacks.gif',
                  Strings.eveningSnacks,
                  Strings.snacks,
                ),
                content: CardWidget(
                  calorieData: data.eveningSnacks ?? [],
                  onRemoveDish: (Meal meal) => _onRemoveDish(meal, data.eveningSnacks ?? []),
                  selectedDate: _selectedDateIndex,
                ),
              ),
              AccordionSection(
                isOpen: false,
                header: _buildHeader(
                  'assets/images/dinner.gif',
                  Strings.dinner,
                  Strings.dinner,
                ),
                content: CardWidget(
                  calorieData: data.dinner ?? [],
                  onRemoveDish: (Meal meal) => _onRemoveDish(meal, data.dinner ?? []),
                  selectedDate: _selectedDateIndex,
                ),
              ),
              AccordionSection(
                isOpen: false,
                header: _buildHeader(
                  'assets/images/dinner.gif',
                  "Other",
                  "Other",
                ),
                content: CardWidget(
                  calorieData: data.other ?? [],
                  onRemoveDish: (Meal meal) => _onRemoveDish(meal, data.other ?? []),
                  selectedDate: _selectedDateIndex,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.read(dailyCalorieProvider);

    if (_isLoading) {
      return const Loader(
        opacity: 1,
        bgColor: ColorCodes.white,
      );
    }

    return Scaffold(
      backgroundColor: ColorCodes.white,
      body: Column(
        children: [
          HeaderWidget(
            goBack: _onGoBack,
            calorieData: data,
            date: dates[_selectedDateIndex],
            onPreviousDate: () {
              setState(() {
                _selectedDateIndex -= 1;
              });
              _onGetDailyCaloriesData();
            },
            onNextDate: () {
              setState(() {
                _selectedDateIndex += 1;
              });
              _onGetDailyCaloriesData();
            },
            enableNextButton: _selectedDateIndex != 6,
            enablePreviousButton: _selectedDateIndex != 0,
          ),
          _buildBody()
        ],
      ),
    );
  }
}
