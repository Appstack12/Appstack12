import 'package:closing_deal/constants/images.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../constants/colors.dart';

class SeeDetailsPage extends StatefulWidget {
  const SeeDetailsPage({super.key});

  @override
  State<SeeDetailsPage> createState() => _SeeDetailsPageState();
}

class _SeeDetailsPageState extends State<SeeDetailsPage> {
  @override
  static const List<String> sampleImages = [
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=9',
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                FanCarouselImageSlider(
                  imagesLink: sampleImages,
                  isAssets: false,
                  autoPlay: false,
                  expandImageHeight: MediaQuery.of(context).size.height * 0.9,
                  expandImageWidth: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          // width: 250,

                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '2 and 3BHK Apartment.........',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: cBlackColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                            color: cSecondryColor,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: cSecondryColor, width: 2)),
                        child: Text(
                          'For Sale',
                          style: TextStyle(
                              color: cWhiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                        'PerSquarefeet :',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        '₹' + '5400*',
                        style: TextStyle(
                            color: cPrimaryColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Container(
                  padding: EdgeInsets.only(left: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '1000 to 1300' + '(SQFT)',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: cBlackColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Container(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    '3 bed Room Flat 2020 sq ft East facing and corner 30th Floor Basil Kokapet',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        color: cPrimaryColor,
                        size: 20,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        'Ammenpur',
                        style: TextStyle(
                          color: cBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                )
              ],
            ),
            Positioned(
              top: 25,
              left: 12,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: cBlackColor,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
