class UserBalence {
  final int simple;
  final int procurement;
  final Map<String, dynamic> other;

  const UserBalence({
    this.simple = 0,
    this.procurement = 0,
    this.other = const {},
  });

  factory UserBalence.fromJson(Map<String, dynamic> json) {
    return UserBalence(
      simple: (json['simple'] ?? 0),
      procurement: (json['procurement'] ?? 0),
      other: json['other'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'simple': simple,
      'procurement': procurement,
      'other': other,
    };
  }
}
