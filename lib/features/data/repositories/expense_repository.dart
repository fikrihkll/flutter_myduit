import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myduit/features/data/models/expense_model.dart';

class ExpenseRepository {

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  ExpenseRepository({required this.firestore, required this.firebaseAuth});

  QueryDocumentSnapshot? lastLoadExpense;
  bool _isLoadMoreAvailable = true;

  bool get isLoadMoreAvailable => _isLoadMoreAvailable;

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

  Future<bool> updateExpense(ExpenseModel model) async {
    try {
      await firestore.collection("expenses").doc(model.id).update(
        ExpenseModel.toFirestore(model, isUpdate: true)
      );
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<List<ExpenseModel>> getCurrentExpense(int limit) async {
    var path = firestore.collection("expenses");
    debugPrint(firebaseAuth.currentUser!.uid);
    var query = await path
        .limit(limit)
        .orderBy("timestamp", descending: true)
        .where("user_id", isEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    return query.docs.map((e) => ExpenseModel.fromFirestore(e)).toList();
  }

  Future<List<ExpenseModel>> getListExpense(int page) async {
    var path = firestore.collection("expenses");
    
    if (page == 1) {
      debugPrint("LOAD FIRST");
      var query = await path
          .limit(10)
          .orderBy("timestamp", descending: true)
          .where("user_id", isEqualTo: firebaseAuth.currentUser!.uid)
          .get();
      lastLoadExpense = query.docs[query.docs.length-1];
      return query.docs.map((e) => ExpenseModel.fromFirestore(e)).toList();
    } else {
      debugPrint("LOAD PAGING");
      var query = await path
          .limit(10)
          .orderBy("timestamp", descending: true)
          .startAfterDocument(lastLoadExpense!)
          .where("user_id", isEqualTo: firebaseAuth.currentUser!.uid)
          .get();
      if (query.docs.isNotEmpty) {
        lastLoadExpense = query.docs[query.docs.length-1];
      } else {
        _isLoadMoreAvailable = false;
      }
      debugPrint("LOAD PAGING DONE");

      return query.docs.map((e) => ExpenseModel.fromFirestore(e)).toList();
    }

  }
}