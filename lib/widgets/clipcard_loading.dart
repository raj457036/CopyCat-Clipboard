import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Card.filled(margin: EdgeInsets.zero, color: colors.surface);
  }
}

const loadingCard = LoadingCard();

class ClipcardLoading extends StatelessWidget {
  final bool compact;
  const ClipcardLoading({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollCacheExtent: const ScrollCacheExtent.pixels(300),
      padding: compact ? const EdgeInsets.all(padding8) : inset12,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 15,
      itemBuilder: (context, index) => loadingCard,
    );
  }
}
