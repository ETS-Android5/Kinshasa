import 'package:flutter/material.dart';
import 'package:kinshasa/shared/exports.dart';

class Utils {
  static showToast(String title, String message) {
    Get.snackbar(
      '',
      '',
      titleText: Text(title, style: TextStyle(color: Colors.white)),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.grey,
    );
  }
}
