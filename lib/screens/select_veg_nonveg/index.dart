// ignore_for_file: use_build_context_synchronously

import 'package:fit_for_life/model/meal_type.dart';
import 'package:fit_for_life/model/user.dart';
import 'package:fit_for_life/provider/user_provider.dart';
import 'package:fit_for_life/screens/select_health_issues/index.dart';
import 'package:fit_for_life/services/user_services.dart';
import 'package:fit_for_life/widgets/button.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:flutter/material.dart';

import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userService = UserService();

class SelectVegNonvegScreen extends ConsumerStatefulWidget {
  const SelectVegNonvegScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectVegNonvegScreen> createState() {
    return _SelectVegNonvegScreenState();
  }
}

class _SelectVegNonvegScreenState extends ConsumerState<SelectVegNonvegScreen> {
  bool _isLoading = false;
  String _mealType = 'Vegitarian';
  final List<MealType> _mealTypes = [
    MealType(
      image: 'assets/images/veg.png',
      mealType: Strings.vegetarian,
      title: Strings.vegetarian,
      subTitle: '',
    ),
    MealType(
      image: 'assets/images/nonveg.png',
      mealType: Strings.nonVegetarian,
      title: Strings.nonVegetarian,
      subTitle: '',
    ),
    MealType(
      image: 'assets/images/egg.png',
      mealType: Strings.eggetarian,
      title: Strings.eggetarian,
      subTitle: Strings.vegEgg,
    ),
    MealType(
      image: 'assets/images/fish.png',
      mealType: Strings.pescetarian,
      title: Strings.pescetarian,
      subTitle: Strings.vegFish,
    ),
    MealType(
      image: 'assets/images/meat.png',
      mealType: Strings.poultry,
      title: Strings.poultry,
      subTitle: Strings.vegEggChicken,
    ),
    MealType(
      image: 'assets/images/vegan.png',
      mealType: Strings.vegan,
      title: Strings.vegan,
      subTitle: '',
    ),
  ];

  @override
  void initState() {
    super.initState();

    final userData = ref.read(userProvider) as User;
    setState(() {
      _mealType = userData.vegNonveg;
    });
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  void _onNavigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const SelectHealthIssuesScreen(),
      ),
    );
  }

  void _onSubmit() async {
    Map<String, dynamic> request = {};
    request['veg_nonveg'] = _mealType;

    if (request.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      final res = await userService.updateUserDetails(request);
      if (res['status']) {
        await ref.read(userProvider.notifier).onSaveUserData(res['data']);

        _onNavigate();
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      _onNavigate();
    }
  }

  Widget _buildHeading(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: ColorCodes.lightBlack,
      ),
    );
  }

  Widget _buildRadioButton(
    String mealType,
    String image,
    String title,
    String subTitle,
  ) {
    final isSelected = _mealType == mealType;

    return GestureDetector(
      onTap: () {
        setState(() {
          _mealType = mealType;
        });
      },
      child: Container(
        width: 130,
        height: 130,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: ColorCodes.white,
          border: Border.all(
            color: isSelected ? ColorCodes.green : ColorCodes.blackBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: ColorCodes.black.withOpacity(0.25),
              blurRadius: isSelected ? 5 : 0,
            )
          ],
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                isSelected ? 'assets/images/activeRadio.png' : 'assets/images/inactiveRadio.png',
                height: 16,
                width: 16,
              ),
            ),
            Image.asset(
              image,
              height: 38,
              width: 38,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: ColorCodes.black,
              ),
            ),
            if (subTitle.isNotEmpty) const SizedBox(height: 4),
            if (subTitle.isNotEmpty)
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                  color: ColorCodes.grey,
                ),
              ),
          ],
        ),
      ),
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
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: [
                  Image.asset(
                    fit: BoxFit.fill,
                    'assets/images/backgroundWithoutLeaf.png',
                    width: width,
                    height: height - 90,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
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
                            _buildHeading(Strings.vegNonveg),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                itemCount: _mealTypes.length ~/ 2,
                                shrinkWrap: true,
                                itemBuilder: (ctx, ind) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildRadioButton(
                                      _mealTypes[ind * 2].mealType,
                                      _mealTypes[ind * 2].image,
                                      _mealTypes[ind * 2].title,
                                      _mealTypes[ind * 2].subTitle,
                                    ),
                                    _buildRadioButton(
                                      _mealTypes[(ind * 2) + 1].mealType,
                                      _mealTypes[(ind * 2) + 1].image,
                                      _mealTypes[(ind * 2) + 1].title,
                                      _mealTypes[(ind * 2) + 1].subTitle,
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
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 104),
            child: Button(
              onPress: _onSubmit,
              label: Strings.next,
            ),
          ),
        ),
        if (_isLoading) const Loader(),
      ],
    );
  }
}
