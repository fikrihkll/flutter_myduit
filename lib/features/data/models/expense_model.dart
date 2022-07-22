import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  String category;
  String nominal;
  String description;
  String date;
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
      required this.date,
      required this.monthlyDateCode,
      required this.dailyDateCode,
      required this.userId,
      required this.timestamp,
      required this.updated_at
  });

  static Map<String, dynamic> toFirestore(ExpenseModel model){
    var dataModel = {
      "id": model.id.isEmpty ? null : model.id,
      "category": model.category,
      "nominal": int.parse(model.nominal),
      "description": model.description,
      "date": model.date,
      "monthly_date_code": model.monthlyDateCode,
      "daily_date_code": model.dailyDateCode,
      "timestamp": model.timestamp.isEmpty ? FieldValue.serverTimestamp() : null,
      "updated_at": model.updated_at.isEmpty ? FieldValue.serverTimestamp() : null,
    };
    if (dataModel["id"] == null)  {
      dataModel.remove("id");
    }
    return dataModel;
  }
}
