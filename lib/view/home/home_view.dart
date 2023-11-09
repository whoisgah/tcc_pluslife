import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:pluslife/common_widget/round_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../../common/colo_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<int> showingTooltipOnSpots = [21];

  String _userName = '';
  int _userHeight = 0;
  int _userWeight = 0;

  String calculateIMCClassification(double weight, double height) {
    double imc = weight / ((height / 100) * (height / 100));

    if (imc < 18.5) {
      return 'Abaixo do Peso';
    } else if (imc < 24.9) {
      return 'Peso Normal';
    } else if (imc < 29.9) {
      return 'Sobrepeso';
    } else if (imc < 34.9) {
      return 'Obesidade Grau I';
    } else if (imc < 39.9) {
      return 'Obesidade Grau II';
    } else {
      return 'Obesidade Grau III';
    }
  }

  void _loadName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userName = prefs.getString('user_name') ?? '';
    final String userHeight = prefs.getString('user_height') ?? '';
    final String userWeight = prefs.getString('user_weight') ?? '';
    setState(() {
      _userName = userName;
      _userHeight = int.parse(userHeight);
      _userWeight = int.parse(userWeight);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    String classification = calculateIMCClassification(
        _userWeight.toDouble(), _userHeight.toDouble());
    bool training = false;
    bool meditation = false;
    bool isChecked = false;
    return MaterialApp(
        home: Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Text(
                          "Bem vindo de volta,",
                          style: TextStyle(color: TColor.gray, fontSize: 17),
                        ),
                        Text(
                          _userName,
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Container(
                  height: media.width * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: TColor.primaryG),
                    borderRadius: BorderRadius.circular(media.width * 0.075),
                  ),
                  child: Stack(alignment: Alignment.center, children: [
                    Image.asset(
                      "assets/img/bg_dots.png",
                      height: media.width * 0.4,
                      width: double.maxFinite,
                      fit: BoxFit.fitHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 25,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "IMC",
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " (Índice de Massa Corporal)",
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ]),
                              ),
                              Text(
                                classification,
                                style: TextStyle(
                                  color: TColor.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),

                              //Ver mais do IMC
                              SizedBox(
                                width: 100,
                                height: 40,
                                child: RoundButton(
                                  title: "Ver mais",
                                  type: RoundButtonType.bgSGradient,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // Calcular o IMC
                                        double imc = _userWeight /
                                            ((_userHeight / 100) *
                                                (_userHeight / 100));
                                        return AlertDialog(
                                          title: const Text(
                                              'Informações sobre o seu IMC'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Seu peso: ${_userWeight.toStringAsFixed(2)} kg',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(height: 8),
                                                Text(
                                                    'Sua Altura: ${(_userHeight / 100).toStringAsFixed(2)} m',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(height: 8),
                                                Text(
                                                    'Sua pontuação IMC: ${imc.toStringAsFixed(1)}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(height: 25),
                                                Text(
                                                    'Sua classificação IMC: $classification',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                // Feche o diálogo quando o botão "OK" é pressionado.
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Voltar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {},
                                ),
                                startDegreeOffset: 270,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius: 0,
                                sections: showingSections(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Status de Atividade",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Container(
                  height: media.width * 0.30,
                  width: media.width * 0.9,
                  decoration: BoxDecoration(
                    color: Color(0xffFFD600),
                    borderRadius: BorderRadius.circular(media.width * 0.075),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Água',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/img/cup_water.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                      width:
                                          5), // Adiciona um espaço entre a imagem e o texto
                                  const Center(
                                    child: Text(
                                      "0.0L / 3.0L",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(0xffFFD600),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: RoundButton(
                                title: "+ 100 mL",
                                type: RoundButtonType.bgSGradient,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  // Adicione a lógica para diminuir 100 mL aqui
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 130,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(0xffFFD600),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: RoundButton(
                                title: "- 100 mL",
                                type: RoundButtonType.bgSGradient,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  // Adicione a lógica para diminuir 100 mL aqui
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Container(
                  height: media.width * 0.30,
                  width: media.width * 0.9,
                  decoration: BoxDecoration(
                    color: Color(0xffFFD600),
                    borderRadius: BorderRadius.circular(media.width * 0.075),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Alimento',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/img/food.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                      width:
                                          5), // Adiciona um espaço entre a imagem e o texto
                                  const Center(
                                    child: Text(
                                      "1.2 Kcal",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(0xffFFD600),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: RoundButton(
                                title: "+ 100 Kcal",
                                type: RoundButtonType.bgSGradient,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  // Adicione a lógica para diminuir 100 mL aqui
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 130,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(0xffFFD600),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: RoundButton(
                                title: "- 100 Kcal",
                                type: RoundButtonType.bgSGradient,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  // Adicione a lógica para diminuir 100 mL aqui
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Container(
                  height: media.width * 0.30,
                  width: media.width * 0.9,
                  decoration: BoxDecoration(
                    color: Color(0xffFFD600),
                    borderRadius: BorderRadius.circular(media.width * 0.075),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Treino',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/img/image_train.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                      width:
                                          5), // Adiciona um espaço entre a imagem e o texto
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Meditação',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/img/meditate.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                      width:
                                          5), // Adiciona um espaço entre a imagem e o texto
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.10,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
      (i) {
        var color0 = TColor.secondaryColor1;
        double imc = _userWeight / (_userHeight / 100 * _userHeight / 100);

        String imcString = imc.toStringAsFixed(1);

        switch (i) {
          case 0:
            return PieChartSectionData(
                color: color0,
                value: 45,
                title: '',
                radius: 55,
                titlePositionPercentageOffset: 0.55,
                badgeWidget: Text(
                  imcString,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                ));
          case 1:
            return PieChartSectionData(
              color: Colors.white,
              value: 72,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
            );

          default:
            throw Error();
        }
      },
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          TColor.primaryColor2.withOpacity(0.5),
          TColor.primaryColor1.withOpacity(0.5),
        ]),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 35),
          FlSpot(2, 70),
          FlSpot(3, 40),
          FlSpot(4, 80),
          FlSpot(5, 25),
          FlSpot(6, 70),
          FlSpot(7, 35),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: TColor.secondaryColor1,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
        ),
        spots: const [
          FlSpot(1, 80),
          FlSpot(2, 50),
          FlSpot(3, 90),
          FlSpot(4, 40),
          FlSpot(5, 80),
          FlSpot(6, 35),
          FlSpot(7, 60),
        ],
      );

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 20,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: TColor.gray,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thu', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}
