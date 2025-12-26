import 'package:flutter/material.dart';

class FilteringContent extends StatefulWidget {
  FilteringContent({
    super.key,
    required this.useFoodPreferences,
    required this.onFoodToggled,
    required this.useKitchenPreferences,
    required this.onKitchenToggled,
    required this.useEnergyPreferences,
    required this.onEnergyToggled,
  });

  bool useFoodPreferences;
  final void Function() onFoodToggled;
  bool useKitchenPreferences;
  final void Function() onKitchenToggled;
  bool useEnergyPreferences;
  final void Function() onEnergyToggled;

  @override
  State<FilteringContent> createState() => _FilteringContentState();
}

class _FilteringContentState extends State<FilteringContent> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 0),
              title: RichText(
                text: TextSpan(
                  text: "Use your ",
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: "food",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge?.fontSize ??
                                14.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(text: " preferences"),
                  ],
                ),
              ),
              trailing: Switch(
                activeTrackColor: Colors.lightGreen,
                inactiveTrackColor: Colors.deepOrange,
                thumbColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  return Colors.white;
                }),
                trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return const Color.fromARGB(
                      20, 0, 0, 0); // Consistent outline color.
                }),
                value: widget.useFoodPreferences,
                onChanged: (value) {
                  widget.onFoodToggled();
                  widget.useFoodPreferences = !widget.useFoodPreferences;
                  setState(() {});
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              title: RichText(
                text: TextSpan(
                  text: "Use your ",
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: "kitchen",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge?.fontSize ??
                                14.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(text: " preferences"),
                  ],
                ),
              ),
              trailing: Switch(
                activeTrackColor: Colors.lightGreen,
                inactiveTrackColor: Colors.deepOrange,
                thumbColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  return Colors.white;
                }),
                trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return const Color.fromARGB(
                      20, 0, 0, 0); // Consistent outline color.
                }),
                value: widget.useKitchenPreferences,
                onChanged: (value) {
                  widget.onKitchenToggled();
                  widget.useKitchenPreferences = !widget.useKitchenPreferences;
                  setState(() {});
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              title: RichText(
                text: TextSpan(
                  text: "Use your ",
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: "time",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge?.fontSize ??
                                14.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(text: " preferences"),
                  ],
                ),
              ),
              trailing: Switch(
                activeTrackColor: Colors.lightGreen,
                inactiveTrackColor: Colors.deepOrange,
                thumbColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  return Colors.white;
                }),
                trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return const Color.fromARGB(
                      20, 0, 0, 0); // Consistent outline color.
                }),
                value: widget.useEnergyPreferences,
                onChanged: (value) {
                  widget.onEnergyToggled();
                  widget.useEnergyPreferences = !widget.useEnergyPreferences;
                  setState(() {});
                },
              ),
            )
          ],
        ));
  }
}
