import 'package:fit_for_life/screens/login/index.dart';
import 'package:flutter/material.dart';
import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/widgets/button.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:carousel_slider/carousel_slider.dart';

const data = [
  {
    'image': 'assets/images/carousel.png',
    'title': Strings.eatHealthy,
    'desc': Strings.maintainHealth,
  },
  {
    'image': 'assets/images/carousel.png',
    'title': Strings.eatHealthy,
    'desc': Strings.maintainHealth,
  },
  {
    'image': 'assets/images/carousel.png',
    'title': Strings.eatHealthy,
    'desc': Strings.maintainHealth,
  },
];

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  void _onNavigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const LoginScreen(),
      ),
    );
  }

  Widget _buildCarouselItem(item) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Image.asset(
          item['image'],
          height: 206,
          width: 206,
        ),
        const SizedBox(height: 48),
        Text(
          item['title'],
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: ColorCodes.lightBlack,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 254,
          child: Text(
            item['desc'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ColorCodes.grey,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                height: 500,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: data.map((i) => _buildCarouselItem(i)).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: data.asMap().entries.map((entry) {
                final isActive = _current == entry.key;
                return GestureDetector(
                  onTap: () {
                    _controller.animateToPage(entry.key);
                  },
                  child: Container(
                    width: isActive ? 29 : 21,
                    height: 11,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: (Theme.of(context).brightness == Brightness.dark ? ColorCodes.orange : ColorCodes.orange)
                            .withOpacity(isActive ? 1 : 0.4)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 59),
            Button(onPress: _onNavigate, label: Strings.getStarted)
          ],
        ),
      ),
    );
  }
}
