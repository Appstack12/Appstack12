// ignore_for_file: use_build_context_synchronously

import 'package:fit_for_life/model/user.dart';
import 'package:fit_for_life/provider/user_provider.dart';
import 'package:fit_for_life/screens/bottom_navigation/index.dart';
import 'package:fit_for_life/services/shared_preferences.dart';
import 'package:fit_for_life/services/user_services.dart';
import 'package:fit_for_life/widgets/button.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:flutter/material.dart';

import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userService = UserService();

class SelectHealthIssuesScreen extends ConsumerStatefulWidget {
  const SelectHealthIssuesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectHealthIssuesScreen> createState() {
    return _SelectHealthIssuesScreenState();
  }
}

class _SelectHealthIssuesScreenState extends ConsumerState<SelectHealthIssuesScreen> {
  bool _isLoading = false;
  var _selectedHealthIssue = [Strings.none];
  final _healthIssues = [
    Strings.none,
    Strings.weightManagement,
    Strings.overWeight,
    Strings.underWeight,
    Strings.pcod,
    Strings.heartHealth,
    Strings.triglycerides,
    Strings.gutHealth,
    Strings.otherGastricIssues,
    Strings.gastritis,
    Strings.uricAcid,
    Strings.energyFitnessSports,
    Strings.prePregnancy,
    Strings.mentalHealth,
    Strings.moodSwings,
    Strings.diabetes,
    Strings.preDiabetes,
    Strings.pcos,
    Strings.thyroid,
    Strings.hypertension,
    Strings.physicalInjury,
    Strings.excessiveStress,
    Strings.depression,
    Strings.angerIssues,
    Strings.loneliness,
    Strings.relationshipStress,
    Strings.cholesterol,
    Strings.sleepIssues,
    Strings.otherIssues,
  ];
  String _enteredMedicationEarlier = '';
  String _selectedProfession = Strings.individual;
  String _enteredHelpYouLooking = '';
  final _form = GlobalKey<FormState>();
  final profession = [Strings.individual, Strings.nutritionist, Strings.businessOwner];

  @override
  void initState() {
    super.initState();

    final userData = ref.read(userProvider) as User;
    setState(() {
      _selectedHealthIssue = userData.healthIssue.split(', ');
      _enteredMedicationEarlier = userData.anyMedication;
      _selectedProfession = userData.profession;
      _enteredHelpYouLooking = userData.help;
    });
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  void _onNavigate() {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const BottomNavigation();
        },
      ),
    );
  }

  void _onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    //final isValid = _form.currentState!.validate();
    // if (!isValid || _selectedHealthIssue.isEmpty) {
    //   return;
    // }

     _form.currentState!.save();

    final userData = ref.read(userProvider) as User;
    Map<String, dynamic> request = {};

    int count = 0;
    userData.healthIssue.split(', ').map((element) {
      if (_selectedHealthIssue.contains(element)) {
        count += 1;
      }
    });

    if ((_selectedHealthIssue.length != userData.healthIssue.length) || (userData.healthIssue.length != count)) {
      request['health_issue'] = _selectedHealthIssue;
    }
    if (_enteredMedicationEarlier != userData.anyMedication || _enteredMedicationEarlier == '') {
      request['any_medication'] = _enteredMedicationEarlier;
    }
    request['profession'] = _selectedProfession.isEmpty ? Strings.individual : _selectedProfession;
    if (_enteredHelpYouLooking != userData.help || _enteredHelpYouLooking == '') {
      request['help'] = _enteredHelpYouLooking;
    }

    if (request.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      final res = await userService.updateUserDetails(request);
      if (res['status']) {
        await ref.read(userProvider.notifier).onSaveUserData(res['data']);
        await SharedPreference.setString('isUserRegistered', 'true');

        _onNavigate();
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      _onNavigate();
    }
    _form.currentState!.reset();
  }

  void _onChangeDropdown(value) {
    if (value == null) {
      return;
    }

    setState(() {
      _selectedProfession = value;
    });
  }

  Widget _buildHeading(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: ColorCodes.lightBlack,
      ),
    );
  }

  void _handleHealthIssues(String issue) {
    final healthIssues = _selectedHealthIssue;
    if (healthIssues.contains(issue)) {
      healthIssues.removeWhere((element) => element == issue);
    } else {
      healthIssues.add(issue);
    }

    setState(() {
      _selectedHealthIssue = healthIssues;
    });
  }

  Widget _buildHealthIssues() {
    return SizedBox(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          _healthIssues.length,
          (index) => GestureDetector(
            onTap: () {
              _handleHealthIssues(_healthIssues[index]);
            },
            child: Container(
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
                  Image.asset(
                    _selectedHealthIssue.contains(_healthIssues[index])
                        ? 'assets/images/activeRadio.png'
                        : 'assets/images/inactiveRadio.png',
                    height: 16,
                    width: 16,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    _healthIssues[index],
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 0, bottom: bottom + 20),
              scrollDirection: Axis.vertical,
              child: Stack(
                children: [
                  Container(
                    color: ColorCodes.white,
                    height: height,
                    width: width,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: _onGoBack,
                                  child: Image.asset(
                                    'assets/images/backArrow.png',
                                    width: 49,
                                    height: 49,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/patternBg.png',
                                  width: 254,
                                  height: 112,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeading(Strings.healthIssues),
                            const SizedBox(height: 15),
                            _buildHealthIssues(),
                            const SizedBox(height: 15),
                            _buildHeading(Strings.usedMedication),
                            const SizedBox(height: 8),
                            Form(
                              key: _form,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    initialValue: _enteredMedicationEarlier,
                                    scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    maxLines: 5,
                                    cursorColor: ColorCodes.black,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: ColorCodes.black,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                      ),
                                      contentPadding: const EdgeInsets.all(15),
                                    ),
                                    validator: (value) {
                                      // if (value == null || value.trim().isEmpty || value.trim().length < 10) {
                                      //   return Strings.enterChar;
                                      // }
                                      //return null;
                                    },
                                    onSaved: (value) {
                                      _enteredMedicationEarlier = value!;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _buildHeading(Strings.profession),
                                  const SizedBox(height: 10),
                                  DropdownButton(
                                    underline: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: ColorCodes.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    menuMaxHeight: 200,
                                    isExpanded: true,
                                    value: _selectedProfession,
                                    items: profession
                                        .map(
                                          (prof) => DropdownMenuItem(
                                            value: prof,
                                            child: Text(prof),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: _onChangeDropdown,
                                  ),
                                  const SizedBox(height: 23),
                                  _buildHeading(Strings.whatHelp),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    maxLines: 5,
                                    initialValue: _enteredHelpYouLooking,
                                    scrollPadding: EdgeInsets.only(bottom: bottom),
                                    cursorColor: ColorCodes.black,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: ColorCodes.black,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                      ),
                                      contentPadding: const EdgeInsets.all(15),
                                    ),
                                    validator: (value) {
                                      // if (value == null || value.trim().isEmpty || value.trim().length < 10) {
                                      //   return Strings.enterChar;
                                      // }
                                      //return null;
                                    },
                                    onSaved: (value) {
                                      _enteredHelpYouLooking = value!;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                            Container(
                              alignment: Alignment.center,
                              child: Button(
                                onPress: _onSubmit,
                                label: Strings.next,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) const Loader(),
      ],
    );
  }
}
