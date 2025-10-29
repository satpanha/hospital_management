import 'package:uuid/uuid.dart';

class IdGenerator {
  static const _uuid = Uuid();
  
  static String generate() {
    // Generates a shorter, unique ID for console readability
    return _uuid.v4().substring(0, 8);
  }
}