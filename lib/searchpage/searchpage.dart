import 'package:closing_deal/constants/colors.dart';
import 'package:flutter/material.dart';

import '../constants/images.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  TextEditingController _controller = TextEditingController();
  List<String> _items = List.generate(100, (index) => 'Item $index');
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cWhiteColor,
        bottomOpacity: 0.6,
        centerTitle: true,
        title: Image.asset(
          Images.LOGO,
          height: 30,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: cBlackColor, // Border color
                      width: 2.0, // Border widt
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: cBlackColor, // Border color
                      width: 2.0, // Border widt
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: cBlackColor, // Border color
                      width: 2.0, // Border widt
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: cBlackColor, // Border color
                      width: 2.0, // Border widt
                    ),
                  ),
                  suffixIcon: SizedBox(
                    height: 30,
                    child: Icon(
                      Icons.search,
                      color: cBlackColor,
                      size: 20,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
