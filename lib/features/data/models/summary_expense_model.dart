import 'package:cloud_firestore/cloud_firestore.dart';

class SummaryExpenseModel {

  String id;
  int nominal;
  String updatedAt;
  String userId;

  SummaryExpenseModel({
    required this.id,
    required this.nominal,
    required this.updatedAt,
    required this.userId
  });

  static Map<String, dynamic> toJson(SummaryExpenseModel model, bool isDecrement) {
    return {
      "nominal": isDecrement ? (model.nominal * -1) : (model.nominal),
      "updated_at": FieldValue.serverTimestamp(),
      "user_id": model.userId
    };
  }

  factory SummaryExpenseModel.fromFirestore(DocumentSnapshot doc) {
    return SummaryExpenseModel(
        id: doc.id,
        nominal: doc.get("nominal"),
        updatedAt: (doc.get("updated_at") as Timestamp).toDate().toString(),
        userId: doc.get("user_id")
    );
  }
}