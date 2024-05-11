import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:tracky/features/heatmap/page/heatmap_page.dart';
import 'package:tracky/features/home/widget/my_drawer.dart';
import 'package:tracky/features/lock/pages/lock_page.dart';
import 'package:tracky/features/tasks/pages/task_page.dart';


import '../../profile/page/profile_page.dart';
import '../widget/my_buttom_nav.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int visit = 0;

  List<TabItem> items = const [
    TabItem(icon: Icons.home, title: "Home"),
    TabItem(icon: Icons.search, title: "Tasks"),
    TabItem(icon: Icons.lock_clock, title: "Lock"),
    TabItem(icon: Icons.person, title: "Profile")
  ];

  Widget setWidgetToRender = const HeatMapPage();

  String? userName;

  Widget? getWidget() {
    Widget? render;

    render = setWidgetToRender;
    return render;
  }

  void setWidget(int index) {
    if (index == 0) {
      setState(() {
        setWidgetToRender = const HeatMapPage(); //home page[Heat Map]
      });
    } else if (index == 1) {
      setState(() {
        setWidgetToRender = const TaskPage(); //Task page
      });
    } else if (index == 2) {
      setState(() {
        setWidgetToRender = const LockPage(); //Lock page
      });
    } else {
      setState(() {
        setWidgetToRender = const ProfilePage(); //Profile page
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: Stack(
        children: [
          gradientBackgroundColor(
            Theme.of(context).colorScheme.background,
            Theme.of(context).colorScheme.primary,
          ),

          setWidgetToRender,

          Positioned(
            bottom: 0,
            child: BottomNavBar(
              onTap: (int index) {
                setState(() {
                  visit = index;
                  setWidget(visit);
                });
              },
              visit: visit,
              items: items,
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
    );
  }

  Widget gradientBackgroundColor(Color background, Color supplementary1) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [supplementary1,supplementary1,supplementary1, background],
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
                colors: [background, background,supplementary1],
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
                startAngle: 0.5,
                endAngle: 1 * 2.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
