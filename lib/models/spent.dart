class Spent {
  final String id;
  final String description;
  final double amount;
  final String userId;

  Spent({
    required this.id,
    required this.description,
    required this.amount,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'userId': userId,
    };
  }
}
