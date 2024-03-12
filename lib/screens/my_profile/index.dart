
import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/model/basic_information.dart';
import 'package:fit_for_life/provider/user_details.dart';
import 'package:fit_for_life/screens/login/index.dart';
import 'package:fit_for_life/services/home_service.dart';
import 'package:fit_for_life/services/shared_preferences.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit_profile_screen.dart';

final homeService = HomeService();

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MyProfileScreenState();
  }
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  List<BasicInformation> _basicInfo = [];
  bool _isLoading = false;
  var basicData;

  @override
  void initState() {
    super.initState();
    _onGetUserDetails();
  }

  void _onGetUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    final res = await homeService.onFetchUserDetails();
    if (res.isNotEmpty) {
      final userData = res['data'];
      print("userData $userData");
      await ref.read(userDetailsProvider.notifier).onSaveUserDetails(userData);
      _setBasicInfo();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _setBasicInfo() {
    final data = ref.read(userDetailsProvider);
    basicData = data;
    print("basicData ${basicData}");
    List<BasicInformation> arr = [];
    arr.addAll([
      BasicInformation(label: Strings.email, value: data.email ?? '---'),
      BasicInformation(label: Strings.phoneNumber, value: data.phoneNumber ?? '---'),
      BasicInformation(label: Strings.dob, value: data.dob ?? '---'),
      BasicInformation(label: Strings.age, value: (data.age ?? '---').toString()),
      BasicInformation(label: Strings.gender, value: data.gender ?? '---'),
      BasicInformation(label: Strings.height, value: data.height ?? '---'),
      BasicInformation(label: Strings.weight, value: data.weight ?? '---'),
      BasicInformation(label: Strings.address, value: data.address ?? '---'),
    ]);

    setState(() {
      _basicInfo = arr;
    });
  }

  void _onLogout() async {
    await SharedPreference.clearStorage();
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(showBackButton: false),
      ),
    );
  }

  Widget _buildHeader() {
    final data = ref.read(userDetailsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      color: ColorCodes.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                Strings.myProfile,
                style: TextStyle(
                  color: ColorCodes.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(
                onTap: _onLogout,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logout.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      Strings.logout,
                      style: TextStyle(
                        color: ColorCodes.white,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            ],
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
                    : const */CircleAvatar(
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
                    data.name ?? '',
                    style: const TextStyle(
                      color: ColorCodes.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${Strings.age}: ${data.age}',
                    style: const TextStyle(
                      color: ColorCodes.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${Strings.kcal}: ${data.calories}',
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

  Widget _buildHealthIssues() {
    final data = ref.read(userDetailsProvider);
    final healthIssues = data.healthIssues ?? [];

    return SizedBox(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          healthIssues.length,
          (index) => Container(
            height: 33,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorCodes.green,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  healthIssues[index],
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ColorCodes.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.read(userDetailsProvider);

    if (_isLoading) {
      return const Loader(
        opacity: 1,
        bgColor: ColorCodes.white,
      );
    }

    return Scaffold(
      backgroundColor: ColorCodes.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 26),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/basicInfo.png',
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          Strings.basicInformation,
                          style: TextStyle(
                            color: ColorCodes.lightBlack,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () async{
                              var data = await Navigator.push(context, MaterialPageRoute(builder: (builder) => EditProfileScreen(basicInfo: basicData,)));
                              if(data != null && data == "success"){
                                print("adasdas $data");
                                _onGetUserDetails();
                              }
                              },
                            icon: Icon(Icons.edit,color: Colors.grey,)
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 9, bottom: 8, left: 19),
                      margin: const EdgeInsets.only(left: 11),
                      decoration: const BoxDecoration(
                        border: Border(left: BorderSide(color: ColorCodes.black, width: 1)),
                      ),
                      child: ListView.builder(
                        itemCount: _basicInfo.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 103,
                                child: Text(
                                  _basicInfo[index].label,
                                  style: const TextStyle(
                                    color: ColorCodes.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const Text(
                                ':',
                                style: TextStyle(
                                  color: ColorCodes.black,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 5),
                              SizedBox(
                                width: 175,
                                child: Text(
                                  _basicInfo[index].value,
                                  style: const TextStyle(
                                    color: ColorCodes.slaty,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/food.png',
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          Strings.foodPreferences,
                          style: TextStyle(
                            color: ColorCodes.lightBlack,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 24, left: 19),
                      margin: const EdgeInsets.only(left: 11),
                      decoration: const BoxDecoration(
                        border: Border(left: BorderSide(color: ColorCodes.black, width: 1)),
                      ),
                      child: Text(
                        data.foodPreference ?? '---',
                        style: const TextStyle(
                          color: ColorCodes.slaty,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/healthIssues.png',
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          Strings.healthIssues,
                          style: TextStyle(
                            color: ColorCodes.lightBlack,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 24, left: 19),
                      margin: const EdgeInsets.only(left: 11),
                      decoration: const BoxDecoration(
                        border: Border(left: BorderSide(color: ColorCodes.black, width: 1)),
                      ),
                      child: _buildHealthIssues(),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/help.png',
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          Strings.helpSupport,
                          style: TextStyle(
                            color: ColorCodes.lightBlack,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
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
