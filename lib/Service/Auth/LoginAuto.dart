
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'file:///E:/Work/Flutter/Order/gpgroup/lib/Model/Users/UsersData.dart';
class LogInAndSignIn {
final FirebaseAuth _auth = FirebaseAuth.instance;

  Future autoLogin(String email,String password)async{

    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email:email, password: password);
      print(result.user.email);

      return  _personalinfo(result.user);
    }
    catch(e){
      print(e.code);
      if(e.code == 'invalid-email'){
        return 'invalid-email';
      }
      else if(e.code == 'wrong-password'){

        return 'wrong-password';
      } else if(e.code == 'user-not-found'){
        return 'user-not-found';
      }
      else{
        return print(e.toString());
      }

      print(e.toString());
    }
  }
Future<dynamic> loginWithGoogle() async {
  try {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount account = await googleSignIn.signIn();
    if(account == null )
      return false;
    UserCredential result = await _auth.signInWithCredential(GoogleAuthProvider.credential(
      idToken: (await account.authentication).idToken,
      accessToken: (await account.authentication).accessToken,
    ));
    if(result.user == null){return null;}
    else{

      return  _personalinfo(result.user);
    }


  } catch (e) {
    print('error');
    print(e.code);

    return false;
  }
}

Future RegisterwithEmail(String email,String password)async{
    try{
      UserCredential result = await  _auth.createUserWithEmailAndPassword(email: email, password: password);
      return  _personalinfo(result.user);
    }
    catch(e){
      if(e.code =='email-already-in-use'){
        return 'email-already-in-use';
      }
    }
}

Future signouts()async{
    try{
      await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
}

UsersData _personalinfo (User user){
    try{
      return user != null?UsersData(userid: user.uid,email: user.email):null;
    }
    catch(e){
      print(e.toString());
    }
}
Stream<UsersData> get USERDATA{
    return _auth.authStateChanges().map(_personalinfo);
}
}