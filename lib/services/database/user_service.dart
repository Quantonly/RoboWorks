import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:robo_works/models/user_data.dart';

class UserService {
  final String uid;
  UserService({required this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<UserData> getUserData() async {
    UserData response = await users.doc(uid).get().then((snapshot) {
      UserData userData = UserData.fromMap(snapshot.data() as Map<String, dynamic>, uid);
      return userData;
    });
    return response;
  }
}
