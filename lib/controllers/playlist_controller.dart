import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/routes.dart';
import 'package:LucaPlay/screens/playlist_screen.dart';
import 'package:LucaPlay/widgets/custom_loading.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlaylistController extends StatelessWidget {
  String code;

  PlaylistController({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: () async {}(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CustomLoading();
        }

        return ValueListenableBuilder(
            valueListenable: Hive.box<Playlist>('playlists').listenable(),
            builder: (context, Box<Playlist> box, widget) {
              if (box.isEmpty) {
                return CustomLoading();
              }

              final playlist = box.values.firstWhere(
                  (playlist) => playlist.key.toString() == this.code,
                  orElse: () => null);

              if (playlist == null) {
                Future.delayed(Duration.zero, () {
                  router.navigateTo(
                    context,
                    "/",
                    transition: TransitionType.inFromLeft,
                  );
                });
                return CustomLoading();
              }

              return PlaylistScreen(
                playlistBox: box,
                playlist: playlist,
              );
            });
      },
    );
  }
}

var playlistHandler = Handler(handlerFunc: (
  BuildContext context,
  Map<String, dynamic> params,
) {
  return PlaylistController(
    code: params["code"][0],
  );
});
