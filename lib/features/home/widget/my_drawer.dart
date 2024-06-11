
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tracky/core/screen_size/mediaQuery.dart';
import 'package:tracky/features/about/page/about_page.dart';
import 'package:tracky/features/auth/auth_services/auth_services.dart';
import 'package:tracky/features/auth/signin/sign_in.dart';

import '../../../utility/pageRoutes.dart';
import '../../contact/page/contact_page.dart';
import '../../profile/page/profile_page.dart';
import '../../settings/page/settings_page.dart';


class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key, required this.storedPhoneNumber, required this.storedOccupation, required this.storedName});

  final String storedPhoneNumber, storedOccupation, storedName;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void logout(BuildContext context) {
    final authService = FirebaseAuthServices();
    authService.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        CustomPageRouteLR(
            child: const LoginPage(),
            direction: AxisDirection.right), (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Gap(50),
              ListTile(
                title: Center(
                  child: Container(width: getWidth(context)-20,
                   height: MediaQuery.of(context).size.height/6,
                    margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset('assets/images/Tracky.png',
                          width: 150, height: 150  ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title:  Text("H O M E", style: TextStyle( color: Theme.of(context).colorScheme.surface),),
                  leading:  Icon(Icons.home, color: Theme.of(context).colorScheme.surface),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("P R O F I L E", style: TextStyle( color: Theme.of(context).colorScheme.surface),),
                  leading:  Icon(Icons.person, color: Theme.of(context).colorScheme.surface),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>   ProfilePage(storedPhoneNumber: widget.storedPhoneNumber, storedOccupation: widget.storedOccupation, storedName: widget.storedName)));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title:  Text("S E T T I N G S", style: TextStyle( color: Theme.of(context).colorScheme.surface),),
                  leading:  Icon(Icons.settings, color: Theme.of(context).colorScheme.surface),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
              ),
              const Gap(40),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title:  Text("C O N T A C T  U S", style: TextStyle( color: Theme.of(context).colorScheme.surface),),
                  leading:  Icon(Icons.phone, color: Theme.of(context).colorScheme.surface),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const ContactPage()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title:  Text("A B O U T", style: TextStyle( color: Theme.of(context).colorScheme.surface),),
                  leading:  Icon(Icons.question_mark, color: Theme.of(context).colorScheme.surface),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const AboutPage()));
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 40),
            child: ListTile(
              title:  Text("L O G O U T", style: TextStyle( color: Theme.of(context).colorScheme.surface),),
              leading:  Icon(Icons.logout, color: Theme.of(context).colorScheme.surface),
              onTap: () {
                logout(context);
              },
            ),
          ),


        ],
      ),
    );
  }
}
