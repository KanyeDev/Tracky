import 'package:flutter/material.dart';
 import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tracky/core/date_time.dart';
import 'package:tracky/utility/toast.dart';

class LockPage extends StatefulWidget {
  const LockPage({super.key});

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  TextEditingController dateController = TextEditingController();
  MyDataTimePicker dataTimePicker = MyDataTimePicker();

  RxString time = "".obs;

  bool _lockEnabled = false;
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _toggleLock(bool value) {
    setState(() {
      _lockEnabled = value;
    });
  }

  void _enableForegroundMode() async {
    Utility().toastMessage("Coming Soon....");
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_KEEP_SCREEN_ON);
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SHOW_WHEN_LOCKED);
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_DISMISS_KEYGUARD);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Increase Productivity",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Text(
              "Keep device away",
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
           Expanded(child: const Gap(40)),
            TextFormField(
              keyboardType: TextInputType.datetime,
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.calendar_month),
                filled: true,
                fillColor: const Color(0xffD9D9D9),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
                hintText: "Time",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter Time";
                }
                return null;
              },
              onTap: () async {
                time.value = await dataTimePicker.selectTime(context);

                setState(() {
                  dateController.text = time.value;
                });
              },
            ),
            const Gap(60),
            GestureDetector(
              onTap: _enableForegroundMode,
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                height: 50,
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.tertiary, borderRadius: BorderRadius.circular(30)),
                child: Center(child: Text("Lock Device")),
              ),
            ),
            
            Expanded(child: SizedBox())
           
          ],
        ),
      ),
    );
  }
}
