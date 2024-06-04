


import 'package:tracky/utility/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FirebaseAuthServices{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

//get current user details
  User? getCurrentUser(){
    return _auth.currentUser;
  }


  //sign up
  Future<void> signUpWithMailPass(String name, email, password, phoneNumber) async{
    try{
      UserCredential credential =
      await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password);


      await _auth.signInWithEmailAndPassword(email: email, password: password);

      //save info in firestore
      await _fireStore.collection("Users").doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'firstLaunchDate': DateTime.now(),
        'occupation': '',
        'profileImage': ''
      });

      Utility().toastMessage("Account Created Successfully");
      signOut();

    }on Error catch (e){
      Utility().toastMessage(e.toString());
    }

  }

  //sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) async{
        // Save email and password to shared preferences for auto-login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setString('password', password);

        Utility().toastMessage("Login Successful");

      });

    } catch (e) {
      Utility().toastMessage('Sign in error: $e');
      return;
    }
  }

  // Auto-login method
  Future<User?> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null && password != null) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        //Utility().toastMessage("Auto Login Successful");
        return userCredential.user;
      } catch (e) {
        Utility().toastMessage('Auto-login error: $e');
        return null;
      }
    } else {
      return null;
    }
  }


  // Sign out method
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear stored email and password
    await _auth.signOut();
    Utility().toastMessage("Logout Successful");
  }


  //send email verification
  Future<void> sendEmailVerification()async{
    try{
      await _auth.currentUser!.sendEmailVerification();
    }catch(e){
      Utility().toastMessage("Error: $e");
    }
  }

  //check if email is verified
  bool isEmailVerified() {
    FirebaseAuth auth =  FirebaseAuth.instance;
    return  auth.currentUser!.emailVerified;
  }



  Future<String> getUserData(String details) async{
    try{
      User? userID = _auth.currentUser;

      final DocumentReference ref =
      FirebaseFirestore.instance.collection("Users").doc(userID!.uid);

      DocumentSnapshot snapshot = await ref.get();

      // Check if the document exists
      if (snapshot.exists) {
        // Get the data from the document
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Access specific fields from the data
        var userDetails = data[details];

        // Do something with the item
        return userDetails;
      } else {
        return 'User';
      }

    }catch(e){
      return "User";
    }

  }

  Future<void> updateUserProfile({String? phoneNumber, String? occupation, String? profileImage}) async {
    final userId = _auth.currentUser!.uid;
    final userDoc = _fireStore.collection('Users').doc(userId);

    // Fetch the current data to check if fields are empty
    final userSnapshot = await userDoc.get();
    final userData = userSnapshot.data() as Map<String, dynamic>;

    // Check if fields are empty and set to "Click to edit" if necessary
    phoneNumber ??= (userData['phoneNumber'] ?? '').isEmpty ? 'Click to edit' : userData['phoneNumber'];

    occupation ??= (userData['occupation'] ?? '').isEmpty ? 'Click to edit' : userData['occupation'];

    profileImage ??= (userData['profileImage'] ?? '').isEmpty ? '' : userData['profileImage'];

    // Update the user document with the new data
    await userDoc.update({
      'phoneNumber': phoneNumber,
      'occupation': occupation,
      'profileImage': profileImage
    });
  }

}