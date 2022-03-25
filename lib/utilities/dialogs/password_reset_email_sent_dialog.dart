import 'package:flutter/material.dart';
import 'package:my_start_app/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content:
        'We have now sent you a link to reset your password. Check your email',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
