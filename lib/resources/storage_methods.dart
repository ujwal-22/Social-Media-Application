import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods{

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ADDING AN IMAGE TO THE FIREBASE STORAGE
  Future<String> uploadImageToStorage(
      {required String childName, required Uint8List file, required bool isPost}) async {

    Reference reference  = _firebaseStorage.ref().child(childName).child(_firebaseAuth.currentUser!.uid);

    if(isPost){
      String id = const Uuid().v1();
      reference = reference.child(id);
    }

    UploadTask uploadTask = reference.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadurl = await snapshot.ref.getDownloadURL();
    return downloadurl;

  }

}