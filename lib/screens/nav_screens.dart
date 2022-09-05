import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtubeclone/data.dart';
import 'package:youtubeclone/screens/home_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:youtubeclone/screens/video_screen.dart';

final selectVideoProvider = StateProvider<Video?>((ref) => null);
final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
        (ref) => MiniplayerController());

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;
  static const double _playerMinHeigth = 60.0;

  final _screens = [
    const HomeScreen(),
    const Scaffold(
      body: Center(
        child: Text("Explore"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("Add"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("Subscription"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("Library"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer(builder: ((context, ref, child) {
        final selectedVideo = ref.watch(selectVideoProvider.state).state;
        final miniPlayerController =
            ref.watch(miniPlayerControllerProvider.state).state;
        return Stack(
          children: _screens
              .asMap()
              .map((i, scren) => MapEntry(
                  i,
                  Offstage(
                    offstage: _selectedIndex != i,
                    child: scren,
                  )))
              .values
              .toList()
            ..add(Offstage(
              offstage: selectedVideo == null,
              child: Miniplayer(
                controller: miniPlayerController,
                minHeight: _playerMinHeigth,
                maxHeight: size.height,
                builder: (height, percentage) {
                  if (selectedVideo == null) {
                    return const SizedBox.shrink();
                  }
                  final time =
                      timeago.format(selectedVideo.timestamp, locale: "es");

                  if (height <= _playerMinHeigth + 50.0) {
                    return Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(
                                selectedVideo.thumbnailUrl,
                                height: _playerMinHeigth - 4.0,
                                width: 120.0,
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          selectedVideo.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${selectedVideo.author.username} * "
                                          "${selectedVideo.viewCount} "
                                          "views $time",
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  ref.read(selectVideoProvider.notifier).state =
                                      null;
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const LinearProgressIndicator(
                            value: 0.4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        ],
                      ),
                    );
                  }
                  return const VideoScreen();
                },
              ),
            )),
        );
      })),
      bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (i) {
            setState(() {
              _selectedIndex = i;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                activeIcon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.explore_outlined,
                ),
                activeIcon: Icon(
                  Icons.explore,
                ),
                label: "Explore"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle_outline,
                ),
                activeIcon: Icon(
                  Icons.add_circle,
                ),
                label: "Add"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.subscriptions_outlined,
                ),
                activeIcon: Icon(
                  Icons.subscriptions,
                ),
                label: "Subscriptions"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.video_library_outlined,
                ),
                activeIcon: Icon(
                  Icons.video_library,
                ),
                label: "Library"),
          ]),
    );
  }
}
