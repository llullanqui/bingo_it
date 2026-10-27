import 'package:bingo_it_all/constants/app_constants.dart';
import 'package:flutter/material.dart';

class MainPageButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const MainPageButton(this.text, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.homePageButtonWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(vertical: 20),
          textStyle: TextStyle(fontSize: 20),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
