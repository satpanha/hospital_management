import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
}

String formatDateOnly(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

String formatTimeOnly(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime);
}

String calculateRemainingTime(DateTime appointmentTime) {
    final now = DateTime.now();
    final diff = appointmentTime.difference(now);

    if (diff.isNegative) {
      return 'Already passed';
    } else if (diff.inHours >= 24) {
      final days = diff.inDays;
      final hours = diff.inHours % 24;
      return '$days day${days > 1 ? 's' : ''} $hours hour${hours != 1 ? 's' : ''} left';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours != 1 ? 's' : ''} left';
    } else {
      final minutes = diff.inMinutes;
      return '$minutes minute${minutes != 1 ? 's' : ''} left';
    }
  }