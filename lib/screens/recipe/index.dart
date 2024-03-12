import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/provider/dish_detail_provider.dart';
import 'package:fit_for_life/services/home_service.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeService = HomeService();

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _onGetDishDetails();
  }

  void _onGetDishDetails() async {
    setState(() {
      _isLoading = true;
    });

    final res = await homeService.onFetchDishDetails(widget.id);
    if (res.isNotEmpty) {
      final dishData = res['data'];
      await ref.read(dishDetailProvider.notifier).onSaveDishDetail(dishData);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  Widget _buildImageHeader(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final data = ref.read(dishDetailProvider);

    return Stack(
      children: [
        Image.asset('assets/images/dummy.png', fit: BoxFit.fill),
        Positioned(
          left: 20,
          top: 20,
          child: GestureDetector(
            onTap: _onGoBack,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/images/arrowWhite.png',
                width: 27,
                height: 27,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.only(
              left: 30,
              top: 10,
            ),
            width: width,
            height: 115,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorCodes.black.withOpacity(0),
                  ColorCodes.black,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.dishName!,
                  style: const TextStyle(
                    color: ColorCodes.white,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${data.calories} ${Strings.kcal}',
                  style: const TextStyle(
                    color: ColorCodes.orange,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipes() {
    final data = ref.read(dishDetailProvider);

    return SizedBox(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 11,
        runSpacing: 10,
        children: List.generate(
          data.recipeValues!.length,
          (index) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: ColorCodes.normalGrey,
              border: Border.all(
                color: ColorCodes.borderColor,
                width: 1,
              ),
            ),
            child: Text(
              '${data.recipeValues![index]} ',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ColorCodes.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutrition() {
    final data = ref.read(dishDetailProvider);
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.nutritionValues!.length,
        itemBuilder: (itemBuilder,index){
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ColorCodes.white,
              border: Border.all(
                color: ColorCodes.blackBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${data.nutritionValues![index].name}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ColorCodes.darkGrey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                 // '${data.nutritionValues![index].quantity} ${data.nutritionValues![index].unit}',
                  '${data.nutritionValues![index].quantity}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorCodes.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }
    );
    return SizedBox(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: MediaQuery.of(context).size.width * 0.08,
        runSpacing: 11,
        children: List.generate(
          data.nutritionValues!.length,
          (index) => Container(
            width: MediaQuery.of(context).size.width * 0.39,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ColorCodes.white,
              border: Border.all(
                color: ColorCodes.blackBorder,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data.nutritionValues![index].name} ',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: ColorCodes.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${data.nutritionValues![index].quantity} ${data.nutritionValues![index].unit}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: ColorCodes.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // Todo:- Will use it later.
                // Stack(
                //   alignment: Alignment.center,
                //   children: [
                //     CircularProgressIndicator(
                //       value: data.nutritionValues![index].percentage / 100,
                //       color: HexColor(data.nutritionValues![index].colour),
                //       backgroundColor: ColorCodes.borderColor,
                //     ),
                //     Text(
                //       '${data.nutritionValues![index].percentage}%',
                //       style: const TextStyle(
                //         fontFamily: 'Poppins',
                //         fontSize: 9,
                //         fontWeight: FontWeight.w400,
                //         color: ColorCodes.lightGrey,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          _buildImageHeader(context),
          const SizedBox(height: 21),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/recipe.png',
                          width: 18,
                          height: 17,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          Strings.recipe,
                          style: TextStyle(
                            color: ColorCodes.lightBlack,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      Strings.ingredients,
                      style: TextStyle(
                        color: ColorCodes.lightBlack,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 9),
                    _buildRecipes(),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/nutrition.png',
                          width: 18,
                          height: 17,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          Strings.nutritionValue,
                          style: TextStyle(
                            color: ColorCodes.lightBlack,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 11),
                    _buildNutrition(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
