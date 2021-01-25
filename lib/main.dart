// REMOVER QUANDO TODAS AS LIBS SUPORTAREM NULL SAFETY
// https://dart.dev/null-safety/unsound-null-safety
// @dart=2.9
import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/models/video.dart';
import 'package:LucaPlay/widgets/custom_loading.dart';
import 'package:cast/discovery_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './routes.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  runApp(AppComponent());
}

class AppComponent extends StatefulWidget {
  @override
  State createState() {
    return AppComponentState();
  }
}

class AppComponentState extends State<AppComponent> {
  AppComponentState() {
    defineRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: () async {
        await Hive.initFlutter();

        if (!Hive.isAdapterRegistered(PlaylistAdapter().typeId)) {
          Hive.registerAdapter(PlaylistAdapter());
        }

        if (!Hive.isAdapterRegistered(VideoAdapter().typeId)) {
          Hive.registerAdapter(VideoAdapter());
        }

        await Future.wait([
          CastDiscoveryService().start(),
          Hive.openBox<Playlist>('playlists'),
        ]);
      }(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return CustomLoading();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'LUCA PLAY',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            onGenerateRoute: router.generator,
            scaffoldMessengerKey: rootScaffoldMessengerKey,
          );
        }

        return CustomLoading();
      },
    );
  }
}
