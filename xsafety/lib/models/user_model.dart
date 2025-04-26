class UserModel {
  String uid;
  String name;
  String age;
  String address;
  String phone;
  String email;
  String bloodGroup;
  String emergencyName;
  String emergencyPhone;

  UserModel({
    required this.uid,
    required this.name,
    required this.age,
    required this.address,
    required this.phone,
    required this.email,
    required this.bloodGroup,
    required this.emergencyName,
    required this.emergencyPhone,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        uid: data['uid'] ?? '',
        name: data['name'] ?? '',
        age: data['age'] ?? '',
        address: data['address'] ?? '',
        phone: data['phone'] ?? '',
        email: data['email'] ?? '',
        bloodGroup: data['bloodGroup'] ?? '',
        emergencyName: data['emergencyName'] ?? '',
        emergencyPhone: data['emergencyPhone'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "age": age,
        "address": address,
        "phone": phone,
        "email": email,
        "bloodGroup": bloodGroup,
        "emergencyName": emergencyName,
        "emergencyPhone": emergencyPhone,
      };
}
