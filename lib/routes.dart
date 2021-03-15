import 'package:luca_play/controllers/index_controller.dart';
import 'package:luca_play/controllers/playlist_controller.dart';
import 'package:fluro/fluro.dart';

final router = FluroRouter.appRouter;

void defineRoutes() {
  router.define("/", handler: indexHandler);
  router.define("/playlist/:code", handler: playlistHandler);
}
