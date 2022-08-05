import 'package:firebase_use/constants/colors.dart';
import 'package:firebase_use/constants/icons.dart';
import 'package:firebase_use/constants/images.dart';
import 'package:firebase_use/constants/string_constants.dart';
import 'package:firebase_use/modules/home/home_page.dart';
import 'package:firebase_use/modules/login/sign_in_screen.dart';
import 'package:firebase_use/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool circular = false;
  final AuthClass _authClass = AuthClass();

  void signup() async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: 'yogita00gautam@gmail.com', password: '1234578');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  StringConstants.signUp,
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: ColorsConstants.white),
                ),
                const SizedBox(
                  height: 20,
                ),

                buttonItem(
                    onTap: () async {
                      await _authClass.googleSignIn(context);
                    },
                    imagePath: AppImages.google,
                    title: StringConstants.continueGoogle,),
                const SizedBox(
                  height: 20,
                ),
                buttonItem(
                    onTap: () {},
                    imagePath: AppImages.phone,
                    title: StringConstants.continueNumber,),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  StringConstants.or,
                  style: TextStyle(color: ColorsConstants.white),
                ),
                textForm(
                    lableText: StringConstants.email,
                    controller: _emailController,
                    obsecureText: false),
                textForm(
                    lableText: StringConstants.password,
                    controller: _passwordController,
                    obsecureText: true),
                colorButton(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      StringConstants.anAccount,
                      style: TextStyle(
                          color: ColorsConstants.white,
                          fontWeight: FontWeight.w500),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                      },
                      child: const Text(
                        StringConstants.login,
                        style: TextStyle(
                          color: ColorsConstants.white,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textForm({
    required String lableText,
    required TextEditingController controller,
    required obsecureText,
  }) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 70,
          height: 50,
          decoration: BoxDecoration(
            color: ColorsConstants.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            obscureText: obsecureText,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: ColorsConstants.lemonGrass,
              labelText: lableText,
              labelStyle: const TextStyle(color: ColorsConstants.white),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorsConstants.white),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget buttonItem({
    required String imagePath,
    required String title,
    required dynamic onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: ColorsConstants.black,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
                width: 1, color: ColorsConstants.mistBlueYourAccount),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                  child: Image.asset(imagePath,height: 40,width: 40,)),
              Text(title,
                style:const TextStyle(color: ColorsConstants.white),
                
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false);
        });
        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);
          print(userCredential.user?.email);
          setState(() {
            circular = false;
          });
        } catch (e) {
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              ColorsConstants.coralRed,
              ColorsConstants.mistBlueYourAccount
            ],
          ),
        ),
        child: Center(
          child: circular
              ? const CircularProgressIndicator()
              : const Text(
                  StringConstants.signUp,
                  style: TextStyle(
                      color: ColorsConstants.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
        ),
      ),
    );
  }
}
