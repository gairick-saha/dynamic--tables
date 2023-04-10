import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Utility {
  static Color generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  static Future<Color> pickColor(BuildContext context,
      {Color? initialColor}) async {
    Color newColor = initialColor ?? generateRandomColor();
    await showDialog<Color>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Pick Table Color"),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlockPicker(
                pickerColor: initialColor ?? Colors.blue,
                onColorChanged: (value) {
                  newColor = value;
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text("Select"),
              ),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );

    return newColor;
  }
}
