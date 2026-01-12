class UserModel {
  final int? id;
  final String email;
  final String name;
  final String gender;
  final String dob;
  final int height;
  final int weight;

  UserModel({
    this.id,
    required this.email,
    required this.name,
    required this.gender,
    required this.dob,
    required this.height,
    required this.weight,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      dob: map['dob'] ?? '',
      height: map['height'] != null
          ? int.parse(map['height'].toString())
          : 0,
      weight: map['weight'] != null
          ? int.parse(map['weight'].toString())
          : 0,
    );
  }

  // 🔥 ID TIDAK BOLEH DI-UPDATE
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'gender': gender,
      'dob': dob,
      'height': height,
      'weight': weight,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? gender,
    String? dob,
    int? height,
    int? weight,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }
}
