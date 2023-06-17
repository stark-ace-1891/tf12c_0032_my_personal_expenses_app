class LocalUser {
  final String id;
  final String? name;
  final String? photoUrl;
  LocalUser({
    required this.id,
    this.name,
    this.photoUrl,
  });

  factory LocalUser.fromJson(Map<String, dynamic> json) {
    return LocalUser(
      id: json["id"],
      name: json["name"],
      photoUrl: json["photoUrl"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'photoUrl': photoUrl,
    };
  }
}
