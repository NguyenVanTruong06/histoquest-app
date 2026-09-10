class HeroCardModel {
  final String id;
  final String heroName;
  final int stars;
  final String era;
  final String title;
  final String quote;
  final String description;
  final bool isCollected;

  const HeroCardModel({
    required this.id,
    required this.heroName,
    required this.stars,
    required this.era,
    required this.title,
    required this.quote,
    required this.description,
    this.isCollected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heroName': heroName,
      'stars': stars,
      'era': era,
      'title': title,
      'quote': quote,
      'description': description,
      'isCollected': isCollected,
    };
  }

  factory HeroCardModel.fromJson(Map<String, dynamic> json) {
    return HeroCardModel(
      id: json['id'] as String? ?? '',
      heroName: json['heroName'] as String? ?? '',
      stars: json['stars'] as int? ?? 1,
      era: json['era'] as String? ?? '',
      title: json['title'] as String? ?? '',
      quote: json['quote'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isCollected: json['isCollected'] as bool? ?? false,
    );
  }
}
