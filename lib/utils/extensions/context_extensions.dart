import 'package:flutter/material.dart';

enum SnackBarType {
  info,
  error,
  success
  ;

  Color? get color => switch (this) {
    SnackBarType.info => null,
    SnackBarType.error => Colors.red,
    SnackBarType.success => Colors.green,
  };
}

extension SnackBarX on BuildContext {
  void showSnackBar(String message, {SnackBarType type = SnackBarType.info}) {
    final messenger = ScaffoldMessenger.of(this);
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 1500),
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: type.color,
    );

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<T?> navigateToPage<T>(Widget page) async {
    return Navigator.of(this).push<T>(
      MaterialPageRoute<T>(builder: (context) => page),
    );
  }
}
