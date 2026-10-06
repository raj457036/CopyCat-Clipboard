import 'package:clipboard/pages/ime/ime_service.dart';
import 'package:clipboard/pages/ime/widgets/ime_bottom_bar.dart';
import 'package:clipboard/pages/ime/widgets/ime_clip_strip.dart';
import 'package:flutter/material.dart';

class ImePage extends StatelessWidget {
  final ImeService imeService;

  const ImePage({super.key, required this.imeService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 290,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            children: [
              Expanded(child: ImeClipStrip(imeService: imeService)),
              ImeBottomBar(imeService: imeService),
            ],
          ),
        ),
      ),
    );
  }
}
