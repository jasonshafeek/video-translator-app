import 'package:flutter/material.dart';

class SubtitleWidget extends StatelessWidget {
  final String subtitle;
  final bool isTranslated;

  const SubtitleWidget({
    Key? key,
    required this.subtitle,
    this.isTranslated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        subtitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          shadows: [
            Shadow(
              offset: const Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: Colors.black.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
