import 'package:closing_deal/constants/colors.dart';
import 'package:flutter/material.dart';

class TextFormFieldWithDropdown extends StatefulWidget {

  final String hinttext;
  final List<DropdownItem> dropdownItems;

  const TextFormFieldWithDropdown({
    Key? key,
    
    required this.hinttext,
    required this.dropdownItems,
  }) : super(key: key);

  @override
  _TextFormFieldWithDropdownState createState() =>
      _TextFormFieldWithDropdownState();
}

class _TextFormFieldWithDropdownState extends State<TextFormFieldWithDropdown> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedItem,
          onChanged: (String? newValue) {
            setState(() {
              _selectedItem = newValue;
            });
          },
          items: widget.dropdownItems.map((DropdownItem item) {
            return DropdownMenuItem<String>(
              value: item.value,
              child: Text(item.label),
            );
          }).toList(),
          decoration: InputDecoration(
            // labelText: widget.labelText,
            hintText: widget.hinttext,
            hintStyle: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w700),
                focusedBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: cBlackColor, width: 2),
            ),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: cBlackColor, width: 2),
            ),
            disabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: cBlackColor, width: 2),
            ),
            errorBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: cBlackColor, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: cBlackColor, width: 2),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class DropdownItem {
  final String value;
  final String label;

  DropdownItem(this.value, this.label);
}
