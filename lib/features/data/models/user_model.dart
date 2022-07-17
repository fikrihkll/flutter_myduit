import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String timestamp;

  UserModel({required this.id, required this.name, required this.email, required this.timestamp});

  static Map<String, dynamic> toMap(UserModel model) {
    return {
      "id": model.id.isEmpty ? null : model.id,
      "email": model.email,
      "name": model.name,
      "timestamp": model.timestamp.isEmpty ? FieldValue.serverTimestamp() : model.timestamp.isEmpty
    };
  }
}