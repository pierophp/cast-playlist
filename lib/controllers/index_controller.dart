import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/screens/index_screen.dart';
import 'package:LucaPlay/widgets/custom_loading.dart';
import 'package:LucaPlay/widgets/custom_appbar.dart';
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
              return Scaffold(
                backgroundColor: const Color(0xffF8F8F8),
                body: IndexScreen(
                  playlistBox: box,
                ),
                appBar: CustomAppBar(
                  title: 'LUCA PLAY',
                  withLogo: false,
                ),
              );
            });
      },
    );
  }
}

var indexHandler = Handler(handlerFunc: (
  BuildContext context,
  Map<String, dynamic> params,
) {
  return IndexController();
});
