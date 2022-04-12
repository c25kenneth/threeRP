import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class DatabaseService {
  final String uid; 
  DatabaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('Users');

  Future updateUserData(String email, String name, String password, int plasticRecylcled, String uid, String imageURL, String imageData) async {
    return await userCollection.document(uid).setData({
      'email': email, 
      'imageData': imageData,
      'imageURL' : imageURL, 
      'name' : name, 
      'password' : password, 
      'plastic_recycled' : plasticRecylcled, 
      'uid' : uid,  
    });
  }
  Future updateRecycleData(int plastic) async {
    return await userCollection.document(uid).setData({
      'plastic_recycled' : plastic,
    }, merge: true);
  }

  List<Recycle> _recycleListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Recycle(
        recycledKG: doc.data['plastic_recycled'] ?? 0,
        userName: doc.data['name'] ?? " ",
      );
    }).toList();
  }
  
  IndivRecycle _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return IndivRecycle(
      uid: uid, 
      recycledKG: snapshot.data['plastic_recycled'],
    );
  }
  Stream<List<Recycle>> get recycle {
    return userCollection.snapshots().map(_recycleListFromSnapshot);
  }

  Stream<IndivRecycle> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }  
}