class UserModel {
  final int? id;
  final String name;
  final String email;
  final String gender;
  final String dob;
  final int height;
  final int weight;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.dob,
    required this.height,
    required this.weight,
  });

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
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }
}
