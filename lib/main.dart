import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/widgets/custom_loading.dart';
import 'package:cast/discovery_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './routes.dart';

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
        Hive.registerAdapter(PlaylistAdapter());

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
          );
        }

        return CustomLoading();
      },
    );
  }
}
