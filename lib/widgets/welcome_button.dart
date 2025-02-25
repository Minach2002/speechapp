import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key,
    this.buttonText,
    this.onTap,
    this.color,
    this.textColor,
  });

  final String? buttonText;
  final Widget? onTap; // This should be the target screen widget
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          // Use Navigator.push to navigate to the provided widget
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => onTap!, // Pass the widget here
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
          ),
        ),
        child: Text(
          buttonText ?? '', // Provide a default value if buttonText is null
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}