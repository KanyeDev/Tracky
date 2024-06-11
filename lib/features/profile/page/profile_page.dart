import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracky/features/profile/page/privacy_policy_page.dart';
import 'package:tracky/features/profile/page/terms_and_con_page.dart';
import 'package:tracky/utility/toast.dart';

import '../../../core/screen_size/mediaQuery.dart';
import '../../../core/widget/custom_button.dart';
import '../../../utility/pageRoutes.dart';
import '../../auth/auth_services/auth_services.dart';
import '../../auth/signin/sign_in.dart';
import '../../home/pages/homepage.dart';
import '../../tasks/widget/task_shimmer_loading.dart';
import '../widget/buildTextWidget.dart';
import '../widget/build_profile_picture.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.storedPhoneNumber, required this.storedOccupation, required this.storedName});

  String? storedPhoneNumber, storedOccupation, storedName;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final FirebaseAuthServices _authServices = FirebaseAuthServices();

  TextEditingController phoneController = TextEditingController();
  TextEditingController occupationController = TextEditingController();

  XFile? imageFile;

  Uint8List? image;

  var isGallery = true.obs;




  Future<void> getImage() async {
    ImagePicker imagePicker = ImagePicker();
    final pickedFile = isGallery.value
        ? await imagePicker.pickImage(source: ImageSource.gallery)
        : await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = await pickedFile.readAsBytes();

      imageFile = pickedFile;


      uploadFile(pickedFile);
    }
  }

  //upload file or images in this case
  Future<void> uploadFile(XFile file) async {

    try {
      Uint8List bytes = await file.readAsBytes();
      Reference referenceImageToUpload =
      FirebaseStorage.instance.ref().child("image/${_authServices.getCurrentUser()!.uid}.jpeg");
      UploadTask uploadTask = referenceImageToUpload.putData(bytes);
      await uploadTask.whenComplete(() => null);
      String url = await referenceImageToUpload.getDownloadURL();


      await _authServices.updateUserProfile(profileImage: url);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profileImage', url);

      Utility().toastMessage("Uploading image...");

    } catch (e) {
           Utility().toastMessage(e.toString());
    }
  }


  void updateProfile(TextEditingController controller,
      void Function()? onPressed) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            content: TextField(
              controller: controller,
            ),
            actions: [
              MaterialButton(
                onPressed: onPressed,
                child: const Text("Update"),
              ),
              MaterialButton(
                child: const Text("Clear"),
                onPressed: () {
                  Navigator.pop(context);
                  controller.clear();
                },
              ),
            ],
          ),
    );
  }


  void callUpdatePhone(){
    updateProfile(phoneController, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await _authServices.updateUserProfile(
          phoneNumber: phoneController.text).then((value) async =>  {

          prefs.setString('phoneNumber', phoneController.text),

          phoneController.clear(),

          Navigator.pop(context),

          });

      setState(() {});
      Utility().toastMessage("Updating... might take a while");

    });
  }

  void callUpdateOccupation(){
    updateProfile(occupationController, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await _authServices.updateUserProfile(
          occupation: occupationController.text).then((value) async => {

          prefs.setString('occupation', occupationController.text),

          occupationController.clear(),

          Navigator.pop(context),
      });

      setState(() {});
      Utility().toastMessage("Updating... might take a while");
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          gradientBackgroundColor(context,
            Theme
                .of(context)
                .colorScheme
                .background,
            Theme
                .of(context)
                .colorScheme
                .primary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SafeArea(
                  child: Stack(
                    children: [
                      BuildProfilePicture(authServices: _authServices, height: 100, width: 100,),
                      Positioned(
                          right: 1,
                          bottom: 1,
                          child: GestureDetector(
                              onTap: () => getImage(),
                              onLongPress: () => isGallery.value = !isGallery.value,
                              child: Obx(() =>
                              isGallery.value == true
                                  ? const Icon(Icons.image)
                                  : const Icon(Icons.camera_alt))))
                    ],
                  ),
                ),

                const Gap(10),
                widget.storedName != '' ? Text(
                  widget.storedName!,
                  style: const TextStyle(fontSize: 18),
                ): FutureBuilder(
                  future: _authServices.getUserData('name'),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return subjectShimmerLoading(
                          35, getWidth(context)); //  loading indicator
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        "${snapshot.data}",
                        style: const TextStyle(fontSize: 18),
                      );
                    }
                  },
                ),
                const Gap(20),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),

                const Gap(50),
                buildTextWidget(context, "E M A I L", Icons.email,
                    _authServices.getCurrentUser()!.email.toString()),
                const Gap(10),

                widget.storedPhoneNumber != '' ? GestureDetector(
                  onTap: (){
                    callUpdatePhone();
                  },
                  child: buildTextWidget(
                      context, "P H O N E", Icons.phone,  widget.storedPhoneNumber!),
                ): FutureBuilder(
                  future: _authServices.getUserData('phoneNumber'),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return subjectShimmerLoading(
                          35, getWidth(context)); //  loading indicator
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return GestureDetector(
                          onTap: (){
                            callUpdatePhone();
                          },
                          child: buildTextWidget(
                              context, "P H O N E", Icons.phone, snapshot.data!.isEmpty? "Click to add phone": snapshot.data!));
                    }
                  },
                ),

                const Gap(10),
                widget.storedOccupation != '' ? GestureDetector(onTap: (){
                  callUpdateOccupation();
                },
                  child: buildTextWidget(
                      context, "O C C U P A T I O N", Icons.work,  widget.storedOccupation!),
                ) : FutureBuilder(
                  future: _authServices.getUserData('occupation'),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return subjectShimmerLoading(
                          35, getWidth(context)); //  loading indicator
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return GestureDetector(
                          onTap: (){
                            callUpdateOccupation();
                          },
                          child: buildTextWidget(context, "O C C U P A T I O N",
                              Icons.work, snapshot.data!.isEmpty? "Click to add occupation": snapshot.data!));
                    }
                  },
                ),

                const Gap(50),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Help and Support",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    SizedBox()
                  ],
                ),

                const Gap(30),
                //Privacy Policy
                GestureDetector(
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage())),
                  child: buildTextWidget(
                      context, "P R I V A C Y  P O L I C Y ", Icons.lock, ''),
                ),
                const Gap(20),
                //Terms and conditions
                GestureDetector(
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditionsPage())),
                  child: buildTextWidget(context, "T E R M S  A N D  C O N D I T I O N S",
                      Icons.menu_book, ''),
                ),
                const Gap(20),
                //Chat Support
                GestureDetector(
                  onTap: () => Utility().toastMessage("Coming soon..."),
                  child: buildTextWidget(
                      context, "C H A T  S U P P O R T", Icons.support_agent, ''),
                ),

                //Logout
                const Expanded(child: SizedBox()),
                CustomButton(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 30,
                    backGroundColor: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    borderColor: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    text: "L O G O U T",
                    textColor: Theme
                        .of(context)
                        .colorScheme
                        .surface,
                    onTap: () {
                      _authServices.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          CustomPageRouteLR(
                              child: const LoginPage(),
                              direction: AxisDirection.right), (route) => false);
                    },
                    isLoading: false),

                const Gap(60),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
