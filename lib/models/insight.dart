/// One AI-generated spending insight shown as a card.
class SpendingInsight {
  final String headline;
  final String detail;
  final bool isWarning;

  const SpendingInsight({
    required this.headline,
    required this.detail,
    this.isWarning = false,
  });

  factory SpendingInsight.fromJson(Map<String, dynamic> json) => SpendingInsight(
        headline: json['headline'] as String,
        detail: json['detail'] as String,
        isWarning: (json['warning'] as bool?) ?? false,
      );
}
