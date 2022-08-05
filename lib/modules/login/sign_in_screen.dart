import 'package:firebase_use/modules/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_use/constants/colors.dart';
import 'package:firebase_use/constants/images.dart';
import 'package:firebase_use/constants/string_constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();
  bool circular = false;
  void signup() async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: 'yogita00gautam@gmail.com', password: '1234578');
    } catch (e) {
      print(e);
    }
  }

  final List items = [
    {
      'title': StringConstants.email,
    },
    {
      'title': StringConstants.password,
    }
  ];

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
                  StringConstants.signIn,
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: ColorsConstants.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
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
                      children: [
                        Image.asset(AppImages.google),
                        const Text(
                          StringConstants.continueGoogle,
                          style: TextStyle(color: ColorsConstants.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                buttonItem(),
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
                    obscureText: false),
                textForm(
                    lableText: StringConstants.password,
                    controller: _passwordController,
                    obscureText: true),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                colorButton(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      StringConstants.dontHaveAnAccount,
                      style: TextStyle(
                          color: ColorsConstants.white,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      StringConstants.signUp,
                      style: TextStyle(
                        color: ColorsConstants.white,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
             const SizedBox(height: 10,),
                const Text(
                  StringConstants.forgotPassword,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                      color: ColorsConstants.white),
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
    required obscureText,
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
            obscureText: obscureText,
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

  Widget buttonItem() {
    return SizedBox(
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
          children: const [
            Icon(
              Icons.phone,
              color: Colors.green,
              size: 50,
            ),
            Text(
              StringConstants.continueGoogle,
              style: TextStyle(color: ColorsConstants.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorButton() {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [ColorsConstants.white, ColorsConstants.mistBlueYourAccount],
        ),
      ),
      child:  Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () async{
            setState(() {
              circular = true;

            });
            try {
              firebase_auth.UserCredential userCredential =
              await firebaseAuth.createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);
              print(userCredential.user?.email);
              setState(() {
                circular = false;
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const HomePage()));
              });
            } catch (e) {
              final snackBar = SnackBar(content: Text(e.toString()));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              setState(() {
                circular = false;
              },);
            }
          } ,
          child:circular
              ? const CircularProgressIndicator():
        const Text(
            StringConstants.signIn,
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
