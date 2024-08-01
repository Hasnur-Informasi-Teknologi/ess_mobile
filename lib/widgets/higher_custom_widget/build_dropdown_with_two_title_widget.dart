import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class BuildDropdownWithTwoTitleWidget extends StatelessWidget {
  final String title;
  final String? selectedValue;
  final List<Map<String, dynamic>> itemList;
  final ValueChanged<String?> onChanged;
  final double horizontalPadding;
  final String? Function(String?)? validator;
  final double? maxHeight;
  final bool isLoading;
  final String valueKey;
  final String titleKey;
  final bool isRequired;

  const BuildDropdownWithTwoTitleWidget({
    super.key,
    required this.title,
    this.selectedValue,
    required this.itemList,
    required this.onChanged,
    required this.horizontalPadding,
    this.validator,
    this.maxHeight,
    this.isLoading = false,
    this.valueKey = "value",
    this.titleKey = "title",
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TitleWidget(
                title: title,
                fontWeight: FontWeight.w300,
                fontSize: textMedium,
              ),
              if (isRequired)
                Text(
                  '*',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
            ],
          ),
          DropdownButtonFormField<String>(
            menuMaxHeight: size.height * 0.5,
            value: selectedValue,
            onChanged: onChanged,
            items: itemList.map((value) {
              return DropdownMenuItem<String>(
                value: value[valueKey].toString(),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TitleWidget(
                    title: '${value[titleKey]} - ${value[valueKey]}',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              constraints:
                  BoxConstraints(maxHeight: maxHeight ?? double.infinity),
              labelStyle: TextStyle(fontSize: textMedium),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: selectedValue != null ? Colors.black54 : Colors.grey,
                  width: 1.0,
                ),
              ),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: const BorderSide(
              //     color: Colors.black,
              //     width: 1.0,
              //   ),
              //   gapPadding: 9,
              //   borderRadius: BorderRadius.circular(8),
              // ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(
              //     color: selectedValue != null ? Colors.black54 : Colors.grey,
              //     width: 1.0,
              //   ),
              //   gapPadding: 9,
              // ),
            ),
            validator: validator,
            icon: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                : const Icon(Icons.arrow_drop_down),
          ),
          SizedBox(height: sizedBoxHeightExtraTall)
        ],
      ),
    );
  }
}
