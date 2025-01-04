import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            const Text('The page you are looking for is not found.'),
            ElevatedButton(
              onPressed: () => context.go("/"),
              child: const Text("Go Home"),
            ),
          ],
        ),
      ),
    );
  }
}
