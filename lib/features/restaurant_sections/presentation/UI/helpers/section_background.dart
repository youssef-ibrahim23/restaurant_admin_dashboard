import 'dart:ui';

class SectionBackground {

  static Color get(String sectionName) {
    final name = sectionName.toLowerCase();
    if (name.contains('burger')) return const Color(0xFFFFF0E9);
    if (name.contains('pizza')) return const Color(0xFFFFF0E8);
    if (name.contains('green')) return const Color(0xFF59B87A);
    return const Color(0xFFF0F0F0);
  }
}