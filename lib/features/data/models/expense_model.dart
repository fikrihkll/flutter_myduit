import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  String category;
  int nominal;
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

  static Map<String, dynamic> toFirestore(ExpenseModel model, {bool isUpdate = false}){

    var dataModel = {
      "id": model.id.isEmpty ? null : model.id,
      "category": model.category,
      "nominal": model.nominal,
      "description": model.description,
      "date": model.date,
      "monthly_date_code": model.monthlyDateCode,
      "daily_date_code": model.dailyDateCode,
      "user_id": model.userId,
      "timestamp": model.timestamp.isEmpty ? FieldValue.serverTimestamp() : null,
      "updated_at": model.updated_at.isEmpty ? FieldValue.serverTimestamp() : null,
    };
    if (dataModel["id"] == null)  {
      dataModel.remove("id");
    }
    if (isUpdate) {
      dataModel.remove("timestamp");
    }
    return dataModel;
  }
  
  factory ExpenseModel.fromFirestore(QueryDocumentSnapshot doc) {
    return ExpenseModel(
        id: doc.id,
        category: doc.get("category"),
        nominal: doc.get("nominal") is String ? int.parse(doc.get("nominal")) : doc.get("nominal"),
        description: doc.get("description"),
        date: doc.get("date"),
        monthlyDateCode: doc.get("monthly_date_code"),
        dailyDateCode: doc.get("daily_date_code"),
        userId: doc.get("user_id"),
        timestamp: (doc.get("timestamp") as Timestamp).toDate().toString(),
        updated_at: (doc.get("timestamp") as Timestamp).toDate().toString()
    );
  }
}

class ExpenseCategory {
  String name;

  ExpenseCategory(this.name);
}

var categoryNameList = [
  ExpenseCategory('Meal'),
  ExpenseCategory('Food'),
  ExpenseCategory('Drink'),
  ExpenseCategory('Laundry'),
  ExpenseCategory('E-Money'),
  ExpenseCategory('Transportation'),
  ExpenseCategory('Tools'),
  ExpenseCategory('Toiletries'),
  ExpenseCategory('Electricity'),
  ExpenseCategory('Daily Needs'),
  ExpenseCategory('Subscription'),
  ExpenseCategory('Shopping'),
  ExpenseCategory('Others'),
];