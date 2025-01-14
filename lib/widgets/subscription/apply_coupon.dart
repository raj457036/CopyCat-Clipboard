import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/snackbar.dart';
import 'package:copycat_pro/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ApplyCouponDialog extends StatefulWidget {
  const ApplyCouponDialog({super.key});

  Future<void> open(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => this,
      barrierDismissible: false,
    );
  }

  @override
  State<ApplyCouponDialog> createState() => _ApplyCouponDialogState();
}

class _ApplyCouponDialogState extends State<ApplyCouponDialog> {
  String? errorMessage;
  bool loading = false;
  late final TextEditingController couponController;

  @override
  void initState() {
    super.initState();
    couponController = TextEditingController();
  }

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  Future<void> applyForPro() async {
    const betaProForm = "https://forms.gle/iuX3XDrvMJPLLtix5";
    launchUrlString(betaProForm);
  }

  Future<void> apply() async {
    final cubit = context.read<MonetizationCubit>();
    setState(() {
      loading = true;
    });
    final failure = await cubit.applyPromoCode(couponController.text);
    if (failure != null) {
      setState(() {
        errorMessage = failure.message;
        loading = false;
      });
    } else {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        showTextSnackbar(context.locale.dialog__ack__sub_updated);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        context.locale.dialog__grant_entitlement__title,
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: 450,
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  text: context.locale.dialog__grant_entitlement__subtitle_p1,
                  children: [
                    TextSpan(
                      text:
                          context.locale.dialog__grant_entitlement__subtitle_p2,
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = applyForPro,
                    ),
                  ],
                ),
              ),
              height16,
              TextFormField(
                enabled: !loading,
                controller: couponController,
                decoration: InputDecoration(
                  labelText: "Code",
                  helperText:
                      context.locale.dialog__grant_entitlement__enter_code,
                  errorText: errorMessage,
                ),
              ),
            ],
          ),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: 16,
        bottom: 0,
        left: 16,
        right: 16,
      ),
      actions: [
        TextButton(
          onPressed: loading ? null : () => Navigator.pop(context),
          child: Text(context.mlocale.cancelButtonLabel.title),
        ),
        TextButton(
          onPressed: loading ? null : apply,
          child: Text(context.locale.dialog__grant_entitlement__apply_code),
        ),
      ],
    );
  }
}
