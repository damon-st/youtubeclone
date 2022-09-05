// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:youtubeclone/data.dart';

class VideoInfo extends StatelessWidget {
  const VideoInfo({
    Key? key,
    required this.video,
  }) : super(key: key);
  final Video video;
  @override
  Widget build(BuildContext context) {
    final time = timeago.format(video.timestamp, locale: "es");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.title,
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 15.0),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            "${video.viewCount} views * $time",
            style:
                Theme.of(context).textTheme.caption!.copyWith(fontSize: 14.0),
          ),
          const Divider(),
          _ActionsRow(video: video),
          const Divider(),
          _AuthorInfo(
            user: video.author,
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({
    Key? key,
    required this.video,
  }) : super(key: key);
  final Video video;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAction(context, Icons.thumb_up_outlined, video.likes),
        _buildAction(context, Icons.thumb_down_outlined, video.dislikes),
        _buildAction(context, Icons.reply_outlined, "Share"),
        _buildAction(context, Icons.download_outlined, "Download"),
        _buildAction(context, Icons.library_add_outlined, "Save"),
      ],
    );
  }

  Widget _buildAction(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.white,
                ),
          )
        ],
      ),
    );
  }
}

class _AuthorInfo extends StatelessWidget {
  const _AuthorInfo({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ///TODO: NAVIGATE TO PROFILE
      },
      child: Row(
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(
              user.profileImageUrl,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    user.username,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 15.0),
                  ),
                ),
                Flexible(
                  child: Text(
                    "${user.subscribers} suspcribers ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "SUBSCRIBE",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.red),
              ))
        ],
      ),
    );
  }
}
