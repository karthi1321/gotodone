class CodeTipModel {
  final int day;
  final String tip;
  final String level;

  CodeTipModel({
    required this.day,
    required this.tip,
    required this.level,
  });

  factory CodeTipModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return CodeTipModel(
      day: json['day'] as int,
      tip: json['tip'] as String,
      level: json['level'] as String,
    );
  }
}
