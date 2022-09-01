

import 'package:default_proyect/ui/views/crop_your_image.dart';
import 'package:default_proyect/ui/views/default_view.dart';
import 'package:default_proyect/ui/views/finaly_crop.dart';
import 'package:fluro/fluro.dart';

class DefaultHandler {

  static Handler defaultHome = new Handler(
    handlerFunc: ((context, parameters) => DefaultView())
  );

  static Handler crop = new Handler(
    handlerFunc: ((context, parameters) => CropYourImageTest())
  );

  static Handler finalyCrop = new Handler(
    handlerFunc: ((context, parameters) => FinalyCrop())
  );

}