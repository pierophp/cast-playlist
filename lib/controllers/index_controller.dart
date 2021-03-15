import 'package:luca_play/models/playlist.dart';
import 'package:luca_play/screens/index_screen.dart';
import 'package:luca_play/widgets/custom_loading.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IndexController extends StatelessWidget {
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
            return IndexScreen(
              playlistBox: box,
            );
          },
        );
      },
    );
  }
}

var indexHandler = Handler(handlerFunc: (
  BuildContext? context,
  Map<String, dynamic> params,
) {
  return IndexController();
});
