import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:closing_deal/constants/colors.dart';
import 'package:closing_deal/uploadagentproperty/uploadvedio.dart';
import 'package:closing_deal/userdetailspage/userdetailspage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../constants/images.dart';
import '../dropdownmodel/dropdownmodel.dart';

class UploadAgentPropert extends StatefulWidget {
  final String title;
  const UploadAgentPropert({super.key, required this.title});

  @override
  State<UploadAgentPropert> createState() => _UploadAgentPropertState();
}

class _UploadAgentPropertState extends State<UploadAgentPropert> {
  CameraController? _controller;
  VideoPlayerController? _videoController;
  String? _videoPath;
  List<File> _images = [];
  List<File> _vedio = [];
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController city = TextEditingController();
  final TextEditingController society = TextEditingController();
  final TextEditingController Area = TextEditingController();
  final TextEditingController Coperate = TextEditingController();
  final TextEditingController BookingToken = TextEditingController();
  final TextEditingController Maintainence = TextEditingController();
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> vediofile(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: source);
    if (pickedFile != null) {
      setState(() {
        _vedio.add(File(pickedFile.path));
        // Play the selected video
        _videoController = VideoPlayerController.file(File(pickedFile.path))
          ..initialize().then((_) {
            setState(() {
              _videoController!.play();
            });
          });
      });
    }
  }

  @override
  void initState() {
    // _controller = VideoPlayerController.asset('');
    super.initState();
    print(widget.title.toString());
  }

  bool _isLoading = false;

  final List<DropdownItem> Areaitems = [
    DropdownItem('value1', 'SQFT'),
    DropdownItem('value2', 'SQYARD')
  ];
  final List<DropdownItem> Coperateitems = [
    DropdownItem('value1', 'SQRFT'),
    DropdownItem('value2', 'SQRYARD')
  ];
  final List<DropdownItem> dropdownItems = [
    DropdownItem('value1', 'Brooklyn'),
    DropdownItem('value2', 'Flat/Appartment'),
    DropdownItem('value3', 'Residential House'),
    DropdownItem('value4', 'Villa'),
    DropdownItem('value5', 'Builder Floor Apartment')
  ];
  final List<DropdownItem> propertytype = [
    DropdownItem('value1', 'New Property'),
    DropdownItem('value2', 'Resale')
  ];
  final List<DropdownItem> propertystatus = [
    DropdownItem('value1', 'Under Construction'),
    DropdownItem('value2', 'Ready to Move')
  ];
  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 90,
          leading: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: cBlackColor,
                  )))),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Agent Upload Form' ,
                              style: TextStyle(
                                  color: cBlackColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Upload Property'+ widget.title.toString(),
                              style: TextStyle(
                                  color: cPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'General Information',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Propertytype',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Property(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'City',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      City(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Name of Project/Society',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      NameOfProject(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Area',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AreaFeet(),
                      Text(
                        'Carpet Area',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CorpoprateArea(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Transction Type',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      PropertyAvailabuilty(),
                      Text(
                        'Possession Status',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      PossessionStatus(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Booking/Token Amount',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BookingTokenAmount(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Maintainence Charges',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      MaintainenceCharges(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Photos',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: _showImageOptions,
                        child: DottedBorder(
                          color: cBlackColor,
                          strokeWidth: 2,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                color: cWhiteColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: Icon(
                              Icons.upload,
                              color: cBlackColor,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (_images.isNotEmpty)
                        Container(
                          height: 150,
                          child: ListView.builder(
                            itemCount: _images.length,
                            scrollDirection: Axis.horizontal,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        height: 100,
                                        child: Image.file(_images[index])),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => _deleteImage(index),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Upload vedios',
                        style: TextStyle(
                            color: cBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      GestureDetector(
                        onTap: () {
                          vediofile(ImageSource.camera);
                        },
                        child: DottedBorder(
                          color: cBlackColor,
                          strokeWidth: 2,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                color: cWhiteColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: Icon(
                              Icons.upload,
                              color: cBlackColor,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      if (_vedio.isNotEmpty)
                        _videoController != null &&
                                _videoController!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              )
                            : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      _isLoading
                          ? CircularProgressIndicator(
                              color: cPrimaryColor,
                            )
                          : Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate() &&
                                      _images != null) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    print(_images.toString());
                                    Future.delayed(Duration(seconds: 1), () {
                                      // Form is valid, proceed with submission
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UploadSucessfulyPage()),
                                      );
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 40),
                                  decoration: BoxDecoration(
                                    color: cPrimaryColor,
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(color: cPrimaryColor),
                                  ),
                                  child: Text(
                                    'Upload',
                                    style: TextStyle(
                                        color: cWhiteColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20),
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }

  Widget Property() {
    return Container(
      child: TextFormFieldWithDropdown(
        hinttext: 'select a propertytype',
        dropdownItems: dropdownItems,
      ),
    );
  }

  Widget City() {
    return Container(
      child: TextFormField(
        controller: city,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter City';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'City',
          hintStyle: TextStyle(
              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget NameOfProject() {
    return Container(
      child: TextFormField(
        controller: society,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter Socity';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Name Of Projecr/Society',
          hintStyle: TextStyle(
              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget AreaFeet() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormFieldWithDropdown(
              hinttext: 'Select Area',
              dropdownItems: Areaitems,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Container(
            child: TextFormField(
              controller: Area,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Area';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Area',
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: cBlackColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: cBlackColor, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: cBlackColor, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: cBlackColor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: cBlackColor, width: 2),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget CorpoprateArea() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormFieldWithDropdown(
              hinttext: 'Select state',
              dropdownItems: Coperateitems,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Container(
            child: TextFormField(
              controller: Coperate,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Carpet Area';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Carpet Area',
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: cBlackColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: cBlackColor, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: cBlackColor, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: cBlackColor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: cBlackColor, width: 2),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget PropertyAvailabuilty() {
    return Container(
        child: TextFormFieldWithDropdown(
      hinttext: 'Propert type',
      dropdownItems: propertytype,
    ));
  }

  Widget PossessionStatus() {
    return Container(
      child: TextFormFieldWithDropdown(
          hinttext: 'Property Status', dropdownItems: propertystatus),
    );
  }

  Widget BookingTokenAmount() {
    return Container(
      child: Container(
        child: TextFormField(
          controller: BookingToken,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter TokenAmount';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Booking/Token Amount',
            hintStyle: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: cBlackColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: cBlackColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: cBlackColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: cBlackColor, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: cBlackColor, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget MaintainenceCharges() {
    return Container(
      child: TextFormField(
        controller: Maintainence,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter Maintainence';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Maintainence Chjarges',
          hintStyle: TextStyle(
              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: cBlackColor, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _videoController?.dispose();
    super.dispose();
  }
}
