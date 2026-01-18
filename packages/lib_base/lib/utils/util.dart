import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void keyDismiss(
    BuildContext context,
    ) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

void requestFocus(
    BuildContext context,
    ) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.requestFocus();
  }
}

Future<void> setDataToClipboard({
  required String text,
}) async {
  await Clipboard.setData(ClipboardData(text: text));
}

Future<ClipboardData?> getDataToClipboard() {
  return Clipboard.getData(Clipboard.kTextPlain);
}