import 'dart:io';
import 'package:intl/intl.dart';

String readNonEmpty(String prompt) {
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.trim() ?? '';
    if (input.isNotEmpty) return input;
    print('Input cannot be empty. Please try again.');
  }
}

int readInt(String prompt, {int? min, int? max}) {
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync();
    final value = int.tryParse(input ?? '');
    if (value == null) {
      print('Please enter a valid number.');
      continue;
    }
    if (min != null && value < min || max != null && value > max) {
      print('Please enter a number between $min and $max.');
      continue;
    }
    return value;
  }
}

DateTime readDate(String prompt) {
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.trim();
    if (input == null || input.isEmpty) {
      print('Date cannot be empty.');
      continue;
    }
    try {
      return DateFormat('yyyy-MM-dd').parseStrict(input);
    } catch (_) {
      print(' Invalid date format. Please use YYYY-MM-DD.');
    }
  }
}

String readTime(String prompt) {
  final timeRegex = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$');
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.trim() ?? '';
    if (timeRegex.hasMatch(input)) return input;
    print('Invalid time. Please use HH:MM (24-hour format).');
  }
}

String readPhone(String prompt) {
  final phoneRegex = RegExp(r'^\+?\d{7,15}$');
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.trim() ?? '';
    if (phoneRegex.hasMatch(input)) return input;
    print('Invalid phone number. Must contain only digits (7–15).');
  }
}

String readId(String prompt) {
  final idRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.trim() ?? '';
    if (idRegex.hasMatch(input)) return input;
    print('Invalid ID format (letters, numbers, underscores, or hyphens only).');
  }
}
