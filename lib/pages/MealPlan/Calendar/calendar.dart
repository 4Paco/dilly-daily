import 'package:dilly_daily/pages/MealPlan/Calendar/calendar_slot.dart';
import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  Calendar({
    super.key,
    required this.onMealAddedToWeek,
    required this.showMealPlanDialog,
  });

  final void Function(BuildContext, String) showMealPlanDialog;
  final void Function(String, int, int) onMealAddedToWeek;
  final List<String> weekDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  final int today = DateTime.now().weekday - 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 278,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < 7; i++) ...[
            Column(
              children: [
                i == 0
                    ? Text(
                        "Today",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      )
                    : Text(weekDays[(today + i) % 7]),
                CalendarSlot(
                  i: i,
                  today: today,
                  time: 0,
                  onMealAddedToWeek: onMealAddedToWeek,
                  showMealPlanDialog: showMealPlanDialog,
                ),
                CalendarSlot(
                  i: i,
                  today: today,
                  time: 1,
                  onMealAddedToWeek: onMealAddedToWeek,
                  showMealPlanDialog: showMealPlanDialog,
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}
