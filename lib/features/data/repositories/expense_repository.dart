import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myduit/features/data/models/expense_model.dart';

class ExpenseRepository {

  final FirebaseFirestore firestore;
  ExpenseRepository({required this.firestore});

  Future<DocumentReference<Map<String, dynamic>>> storeInsertExpense(ExpenseModel model) async {
    var store;
    try {
      store = await firestore.collection("expenses").add(ExpenseModel.toFirestore(model));
      return store;
    } catch(e) {
      store = null;
    }
    return store;
  }
}