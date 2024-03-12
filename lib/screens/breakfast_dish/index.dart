// ignore_for_file: use_build_context_synchronously

import 'package:easy_debounce/easy_debounce.dart';
import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/model/meal.dart';
import 'package:fit_for_life/provider/dish_provider.dart';
import 'package:fit_for_life/screens/add_new_recipe/index.dart';
import 'package:fit_for_life/screens/calorie_stats/index.dart';
import 'package:fit_for_life/screens/recipe/index.dart';
import 'package:fit_for_life/services/home_service.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:fit_for_life/widgets/button.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:fit_for_life/widgets/meal_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final homeService = HomeService();

class BreakfastDish extends ConsumerStatefulWidget {
  const BreakfastDish({
    super.key,
    required this.meal,
    required this.dishIds,
  });

  final String meal;
  final List<dynamic> dishIds;

  @override
  ConsumerState<BreakfastDish> createState() {
    return _BreakfastDishState();
  }
}

class _BreakfastDishState extends ConsumerState<BreakfastDish> {
  final ScrollController _scrollController = ScrollController();
  final meals = [
    Strings.breakfast,
    Strings.lunch,
    Strings.snacks,
    Strings.dinner,
    "Other"
  ];
  String _selectedMeal = Strings.breakfast;
  String _searchText = '';
  bool _isLoading = true;
  bool _paginatedLoading = false;
  int _page = 1;
  final int _pageSize = 10;
  int _totalCount = 0;
  List<dynamic> dishIds = [];
  final _dishesType = [
    Strings.dcDishes,
    Strings.ownDishes,
    Strings.niaDishes,
    Strings.restaurantDishes,
  ];
  String _selectedDishesType = Strings.dcDishes;

  // bool _isVeg = false;
  // bool _isNonVeg = false;
  // bool _isEgg = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedMeal = widget.meal;
    });
    _onGetDishes();
    setState(() {
      dishIds.addAll(widget.dishIds);
      
    });

    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        final dishes = ref.read(dishProvider);
        if (!_isLoading && dishes.length != _totalCount) {
          _isLoading = !_isLoading;
          setState(() {
            _page += 1;
            _paginatedLoading = true;
          });

          try {
            await _onGetDishes(true);
            setState(() {
              _paginatedLoading = false;
            });
          } catch (err) {
            setState(() {
              _paginatedLoading = false;
            });
          }
        }
      }
    });
  }

  String getDishType(String dish) {
    switch (dish) {
      case Strings.ownDishes:
        return 'OWN';
      case Strings.dcDishes:
        return 'Fit4life';
      case Strings.niaDishes:
        return 'ANI';
      case Strings.restaurantDishes:
        return 'Restaurent';
      default:
        return 'OWN';
    }
  }

  Future<void> _onGetDishes([bool isPagination = false]) async {
    setState(() {
      _isLoading = true;
    });

    final selectedMeal = _selectedMeal == Strings.snacks ? Strings.eveningSnacks : _selectedMeal;
    final res = await homeService.onFetchDishes(
      selectedMeal.replaceAll(' ', '_').toLowerCase(),
      _page,
      _pageSize,
      getDishType(_selectedDishesType),
      _searchText,
    );
    print("res dishes ${res}");
    if (res.isNotEmpty) {
      final dishData = res['results'];

      await ref.read(dishProvider.notifier).onSaveDishes(dishData, isPagination);

      setState(() {
        _totalCount = res['count'];
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  void _onChangeDropdown(value) {
    if (value != null) {
      setState(() {
        _selectedMeal = value;
      });
      _onGetDishes();
    }
  }

  // Todo:- Will use it later.
  // Widget _buildFilter() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             _isVeg = !_isVeg;
  //           });
  //         },
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 7,
  //             vertical: 6,
  //           ),
  //           decoration: BoxDecoration(
  //             color: ColorCodes.white,
  //             borderRadius: BorderRadiusDirectional.circular(5),
  //             border: Border.all(
  //               color: _isVeg ? ColorCodes.darkGreen : ColorCodes.borderColor,
  //               width: 1,
  //             ),
  //           ),
  //           child: Row(
  //             children: [
  //               Container(
  //                 height: 9,
  //                 width: 9,
  //                 decoration: BoxDecoration(
  //                   color: ColorCodes.darkGreen,
  //                   borderRadius: BorderRadiusDirectional.circular(100),
  //                 ),
  //               ),
  //               if (_isVeg) const SizedBox(width: 3),
  //               if (_isVeg)
  //                 const Text(
  //                   Strings.veg,
  //                   style: TextStyle(
  //                     color: Colors.grey,
  //                     fontSize: 10,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       const SizedBox(height: 3),
  //       GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             _isNonVeg = !_isNonVeg;
  //           });
  //         },
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 7,
  //             vertical: 6,
  //           ),
  //           decoration: BoxDecoration(
  //             color: ColorCodes.white,
  //             borderRadius: BorderRadiusDirectional.circular(5),
  //             border: Border.all(
  //               color: _isNonVeg ? ColorCodes.red : ColorCodes.borderColor,
  //               width: 1,
  //             ),
  //           ),
  //           child: Row(
  //             children: [
  //               Container(
  //                 height: 9,
  //                 width: 9,
  //                 decoration: BoxDecoration(
  //                   color: ColorCodes.red,
  //                   borderRadius: BorderRadiusDirectional.circular(100),
  //                 ),
  //               ),
  //               if (_isNonVeg) const SizedBox(width: 3),
  //               if (_isNonVeg)
  //                 const Text(
  //                   Strings.nonveg,
  //                   style: TextStyle(
  //                     color: Colors.grey,
  //                     fontSize: 10,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       const SizedBox(height: 3),
  //       GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             _isEgg = !_isEgg;
  //           });
  //         },
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 7,
  //             vertical: 6,
  //           ),
  //           decoration: BoxDecoration(
  //             color: ColorCodes.white,
  //             borderRadius: BorderRadiusDirectional.circular(5),
  //             border: Border.all(
  //               color: _isEgg ? ColorCodes.yellow : ColorCodes.borderColor,
  //               width: 1,
  //             ),
  //           ),
  //           child: Row(
  //             children: [
  //               Container(
  //                 height: 9,
  //                 width: 9,
  //                 decoration: BoxDecoration(
  //                   color: ColorCodes.yellow,
  //                   borderRadius: BorderRadiusDirectional.circular(100),
  //                 ),
  //               ),
  //               if (_isEgg) const SizedBox(width: 3),
  //               if (_isEgg)
  //                 const Text(
  //                   Strings.egg,
  //                   style: TextStyle(
  //                     color: Colors.grey,
  //                     fontSize: 10,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void _handleSearch(String value) {
    setState(() {
      _searchText = value;
    });

    EasyDebounce.debounce(
      'my-debouncer',
      const Duration(milliseconds: 500),
      () => _onGetDishes(),
    );
  }

  void _onAddDishes(Meal meal) async {
    if (!dishIds.contains(meal.id)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 500),
          content: Text(
            '${meal.dishName} ${Strings.added}',
            style: const TextStyle(
              color: ColorCodes.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: ColorCodes.orange,
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                dishIds.remove(meal.id);
              });
            },
            textColor: ColorCodes.white,
            backgroundColor: ColorCodes.transparent,
          ),
        ),
      );

      await homeService.onAddDishes({
        'dish_ids': [...dishIds, meal.id]
      });
      setState(() {
        dishIds.add(meal.id);
      });
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 500),
          content: Text(
            '${meal.dishName} ${Strings.removed}',
            style: const TextStyle(
              color: ColorCodes.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: ColorCodes.orange,
        ),
      );

      setState(() {
        dishIds.remove(meal.id);
      });
      await homeService.onAddDishes({'dish_ids': dishIds});
    }
  }

  void _onNavigate(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => RecipeScreen(id: id),
      ),
    );
  }

  void _onAddNewRecipe() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const AddNewRecipeScreen(),
      ),
    );
  }

  void _onTrackCalories() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CalorieStatsScreen(
          selectedTab: meals.indexOf(_selectedMeal) + 1,
          showBackIcon: true,
        ),
      ),
    );
    // final data = {'dish_ids': dishIds};
    // setState(() {
    //   _isLoading = true;
    // });

    // final res = await homeService.onAddDishes(data);
    // if (res.isNotEmpty) {
    //   Navigator.pop(context);
    // }

    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final data = ref.read(dishProvider);

    if (_isLoading && _searchText.isEmpty && !_paginatedLoading) {
      return const Loader(
        opacity: 1,
        bgColor: ColorCodes.white,
      );
    }

    return Scaffold(
      backgroundColor: ColorCodes.white,
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: width,
            height: 75,
            decoration: const BoxDecoration(
              color: ColorCodes.darkGreen,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: _onGoBack,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/arrowWhite.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 33),
                  DropdownButton(
                    items: meals
                        .map(
                          (meal) => DropdownMenuItem(
                            value: meal,
                            child: Text(
                              meal,
                              style: const TextStyle(
                                color: ColorCodes.black,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    selectedItemBuilder: (BuildContext ctxt) {
                      return meals.map((meal) {
                        return DropdownMenuItem(
                          value: meal,
                          child: Text(
                            meal,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: ColorCodes.white,
                    ),
                    underline: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: ColorCodes.transparent,
                          ),
                        ),
                      ),
                    ),
                    value: _selectedMeal,
                    onChanged: _onChangeDropdown,
                  ),
                  // Todo:- Will use it later.
                  // const SizedBox(width: 30),
                  // _buildFilter(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/10,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisExtent: 45,
              ),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  setState(() {
                    _selectedDishesType = _dishesType[index];
                  });
                  _onGetDishes();
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 6, right: index == 3 ? 6 : 0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selectedDishesType == _dishesType[index] ? ColorCodes.orange : ColorCodes.white,
                      border: Border.all(
                        color: _selectedDishesType == _dishesType[index] ? ColorCodes.orange : ColorCodes.blackBorder,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _dishesType[index],
                      style: TextStyle(
                        color: _selectedDishesType == _dishesType[index] ? ColorCodes.white : ColorCodes.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: 4,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: TextField(
              scrollPadding: EdgeInsets.only(bottom: bottom),
              cursorColor: ColorCodes.black,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(bottom: 8, left: 19),
                suffixIcon: const Icon(
                  Icons.search,
                  color: ColorCodes.lightBlack,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                labelText: '${Strings.search} ${widget.meal} ${Strings.dish}',
                labelStyle: TextStyle(
                  color: _searchText == '' ? ColorCodes.lightGrey : ColorCodes.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
              ),
              onChanged: _handleSearch,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: MealCard(
                physics: const ScrollPhysics(),
                data: data
                    .map(
                      (e) => Meal(
                        calorie: e.calories.toString(),
                        dishName: e.dishName,
                        quantity_type: e.quantity_type,
                        quantity: e.quantity,
                        // ingredients: e.ingredients,
                        grams: e.grams,
                        id: e.dishId,
                        icon: dishIds.contains(e.dishId) ? Icons.close : Icons.add,
                      ),
                    )
                    .toList(),
                padding: 0,
                scrollController: _scrollController,
                onClickIcon: _onAddDishes,
                onNavigate: _onNavigate,
              ),
            ),
          ),
          if (_paginatedLoading)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Center(
                child: CircularProgressIndicator(
                  color: ColorCodes.green,
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(bottom: 0),
            child: Button(
              paddingVertical: 11,
              topLeftBorderRadius: 0,
              topRightBorderRadius: 0,
              bottomLeftBorderRadius: 0,
              bottomRightBorderRadius: 0,
              width: width,
              onPress: _onAddNewRecipe,
              label: Strings.addOwnRecipe,
              color: ColorCodes.slaty,
              fontSize: 16,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 0),
            child: Button(
              paddingVertical: 11,
              topLeftBorderRadius: 0,
              topRightBorderRadius: 0,
              bottomLeftBorderRadius: 0,
              bottomRightBorderRadius: 0,
              width: width,
              onPress: _onTrackCalories,
              label: '${Strings.trackFor} ${widget.meal}',
              fontSize: 16,
              disabled: dishIds.isEmpty,
            ),
          ),
        ],
      ),
    );
  }
}
