import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myduit/features/data/models/user_model.dart';

class AuthenticationRepository {

  final FirebaseFirestore firestore;
  AuthenticationRepository({required this.firestore});

  Future<bool> isUserExist(String email) async {
    var result = await firestore.collection("users").where("email", isEqualTo: email).get();
    if (result.size == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> storeNewUserData(UserModel model) async {
    bool result = false;
    try {
      await firestore.collection("users").add(UserModel.toMap(model));
      result = true;
    } catch(e) {
      result = false;
    }
    return result;
  }

}