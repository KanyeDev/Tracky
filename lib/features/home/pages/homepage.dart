import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracky/features/auth/auth_services/auth_services.dart';
import 'package:tracky/features/heatmap/page/heatmap_page.dart';
import 'package:tracky/features/home/widget/my_drawer.dart';
import 'package:tracky/features/lock/pages/lock_page.dart';
import 'package:tracky/features/tasks/pages/task_page.dart';
import 'package:tracky/utility/pageRoutes.dart';

import '../../profile/page/profile_page.dart';
import '../widget/my_buttom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int visit = 0;
  int indexToReturnTo = 0;

  final FirebaseAuthServices authServices = FirebaseAuthServices();

  List<TabItem> items = const [
    TabItem(icon: Icons.home, title: "Home"),
    TabItem(icon: Icons.search, title: "Tasks"),
    TabItem(icon: Icons.lock_clock, title: "Lock"),
    TabItem(icon: Icons.person, title: "Profile")
  ];

  Widget setWidgetToRender = const HeatMapPage();

  String userName = "";
  String storedPhoneNumber = "";
  String storedOccupation = "";
  String storedName = "";
  RxString imageUrl = "".obs;

  void setProfileDetailsData() async {
    storedPhoneNumber = await checkAndSetStoredData('phoneNumber');
    storedOccupation = await checkAndSetStoredData('occupation');
    storedName = await FirebaseAuthServices().getUserData('name');
    imageUrl.value  = await FirebaseAuthServices().getUserData('profileImage');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setProfileDetailsData();
  }

  Widget? getWidget() {
    Widget? render;

    render = setWidgetToRender;
    return render;
  }

  Future<String> checkAndSetStoredData(String data) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the 'phoneNumber' key exists in SharedPreferences
    if (!prefs.containsKey(data)) {
      // If it does not exist, set it to an empty string
      await prefs.setString(data, '');
    }
    return prefs.getString(data)!;
  }

  Future<void> setWidget(int index) async {
    if (index == 0) {
      setState(() {
        indexToReturnTo = index;
        setWidgetToRender = const HeatMapPage(); //home page[Heat Map]
      });
    } else if (index == 1) {
      setState(() {
        indexToReturnTo = index;
        setWidgetToRender = const TaskPage(); //Task page
      });
    } else if (index == 2) {
      setState(() {
        indexToReturnTo = index;
        setWidgetToRender = const LockPage(); //Lock page
      });
    } else {
      setProfileDetailsData();
      Navigator.push(
              context,
              CustomPageRouteLR(
                  child: ProfilePage(
                    storedPhoneNumber: storedPhoneNumber,
                    storedOccupation: storedOccupation,
                    storedName: storedName,
                  ),
                  direction: AxisDirection.left))
          .then((_) {
        // Reset to the previously selected tab after returning from ProfilePage
        setState(() {
          visit = indexToReturnTo;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      bottomNavigationBar: BottomNavBar(
        onTap: (int index) {
          setState(() {
            visit = index;
            setWidget(visit);
          });
          return null;
        },
        visit: visit,
        items: items,
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CustomPageRouteLR(
                    child: ProfilePage(
                      storedPhoneNumber: storedPhoneNumber,
                      storedOccupation: storedOccupation,
                      storedName: storedName,
                    ),
                    direction: AxisDirection.left,
                  ),
                );
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Obx(() =>ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: imageUrl.value == ""? FutureBuilder(
                        future: authServices.getUserData('profileImage'),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if( snapshot.hasData){
                            return CachedNetworkImage( width: 50, height: 50,
                              imageUrl: snapshot.data!,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress, color: Theme.of(context).colorScheme.surface,),
                              errorWidget: (context, url, error) {
                                return const Icon(Icons.error);
                              },
                              fit: BoxFit.cover,
                            );
                          }
                           else if (snapshot.data == '') {
                            return CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              radius: 50,
                              child: const Icon(
                                Icons.person,
                                size: 40,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              radius: 50,
                              child: const Icon(
                                Icons.error,
                                size: 40,
                              ),
                            );
                          }
                           else{
                             return CircleAvatar(
                               backgroundColor: Colors.grey.shade300,
                               radius: 50,
                               child: CircularProgressIndicator(),
                             );
                           }
                        }) : CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: imageUrl.value,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                          CircularProgressIndicator(
                            value: downloadProgress.progress,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                      errorWidget: (context, url, error) {
                        return const Icon(Icons.error);
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          gradientBackgroundColor(
            context,
            Theme.of(context).colorScheme.background,
            Theme.of(context).colorScheme.primary,
          ),
          setWidgetToRender,
        ],
      ),
      drawer:  MyDrawer(storedPhoneNumber: storedPhoneNumber, storedOccupation: storedOccupation, storedName: storedName,),
    );
  }
}

Widget gradientBackgroundColor(
    BuildContext context, Color background, Color supplementary1) {
  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              supplementary1,
              supplementary1,
              supplementary1,
              background
            ],
            end: Alignment.center,
            begin: Alignment.bottomCenter,
          ),
        ),
      ),
      Opacity(
        opacity: 0.3,
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [background, background, supplementary1],
              center: Alignment.topLeft,
              radius: 0.5,
            ),
          ),
        ),
      ),
      Opacity(
        opacity: 0.5,
        child: Container(
          decoration: BoxDecoration(
            gradient: SweepGradient(
              colors: [Theme.of(context).colorScheme.tertiary, supplementary1],
              center: Alignment.topRight,
              startAngle: 0.0,
              endAngle: 1 * 1.8,
            ),
          ),
        ),
      ),
    ],
  );
}
