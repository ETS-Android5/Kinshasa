import 'package:flutter/material.dart';

ThemeData theme(BuildContext context) {
  return ThemeData(
    colorScheme:
        Theme.of(context).colorScheme.copyWith(secondary: Colors.red[400]),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    ),
  );
}
