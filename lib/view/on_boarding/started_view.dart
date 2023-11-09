import 'package:pluslife/common/colo_extension.dart';
import 'package:pluslife/view/on_boarding/on_boarding_view.dart';
import 'package:flutter/material.dart';

import '../../common_widget/round_button.dart';

class StartedView extends StatefulWidget {
  const StartedView({super.key});

  @override
  State<StartedView> createState() => _StartedViewState();
}

class _StartedViewState extends State<StartedView> {
  bool isChangeColor = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: Container(
          width: media.width,
          decoration: BoxDecoration(
            gradient: isChangeColor
                ? RadialGradient(
                    colors: TColor.primaryG,
                    radius: 1.0,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              RichText(
                  text: TextSpan(children: [
                const TextSpan(
                  text: "+",
                  style: TextStyle(
                    color: Color(0xFFF0E608),
                    fontSize: 50,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                TextSpan(
                  text: "Life",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 36,
                      fontWeight: FontWeight.w800),
                )
              ])),
              Text(
                "Monitore sua saúde",
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: RoundButton(
                    title: "Comece",
                    type: isChangeColor
                        ? RoundButtonType.textGradient
                        : RoundButtonType.bgGradient,
                    onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OnBoardingView()));
                    },
                  ),
                ),
              )
            ],
          )),
    );
  }
}
