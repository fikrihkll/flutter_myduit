class ExpenseModel {
  final String id;
  String category;
  int nominal;
  String description;
  String monthlyDateCode;
  String dailyDateCode;
  final String userId;
  final String timestamp;
  String updated_at;

  ExpenseModel({
      required this.id,
      required this.category,
      required this.nominal,
      required this.description,
      required this.monthlyDateCode,
      required this.dailyDateCode,
      required this.userId,
      required this.timestamp,
      required this.updated_at
  });
}
