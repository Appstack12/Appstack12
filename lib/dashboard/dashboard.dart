import 'package:closing_deal/constants/colors.dart';
import 'package:closing_deal/homepage/homepage.dart';
import 'package:closing_deal/profiledetailspage/profiledetailspage.dart';
import 'package:closing_deal/seedetailspage/seedetailspage.dart';
import 'package:closing_deal/uploadagentproperty/uploadagentpropert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:slider_button/slider_button.dart';
import 'package:sweep_animation_button/sweep_animation_button.dart';

import '../constants/images.dart';
import '../willpopuppage/willpopuppage.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  bool isChanged = true;
  bool visibility = true;
  bool isrent = true;
  bool rentvisibility = true;
  final List<String> titles = ['Buy', 'Rent', 'Sell'];
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        willpopAlert2(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cWhiteColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Image.asset(
            Images.LOGO,
            height: 40,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileDetailsPage()),
                  );
                },
                icon: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Color(0xff0b3940),
                      borderRadius: BorderRadius.circular(45)),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: cWhiteColor,
                  ),
                ))
          ],
        ),
        body: Stack(alignment: Alignment.bottomCenter, children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff0b3940),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sell',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: cWhiteColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        '44',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: cWhiteColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: cWhiteColor, // Color of the divider
                                    thickness: 2, // Thickness of the divider
                                    indent:
                                        10, // Empty space before the divider
                                    endIndent:
                                        10, // Empty space after the divider
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Rent',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: cWhiteColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        '44',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: cWhiteColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: Text(
                      'Recently Added',
                      style: TextStyle(
                          color: Color(0xff0b3940),
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      itemBuilder: ((BuildContext context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SeeDetailsPage()),
                            );
                          },
                          child: SingleChildScrollView(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    color: cWhiteColor,
                                    borderRadius: BorderRadius.circular(10),
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
                                              5), // Adjust the radius as needed
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: cBlackColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700),
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
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
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
                          ),
                        );
                      })),
                  SizedBox(
                    height: 7,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                            color: Color(0xff0b3940),
                            borderRadius: BorderRadius.circular(30),
                            border:
                                Border.all(color: Color(0xff0b3940), width: 2)),
                        child: Text(
                          'View All',
                          style: TextStyle(
                              color: cWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                        decoration: BoxDecoration(
                          color: cWhiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Container(
                                height: 10,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: cBlackColor, width: 1)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Agent Upload For :',
                              style: TextStyle(
                                  color: cBlackColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: titles.length,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UploadAgentPropert(title: titles[index])),
                                  );
                                },
                                title: Text(
                                  titles[index].toString(),
                                  style: TextStyle(
                                      color: cBlackColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              );
                            }),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ));
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 14),
                padding: EdgeInsets.only(right: 15, top: 8, bottom: 8),
                decoration: BoxDecoration(
                    color: cPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: cPrimaryColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 7),
                        decoration: BoxDecoration(
                            color: cPrimaryColor,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: cWhiteColor, width: 3)),
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: cWhiteColor,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Upload Property',
                      style: TextStyle(color: cWhiteColor, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
