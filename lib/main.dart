import 'package:CastPlaylist/widgets/custom_loading.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

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
        await Future.wait(
            [DotEnv.load(fileName: kDebugMode ? ".env" : ".env.production")]);
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
            // theme: theme,
            onGenerateRoute: router.generator,
          );
        }

        return CustomLoading();
      },
    );
  }
}
