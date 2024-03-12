import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/provider/stats.dart';
import 'package:fit_for_life/services/home_service.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final homeService = HomeService();

class CalorieStatsScreen extends ConsumerStatefulWidget {
  const CalorieStatsScreen({
    super.key,
    this.showBackIcon = false,
    this.selectedTab = 0,
  });

  final bool showBackIcon;
  final int selectedTab;

  @override
  ConsumerState<CalorieStatsScreen> createState() => _CalorieStatsScreenState();
}

class _CalorieStatsScreenState extends ConsumerState<CalorieStatsScreen> {
  bool _isLoading = true;
  int _selectedTab = 0;
  DateTime? _selectedDate = DateTime.now();
  final colorList = <Color>[
    ColorCodes.yellow,
    ColorCodes.lightGreen,
  ];
  final List<String> items = List.generate(2, (index) => 'Item $index');
  final PageController controller = PageController(initialPage: 0);

  void _presentDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day - 6);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
    _onGetStats();
  }

  @override
  void initState() {
    super.initState();
    _onGetStats();
    setState(() {
      _selectedTab = widget.selectedTab;
    });
  }

  Future<void> _onGetStats() async {

    print("items items ${items}");
    setState(() {
      _isLoading = true;
    });

    final res = await homeService.onFetchStats(
        DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now()), _getMealType());

    if (res.isNotEmpty) {
      final dishData = res['data'];

      print("dishData state ${dishData}");

      try {
        await ref.read(statsProvider.notifier).onSaveStats(dishData);
      } catch (err) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  String _getMealType() {
    switch (_selectedTab) {
      case 1:
        return 'breakfast';
      case 2:
        return 'lunch';
      case 3:
        return 'evening_snacks';
      case 4:
        return 'dinner';
      case 5:
        return 'other';
      default:
        return '';
    }
  }

  Widget _buildHeader() {
    final data = ref.read(statsProvider);

    return Container(
      padding: const EdgeInsets.only(top: 35, left: 15, right: 25, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorCodes.darkestOrange, ColorCodes.darkOrange],
          end: AlignmentDirectional.bottomStart,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (widget.showBackIcon)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/arrowWhite.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  if (widget.showBackIcon) const SizedBox(width: 10),
                  const Text(
                    Strings.calorigram,
                    style: TextStyle(
                      color: ColorCodes.white,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => _presentDatePicker(context),
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      style: const TextStyle(
                        color: ColorCodes.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _presentDatePicker(context),
                    icon: Image.asset(
                      'assets/images/calendar.png',
                      height: 25,
                      width: 25,
                      color: ColorCodes.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                          data.eatenCalories.toString(),
                          style: const TextStyle(
                            color: ColorCodes.white,
                            fontSize: 40,
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
                        Text(
                          data.remainingCalories.toString(),
                          style: const TextStyle(
                            color: ColorCodes.white,
                            fontSize: 40,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/papaya.png',
                      height: 180,
                      width: 180,
                    ),
                    // Todo:- Will use it later.
                    // PieChart(
                    //   dataMap: <String, double>{
                    //     "Eaten":
                    //         double.tryParse(data.eatenCalories.toString()) ?? 0,
                    //     "Remaining":
                    //         double.tryParse(data.remainingCalories.toString()) ?? 0,
                    //   },
                    //   animationDuration: const Duration(milliseconds: 800),
                    //   chartRadius: MediaQuery.of(context).size.width / 4.2,
                    //   colorList: colorList,
                    //   initialAngleInDegree: -100,
                    //   chartType: ChartType.ring,
                    //   ringStrokeWidth: 42,
                    //   centerText: "NL",
                    //   legendOptions: const LegendOptions(
                    //     showLegends: true,
                    //     legendPosition: LegendPosition.top,
                    //   ),
                    //   chartValuesOptions: const ChartValuesOptions(
                    //     showChartValueBackground: false,
                    //     showChartValuesOutside: true,
                    //     showChartValuesInPercentage: true,
                    //     decimalPlaces: 0,
                    //     chartValueStyle: TextStyle(
                    //       color: ColorCodes.black,
                    //       fontSize: 10,
                    //       fontFamily: 'Poppins',
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    //   centerTextStyle: const TextStyle(
                    //     color: ColorCodes.white,
                    //     fontSize: 10,
                    //     fontFamily: 'Poppins',
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // )
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: ColorCodes.white,
                        size: 20,
                      ),
                      onPressed: () {
                        if (controller.page! > 0) {
                          controller.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                        }
                      },
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: PageView.builder(
                          controller: controller,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            int position = index == 0 ? index : index+1;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (data.eatenCaloriesBreakdown ?? [])[position].label,
                                      style: const TextStyle(
                                        color: ColorCodes.white,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      (data.eatenCaloriesBreakdown ?? [])[position].calorie.toString(),
                                      style: const TextStyle(
                                        color: ColorCodes.white,
                                        fontSize: 24,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Text(
                                      Strings.kcal,
                                      style: TextStyle(
                                        color: ColorCodes.white,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (data.eatenCaloriesBreakdown ?? [])[position + 1].label,
                                      style: const TextStyle(
                                        color: ColorCodes.white,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      (data.eatenCaloriesBreakdown ?? [])[position + 1].calorie.toString(),
                                      style: const TextStyle(
                                        color: ColorCodes.white,
                                        fontSize: 24,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Text(
                                      Strings.kcal,
                                      style: TextStyle(
                                        color: ColorCodes.white,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (data.eatenCaloriesBreakdown ?? [])[position + 2].label,
                                      style: const TextStyle(
                                        color: ColorCodes.white,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      (data.eatenCaloriesBreakdown ?? [])[position + 2].calorie.toString(),
                                      style: const TextStyle(
                                        color: ColorCodes.white,
                                        fontSize: 24,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Text(
                                      Strings.kcal,
                                      style: TextStyle(
                                        color: ColorCodes.white,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: ColorCodes.white,
                        size: 20,
                      ),
                      onPressed: () {
                        if (controller.page! == 0) {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: ColorCodes.cardGrey,
        boxShadow: [
          BoxShadow(
            color: ColorCodes.blackWithOpacity,
            blurRadius: 5,
          )
        ],
      ),
      child: DefaultTabController(
        length: 6,
        initialIndex: _selectedTab,
        child: TabBar(
          isScrollable: true,
          indicatorColor: ColorCodes.orange,
          labelColor: ColorCodes.orange,
          unselectedLabelColor: ColorCodes.black,
          padding: const EdgeInsets.symmetric(vertical: 15),
          labelStyle: const TextStyle(
            color: ColorCodes.orange,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          unselectedLabelStyle: const TextStyle(
            color: ColorCodes.black,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          onTap: (val) {
            setState(() {
              _selectedTab = val;
            });
            _onGetStats();
          },
          tabs: const [
            Text(Strings.allMeals),
            Text(Strings.breakfast),
            Text(Strings.lunch),
            Text(Strings.eveningSnacks),
            Text(Strings.dinner),
            Text("Other"),
          ],
        ),
      ),
    );
  }

  // Widget _buildNutrition() {
  //   final data = ref.read(statsProvider);

  //   return Column(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
  //         decoration: const BoxDecoration(
  //           border: Border(
  //             bottom: BorderSide(color: ColorCodes.lightGrey, width: 1),
  //           ),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       data.nutritionValues[0].name,
  //                       style: const TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w400,
  //                         color: ColorCodes.darkGrey,
  //                       ),
  //                     ),
  //                     Text(
  //                       '${data.nutritionValues[0].quantity} ${data.nutritionValues[0].unit}',
  //                       style: const TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.w500,
  //                         color: ColorCodes.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(width: 110),
  //                 Container(
  //                   color: ColorCodes.black.withOpacity(0.4),
  //                   width: 1,
  //                   height: 40,
  //                 ),
  //               ],
  //             ),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   data.nutritionValues[1].name,
  //                   style: const TextStyle(
  //                     fontFamily: 'Poppins',
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w400,
  //                     color: ColorCodes.darkGrey,
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     Text(
  //                       '${data.nutritionValues[1].quantity} ${data.nutritionValues[1].unit}',
  //                       style: const TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.w500,
  //                         color: ColorCodes.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //       Container(
  //         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
  //         decoration: const BoxDecoration(
  //           border: Border(
  //             bottom: BorderSide(color: ColorCodes.lightGrey, width: 1),
  //           ),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       data.nutritionValues[2].name,
  //                       style: const TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w400,
  //                         color: ColorCodes.darkGrey,
  //                       ),
  //                     ),
  //                     Row(
  //                       children: [
  //                         Text(
  //                           '${data.nutritionValues[2].quantity} ${data.nutritionValues[2].unit}',
  //                           style: const TextStyle(
  //                             fontFamily: 'Poppins',
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.w500,
  //                             color: ColorCodes.black,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(width: 97),
  //                 Container(
  //                   color: ColorCodes.black.withOpacity(0.4),
  //                   width: 1,
  //                   height: 40,
  //                 ),
  //               ],
  //             ),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   data.nutritionValues[3].name,
  //                   style: const TextStyle(
  //                     fontFamily: 'Poppins',
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w400,
  //                     color: ColorCodes.darkGrey,
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     Text(
  //                       '${data.nutritionValues[3].quantity} ${data.nutritionValues[3].unit}',
  //                       style: const TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.w500,
  //                         color: ColorCodes.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       data.nutritionValues[4].name,
  //                       style: const TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w400,
  //                         color: ColorCodes.darkGrey,
  //                       ),
  //                     ),
  //                     Row(
  //                       children: [
  //                         Text(
  //                           '${data.nutritionValues[4].quantity} ${data.nutritionValues[4].unit}',
  //                           style: const TextStyle(
  //                             fontFamily: 'Poppins',
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.w500,
  //                             color: ColorCodes.black,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(width: 115),
  //                 Container(
  //                   color: ColorCodes.black.withOpacity(0.4),
  //                   width: 1,
  //                   height: 40,
  //                 ),
  //               ],
  //             ),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   data.nutritionValues[5].name,
  //                   style: const TextStyle(
  //                     fontFamily: 'Poppins',
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w400,
  //                     color: ColorCodes.darkGrey,
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     Text(
  //                       '${data.nutritionValues[5].quantity} ${data.nutritionValues[5].unit}',
  //                       style: const TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.w500,
  //                         color: ColorCodes.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }
  Widget _buildNutrition() {
    final data = ref.read(statsProvider);

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.nutritionValues.length,
        itemBuilder: (itemBuilder,index){
          return Container(
            padding: const EdgeInsets.all(10),
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
                  '${data.nutritionValues[index].name} ',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ColorCodes.darkGrey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  //'${data.nutritionValues[index].quantity} ${data.nutritionValues[index].unit}',
                  '${data.nutritionValues[index].quantity}',
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

    // return Wrap(
    //   direction: Axis.horizontal,
    //   alignment: WrapAlignment.start,
    //   runSpacing: 10,
    //   children: List.generate(
    //     data.nutritionValues.length,
    //     (index) => Container(
    //       margin: const EdgeInsets.symmetric(horizontal: 10),
    //       padding: const EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(5),
    //         color: ColorCodes.white,
    //         border: Border.all(
    //           color: ColorCodes.blackBorder,
    //         ),
    //       ),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             '${data.nutritionValues[index].name} ',
    //             style: const TextStyle(
    //               fontFamily: 'Poppins',
    //               fontSize: 11,
    //               fontWeight: FontWeight.w400,
    //               color: ColorCodes.darkGrey,
    //             ),
    //           ),
    //           const SizedBox(height: 2),
    //           Text(
    //             '${data.nutritionValues[index].quantity} ${data.nutritionValues[index].unit}',
    //             style: const TextStyle(
    //               fontFamily: 'Poppins',
    //               fontSize: 18,
    //               fontWeight: FontWeight.w500,
    //               color: ColorCodes.black,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
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
     
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: ColorCodes.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 20,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/nutrition.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 5),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.nutritionValue,
                                style: TextStyle(
                                  color: ColorCodes.black,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildNutrition(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
