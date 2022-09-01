

import 'package:default_proyect/router/default_handler.dart';
import 'package:fluro/fluro.dart';

class Flurorouter {

  static final FluroRouter router = new FluroRouter();

  static String rootRoute = '/';

  static String cropRoute = '/crop';

  static String finalyRoute = '/finaly';


  static void configureRoutes(){

    router.define(rootRoute, handler: DefaultHandler.defaultHome, transitionType: TransitionType.none);
    router.define(cropRoute, handler: DefaultHandler.crop, transitionType: TransitionType.none);
    router.define(finalyRoute, handler: DefaultHandler.finalyCrop, transitionType: TransitionType.none);

  }

}