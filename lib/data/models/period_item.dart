/// Model dữ liệu cho từng thời kỳ trên dòng thời gian dây leo
class PeriodItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isSelected;
  final bool isUnlocked;

  const PeriodItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.isSelected = false,
    this.isUnlocked = true,
  });

  PeriodItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    bool? isSelected,
    bool? isUnlocked,
  }) {
    return PeriodItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      isSelected: isSelected ?? this.isSelected,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
