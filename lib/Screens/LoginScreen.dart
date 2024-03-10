import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';
import 'package:wassuptoday/Screens/HomeScreen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  

  Future<Map?> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
    print(userCredential.additionalUserInfo?.isNewUser);
    return {
      'newUser': userCredential.additionalUserInfo?.isNewUser,
      'displayName': userCredential.user?.displayName,
      'email': userCredential.user?.email,
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return Sizer(builder: (context, orientation, deviceType) {
              return Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: [
                      Image(image: AssetImage("assets/wassuptoday.png")),
                      Container(
                        margin: EdgeInsets.only(left: 20, bottom: 200),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 80.w,
                            child: Text('Oops you are not signed in!',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, bottom: 200),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Spotify',
                            ),
                          ),
                          onPressed: () async {
                            Map? user = await signInWithGoogle();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
            },);
          } else {
            return HomeScreen();
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
