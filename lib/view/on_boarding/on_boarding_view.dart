import 'package:flutter/material.dart';
import 'package:pluslife/common_widget/on_boarding_page.dart';
import 'package:pluslife/view/login/complete_profile_view.dart';

import '../../common/colo_extension.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.addListener(() {
        selectPage = controller.page?.round() ?? 0;

      setState(() {
        
      });
    });
  }

  List pageArr = [
    {
      "title": "Acompanhe\nseu Objetivo",
      "subtitle":
          "Não se preocupe se tiver problemas para determinar seus objetivos. Podemos ajudá-lo a determinar e monitorar seus objetivos.",
      "image": "assets/img/on_1.png"
    },
    {
      "title": "Mova-se",
      "subtitle":
          "Continue se exercitando para alcançar seus objetivos, a dor é passageira, mas a satisfação é duradoura.",
      "image": "assets/img/on_2.png"
    },
    {
      "title": "Hidrate-se",
      "subtitle":
          "Vamos começar uma rotina de hidratação saudável, podemos ajudar a garantir que você beba água suficiente todos os dias.",
      "image": "assets/img/on_3.png"
    },
    {
      "title": "Melhore sua\nQualidade de Sono",
      "subtitle":
          "Melhore a qualidade do seu sono conosco, um sono de boa qualidade pode trazer um bom humor pela manhã.",
      "image": "assets/img/on_4.png"
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
              controller: controller,
              itemCount: pageArr.length,
              itemBuilder: (context, index) {
                var pObj = pageArr[index] as Map? ?? {};
                return OnBoardingPage(pObj: pObj) ;
              }),

          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [

                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    color: TColor.primaryColor1,
                    value: (selectPage + 1) / 4 ,
                    strokeWidth: 2,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(color: TColor.primaryColor1, borderRadius: BorderRadius.circular(35)),
                  child: IconButton(icon: Icon( Icons.navigate_next, color: TColor.white, ), onPressed: (){
          
                      if(selectPage < 3) {
          
                         selectPage = selectPage + 1;

                        controller.animateToPage(selectPage, duration: const Duration(milliseconds: 600), curve: Curves.bounceInOut);
                        
                        // controller.jumpToPage(selectPage);
                        
                          setState(() {
                            
                          });
          
                      }else{
                        // Open Welcome Screen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CompleteProfileView() ));
                      }
                      
                  },),
                ),

                
              ],
            ),
          )
        ],
      ),
    );
  }
}