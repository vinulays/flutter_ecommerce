import 'package:cloud_firestore/cloud_firestore.dart';

class UserLocal {
  String? id;
  String email;
  String? avatarURL;
  String displayName;
  String username;
  String? contactNo;
  String? address;
  List<String> likedProducts;
  String? role;

  UserLocal(
      {this.id,
      required this.email,
      this.avatarURL,
      required this.displayName,
      required this.username,
      this.contactNo,
      this.address,
      required this.likedProducts,
      required this.role});

  factory UserLocal.fromFirestore(DocumentSnapshot doc, String? emailAddress) {
    final data = doc.data() as Map<String, dynamic>;

    return UserLocal(
        id: doc.id,
        email: emailAddress!,
        avatarURL: data['avatarURL'],
        displayName: data['displayName'],
        username: data['username'],
        contactNo: data['contactNo'],
        address: data['address'],
        likedProducts: List<String>.from(
          data['likedProducts'],
        ),
        role: data["role"]);
  }
}