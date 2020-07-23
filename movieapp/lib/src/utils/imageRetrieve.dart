import 'package:flutter/material.dart';

//external package
import 'package:cached_network_image/cached_network_image.dart';

class ImageRetrieve {
  ImageRetrieve._();

  static request(imagePath) => CachedNetworkImage(
        imageUrl: imagePath,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        //placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Container(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),

        fadeOutDuration: const Duration(seconds: 1),
        fadeInDuration: const Duration(seconds: 1),
      );

  static requestWithError(imagePath) => CachedNetworkImage(
        imageUrl: imagePath,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        //placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/error/image-not-found.png',
          fit: BoxFit.cover,
        ),

        fadeOutDuration: const Duration(seconds: 1),
        fadeInDuration: const Duration(seconds: 1),
      );
}
