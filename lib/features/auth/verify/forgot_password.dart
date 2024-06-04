import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '/utility/toast.dart';
import '../../../../core/widget/rounded_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),

            const SizedBox(height: 40,),

            Obx(()=> RoundedButton(
                borderColor: Theme
                    .of(context)
                    .colorScheme
                    .tertiary,
                fillColor: Theme
                    .of(context)
                    .colorScheme
                    .tertiary,
                onTap: (){
                  isLoading.value = true;

                  auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){

                    isLoading.value = false;

                    Utility().toastMessage("Reset link sent to your mail for password recovery");
                    emailController.clear();
                  }).onError((error, stackTrace) {
                    Utility().toastMessage(error.toString());

                    isLoading.value = false;

                  });

                },
                isLoading: isLoading.value,
                child: Text(
                  "Forgot",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 17, color: Theme
                          .of(context)
                          .colorScheme
                          .surface)),
                )),
            ),

          ],
        ),
      ),
    );
  }
}
