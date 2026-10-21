class SectionIcon {

  static String get(String sectionName) {
    final name = sectionName.toLowerCase();
    if (name.contains('burger')) return '🍔';
    if (name.contains('pizza')) return '🍕';
    if(name.contains('green')) return '🥬';
    if (name.contains('chicken')) return '🍗';
    if (name.contains('fries') || name.contains('sides')) return '🍟';
    if (name.contains('drink') || name.contains('beverage')) return '🥤';
    if (name.contains('dessert') || name.contains('sweet')) return '🍰';
    if (name.contains('salad')) return '🥗';
    if (name.contains('sandwich')) return '🥪';
    if (name.contains('taco')) return '🌮';
    if (name.contains('hot dog')) return '🌭';
    if (name.contains('breakfast') || name.contains('egg')) return '🍳';
    if (name.contains('seafood') || name.contains('fish')) return '🍤';
    if (name.contains('pasta')) return '🍝';
    if (name.contains('soup')) return '🍲';
    return '🍽️';
  }
}