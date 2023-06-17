import 'package:cloud_firestore/cloud_firestore.dart';

class Spent {
  final String id;
  final String description;
  final double amount;
  final String userId;
  final DateTime createAt;

  Spent({
    required this.id,
    required this.description,
    required this.amount,
    required this.userId,
    required this.createAt,
  });

  factory Spent.fromJson(Map<String, dynamic> json) {
    return Spent(
      id: json["id"] as String,
      description: json["description"] as String,
      amount: json["amount"] as double,
      userId: json["userId"] as String,
      createAt: DateTime.fromMicrosecondsSinceEpoch(
          (json["createAt"] as Timestamp).microsecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'userId': userId,
      'createAt': createAt,
    };
  }
}
