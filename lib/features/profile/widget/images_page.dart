
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImagesPage extends StatelessWidget {
  const ImagesPage({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const Gap(40),
        IconButton(onPressed: () => Navigator.pop(context), icon:  const Icon(Icons.arrow_back, size: 30, color: Colors.white,)),
        const Gap(90),
        Center(child: Hero(tag: "imageChat", child: CachedNetworkImage(
          imageUrl: imageUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress, color: Theme.of(context).colorScheme.surface,),
          errorWidget: (context, url, error) {
            return const Icon(Icons.error);
          },
          fit: BoxFit.contain,
        ),))
      ],),
    );
  }
}
