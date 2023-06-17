import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tf12c_0032_my_personal_expenses_app/core/exceptions/exceptions.dart';
import 'package:tf12c_0032_my_personal_expenses_app/models/spent.dart';
import 'package:uuid/uuid.dart';

class ExpensesService {
  final cloudFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> saveSpent(
      {required String description, required double amount}) async {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId != null) {
        final spentId = Uuid().v1();
        final spent = Spent(
            id: spentId,
            description: description,
            amount: amount,
            userId: userId);
        await cloudFirestore
            .collection('expenses')
            .doc(spentId)
            .set(spent.toJson());
      } else {
        throw SaveSpentException();
      }
    } catch (e) {
      throw SaveSpentException();
    }
  }
}
