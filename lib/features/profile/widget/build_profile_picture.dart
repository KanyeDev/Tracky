import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utility/pageRoutes.dart';
import '../../auth/auth_services/auth_services.dart';
import 'images_page.dart';

class BuildProfilePicture extends StatelessWidget {
  const BuildProfilePicture({
    super.key,
    required FirebaseAuthServices authServices, required this.height, required this.width,
  }) : _authServices = authServices;

  final FirebaseAuthServices _authServices;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authServices.getUserData('profileImage'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 50,
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}'); // Debugging error
          return CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 50,
            child: const Icon(
              Icons.error,
              size: 40,
            ),
          );
        } else if (snapshot.data == '') {
          return CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 50,
            child: const Icon(
              Icons.person,
              size: 40,
            ),
          );
        } else if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                FadeScalePageRoute(
                  child: ImagesPage(
                    imageUrl: snapshot.data!,
                  ),
                ),
              );
            },
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(width/2),
                child: Hero(
                  tag: "imageChat",
                  child: CachedNetworkImage( width: width, height: height,
                    imageUrl: snapshot.data!,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress, color: Theme.of(context).colorScheme.surface,),
                    errorWidget: (context, url, error) {
                      return const Icon(Icons.error);
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        } else {
          return CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 50,
            child: const Icon(
              Icons.person,
              size: 40,
            ),
          );
        }
      },
    );
  }
}


