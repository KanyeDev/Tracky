
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tracky/features/about/page/about_page.dart';

import '../../profile/page/profile_page.dart';
import '../../settings/page/settings_page.dart';


class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  //
  // void logout(BuildContext context) {
  //   final authService = AuthServices();
  //   authService.signOut();
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => LoginPage()));
  // }

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
                  child: Container(
                   height: MediaQuery.of(context).size.height/6,
                    margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10)),
                      // child: Lottie.asset('assets/wechat.json',
                      //     width: 150, height: 150, animate: false
                      // ),
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
                            builder: (context) => const ProfilePage()));
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
            padding: const EdgeInsets.only(left: 25.0, bottom: 30),
            child: ListTile(
              title:  Text("L O G O U T", style: TextStyle( color: Theme.of(context).colorScheme.surface),),
              leading:  Icon(Icons.logout, color: Theme.of(context).colorScheme.surface),
              onTap: () {
                //logout(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
