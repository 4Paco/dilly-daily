import 'dart:math';

import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:dilly_daily/models/ui/plus_minus_button.dart';
import 'package:flutter/material.dart';
import 'package:gradient_slider/gradient_slider.dart';

class CookingProfilePage extends StatefulWidget {
  const CookingProfilePage({
    super.key,
  });

  @override
  State<CookingProfilePage> createState() => _CookingProfilePageState();
}

class _CookingProfilePageState extends State<CookingProfilePage> {
  void setDefaultMealsNumber(int delta) {
    setState(() {
      personals.defaultPersonNumber =
          max(1, personals.defaultPersonNumber + delta);
    });
  }

  void updatePatience(double newVal) {
    setState(() {
      personals.patience =
          max(0.1, min(0.9, (newVal * 10).roundToDouble() / 10));
    });
  }

  @override
  Widget build(BuildContext context) {
    final nbStyle = Theme.of(context).textTheme.headlineSmall;
    final sliderLabelStyle = Theme.of(context).textTheme.bodyMedium;
    return Column(
      children: [
        BlocTitle(texte: "Number of portions per meal"),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          PlusMinusButton(function: setDefaultMealsNumber, val: -1, texte: "-"),
          Text(
            personals.defaultPersonNumber.toString(),
            style: nbStyle,
          ),
          SizedBox(width: 7),
          Icon(
            Icons.restaurant,
            size: 30,
            //color: themeScheme.primary,
          ),
          PlusMinusButton(function: setDefaultMealsNumber, val: 1, texte: "+")
        ]),
        BlocTitle(texte: "Patience for cooking"),
        //Image.asset("assets/image/slider_thumb_cute.png")
        Stack(children: [
          GradientSlider(
            thumbAsset: 'assets/image/slider_thumb_cute_primary.png',
            thumbHeight: 30,
            thumbWidth: 30,
            trackHeight: 20,
            activeTrackGradient:
                const LinearGradient(colors: [Colors.blue, Colors.pink]),
            inactiveTrackGradient:
                LinearGradient(colors: [Colors.blue, Colors.pink]),
            slider: Slider(
                value: personals.patience,
                onChanged: (value) {
                  updatePatience(value);
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 54, top: 20),
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: personals.patience == 0.1 ? 7 : 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 54, top: 20),
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: personals.patience == 0.9 ? 7 : 25,
                ),
              ),
            ],
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Might not\neat",
                style: sliderLabelStyle,
              ),
              Text(
                "Love elaborate\nmeals",
                textAlign: TextAlign.end,
                style: sliderLabelStyle,
              )
            ],
          ),
        ),
      ],
    );
  }
}
