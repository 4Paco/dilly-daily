import 'package:dilly_daily/pages/Explore/filtering_content.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class FilterButton extends StatelessWidget {
  FilterButton({
    super.key,
    required this.themeScheme,
    required this.foodBool,
    required this.onFoodToggled,
    required this.kitchenBool,
    required this.onKitchenToggled,
    required this.energyBool,
    required this.onEnergyToggled,
  });

  final ColorScheme themeScheme;
  bool foodBool;
  final void Function() onFoodToggled;
  bool kitchenBool;
  final void Function() onKitchenToggled;
  bool energyBool;
  final void Function() onEnergyToggled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 63,
      decoration: BoxDecoration(
        color: themeScheme.tertiaryFixed,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: themeScheme.tertiaryFixed.withAlpha(80),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
          onPressed: () {
            showPopover(
              context: context,
              bodyBuilder: (context) => FilteringContent(
                useFoodPreferences: foodBool,
                onFoodToggled: onFoodToggled,
                useKitchenPreferences: kitchenBool,
                onKitchenToggled: onKitchenToggled,
                useEnergyPreferences: energyBool,
                onEnergyToggled: onEnergyToggled,
              ),
              direction: PopoverDirection.bottom,
              backgroundColor: themeScheme.tertiaryFixed,
              barrierColor: Colors.transparent,
              shadow: [
                BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 10,
                    offset: Offset(-2, -1))
              ],
              width: 200,
              arrowHeight: 17,
              arrowWidth: 12,
              arrowDxOffset: 24,
              arrowDyOffset: 2,
              contentDyOffset: -12,
            );
          },
          icon: Icon(Icons.tune_rounded)),
    );
  }
}
