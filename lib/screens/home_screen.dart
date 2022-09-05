import 'package:flutter/material.dart';
import 'package:youtubeclone/data.dart';
import 'package:youtubeclone/widgets/custom_sliver_appbar.dart';
import 'package:youtubeclone/widgets/video_cart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 60.0),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((c, index) {
              final video = videos[index];
              return VideoCard(video: video);
            }, childCount: videos.length)),
          )
        ],
      ),
    );
  }
}
