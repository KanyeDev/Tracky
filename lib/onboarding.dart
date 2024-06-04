

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:tracky/core/screen_size/mediaQuery.dart';
import 'package:tracky/utility/pageRoutes.dart';
import 'package:tracky/utility/toast.dart';

import 'core/widget/custom_button.dart';
import 'features/auth/auth_services/auth_services.dart';
import 'features/auth/signin/sign_in.dart';
import 'features/auth/signup/signup.dart';
import 'features/home/pages/homepage.dart';



class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: FutureBuilder<User?>(
            future: FirebaseAuthServices().autoLogin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading indicator while checking auto-login
                return   Column(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(getHeight(context)/5),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: ClipRRect(borderRadius: BorderRadius.circular(40), child: Image.asset("assets/images/Tracky.png")),
                    ),
                    const Gap(50),
                    CircularProgressIndicator(color: Theme.of(context).colorScheme.surface,),
                    const  Gap(20),
                    const Text("Please Wait!"),
                    Expanded(child: const  Gap(1)),
                  ],
                );
              } else {
                if (snapshot.hasData) {
                  // User is already logged in, navigate to home page
                  //Utility().toastMessage("Login Successful");

                  return const HomePage();
                } else {
                  // User is not logged in, navigate to login page
                  return Stack(
                    children: [
                      // Positioned(
                      //     bottom: 0,
                      //     child: Image.asset(
                      //       "asset/images/curvebtm.png",
                      //       fit: BoxFit.contain,
                      //     )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Gap(50),
                          SizedBox(width: MediaQuery.of(context).size.width/1.2, child: Image.asset("assets/images/Tracky.png")),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //sign up btn
                              CustomButton(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      FadePageRouteLR(
                                        child: const SignupPage(),
                                        direction: AxisDirection.right,
                                      ));
                                },
                                width: 150,
                                backGroundColor: Theme.of(context).colorScheme.primary,
                                borderColor:  Theme.of(context).colorScheme.tertiary,
                                text: 'Sign Up',
                                textColor:  Theme.of(context).colorScheme.tertiary,
                                isLoading: false,
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              //Login Btn
                              CustomButton(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      FadePageRouteLR(
                                        child: const LoginPage(),
                                        direction: AxisDirection.left,
                                      ));
                                },
                                width: 150,
                                backGroundColor:  Theme.of(context).colorScheme.tertiary,
                                borderColor:  Theme.of(context).colorScheme.tertiary,
                                text: 'Login',
                                textColor: Theme.of(context).colorScheme.surface,
                                isLoading: false,
                              ),

                              const SizedBox(
                                height: 120,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  );
                }
              }
            }));
  }
}
