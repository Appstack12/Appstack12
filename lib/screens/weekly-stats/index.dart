import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/provider/user_profile.dart';
import 'package:fit_for_life/services/home_service.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


final homeService = HomeService();

class WeeklyStatsScreen extends ConsumerStatefulWidget {
  const WeeklyStatsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _WeeklyStatsScreenState();
  }
}

class _WeeklyStatsScreenState extends ConsumerState<WeeklyStatsScreen> {
  // Todo:- Will use it later.
  // String _selectedStats = Strings.monthly;
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  List<String> weekDates=[];

  final stats = [
    Strings.monthly,
    Strings.weekly,
  ];
  bool _isLoading = true;
  List<String> _tabsData = ['Carbs','Proteins','Fats','GL'];
  String currentTab='Carbs';
  List<dynamic> _lineChartData = [];

   DateTime startDate =  DateTime.now();
   DateTime endDate =  DateTime.now();
   var fromDate = DateTime.now();
   bool nextAvl = false;

   var weekResponseData;
   var userData;

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  void setWeekDate(){
    startDate = getDate(fromDate.subtract(Duration(days: fromDate.weekday - 1)));
    endDate = getDate(fromDate.add(Duration(days: DateTime.daysPerWeek - fromDate.weekday)));

    weekDates = [
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 1)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 2)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 3)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 4)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 5)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 6)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 7)))),
    ];

    print("weekDates $weekDates");
    print("startDate ${DateFormat('yyyy-MM-dd').format(startDate)}");
    print("endDate ${DateFormat('yyyy-MM-dd').format(endDate)}");
    _onGetWeeklyCaloriesData();
  }
  void previousWeek(){
    fromDate = DateTime(startDate.year,startDate.month,startDate.day - 7);
    startDate = getDate(fromDate.subtract(Duration(days: fromDate.weekday - 1)));
    endDate = getDate(fromDate.add(Duration(days: DateTime.daysPerWeek - fromDate.weekday)));
    nextAvl = true;

    weekDates = [
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 1)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 2)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 3)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 4)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 5)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 6)))),
      DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 7)))),
    ];

    print("previousWeek weekDates $weekDates");
    setState(() {});
    _onGetWeeklyCaloriesData();
  }
  void nextWeek(){
    if(nextAvl){
      fromDate = DateTime(startDate.year,startDate.month,startDate.day + 7);
      startDate = getDate(fromDate.subtract(Duration(days: fromDate.weekday - 1)));
      endDate = getDate(fromDate.add(Duration(days: DateTime.daysPerWeek - fromDate.weekday)));
      nextAvl = endDate == getDate(DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))) ? false : true;

      weekDates = [
        DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 1)))),
        DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 2)))),
        DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 3)))),
        DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 4)))),
        DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 5)))),
        DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 6)))),
        DateFormat('yyyy-MM-dd').format(getDate(fromDate.subtract(Duration(days: fromDate.weekday - 7)))),
      ];

      print("nextWeek weekDates $weekDates");
      setState(() {});
      _onGetWeeklyCaloriesData();
    }


  }

  @override
  void initState() {
    super.initState();
    setWeekDate();
    //_onGetUserProfile();
  }

  void _onGetWeeklyCaloriesData() async {
    setState(() {
      _isLoading = true;
    });

    final res = await homeService.onFetchWeeklyCaloriesData(DateFormat('yyyy-MM-dd').format(startDate),DateFormat('yyyy-MM-dd').format(endDate));
    print("onFetchWeeklyCaloriesData ${res}");
    final calorieData = res['data'];
    weekResponseData = calorieData;
    userData = calorieData;
    // final res = await homeService.onFetchDailyCaloriesData(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    // if (res.isNotEmpty) {
    //   final calorieData = res['data'];
    //   print("calorieData ${calorieData}");
    //
    //   // print("calorieData $calorieData");
    //   // await ref.read(dailyCalorieProvider.notifier).onSaveDailyCalorieData(calorieData);
    // }

    setState(() {
      _isLoading = false;
    });
  }
  // void _onGetUserProfile() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   // Todo:- Will use it later.
  //   // final date = DateTime.now();
  //   // final startDate = DateFormat('yyyy-MM-dd')
  //   //     .format(DateTime(date.year, date.month, date.day - 6));
  //   // final endDate = DateFormat('yyyy-MM-dd').format(date);
  //
  //   final res = await homeService.onFetchUserProfile();
  //   print("homeService $res");
  //   if (res.isNotEmpty) {
  //      userData = res['data'];
  //     //_buildTabsData();
  //   }
  //
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  // void _buildTabsData() {
  //   final data = ref.read(userProfileProvider);
  //
  //   //var tabs = data.nutritionIntake?.dataPoints.map((e) => e.name).toList() ?? [];
  //   var tabs = ['Carbs','Proteins','Fats','Gl'];
  //   setState(() {
  //     _tabsData = tabs;
  //   });
  //
  //   print("_tabsData ${_tabsData}");
  //
  //   if (tabs.isNotEmpty) {
  //     setState(() {
  //       //_lineChartData = data.nutritionIntake?.dataPoints[0].values ?? [];
  //     });
  //   }
  // }

  List<FlSpot> _getLinerChartData() {
    final List<FlSpot> spots = [];

    for (int i = 0; i < 7; i++) {
      // double val = i== 0 ? 100 : i== 1 ? 200 :  i == 3 ? 150 :
      // i == 3 ? 350 : i == 4 ? 450 : i == 5 ? 750 : i == 6 ? 550 : 100;
      var key='';
      if(currentTab == "Carbs"){
        key = 'carbs';
      }else if(currentTab == "Proteins"){
        key = 'gross_protein';
      }else if(currentTab == "Fats"){
        key = 'total_fat';
      }else if(currentTab == "GL"){
        key = 'gl';
      }
      //print("dasdasdas ${weekResponseData['nutrition_intake']['data_points']['${weekDates[i]}'][key]}");
      if(weekResponseData['nutrition_intake']['data_points']['${weekDates[i]}'].toString() == 'null'){
        spots.add(
          FlSpot(double.parse(i.toString()), 0),
        );
      }else{
        spots.add(
          FlSpot(double.parse(i.toString()), double.parse(weekResponseData['nutrition_intake']['data_points']['${weekDates[i]}'][key].toString()) ?? 0),
        );
      }
      // spots.add(
      //   //FlSpot(i, _lineChartData[i.toInt()]),
      //   FlSpot(i, val),
      // );
    }

    return spots;
  }

  BarChartData mainBarData() {
    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            interval: 300,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(
            color: ColorCodes.slaty,
          ),
          bottom: BorderSide(
            color: ColorCodes.slaty,
          ),
        ),
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        horizontalInterval: 100,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: ColorCodes.borderColor,
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: ColorCodes.grey,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Mon', style: style);
        break;
      case 1:
        text = const Text('Tue', style: style);
        break;
      case 2:
        text = const Text('Wed', style: style);
        break;
      case 3:
        text = const Text('Thu', style: style);
        break;
      case 4:
        text = const Text('Fri', style: style);
        break;
      case 5:
        text = const Text('Sat', style: style);
        break;
      case 6:
        text = const Text('Sun', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  List<BarChartGroupData> showingGroups() {
    final data = ref.read(userProfileProvider);
    final List<BarChartGroupData> dataPoints = [];

    for (var i = 0; i < 7; i++) {
      // double val = i== 0 ? 100 : i== 1 ? 200 :  i == 3 ? 150 :
      // i == 3 ? 350 : i == 4 ? 450 : i == 5 ? 750 : i == 6 ? 550 : 100;
      //print("dsd ${i}");
      //print("dsd ${weekDates[i]}");
      //print("dasdasdas ${weekResponseData['calorie_intake']['daywise_stats']['${weekDates[i]}']}");
      if(weekResponseData['calorie_intake']['daywise_stats']['${weekDates[i]}'].toString() == 'null'){
        dataPoints.add(
          makeGroupData(i,0),
          //makeGroupData(i, val),
        );
      }else{
        dataPoints.add(
          makeGroupData(i, double.parse(weekResponseData['calorie_intake']['daywise_stats']['${weekDates[i]}'].toString()) ?? 0),
          //makeGroupData(i, val),
        );
      }

    }
    return dataPoints;
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: ColorCodes.darkGreen,
          
          width: 22,
          
          borderRadius: BorderRadius.circular(0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 3000,
            color: ColorCodes.transparent,
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: 10,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: ColorCodes.borderColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 70,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(
            color: ColorCodes.slaty,
          ),
          bottom: BorderSide(
            color: ColorCodes.slaty,
          ),
        ),
      ),
      minX: 0,
      maxX: 7,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: _getLinerChartData(),
          isCurved: true,
          color: ColorCodes.blue.withOpacity(0.5),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: ColorCodes.blue.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: ColorCodes.grey,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    return Text(
      '${value.toString()}gms',
      style: style,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: ColorCodes.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            Strings.weeklyStats,
            style: TextStyle(
              color: ColorCodes.white,
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorCodes.borderGreen,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: /*data.profileImage != null
                    ? CircleAvatar(
                        radius: 47,
                        backgroundImage: NetworkImage(
                          data.profileImage!,
                        ),
                      )
                    :*/ const CircleAvatar(
                        radius: 47,
                        backgroundImage: AssetImage(
                          'assets/images/user.png',
                        ),
                      ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData['name']!,
                    style: const TextStyle(
                      color: ColorCodes.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${Strings.age}: ${userData['age']}',
                    style: const TextStyle(
                      color: ColorCodes.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${Strings.kcal}: ${userData['calories']}',
                    style: const TextStyle(
                      color: ColorCodes.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySelection() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      color: ColorCodes.normalGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            Strings.weeklyStats,
            style: TextStyle(
              color: ColorCodes.lightBlack,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              InkWell(
                onTap: (){
                  previousWeek();
                },
                child: const Icon(Icons.arrow_back_ios_rounded,size: 20,),
              ),
              Text("${startDate.day} ${months[startDate.month - 1]} - ",style: const TextStyle(
                color: ColorCodes.lightBlack,
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
               ),
              ),
              Text("${endDate.day} ${months[startDate.month - 1]}",style: const TextStyle(
                color: ColorCodes.lightBlack,
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              ),
              InkWell(
                onTap: (){
                  nextWeek();
                },
                child: const Icon(Icons.arrow_forward_ios_rounded,size: 20,),
              ),
            ],
          ),
          // Todo: Will use it later.
          // Expanded(
          //   child: DropdownButtonHideUnderline(
          //     child: Container(
          //       constraints: const BoxConstraints(minHeight: 40),
          //       decoration: BoxDecoration(
          //         border: Border(
          //           bottom: BorderSide(
          //             color: ColorCodes.black.withOpacity(0.4),
          //           ),
          //         ),
          //         color: ColorCodes.normalGrey,
          //       ),
          //       child: DropdownButton(
          //         borderRadius: BorderRadius.circular(10),
          //         isExpanded: false,
          //         value: _selectedStats,
          //         items: stats
          //             .map(
          //               (stat) => DropdownMenuItem(
          //                 value: stat,
          //                 child: Text(stat),
          //               ),
          //             )
          //             .toList(),
          //         onChanged: (value) {
          //           if (value != null) {
          //             setState(() {
          //               _selectedStats = value;
          //             });
          //           }
          //         },
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        mainBarData(),
        swapAnimationDuration: const Duration(milliseconds: 150),
      ),
    );
  }

  Widget _buildTabs() {
    //final data = ref.read(userProfileProvider);

    print("_tabsData ${_tabsData}");
    return Container(
      decoration: const BoxDecoration(
        color: ColorCodes.white,
        border: Border(
          bottom: BorderSide(
            color: ColorCodes.lightWhite,
          ),
        ),
      ),
      child: DefaultTabController(
        initialIndex: 0,
        length: _tabsData.length,
        child: TabBar(
          isScrollable: true,
          indicatorColor: ColorCodes.blue,
          labelColor: ColorCodes.blue,
          unselectedLabelColor: ColorCodes.grey,
          padding: const EdgeInsets.only(top: 15),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: Colors.black
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: Colors.black
          ),
          tabs: _tabsData.map((e) => Text(e)).toList(),
          onTap: (val) {
            setState(() {
              currentTab = _tabsData[val].toString();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.read(userProfileProvider);


    if (_isLoading) {
      return const Loader(
        opacity: 1,
        bgColor: ColorCodes.white,
      );
    }
    print("weekResponseData $weekResponseData");
    return Scaffold(
      backgroundColor: ColorCodes.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildWeeklySelection(),
          const SizedBox(height: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      Strings.calorieIntake,
                      style: TextStyle(
                        color: ColorCodes.lightBlack,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${Strings.averageGoal}: ${weekResponseData['calorie_intake']['average_calorie'].toString()}',
                      style: const TextStyle(
                        color: ColorCodes.lightGrey,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // const LinearProgressIndicator(
                    //   value: 0.2,
                    //   minHeight: 2,
                    //   color: ColorCodes.blue,
                    //   backgroundColor: ColorCodes.borderColor,
                    // ),
                    const SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height/2,
                      child: _buildBarChart()),

                    const SizedBox(height: 20),
                    const Text(
                      "Calorie ${Strings.nutrientIntake}",
                      style: TextStyle(
                        color: ColorCodes.lightBlack,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // const Text(
                    //   Strings.nutrientIntake,
                    //   style: TextStyle(
                    //     color: ColorCodes.lightBlack,
                    //     fontSize: 14,
                    //     fontFamily: 'Poppins',
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    const Text(
                      Strings.averageChosenPeriod,
                      style: TextStyle(
                        color: ColorCodes.lightGrey,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // const LinearProgressIndicator(
                    //   value: 0.2,
                    //   minHeight: 2,
                    //   color: ColorCodes.blue,
                    //   backgroundColor: ColorCodes.borderColor,
                    // ),
                    _buildTabs(),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        mainData(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
