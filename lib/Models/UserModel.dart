class UserModel {
  String id;
  String userHash;
  String? name;
  String? bio;
  String profilePhotoBase64;
  String phoneNumber;
  String phoneAreaCode;

  UserModel({
    required this.id,
    required this.userHash,
    this.name,
    this.bio,
    required this.profilePhotoBase64,
    required this.phoneNumber,
    required this.phoneAreaCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"].toString(),
        userHash: json["userHash"],
        name: json["name"],
        bio: json["bio"],
        profilePhotoBase64: json["profilePhotoBase64"],
        phoneNumber: json["phoneNumber"],
        phoneAreaCode: json["phoneAreaCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userHash": userHash,
        "name": name,
        "bio": bio,
        "profilePhotoBase64": profilePhotoBase64,
        "phoneNumber": phoneNumber,
        "phoneAreaCode": phoneAreaCode,
      };
}
