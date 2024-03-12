import 'package:closing_deal/constants/colors.dart';
import 'package:closing_deal/constants/images.dart';
import 'package:closing_deal/profiledetailspage/profiledetailspage.dart';
import 'package:closing_deal/searchpage/searchpage.dart';
import 'package:closing_deal/seedetailspage/seedetailspage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../uploadagentproperty/uploadagentpropert.dart';
import '../willpopuppage/willpopuppage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  final List<String> items = [
    'ALL',
    'Flat',
    'Villas',
    'Indipendent',
  ];
  String? selectedValue;
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        willpopAlert2(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          bottomOpacity: 0.5,
          automaticallyImplyLeading: false,
          backgroundColor: cWhiteColor,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileDetailsPage()),
                );
              },
              icon: Icon(
                Icons.person,
                color: cBlackColor,
                size: 30,
              )),
          title: Image.asset(
            Images.LOGO,
            height: 30,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                icon: Icon(
                  Icons.search,
                  color: cBlackColor,
                  size: 35,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    // color: cSecondryColor,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Select Item',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: cBlackColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: items
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: cBlackColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 160,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: cWhiteColor.withOpacity(0.5),
                            ),
                            color: cWhiteColor,
                          ),
                          elevation: 2,
                        ),
                      
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: cWhiteColor,
                          ),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    itemCount: 20,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemBuilder: ((BuildContext context, index) {
                      return SingleChildScrollView(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                color: cWhiteColor,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(0, 3),
                                  )
                                ]),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          20), // Adjust the radius as needed
                                      child: Image.asset(
                                        Images
                                            .BUILDING, // Replace with your image path
                                        width:
                                            100, // Adjust image width as needed
                                        height:
                                            100, // Adjust image height as needed
                                        fit: BoxFit
                                            .cover, // Adjust the fit as needed
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              '2 and 3BHK Apartment.........',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: cBlackColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            '3 bed Room Flat 2020 sq ft East facing and corner 30th Floor Basil Kokapet',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SeeDetailsPage()),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: cPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: cPrimaryColor)),
                                              child: Text(
                                                'See Details',
                                                style: TextStyle(
                                                    color: cWhiteColor,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
