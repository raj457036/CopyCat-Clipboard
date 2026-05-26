import 'package:animate_do/animate_do.dart';
import 'package:clipboard/widgets/copycat_logo.dart';
import 'package:flutter/material.dart';

class CatIntroductionAvatar extends StatelessWidget {
  final double size;

  const CatIntroductionAvatar({super.key, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CircleAvatar(
        radius: size,
        child: SlideInLeft(
          child: Tada(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CopyCatLogo(dimension: size * 1.4),
            ),
          ),
        ),
      ),
    );
  }
}
