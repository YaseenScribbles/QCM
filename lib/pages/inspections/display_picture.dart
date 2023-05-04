import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'package:qcm/library/library.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Picture',
      //     style: kFontAppBar,
      //   ),
      // ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: PhotoViewGallery.builder(
        itemCount: imagePaths.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: Image.file(File(imagePaths[index])).image,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
      ),

      //     SafeArea(
      //   child: Builder(
      //     builder: (context) {
      //       final double height = MediaQuery.of(context).size.height;
      //       return Center(
      //         child: CarouselSlider(
      //           options: CarouselOptions(
      //             height: height * 0.7,
      //             viewportFraction: 1.0,
      //             enlargeCenterPage: false,
      //             // autoPlay: false,
      //           ),
      //           items: imagePaths
      //               .map(
      //                 (item) => Container(
      //                   child: Center(
      //                     child: Image.file(
      //                       File(item),
      //                       fit: BoxFit.contain,
      //                       height: height,
      //                     ),
      //                   ),
      //                 ),
      //               )
      //               .toList(),
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
