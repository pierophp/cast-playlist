import 'package:CastPlaylist/widgets/custom_loading.dart';
import 'package:cast/discovery_service.dart';
import 'package:flutter/material.dart';

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
        await Future.wait([
          CastDiscoveryService().start(),
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
            title: 'CAST PLAYLIST',
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
