// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/model/add_new_recipe.dart';
import 'package:fit_for_life/provider/add_new_recipe.dart';
import 'package:fit_for_life/services/home_service.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:fit_for_life/widgets/button.dart';
import 'package:fit_for_life/widgets/loader.dart';
import 'package:fit_for_life/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final homeService = HomeService();

class AddNewRecipeScreen extends ConsumerStatefulWidget {
  const AddNewRecipeScreen({super.key});

  @override
  ConsumerState<AddNewRecipeScreen> createState() => _AddNewRecipeScreenState();
}

class _AddNewRecipeScreenState extends ConsumerState<AddNewRecipeScreen> {
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();
  String _selectedImage = '';
  bool _isImageLoading = false;
  String _enteredRecipeName = '';
  String _selectedCategory = Strings.breakfast;
  String _selectedServingSize = Strings.gms;
  IngredientsList? _selectedIngredient;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  final List<Ingredient> _ingredients = [];
  final categories = [
    Strings.breakfast,
    Strings.lunch,
    Strings.eveningSnacks,
    Strings.dinner,
    "Other"
  ];
  final servingSize = [
    Strings.gms,
    Strings.ml,
    Strings.quantity,
  ];

  @override
  void initState() {
    super.initState();
    _onGetIngredients();
  }

  TextEditingController _textField1Controller = TextEditingController();
  TextEditingController _textField2Controller = TextEditingController();
  String _selectedDropdownValue = "Gms";
  List<String> _dropdownItems = ["Gms", "Ltrs", "Teaspoon"];
  List<String> _enteredDataList = [];

  void _onButtonPressed() {
    setState(() {
      // Concatenate entered data and update the displayed text
      String enteredData =
          " ${_textField1Controller.text} ${_textField2Controller.text} $_selectedDropdownValue";
      _enteredDataList.add(enteredData);

      // Clear text fields
      _textField1Controller.clear();
      _textField2Controller.clear();
    });
  }

  File? _image;

  Future _getImage() async {
    final picker = ImagePicker();
    // or ImageSource.camera
    final PickedFile = await picker.pickImage(source: ImageSource.camera);

    if (PickedFile != null) {
      setState(() {
        _image = File(PickedFile!.path);
      });
    }
  }

  Future _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage!.path);
      });
    }
  }

  void _onGetIngredients() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final res = await homeService.onFetchIngredients();
      print("GetIngredients $res");
      if (res.isNotEmpty) {
        await ref
            .read(addNewRecipeProvider.notifier)
            .onSaveIngredients(res['data'] ?? []);

        final ingredients = ref.read(addNewRecipeProvider);
        setState(() {
          _selectedIngredient = ingredients[0];
          _isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  void _onPickImage(String pickedImage) {
    _selectedImage = pickedImage;
  }

  void _onChangeDropdown(value) {
    if (value == null) {
      return;
    }

    setState(() {
      _selectedCategory = value;
    });
  }

  void _onAddNewRecipe() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } else if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.addIngredient),
          showCloseIcon: true,
          closeIconColor: ColorCodes.white,
          backgroundColor: ColorCodes.red,
        ),
      );

      return;
    } else if (_selectedImage.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.addImage),
          showCloseIcon: true,
          closeIconColor: ColorCodes.white,
          backgroundColor: ColorCodes.red,
        ),
      );

      return;
    }

    _form.currentState!.save();

    final data = {
      'image': _selectedImage,
      'dish_name': _enteredRecipeName,
      'category': _selectedCategory.replaceAll(' ', '_').toLowerCase(),
      'serving_size': _selectedServingSize,
      'ingredients':
          _ingredients.map((ingredient) => ingredient.toJson()).toList(),
    };

    setState(() {
      _isLoading = true;
    });

    final res = await homeService.onAddNewRecipe(data);
    if (res.isNotEmpty) {
      Navigator.pop(context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _addIngredient() {
    FocusManager.instance.primaryFocus?.unfocus();
    final enteredQuantity = double.tryParse(_quantityController.text) ?? 0;
    final enterIngeredient = double.tryParse(_ingredientController.text) ?? 0;
    if (enteredQuantity == 0 &&
        enterIngeredient == _ingredientController.text.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.enterQuantity),
          showCloseIcon: true,
          closeIconColor: ColorCodes.white,
          backgroundColor: ColorCodes.red,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter ingrediant is madiatory'),
          showCloseIcon: true,
          closeIconColor: ColorCodes.white,
          backgroundColor: ColorCodes.red,
        ),
      );
      return;
    }

    setState(() {
      _ingredients.add(Ingredient(
        id: _selectedIngredient!.id,
        ingredientName: _selectedIngredient!.ingredientName,
        quantity: enteredQuantity,
      ));
    });
    _quantityController.clear();
    _ingredientController.clear();
  }

  Widget _buildProfile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image == null
              ? Container()
              : Container(
                  child: Image.file(
                    _image!,
                    height: 200.0,
                    width: double.infinity,
                  ),
                ),
          SizedBox(height: 20.0),
          _image != null
              ? Container()
              : ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Select Image Source'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.camera),
                                title: Text('Camera'),
                                onTap: () {
                                  _getImage();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.image),
                                title: Text('Gallery'),
                                onTap: () {
                                  _uploadImage();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    child: DottedBorder(
                      color: Colors.black,
                      strokeWidth: 1,
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: Container(
                                child: Image.asset(
                                  'assets/images/camera.png',
                                  height: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text('Upload Recipe Pic',
                                  style: TextStyle(
                                      color: ColorCodes.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400)),
                            ),
                            SizedBox(
                              height: 40,
                            ),

                            // UserImagePicker(
                            //   onPickImage: _onPickImage,
                            //   isLoading: (loading) => setState(() {
                            //     _isImageLoading = loading;
                            //   }),
                            //   image: _selectedImage,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildHeadingText() {
    return const Text(
      Strings.uploadRecipePic,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: ColorCodes.lightBlack,
      ),
    );
  }

  Widget _buildProvideText() {
    return const SizedBox(
      width: 251,
      child: Text(
        Strings.pleaseProvideRecipeDetails,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: ColorCodes.lightBlack,
        ),
      ),
    );
  }

  Widget _buildHeading(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: ColorCodes.lightBlack,
      ),
    );
  }

  Widget _buildFormField() {
    final ingredients = ref.read(addNewRecipeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _enteredRecipeName,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                cursorColor: ColorCodes.black,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(),
                  labelText: Strings.recipeName,
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
                    return Strings.enterText;
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredRecipeName = value!;
                },
              ),
              const SizedBox(height: 15),
              _buildHeading(Strings.category),
              DropdownButton(
                underline: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: ColorCodes.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(10),
                isExpanded: true,
                value: _selectedCategory,
                items: categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: _onChangeDropdown,
              ),
              const SizedBox(height: 15),
              _buildHeading(Strings.servingSize),
              DropdownButton(
                underline: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: ColorCodes.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(10),
                isExpanded: true,
                value: _selectedServingSize,
                items: servingSize
                    .map(
                      (size) => DropdownMenuItem(
                        value: size,
                        child: Text(size),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedServingSize = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        _buildHeading(Strings.addIngredients),
        // Row(
        //   children: [
        //     Expanded(
        //       child: TextField(
        //         controller: _ingredientController,
        //         textInputAction: TextInputAction.done,
        //         keyboardType: TextInputType.text,
        //         scrollPadding: EdgeInsets.only(
        //             bottom: MediaQuery.of(context).viewInsets.bottom),
        //         cursorColor: ColorCodes.black,
        //         decoration: const InputDecoration(
        //           focusedBorder: UnderlineInputBorder(),
        //           labelText: Strings.ingredient,
        //           labelStyle: TextStyle(
        //             color: ColorCodes.black,
        //             fontWeight: FontWeight.w400,
        //             fontFamily: 'Poppins',
        //             fontSize: 16,
        //           ),
        //           contentPadding: EdgeInsets.only(bottom: 5),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(width: 15),
        //     Expanded(
        //       child: DropdownButton(
        //         underline: Container(
        //           padding: EdgeInsets.only(top: 12),
        //           decoration: BoxDecoration(
        //             border: Border(
        //               bottom: BorderSide(
        //                 color: ColorCodes.black,
        //               ),
        //             ),
        //           ),
        //         ),
        //         borderRadius: BorderRadius.circular(10),
        //         isExpanded: true,
        //         value: _selectedServingSize,
        //         items: servingSize
        //             .map(
        //               (size) => DropdownMenuItem(
        //                 value: size,
        //                 child: Text(
        //                   size,
        //                   style:
        //                       TextStyle(color: ColorCodes.black, fontSize: 18),
        //                 ),
        //               ),
        //             )
        //             .toList(),
        //         onChanged: (value) {
        //           if (value != null) {
        //             setState(() {
        //               _selectedServingSize = value;
        //             });
        //           }
        //         },
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 15,
        //     ),
        //     Expanded(
        //       child: TextField(
        //         controller: _quantityController,
        //         textInputAction: TextInputAction.done,
        //         keyboardType: TextInputType.number,
        //         scrollPadding: EdgeInsets.only(
        //             bottom: MediaQuery.of(context).viewInsets.bottom),
        //         cursorColor: ColorCodes.black,
        //         decoration: const InputDecoration(
        //           focusedBorder: UnderlineInputBorder(),
        //           labelText: Strings.quantityCaps,
        //           labelStyle: TextStyle(
        //             color: ColorCodes.black,
        //             fontWeight: FontWeight.w400,
        //             fontFamily: 'Poppins',
        //             fontSize: 16,
        //           ),
        //           contentPadding: EdgeInsets.only(bottom: 5),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(width: 15),
        //     GestureDetector(
        //       onTap: _addIngredient,
        //       child: Image.asset(
        //         'assets/images/add.png',
        //         height: 25,
        //         width: 25,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildIngredients() {
    return SizedBox(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 11,
        runSpacing: 10,
        children: List.generate(
          _ingredients.length,
          (index) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: ColorCodes.normalGrey,
              border: Border.all(
                color: ColorCodes.borderColor,
                width: 1,
              ),
            ),
            child: Text(
              '${_ingredients[index].ingredientName} (${_ingredients[index].quantity} $_selectedServingSize)',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ColorCodes.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Loader(
        opacity: 1,
        bgColor: ColorCodes.white,
      );
    }

    return Scaffold(
      backgroundColor: ColorCodes.white,
      appBar: AppBar(
        backgroundColor: Color(0xff00AE4D),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            'assets/images/backArrow.png',
            color: Colors.white,
            width: 30,
            height: 49,
          ),
        ),
        title: Text(
          'Upload Recipe',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 21),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfile(),
                    const SizedBox(height: 16),
                    _buildHeadingText(),
                    _buildProvideText(),
                    const SizedBox(height: 19),
                    _buildFormField(),
                    if (_ingredients.isNotEmpty) const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: _textField1Controller,
                            decoration:
                                InputDecoration(labelText: 'Ingrediants'),
                          ),
                        ),
                        SizedBox(width: 10),
                        DropdownButton<String>(
                          value: _selectedDropdownValue,
                          onChanged: (value) {
                            setState(() {
                              _selectedDropdownValue = value!;
                            });
                          },
                          items: _dropdownItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _textField2Controller,
                            decoration: InputDecoration(labelText: 'Quantity'),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: _onButtonPressed,
                          child: Icon(
                            Icons.add,
                            color: ColorCodes.darkGreen,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Entered Data List:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    for (String enteredData in _enteredDataList)
                      Text(
                        enteredData,
                        style: TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 14),
                    Container(
                      alignment: Alignment.center,
                      child: Button(
                        onPress: _onAddNewRecipe,
                        label: Strings.upload,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
