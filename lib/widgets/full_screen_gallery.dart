import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenGallery extends StatelessWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final List<Widget>? appBarActions;
  final Widget? appBarLeading;
  final void Function(int)? onPageChange;

  const FullScreenGallery({
    required this.imagePaths,
    required this.initialIndex,
    this.appBarActions,
    this.appBarLeading,
    this.onPageChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: appBarLeading,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        actions: appBarActions,
      ),
      body: PhotoViewGallery.builder(
        onPageChanged: onPageChange,
        pageController: PageController(initialPage: initialIndex),
        // enableRotation: true,
        // allowImplicitScrolling: true,
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(
              File(
                imagePaths[index],
              ),
            ),
            filterQuality: FilterQuality.high,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 5,
          );
        },
        itemCount: imagePaths.length,
      ),
    );
  }
}
