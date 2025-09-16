import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("users");

  // CREATE
  Future<void> createUser(String id, Map<String, dynamic> data) async {
    await _dbRef.child(id).set(data);
  }

  // READ (Single User)
  Future<DataSnapshot> readUser(String id) async {
    return await _dbRef.child(id).get();
  }

  // READ (All Users - stream for realtime updates)
  Stream<DatabaseEvent> readUsers() {
    return _dbRef.onValue;
  }

  // UPDATE
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _dbRef.child(id).update(data);
  }

  // DELETE
  Future<void> deleteUser(String id) async {
    await _dbRef.child(id).remove();
  }
}
