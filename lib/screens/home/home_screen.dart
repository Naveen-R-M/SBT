import 'package:SBT/my_colors.dart';
import 'package:SBT/screens/home/image_carousel.dart';
import 'package:SBT/screens/home/thumnail_images.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: MyColors.STATUS_BAR.withOpacity(0.8),
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ImageCarousel()
              ),
            ),
          SliverFillRemaining(
            child: Column(
              children: [
                LoadImages(val: 'Images'),
              ],
            ),
          )
        ],
      )
    );
  }
}
