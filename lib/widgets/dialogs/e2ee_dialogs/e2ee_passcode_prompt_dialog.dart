import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class E2EEPasscodePromptDialog {
  const E2EEPasscodePromptDialog._();

  static Future<String?> show(BuildContext context) async {
    var passcode = '';
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.locale.transfer__enter_passcode),
          content: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            onChanged: (value) => passcode = value,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: context.locale.transfer__six_digit_passcode,
            ),
            autocorrect: false,
            autofillHints: null,
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(context.mlocale.cancelButtonLabel),
            ),
            ElevatedButton(
              onPressed: () => context.pop(passcode.trim()),
              child: Text(context.locale.app__continue),
            ),
          ],
        );
      },
    );
  }
}
