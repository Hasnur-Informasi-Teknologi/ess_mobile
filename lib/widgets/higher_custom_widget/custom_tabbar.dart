import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabTitles;
  final ValueChanged<int>? onTap;
  final int selectedIndex;

  const CustomTabBar({
    Key? key,
    required this.tabTitles,
    required this.selectedIndex,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalWide = size.width * 0.0585;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[100],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: tabTitles.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String title = entry.value;
                  bool isSelected = idx == selectedIndex;

                  return GestureDetector(
                    onTap: () => onTap?.call(idx),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 15.0,
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
