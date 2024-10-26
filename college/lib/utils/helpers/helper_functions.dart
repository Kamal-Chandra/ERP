import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HelperFunctions {
  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  static Color? getColor(String value) {
    switch (value) {
      case 'Green':
        return Colors.green;
      case 'LightGreen':
        return Colors.lightGreen;
      case 'DarkGreen':
        return Colors.green[800];
      case 'Red':
        return Colors.red;
      case 'Pink':
        return Colors.pink;
      case 'Purple':
        return Colors.purple;
      case 'DeepPurple':
        return Colors.deepPurple;
      case 'Indigo':
        return Colors.indigo;
      case 'Blue':
        return Colors.blue;
      case 'LightBlue':
        return Colors.lightBlue;
      case 'Cyan':
        return Colors.cyan;
      case 'Teal':
        return Colors.teal;
      case 'Orange':
        return Colors.orange;
      case 'DeepOrange':
        return Colors.deepOrange;
      case 'Amber':
        return Colors.amber;
      case 'Yellow':
        return Colors.yellow;
      case 'Brown':
        return const Color(0xFF8B4513);
      case 'Grey':
        return Colors.grey;
      case 'BlueGrey':
        return Colors.blueGrey;
      case 'Black':
        return Colors.black;
      case 'White':
        return Colors.white;
      case 'Transparent':
        return Colors.transparent;
      case 'Lime':
        return Colors.lime;
      case 'DeepPurpleAccent':
        return Colors.deepPurpleAccent;
      case 'LightBlueAccent':
        return Colors.lightBlueAccent;
      case 'RedAccent':
        return Colors.redAccent;
      case 'PinkAccent':
        return Colors.pinkAccent;
      case 'AmberAccent':
        return Colors.amberAccent;
      case 'CyanAccent':
        return Colors.cyanAccent;
      case 'TealAccent':
        return Colors.tealAccent;
      case 'OrangeAccent':
        return Colors.orangeAccent;
      case 'LightPink':
        return Colors.pink[100];
      case 'DarkBlue':
        return Colors.blue[900];
      case 'LightYellow':
        return Colors.yellow[100];
      case 'DeepOrangeAccent':
        return Colors.deepOrangeAccent;
      default:
        return null;
    }
  }
}