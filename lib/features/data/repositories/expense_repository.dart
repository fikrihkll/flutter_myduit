import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myduit/features/data/models/expense_model.dart';
import 'package:myduit/features/data/models/summary_expense_model.dart';

class ExpenseRepository {

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  ExpenseRepository({required this.firestore, required this.firebaseAuth});

  QueryDocumentSnapshot? lastLoadExpense;
  bool _isLoadMoreAvailable = true;

  bool get isLoadMoreAvailable => _isLoadMoreAvailable;

  Future<bool> storeInsertExpense(ExpenseModel model) async {
    var store;
    try {
      var userUid = firebaseAuth.currentUser!.uid;
      await firestore.runTransaction((transaction) async {
        var monthlyRef = firestore.collection("monthly_expenses").doc("${model.monthlyDateCode}_$userUid");
        var dailyRef = firestore.collection("daily_expenses").doc("${model.dailyDateCode}_$userUid");

        var monthlyExpensePrevDoc = await transaction.get(monthlyRef);
        var dailyExpensePrevDoc = await transaction.get(dailyRef);

        if (monthlyExpensePrevDoc.exists) {
          transaction.update(monthlyRef, {
            "nominal": FieldValue.increment(model.nominal),
            "updated_at": FieldValue.serverTimestamp()
          });
        } else {
          transaction.set(monthlyRef, {
            "nominal": FieldValue.increment(model.nominal),
            "updated_at": FieldValue.serverTimestamp(),
            "timestamp": FieldValue.serverTimestamp(),
            "user_id": userUid
          });
        }

        if (dailyExpensePrevDoc.exists) {
          transaction.update(dailyRef, {
            "nominal": FieldValue.increment(model.nominal),
            "updated_at": FieldValue.serverTimestamp()
          });
        } else {
          transaction.set(dailyRef, {
            "nominal": FieldValue.increment(model.nominal),
            "updated_at": FieldValue.serverTimestamp(),
            "timestamp": FieldValue.serverTimestamp(),
            "user_id": userUid
          });
        }

        var docRef = firestore.collection("expenses").doc();
        store = transaction.set(docRef, ExpenseModel.toFirestore(model));
      });

      return true;
    } catch(e) {
      debugPrint("err insert firestore ${e.toString()}");
    }
    return false;
  }

  Future<bool> deleteLog(ExpenseModel model) async {
    try {
      var userUid = firebaseAuth.currentUser!.uid;

      var monthlyRef = firestore.collection("monthly_expenses").doc("${model.monthlyDateCode}_$userUid");
      var dailyRef = firestore.collection("daily_expenses").doc("${model.dailyDateCode}_$userUid");

      var monthlyExpensePrevDoc = await monthlyRef.get();
      var dailyExpensePrevDoc = await dailyRef.get();

      if (monthlyExpensePrevDoc.exists) {
        await monthlyRef.update({
          "nominal": FieldValue.increment(-1 * model.nominal),
          "updated_at": FieldValue.serverTimestamp()
        });
      }

      if (dailyExpensePrevDoc.exists) {
        await dailyRef.update({
          "nominal": FieldValue.increment(-1 * model.nominal),
          "updated_at": FieldValue.serverTimestamp()
        });
      }

      await firestore.collection("expenses").doc(model.id).delete();
      return true;
    } catch(e) {
      debugPrint("Firebase Error => $e");
      return false;
    }
  }

  Future<SummaryExpenseModel?> getDailyExpense() async {
    var date = DateTime.now();
    String userId = firebaseAuth.currentUser!.uid;
    var path = firestore.collection("daily_expenses").doc("${date.day}-${date.month}-${date.year}_$userId");
    var query = await path.get();

    if(query.exists) {
      return SummaryExpenseModel.fromFirestore(query);
    }

    return null;
  }

  Future<SummaryExpenseModel?> getMonthlyExpense() async {
    var date = DateTime.now();
    String userId = firebaseAuth.currentUser!.uid;
    var path = firestore.collection("monthly_expenses").doc("${date.month}-${date.year}_$userId");
    var query = await path.get();

    if (query.exists) {
      return SummaryExpenseModel.fromFirestore(query);
    }

    return null;
  }

  Future<bool> updateExpense(ExpenseModel oldModel, ExpenseModel newModel) async {
    try {
      var userUid = firebaseAuth.currentUser!.uid;
      await firestore.runTransaction((transaction) async {
        var logRef = firestore.collection("expenses");
        var monthlyRef = firestore.collection("monthly_expenses");
        var dailyRef = firestore.collection("daily_expenses");

        var newDocRef = logRef.doc(newModel.id);
        var logDoc = await transaction.get(newDocRef);
        if (!logDoc.exists) {
          throw Exception("Log not found");
        }

        var monthlyExpensePrevDoc = await transaction.get(monthlyRef.doc("${oldModel.monthlyDateCode}_$userUid"));
        var dailyExpensePrevDoc = await transaction.get(dailyRef.doc("${oldModel.dailyDateCode}_$userUid"));
        var monthlyExpenseDoc = await transaction.get(monthlyRef.doc("${newModel.monthlyDateCode}_$userUid"));
        var dailyExpenseDoc = await transaction.get(dailyRef.doc("${newModel.dailyDateCode}_$userUid"));

        var oldMonthlyDocRef = monthlyRef.doc("${oldModel.monthlyDateCode}_$userUid");
        var oldDailyDocRef = dailyRef.doc("${oldModel.dailyDateCode}_$userUid");
        var newMonthlyDocRef = monthlyRef.doc("${newModel.monthlyDateCode}_$userUid");
        var newDailyDocRef = dailyRef.doc("${newModel.dailyDateCode}_$userUid");

        if (monthlyExpensePrevDoc.exists) {
          transaction.update(oldMonthlyDocRef, {
            "nominal": FieldValue.increment(-1 * oldModel.nominal),
            "updated_at": FieldValue.serverTimestamp()
          });
        }

        if (dailyExpensePrevDoc.exists) {
          transaction.update(oldDailyDocRef, {
            "nominal": FieldValue.increment(-1 * oldModel.nominal),
            "updated_at": FieldValue.serverTimestamp()
          });
        }

        // Update new value
        if (monthlyExpenseDoc.exists) {
          transaction.update(newMonthlyDocRef, {
            "nominal": FieldValue.increment(newModel.nominal),
            "updated_at": FieldValue.serverTimestamp()
          });
        } else {
          transaction.set(newMonthlyDocRef, {
            "nominal": FieldValue.increment(newModel.nominal),
            "updated_at": FieldValue.serverTimestamp(),
            "timestamp": FieldValue.serverTimestamp(),
            "user_id": newModel.userId
          });
        }

        if (dailyExpenseDoc.exists) {
          transaction.update(newDailyDocRef, {
            "nominal": FieldValue.increment(newModel.nominal),
            "updated_at": FieldValue.serverTimestamp()
          });
        } else {
          transaction.set(newDailyDocRef, {
            "nominal": FieldValue.increment(newModel.nominal),
            "updated_at": FieldValue.serverTimestamp(),
            "timestamp": FieldValue.serverTimestamp(),
            "user_id": newModel.userId
          });
        }

        // Update log
        transaction.update(newDocRef, ExpenseModel.toFirestore(newModel, isUpdate: true));
      });
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<ExpenseModel>> getCurrentExpense(int limit) async {
    var path = firestore.collection("expenses");
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
      var query = await path
          .limit(10)
          .orderBy("timestamp", descending: true)
          .where("user_id", isEqualTo: firebaseAuth.currentUser!.uid)
          .get();
      lastLoadExpense = query.docs[query.docs.length-1];
      if (query.docs.length < 10) {
        _isLoadMoreAvailable = false;
      }
      return query.docs.map((e) => ExpenseModel.fromFirestore(e)).toList();
    } else {
      var query = await path
          .limit(10)
          .orderBy("timestamp", descending: true)
          .startAfterDocument(lastLoadExpense!)
          .where("user_id", isEqualTo: firebaseAuth.currentUser!.uid)
          .get();
      if (query.docs.isNotEmpty) {
        if (query.docs.length < 10) {
          _isLoadMoreAvailable = false;
        }
        lastLoadExpense = query.docs[query.docs.length-1];
      } else {
        _isLoadMoreAvailable = false;
      }
      return query.docs.map((e) => ExpenseModel.fromFirestore(e)).toList();
    }

  }
}