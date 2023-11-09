import 'package:pluslife/common/colo_extension.dart';
import 'package:pluslife/view/login/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
   TextEditingController userGender = TextEditingController();
   TextEditingController userDOA = TextEditingController();
   TextEditingController userWeight = TextEditingController();
   TextEditingController userHeight = TextEditingController();
   var dropValue = ValueNotifier('');
   TextEditingController userName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  void _loadName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString('user_name') ?? '';
    final String gender = prefs.getString('user_gender') ?? '';
    final String birthdate = prefs.getString('user_birthdate') ?? '';
    final String weight = prefs.getString('user_weight') ?? '';
    final String height = prefs.getString('user_height') ?? '';
    userName.text = name;
    dropValue = ValueNotifier(gender);
    userDOA.text = birthdate;
    userWeight.text = weight;
    userHeight.text = height;
  }

  void _saveName() async {
    final String name = userName.text;
    final String gender = userGender.text;
    final String birthdate = userDOA.text;
    final String weight = userWeight.text;
    final String height = userHeight.text;
    if (name.isNotEmpty || gender.isNotEmpty || birthdate.isNotEmpty || weight.isNotEmpty || height.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_gender', gender);
      await prefs.setString('user_birthdate', birthdate);
      await prefs.setString('user_weight', weight);
      await prefs.setString('user_height', height);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Vamos completar seu perfil",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "Isso vai nos ajudar a saber mais sobre você!",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      RoundTextField(
                        controller: userName,
                        hitText: "Nome",
                        icon: "assets/img/user_text.png",
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.lightGray,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Image.asset(
                                  "assets/img/gender.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                  color: TColor.gray,
                                )),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: ValueListenableBuilder(
                                  valueListenable: dropValue,
                                  builder: (BuildContext context, dynamic value,
                                      Widget? child) {
                                    return DropdownButton<String>(
                                      items: ["Masculino", "Feminino", "Transgênero", "Não-Binário", ]
                                          .map((gender) => DropdownMenuItem(
                                                value: gender,
                                                child: Text(
                                                  gender,
                                                  style: TextStyle(
                                                      color: TColor.gray,
                                                      fontSize: 12),
                                                ),
                                              ))
                                          .toList(),
                                      value: (value.isEmpty) ? null : value,
                                      onChanged: (String? newValue) {
                                          dropValue.value = newValue.toString();
                                          setState(() {
                                            userGender.text = newValue!;
                                          });
                                      },
                                      isExpanded: true,
                                      hint: Text(
                                        "Escolher Gênero",
                                        style: TextStyle(
                                            color: TColor.gray, fontSize: 12),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.lightGray,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          controller: userDOA,
                          keyboardType: TextInputType.number,
                          inputFormatters: [DateInputFormatter()],
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              hintText: "Data de Nascimento",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    "assets/img/date.png",
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                    color: TColor.gray,
                                  )),
                              hintStyle:
                                  TextStyle(color: TColor.gray, fontSize: 12)),
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: userWeight,
                              hitText: "Seu Peso",
                              icon: "assets/img/weight.png",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.primaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "KG",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: userHeight,
                              hitText: "Sua Altura",
                              icon: "assets/img/height.png",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.primaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(

                              "CM",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      RoundButton(
                          title: "Avançar >",
                          onPressed: () {
                            var name = userName.text;
                            _saveName();
                            print('debug: $name ...');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const WelcomeView()));
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
