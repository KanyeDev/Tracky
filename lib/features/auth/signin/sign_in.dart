import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracky/utility/toast.dart';

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import '../../../core/widget/my_textform_field.dart';
import '../../../core/widget/rounded_button.dart';
import '../../../utility/pageRoutes.dart';
import '../../home/pages/homepage.dart';
import '../auth_services/auth_services.dart';

import 'package:get/get.dart';

import '../signup/signup.dart';
import '../verify/forgot_password.dart';
import '../verify/verify_email.dart';



//TODO: GOOOOOGLE SIGNIN AND LOGIN

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuthServices _authServices = FirebaseAuthServices();

  RxBool isLoading = false.obs;
  RxBool isLoadingLogin = false.obs;
  RxBool isPasswordVisible = false.obs;

  void login()async{
    try{
      await _authServices.signInWithEmailAndPassword(_controller.text, _passwordController.text).then((value) {
        FirebaseAuthServices().isEmailVerified() ? Navigator.pushAndRemoveUntil(
            context,
            CustomPageRouteLR(
                child: const HomePage(),
                direction: AxisDirection.left), (route) => false) : Navigator
            .push(
            context,
            CustomPageRouteLR(
                child: const EmailVerification(),
                direction: AxisDirection.left));
      });
      isLoadingLogin.value = false;
    }catch(e){
      isLoadingLogin.value = false;
      Utility().toastMessage(e.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                Text(
                  "Login",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.surface)),
                ),
                const Gap(7),
                Text(
                  "Sign in to gain access to your account",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12.8,
                          color: Colors.grey)),
                ),
                const Gap(20),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email address",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.surface)),
                        ),
                        const Gap(15),
                        SizedBox(
                            height: 44,
                            child: MyTextFormField(
                              controller: _controller,
                              hintText: 'Enter Email',
                              keyboardType: TextInputType.text,
                              isObscured: false,
                            )),
                        const Gap(20),
                        Text(
                          "Password",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.surface)),
                        ),
                        const Gap(20),
                        SizedBox(
                            height: 44,
                            child: Obx(()=> MyTextFormField(
                              controller: _passwordController,
                              hintText: 'Enter Password',
                              icon: isPasswordVisible.value? GestureDetector(
                                onTap: ()=> isPasswordVisible.value = false,
                                child: const Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ): GestureDetector(
                                onTap: ()=> isPasswordVisible.value = true,
                                child: const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              isObscured: !isPasswordVisible.value,
                            ),
                            )),
                      ],
                    )),
                const Gap(13),

                //forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),

                    GestureDetector(
                      onTap: () => Navigator.push(context, CustomPageRouteLR(child: const ForgotPasswordScreen(), direction: AxisDirection.down)),
                      child: Text(
                        "Forgot password?",
                        style: GoogleFonts.poppins(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ],
                ),
                const Gap(25),

                //Login Button
                Obx(()=>
                    RoundedButton(
                        borderColor: Theme.of(context).colorScheme.tertiary,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        onTap: (){
                          isLoadingLogin.value = true;
                          if (_formKey.currentState!.validate()) {
                            login();
                          }
                          else{
                            isLoadingLogin.value = false;
                          }
                        },
                        isLoading: isLoadingLogin.value,
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontSize: 17, color: Theme.of(context).colorScheme.surface)),
                        )),
                ),
                const Gap(15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.poppins(fontSize: 16,
                          color: Colors.grey),
                    ),
                    const Gap(10),
                    GestureDetector(
                      onTap: () =>   Navigator.push(
                          context,
                          CustomPageRouteLR(
                              child: const SignupPage(),
                              direction: AxisDirection.right)),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(fontSize: 16,
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ],
                ),
                const Gap(15),
                Center(
                  child: Text(
                    "OR",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface),
                  ),
                ),
                const Gap(20),

                //Google sign in
                Obx(() => RoundedButton(
                    borderColor: Theme.of(context).colorScheme.tertiary,
                    fillColor: Theme.of(context).colorScheme.primary,
                    onTap: (){
                      isLoading.value = true;
                    },
                    isLoading: isLoading.value,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            const FaIcon(FontAwesomeIcons.google,color: Colors.black,),
                            ShaderMask(blendMode: BlendMode.modulate, shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [
                                  Colors.red, // Replace with your desired colors for gradient
                                  Colors.yellow, // Replace with your desired colors for gradient
                                  Colors.green, // Replace with your desired colors for gradient
                                  Colors.blue,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(bounds);
                            }, child: const FaIcon(FontAwesomeIcons.google,color: Colors.white,)),
                          ],
                        ),
                        const Gap(15),
                        Text(
                          "Sign in with Google",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontSize: 17, color: Theme.of(context).colorScheme.surface)),
                        ),
                      ],
                    )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


