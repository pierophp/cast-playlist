import 'package:LucaPlay/controllers/index_controller.dart';
import 'package:fluro/fluro.dart';

final router = FluroRouter.appRouter;

void defineRoutes() {
  router.define("/", handler: indexHandler);
}
