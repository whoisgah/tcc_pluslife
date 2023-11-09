import 'package:flutter/material.dart';
import '../../common/colo_extension.dart';

class CharacterView extends StatefulWidget {
  const CharacterView({super.key});

  @override
  State<CharacterView> createState() => _CharacterView();
}

class _CharacterView extends State<CharacterView> {
  String selectedImagePath = 'assets/img/character1.gif';

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Personagem",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main Image in the Center
            Image.asset(
              selectedImagePath,
              width: 350.0,
              height: 350.0,
            ),
            SizedBox(height: 80.0),

            // Mini Images Below the Center Image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    MiniImageButton('assets/img/character1.gif', () {
                      selectImage('assets/img/character1.gif');
                    }),
                    SizedBox(height: 30.0),
                    MiniImageButton('assets/img/character 2.gif', () {
                      selectImage('assets/img/character 2.gif');
                    }),
                  ],
                ),
                SizedBox(width: 60.0),
                MiniImageButton('assets/img/character 3.gif', () {
                  selectImage('assets/img/character 3.gif');
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void selectImage(String imagePath) {
    setState(() {
      selectedImagePath = imagePath;
    });
  }
}

class MiniImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  MiniImageButton(this.imagePath, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: MiniImage(imagePath),
    );
  }
}

class MiniImage extends StatelessWidget {
  final String imagePath;

  MiniImage(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: 70.0,
      height: 70.0,
    );
  }
}
