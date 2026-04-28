import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.not_found__title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Text(context.locale.not_found__subtitle),
            ElevatedButton(
              onPressed: () => context.go("/"),
              child: Text(context.locale.not_found__go_home),
            ),
          ],
        ),
      ),
    );
  }
}
