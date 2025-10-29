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