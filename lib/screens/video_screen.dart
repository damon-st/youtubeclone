import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtubeclone/data.dart';
import 'package:youtubeclone/screens/nav_screens.dart';
import 'package:youtubeclone/widgets/vide_info.dart';
import 'package:youtubeclone/widgets/video_cart.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      final selectVideo = ref.watch(selectVideoProvider.state).state;

      return GestureDetector(
        onTap: () {
          ref
              .read(miniPlayerControllerProvider.state)
              .state
              .animateToHeight(state: PanelState.MAX);
        },
        child: Scaffold(
          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: CustomScrollView(
              controller: _scrollController,
              shrinkWrap: true,
              slivers: [
                SliverToBoxAdapter(
                    child: SafeArea(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            selectVideo!.thumbnailUrl,
                            height: 220.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                              onPressed: () {
                                ref
                                    .read(miniPlayerControllerProvider.state)
                                    .state
                                    .animateToHeight(state: PanelState.MIN);
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      const LinearProgressIndicator(
                        value: 0.4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                      VideoInfo(
                        video: selectVideo,
                      ),
                    ],
                  ),
                )),
                SliverList(
                    delegate: SliverChildBuilderDelegate((c, index) {
                  final video = suggestedVideos[index];
                  return VideoCard(
                      onTap: () {
                        _scrollController?.animateTo(0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      },
                      video: video,
                      hasPadding: true);
                }, childCount: suggestedVideos.length))
              ],
            ),
          ),
        ),
      );
    }));
  }
}
