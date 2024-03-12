import 'package:fit_for_life/screens/my_profile/select_dob_screen.dart';
import 'package:fit_for_life/screens/my_profile/update_height_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../color_codes/index.dart';
import '../../model/basic_information.dart';
import '../../services/user_services.dart';
import '../../widgets/button.dart';
import '../select_age/index.dart';
import '../select_location/index.dart';


class EditProfileScreen extends StatefulWidget {
  final basicInfo;

  const EditProfileScreen({super.key,required this.basicInfo});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final userService = UserService();

  TextEditingController _ctrEmail = TextEditingController();
  TextEditingController _ctrPhone = TextEditingController();
  TextEditingController _ctrDoB = TextEditingController();
  TextEditingController _ctrAge = TextEditingController();
  TextEditingController _ctrGender = TextEditingController();
  TextEditingController _ctrHeight = TextEditingController();
  TextEditingController _ctrWeight = TextEditingController();
  TextEditingController _ctrAddress = TextEditingController();
  DateTime? _selectedDate;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

        _ctrEmail.text = widget.basicInfo.email ?? '---';
        _ctrPhone.text = widget.basicInfo.phoneNumber ?? '---';
        _ctrDoB.text = widget.basicInfo.dob ?? '---';
        _ctrAge.text = widget.basicInfo.age.toString() ?? '0';
        _ctrGender.text = widget.basicInfo.gender ?? '---';
        _ctrHeight.text = widget.basicInfo.height ?? '---';
        _ctrWeight.text = widget.basicInfo.weight ?? '---';
        _ctrAddress.text = widget.basicInfo.address ?? '---';

  }

  void _onSubmit(BuildContext _context) async {


    Map<String, dynamic> request = {};

    if(_ctrEmail.text.isNotEmpty){
      request['email'] = _ctrEmail.text;
    }

    if(_ctrPhone.text.isNotEmpty){
      request['contact_number'] = _ctrPhone.text;
    }

    if(_ctrDoB.text.isNotEmpty){
      request['date_of_birth'] = _ctrDoB.text;
      request['age'] = _ctrAge.text;
    }

    if(_ctrGender.text.isNotEmpty){
      request['gender'] = _ctrGender.text;
    }

    if(_ctrHeight.text.isNotEmpty){
      List list = _ctrHeight.text.split(" ");
      request['height'] = list[0].toString();
      request['height_unit'] = list[1].toString();
    }

    if(_ctrWeight.text.isNotEmpty){
      List list = _ctrWeight.text.split(" ");
      request['weight'] = list[0].toString();
      request['weight_unit'] = list[1].toString();
    }

    if(_ctrAddress.text.isNotEmpty){
      request['address'] = _ctrAddress.text;
    }
    print("request $request");

    if (request.isNotEmpty) {
      showLoaderDialog(context);
      final res = await userService.editUserDetails(request);
      Navigator.of(context, rootNavigator: true).pop('dialog');
      print("response edit $res");
      if (res['id'] != null) {
        Navigator.pop(context,"success");
      }
    }

  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 7),
              child:const Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorCodes.darkGreen,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30,),
              TextFormField(
                controller: _ctrEmail,
                readOnly: true,
                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                cursorColor: Colors.grey.shade300,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  contentPadding: EdgeInsets.only(bottom: 5),
                ),
                style: TextStyle(color: Colors.grey,),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  return null;
                },
                onSaved: (value) {

                },
              ),
              SizedBox(height: 30,),
              TextFormField(
                controller: _ctrPhone,
                readOnly: true,
                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                cursorColor: ColorCodes.black,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  labelText: "Phone Number",
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  contentPadding: EdgeInsets.only(bottom: 5),
                ),
                style: TextStyle(color: Colors.grey,),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  return null;
                },
                onSaved: (value) {

                },
              ),
              SizedBox(height: 30,),
              TextFormField(
                controller: _ctrDoB,
                onTap: () async{
                  var data = await Navigator.push(context, MaterialPageRoute(builder: (builder) => SelectDobScreen(basicInfo: widget.basicInfo,)));
                  if(data != null){

                    print("do $data");
                    _selectedDate = data['dob'];
                    _ctrDoB.text = "${_selectedDate!.month}-${_selectedDate!.year.toString()}";
                    _ctrAge.text = data['age'].toString();
                   }
                  },
                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                cursorColor: ColorCodes.black,
                readOnly: true,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(),
                  labelText: "Date of Birth",
                  labelStyle: TextStyle(
                    color: ColorCodes.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  suffixIcon: Icon(Icons.calendar_month),
                  contentPadding: EdgeInsets.only(bottom: 5),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  return null;
                },
                onSaved: (value) {

                },
              ),
              SizedBox(height: 30,),
              TextFormField(
                controller: _ctrGender,
                readOnly: true,
                onTap: (){
                  showModalBottomSheet(context: context,
                      builder: (builder){
                        return Column(
                          children: [
                            Container(
                              color: ColorCodes.darkGreen,
                              height: 60,
                              alignment: Alignment.center,
                              child: const Text("Select Gender",style: TextStyle(
                                color: ColorCodes.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),),
                            ),
                            const SizedBox(height: 20,),
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                                _ctrGender.text = "Male";
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: const Text("Male",style: TextStyle(
                                  color: ColorCodes.black,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                                _ctrGender.text = "Female";
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: const Text("Female",style: TextStyle(
                                  color: ColorCodes.black,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                                _ctrGender.text = "Others";
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: const Text("Others",style: TextStyle(
                                  color: ColorCodes.black,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                  );
                },
                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                cursorColor: ColorCodes.black,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(),
                  labelText: "Gender",
                  labelStyle: TextStyle(
                    color: ColorCodes.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  contentPadding: EdgeInsets.only(bottom: 5),
                  suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  return null;
                },
                onSaved: (value) {

                },
              ),
              SizedBox(height: 30,),
              TextFormField(
                controller: _ctrHeight,
                readOnly: true,
                onTap: () async{
                  var data = await Navigator.push(context, MaterialPageRoute(builder: (builder) => UpdateHeightScreen(basicInfo: widget.basicInfo,)));
                  if(data != null){
                    _ctrHeight.text = data['height'].toString();
                    _ctrWeight.text = data['weight'].toString();
                  }
                },
                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                cursorColor: ColorCodes.black,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(),
                  labelText: "Height",
                  labelStyle: TextStyle(
                    color: ColorCodes.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  contentPadding: EdgeInsets.only(bottom: 5),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  return null;
                },
                onSaved: (value) {

                },
              ),
              SizedBox(height: 30,),
              TextFormField(
                controller: _ctrWeight,
                readOnly: true,
                onTap: () async{
                  var data = await Navigator.push(context, MaterialPageRoute(builder: (builder) => UpdateHeightScreen(basicInfo: widget.basicInfo,)));
                  if(data != null){
                    _ctrHeight.text = data['height'].toString();
                    _ctrWeight.text = data['weight'].toString();
                  }
                },
                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                cursorColor: ColorCodes.black,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(),
                  labelText: "Weight",
                  labelStyle: TextStyle(
                    color: ColorCodes.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  contentPadding: EdgeInsets.only(bottom: 5),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  return null;
                },
                onSaved: (value) {

                },
              ),
              SizedBox(height: 30,),
              TextFormField(
                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                cursorColor: ColorCodes.black,
                controller: _ctrAddress,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(),
                  labelText: "Address",
                  labelStyle: TextStyle(
                    color: ColorCodes.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  contentPadding: EdgeInsets.only(bottom: 5),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  return null;
                },
                onSaved: (value) {

                },
              ),
              SizedBox(height: 30,),
              Container(
                alignment: Alignment.center,
                child: Button(
                  onPress: (){
                    _onSubmit(context);
                  },
                  label: "Update",
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),

    );
  }
}
