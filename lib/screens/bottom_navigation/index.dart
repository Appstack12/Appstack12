import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/screens/daily_calories/index.dart';
import 'package:fit_for_life/screens/my_profile/index.dart';
import 'package:fit_for_life/screens/weekly-stats/index.dart';
import 'package:fit_for_life/screens/notification/index.dart';
import 'package:fit_for_life/services/home_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeService = HomeService();

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends ConsumerState<BottomNavigation> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_selectedIndex].currentState!.maybePop();

        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              label: '',
              icon: Image.asset(
                'assets/images/dashboard.png',
                color: ColorCodes.black,
                width: 22,
                height: 22,
              ),
              activeIcon: Image.asset(
                'assets/images/dashboard.png',
                color: ColorCodes.green,
                width: 22,
                height: 22,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Image.asset(
                'assets/images/stats.png',
                color: ColorCodes.black,
                width: 22,
                height: 22,
              ),
              activeIcon: Image.asset(
                'assets/images/stats.png',
                color: ColorCodes.green,
                width: 22,
                height: 22,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Image.asset(
                'assets/images/notification.png',
                color: ColorCodes.black,
                width: 22,
                height: 22,
              ),
              activeIcon: Image.asset(
                'assets/images/notification.png',
                color: ColorCodes.green,
                width: 22,
                height: 22,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Image.asset(
                'assets/images/profileBottom.png',
                color: ColorCodes.black,
                width: 22,
                height: 22,
              ),
              activeIcon: Image.asset(
                'assets/images/profileBottom.png',
                color: ColorCodes.green,
                width: 22,
                height: 22,
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
          ],
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          const DailyCaloriesScreen(),
          const WeeklyStatsScreen(),
          const NotificationScreen(),
          const MyProfileScreen(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }
}
